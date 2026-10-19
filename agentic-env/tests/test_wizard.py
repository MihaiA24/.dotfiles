from __future__ import annotations

import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


TEMPLATE = Path(__file__).resolve().parents[1] / "agentic_env/vendored/mattpocock/skills/wizard/template.sh"


@unittest.skipUnless(shutil.which("bash") and shutil.which("node"), "requires Bash and Node.js")
class WizardTests(unittest.TestCase):
    def test_saved_values_survive_dotenv_loading_and_keep_current(self) -> None:
        library = TEMPLATE.read_text().split("\nrun_wizard() {", 1)[0]
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            wizard = root / "wizard.sh"
            wizard.write_text(
                library
                + '\nENV_FILE="$1"\n'
                + 'write_env WIZARD_TOKEN "$2"\n'
                + 'cp "$ENV_FILE" "$ENV_FILE.before"\n'
                + 'ask_secret WIZARD_TOKEN "Keep token:"\n'
                + 'printf "%s" "$WIZARD_TOKEN" > "$ENV_FILE.kept"\n'
                + 'write_env WIZARD_TOKEN "$WIZARD_TOKEN"\n'
            )
            for value in (
                "demo's-token",
                '  say "hello" # $HOME =  ',
                r"C:\new\raw",
                r"it's $HOME\path # token",
                "",
            ):
                with self.subTest(value=value):
                    env_file = root / ".env"
                    result = subprocess.run(
                        ["bash", str(wizard), str(env_file), value],
                        input="\n", capture_output=True, text=True,
                    )
                    self.assertEqual(result.returncode, 0, result.stderr)
                    self.assertEqual((root / ".env.kept").read_text(), value)
                    parsed = subprocess.run(
                        ["node", "-e", "const fs = require('node:fs'); "
                         "const {parseEnv} = require('node:util'); "
                         "console.log(JSON.stringify(parseEnv(fs.readFileSync(process.argv[1], 'utf8'))));",
                         str(env_file)],
                        capture_output=True, text=True, check=True,
                    )
                    self.assertEqual(json.loads(parsed.stdout)["WIZARD_TOKEN"], value)
                    self.assertEqual(env_file.read_bytes(), (root / ".env.before").read_bytes())

    def test_unrepresentable_values_leave_existing_configuration_untouched(self) -> None:
        library = TEMPLATE.read_text().split("\nrun_wizard() {", 1)[0]
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            wizard = root / "wizard.sh"
            wizard.write_text(library + '\nENV_FILE="$1"\nwrite_env WIZARD_TOKEN "$2"\n')
            env_file = root / ".env"
            original = "KEEP='existing configuration'\n"
            env_file.write_text(original)
            for value in ("both ' and \" quotes", "two\nlines", "carriage\rreturn", r"it's \new"):
                with self.subTest(value=value):
                    result = subprocess.run(
                        ["bash", str(wizard), str(env_file), value],
                        capture_output=True, text=True,
                    )
                    self.assertNotEqual(result.returncode, 0)
                    self.assertEqual(env_file.read_text(), original)
