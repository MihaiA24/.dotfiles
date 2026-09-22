# Start a new repo with the selected pstack skills

Prepare this OMP host, then set up verification in the target repository. This guide adapts Lauren Tan's [Complete Guide to pstack, Part 1](https://x.com/poteto/status/2094457600259842065) on verification and [Part 2](https://x.com/poteto/status/2097732320606507506) on understanding and design to [our selected skills](../DECISIONS_AI_TOOLING.md#6-skills).

Host preparation comes first. The rest follows the articles' order: build reliable verification, map and maintain it, use it on changes, then add understanding and design methods. Optional cloud services and unselected skills are identified where the articles introduce them. This is not a skill chain to run for every task.

## Before you start

### Refresh the host's skills

OMP already runs on this host. Use the [managed skills refresh](../README.md#refresh-skills-on-an-existing-omp-host), not full bootstrap. Preserve intentional edits to installed skills before replacing them.

```bash
cd "$HOME/.dotfiles/agentic-env"
uv tool install --force .
agentic-install-skills-mcps --skill-profile default --yes
agentic-stack-doctor
agentic-skill-drift --no-upstream
```

The command installs the curated profile for Hermes, Claude, and Codex, but no MCPs. OMP reads Claude's skill links; Codex populates the canonical store. There is no `--skill-agent omp`.

Check the `skills` mapping in `~/.omp/agent/config.yml`. Keep the rest of the configuration intact.

```yaml
skills:
  enableClaudeUser: true
  enableAgentsUser: false
```

Inspect failures before proceeding. `foreign:<source>` reports a provenance mismatch, not necessarily different content. `--no-upstream` compares reviewed sources and installed packages without checking upstream freshness. Do not clear findings with `--update-baseline`. Doctor and drift check the installation, not whether an app works.

### Open the target repository

Replace the example path with the repository's root and start a fresh session:

```bash
cd /path/to/new-repo
omp
```

Ask the agent:

```text
Read skill://create-verification-skill, skill://maintain-verification-skill,
skill://how, and skill://teach. Report whether each loads. Do not execute
the skills yet.
```

The shared skills are installed on the host. Keep only app-specific verification knowledge in the repo's `.agents/skills/` directory; do not copy the whole catalog into each repository.

Pstack skills are manual-only. OMP hides them from automatic discovery but loads them by name. Invoking `/teach` authorizes its named `/how` and `/why` calls. Checking discovery, as above, does not invoke a recipe. `/teach` explains engineering work without changing code or creating a learning workspace.

### Check that the app runs

Locate the project instructions, run command, existing drivers, and any project-local verifier. Reuse a working verifier. If its commands or map have drifted, use the maintenance step below.

For an empty repo, first build and run the smallest useful user path. Do not map planned features. For an existing app that will not start, resolve or report that failure before writing verification instructions.

Use disposable data, test accounts, and isolated ports or profiles. Production data, credentials, infrastructure, and global runtime settings require separate authorization.

## Part 1: establish verification

### 1. Create the project verifier

Lauren starts with `/create-verification-skill`. Once the app runs, invoke it if no usable verifier exists:

```text
/create-verification-skill for this repository. Reuse its existing runner
and automation before adding helpers or dependencies. Keep the initial
feature map grounded in the main user-facing flows that exist today.
Use disposable state. Prove one mapped feature end to end, capture the
action and resulting state, clean up what you started, and confirm the
evidence survives. Do not commit, push, or change global configuration.
```

Expect `.agents/skills/verify-<app>/SKILL.md`. The agent chooses an app-specific name; `verify-<app>` is not a literal command.

### 2. Make verification reproducible

The article next develops the app-driving tools and development environment. Reuse the project's runner and drivers before adding a CLI. Check that:

- The launch, readiness, drive, evidence, and cleanup instructions match commands the agent ran successfully.
- The agent exercised a real user path and checked its side effects, not only mocks or internal setters.
- Cleanup removed only the run's temporary state and processes. The evidence files still exist.
- A fresh OMP session can load the generated skill by its actual name.

Hermes requires explicit human trust for project-skill discovery. Follow the generated skill's handoff; do not let the agent grant trust or weaken runtime settings on your behalf.

The article discusses Cloud Agents next, after successful local verification and a few delivered changes. This is an optional scaling step, not a requirement before continuing. Cursor Cloud Agents require separate adoption and setup. Local subagents do not provide that infrastructure.

### 3. Map the app's existing features

The generated `features/README.md` indexes the feature files. Start with the main three to five features, or fewer if that is all the app has. Each entry should explain what users do, how the agent drives it, and which result proves success.

One proved feature establishes the initial verifier, not full-map coverage. Record which features remain unexercised. Written instructions alone do not prove that verification works.

### 4. Keep the verifier useful

Lauren introduces maintenance alongside the feature map and recommends running it daily. Choose a cadence that matches how often the app changes. After substantial changes, or when the instructions no longer match the app, run:

```text
/maintain-verification-skill for .agents/skills/[verifier].
Check the feature map against source and exercise every mapped feature.
Drive shared app state serially. Fix verifier drift only; report product
regressions separately. Preserve evidence and report any blocked coverage.
Do not commit or push.
```

Source readers may work in parallel. Agents must drive a shared app instance serially. Full maintenance is separate from the affected-path checks for an ordinary change.

### 5. Use the verifier on real changes

The article then shows feature work, performance work, and report reproduction. Replace `[verifier]` with the generated skill name and name one concrete task:

```text
Implement [small feature or fix]. Use /[verifier] to exercise the affected
user path and show the action, resulting state, and relevant side effects.
For a bug, demonstrate the failure before the fix and the same path working
afterward. Keep the change focused. Do not commit or push.
```

For a UI, ask for screenshots or video of the interaction. For a CLI, ask for the invocation, terminal output, exit status, and changed files. For a service, ask for requests, responses, and relevant stored state. For performance work, capture a baseline and compare the same scenario afterward.

Keep useful regression tests, but also exercise the changed behavior. Update affected verifier instructions when intended behavior changes.

The article uses `/poteto-mode` to coordinate work and `/swarm` for repeated verification across cloud agents. Neither is selected here. Invoke the verifier directly; local fan-out is not equivalent to `swarm` coverage.

Automated report reproduction comes after reliable manual verification. Scheduled runs and feedback-channel automation need separate setup and authorization. Installing a skill does not create either.

## Part 2: understand the problem, then design

### 6. Restate the problem and build a mental model

Ask the agent to restate an ambiguous report in plain English before proposing a fix. Use `/teach` to explain the work through `/how` and `/why`. A narrow mechanism question can use `/how` alone:

```text
/how does a user complete the app's main task? Identify the relevant code,
how to run it, and the existing way to exercise that user path.
Explain briefly. Do not refactor anything.
```

Lauren then introduces `/recall` for relevant work from earlier conversations. Use it when that history exists, not as a prerequisite in an empty workspace.

### 7. Work backwards from the caller's experience

For shared code or a package, use `/technical-writing` to draft a tutorial showing how callers will use it before choosing the implementation. Edit the draft with `/unslop`. Our selected `/codebase-design` can help assess the interface.

### 8. Answer design questions with prototypes

Next, test uncertain interactions or state models in code. Drive the prototypes with the verifier and compare observed results. Our Matt `/prototype` is available for this job; the article's `/poteto-mode` prototyping playbook is not.

The article then introduces `/architect` for larger, competing designs. That skill is not selected here. `/codebase-design` supports interface design, but does not reproduce the full architecture workflow.

### 9. Write an execution plan only when needed

Lauren turns a settled design into a plan after investigation and experiments. Use `/to-spec` or `/to-tickets` when work needs coordination across sessions or people. Each slice should name a `/[verifier]` action and its observable result. Approve tracker publication separately.

For a small change you already understand, implement and verify it directly. [Choose a skill for the job](skill-routing.md) provides prompts for these routes without making them mandatory stages.
