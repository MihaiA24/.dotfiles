# mattpocock/skills (vendored)

Copied from `mattpocock/skills`, directories `skills/engineering/` and
`skills/productivity/`, at commit
`c55ee46073ed923f86ce59a5eb3b6d895095d1b7` (2026-09-18T11:12:29+01:00).
Licence: `LICENSE` (MIT, Matt Pocock).

Why a copy: the reviewed source is newer than the published `v1.2.3` release,
and selected packages need local OMP/Hermes adaptations. The `skills` CLI
supports tags and full commit SHAs; vendoring preserves those adaptations and
the complete reviewed packages rather than relying on a moving upstream.

Contents: nineteen skills in `skills/`, flattened out of the upstream
`engineering/` and `productivity/` category directories, which only held the
category `README.md` indexes (not copied, since they index skills this pack
excludes).

From `skills/engineering/`: `code-review`, `codebase-design`,
`diagnosing-bugs`, `domain-modeling`, `grill-with-docs`,
`improve-codebase-architecture`, `prototype`, `research`,
`resolving-merge-conflicts`, `tdd`, `to-spec`, `to-tickets`, `wayfinder`,
`wizard`. From `skills/productivity/`: `grilling`, `handoff`, `teach`,
`wait-what`, `writing-for-agents`.

Each directory is complete: supporting reference files (`DEEPENING.md`,
`DESIGN-IT-TWICE.md`, `ADR-FORMAT.md`, `CONTEXT-FORMAT.md`, `HTML-REPORT.md`,
`LOGIC.md`, `UI.md`, `mocking.md`, `tests.md`, `SKILL-MECHANICS.md`, the
`teach` format files), scripts (`hitl-loop.template.sh`, `template.sh`) and the
per-skill `agents/openai.yaml` descriptors all ride along.

Everything else upstream is deliberately not copied: `implement`, `ask-matt`,
`triage`, `setup-matt-pocock-skills`, `grill-me`, `to-questionnaire`, and the
beta/misc trees. The roster is `DECISIONS_AI_TOOLING.md` §6; the evidence
behind it is `docs/skills-workflow-recheck-2026-09-21.md`.

## Local modifications

The adaptations below are local; supporting assets otherwise retain the
reviewed upstream content.

- **Runtime-native skill loading** — upstream tells the agent to "call the Skill
  tool with X", which is one runtime's tool name. Each call site now names the
  skill and how to load it in either runtime (OMP `read skill://<name>`, Hermes
  `skill_view <name>`), resolved through the runtime's own skill directory
  rather than a checkout path: `grill-with-docs/SKILL.md`,
  `improve-codebase-architecture/SKILL.md`, `tdd/SKILL.md`,
  `wayfinder/SKILL.md`, `handoff/SKILL.md`.
- **Runtime-native delegation** — "spawn a sub-agent" now names the delegation
  tool of either runtime (OMP `task`, Hermes `delegate_task`):
  `research/SKILL.md`, `codebase-design/DESIGN-IT-TWICE.md`,
  `code-review/SKILL.md`, `improve-codebase-architecture/SKILL.md` (where a
  single mandatory survey sub-agent also became optional delegation, kept for
  scopes wide enough to partition).
- **Setup pointer replaced** — upstream sends the user to
  `/setup-matt-pocock-skills`, a skill this pack excludes. The tracker-dependent
  skills now point at `docs/agents/issue-tracker.md` and, when it is absent, ask
  the user rather than guessing: `code-review/SKILL.md`, `to-spec/SKILL.md`,
  `to-tickets/SKILL.md`, `wayfinder/SKILL.md` (which keeps its local-markdown
  default).
- **`code-review` reviews a pinned snapshot** — the diff is built once by
  `scripts/review_snapshot.py` (owned by this repo, not upstream) into a
  frozen output directory, and both sub-agents read that `tree/` instead of a
  live working tree that moves while they read. Adds an explicit `wip` mode with
  required `--path` scoping, so work in progress is reviewable without being
  told to commit first, and spec discovery no longer dead-ends when
  `commits.txt` is empty: stated intent and a user-supplied path rank above
  commit-message issue references.
  The directory is frozen input, not filesystem-enforced immutable storage:
  SHA256 verification runs before and after review, and outputs stay outside it.
  Source symlinks are represented as text, not followed. The helper uses a
  temporary Git index and object database, leaving user staging untouched.
  Reviewers require actual restricted tool grants or tool-less inline input.
- **`wizard` is manual-only, and no longer reads secrets** — `disable-model-
  invocation: true`, a description prefixed `Manual only:`, and a matching stop
  instruction in the body, since generating a script that provisions
  infrastructure or rotates credentials is not something to fire autonomously
  and the installed Hermes build ignores the frontmatter flag entirely, so the
  guard cannot live in metadata alone. The scoping step reads only files that
  *name* values (`.env.example`, CI workflows) and is explicitly barred from
  opening secret-bearing files; the stage list needs the user's approval before
  authoring; the human always runs the wizard, the agent never executes it.
- **Publication is a separately authorised effect** — committing, creating
  branches and writing to a tracker are gated on the user asking for them:
  `prototype/SKILL.md` (throwaway-branch capture and issue pointer),
  `wayfinder/SKILL.md` (`research/<name>` branch),
  `to-spec/SKILL.md` (publishing the spec), `to-tickets/SKILL.md` (publishing
  only approved tickets), `wizard/SKILL.md` (committing the script, linking it
  from the README). `resolving-merge-conflicts/SKILL.md` keeps its finishing
  commit, because a half-resolved merge is worse than either side, but stages
  only the resolved paths and says what it is about to commit.
- **`improve-codebase-architecture` surveys, never refactors** — stated up
  front, and its scope is announced before the scan.
- **`writing-for-agents/SKILL-MECHANICS.md` matches native invocation** —
  manual hiding is distinct from resource access. Explicit recipe composition
  and package-relative reference loading work without making a dependency
  automatic; Hermes's missing metadata gate is documented, not hidden.

`skills/code-review/scripts/review_snapshot.py` is local, not upstream.

## Bump

Re-copy the same nineteen directories at a reviewed commit, update the commit
and date above, re-apply the Local modifications (diff the old vendored copy
against its old upstream commit to recover them), keep
`skills/code-review/scripts/review_snapshot.py`, which upstream does not carry,
and note the bump in `DECISIONS_AI_TOOLING.md` Upstream watch.
