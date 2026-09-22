# Start a new repo with the selected pstack skills

Use this guide to prepare an existing OMP host, then give an agent a reliable way to work in another repository. It adapts Lauren Tan's [Complete Guide to pstack, Part 1](https://x.com/poteto/status/2094457600259842065) (verification) and [Part 2](https://x.com/poteto/status/2097732320606507506) (understanding and design) to [our selected skills](../DECISIONS_AI_TOOLING.md#6-skills). It does not install full pstack or recreate Cursor's cloud services.

The starting sequence is: make one user path runnable, create or reuse its verifier, prove the verifier works, then use it while changing the app. Add investigation and design methods only when the task needs them. [Choose a skill for the job](skill-routing.md) says which method fits which task.

## 1. Prepare this host once

OMP already runs on this host. Use the [managed skills refresh](../README.md#refresh-skills-on-an-existing-omp-host), not full bootstrap. Preserve any intentional edits to installed skills before refreshing them.

Run these commands yourself when ready. The installation command replaces selected installed packages.

```bash
cd "$HOME/.dotfiles/agentic-env"
uv tool install --force .
agentic-install-skills-mcps --skill-profile default --yes
agentic-stack-doctor
agentic-skill-drift --no-upstream
```

This installs the curated profile using the default Hermes, Claude, and Codex targets without selecting MCP installation. Claude's skill links provide OMP discovery; Codex populates the canonical store. There is no `--skill-agent omp`.

Check that the existing `skills` mapping in `~/.omp/agent/config.yml` contains these fields. Do not replace the rest of the configuration.

```yaml
skills:
  enableClaudeUser: true
  enableAgentsUser: false
```

Inspect failures before proceeding. `foreign:<source>` means recorded installation provenance disagrees; it does not necessarily mean different content. `--no-upstream` checks reviewed sources and installed packages without checking upstream freshness. Do not clear findings with `--update-baseline`. Doctor and drift are installation checks, not proof that an application works.

## 2. Open the target repo and check discovery

Replace the example path with the new repository's root, then start a fresh session:

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

The shared skills are already installed on the host. Do not copy the whole catalog into every repository. Keep app-specific verification knowledge in the target repo's `.agents/skills/` directory.

The selected pstack skills are manual-only, so explicitly invoke them when needed. OMP hides them from automatic discovery but still loads them by name. Invoking a recipe also authorizes the skills it names: `/teach` can call `/how` and `/why` without a second request. Merely checking discovery, as above, does not invoke the recipe. `/teach` is the adapted pstack explanation skill. It explains engineering work to you and does not change code or build a learning workspace. `/poteto-mode`, `/architect`, and `/swarm` are excluded from this stack, so they are not available.

## 3. Establish a runnable starting point

For an existing app, first locate its project instructions, documented run command, existing verification tooling, and any project-local verifier. Use a narrow question if you need help understanding it:

```text
/how does a user complete the app's main task? Identify the relevant code,
how to run it, and the existing way to exercise that user path.
Explain briefly. Do not refactor anything.
```

If a usable verifier already exists, read and exercise it instead of generating another. If its map or commands have drifted, go to step 7.

For an empty repository, first build and run the smallest useful user path. There is no app to catalog yet. Do not generate a feature map for planned features. For a broken existing app, resolve or report the startup failure before writing verification instructions against it.

Choose disposable data, test accounts, and isolated ports or profiles. Do not use production data or change credentials, infrastructure, or global runtime settings without separate authorization.

## 4. Create and prove the project verifier

When a runnable app has no usable project verifier, prompt:

```text
/create-verification-skill for this repository. Reuse its existing runner
and automation before adding helpers or dependencies. Keep the initial
feature map grounded in the main user-facing flows that exist today.
Use disposable state. Prove one mapped feature end to end, capture the
action and resulting state, clean up what you started, and confirm the
evidence survives. Do not commit, push, or change global configuration.
```

Expect `.agents/skills/verify-<app>/SKILL.md` and a `features/README.md` index with feature files. The agent chooses a real app-specific name; `verify-<app>` is not a literal command. Start with the main three to five features, or fewer if that is all the app has.

Before accepting the result, check that:

- Launch, readiness checks, driving commands, evidence paths, and cleanup describe this app and actually work.
- Each mapped feature explains what users do, how the agent drives it, and what observable result proves success.
- The agent exercised one real user path and checked its side effects, not only mocks or internal setters.
- Cleanup removed only the run's temporary state and processes. The proof artifacts still exist.
- A fresh OMP session can load the generated skill by its actual name.

One proved feature establishes the initial verifier, not full feature coverage. Record which other features remain unexercised. A document that was never executed is not a finished verifier.

If using Hermes instead, project-skill discovery requires explicit human trust. Follow the generated skill's handoff; do not let the agent grant trust or weaken runtime settings on your behalf.

## 5. Use the verifier on the first real change

Replace `[verifier]` with the generated skill name and name one concrete task:

```text
Implement [small feature or fix]. Use /[verifier] to exercise the affected
user path and show the action, resulting state, and relevant side effects.
For a bug, demonstrate the failure before the fix and the same path working
afterward. Keep the change focused. Do not commit or push.
```

For a UI, ask for screenshots or video of the interaction. For a CLI, ask for the invocation, terminal output, exit status, and files it changed. For a service, ask for requests, responses, and relevant stored state. For performance work, capture a baseline and compare the same scenario afterward.

Keep useful regression tests, but do not accept a passing test suite as a substitute for exercising the changed behavior. Update affected verifier instructions when the intended behavior changes. Do not run the entire maintenance pass for every small change.

## 6. Add other methods only when the task needs them

Most changes need nothing beyond the verifier. When a task does need a method, pick it with [Choose a skill for the job](skill-routing.md). That guide covers ambiguous reports, explanation, history, goals, prototypes, interface design, critique, and planning, with a prompt for each.

Keep this workflow's proof rule across those routes. When a prototype, spec slice, or ticket needs proof, name `/[verifier]` and ask for the action and the observable result. An explanation, a plan, or a review is not evidence that the app works.

## 7. Keep the verifier useful

After substantial app changes, or when its instructions no longer match reality, prompt:

```text
/maintain-verification-skill for .agents/skills/[verifier].
Check the feature map against source and exercise every mapped feature.
Drive shared app state serially. Fix verifier drift only; report product
regressions separately. Preserve evidence and report any blocked coverage.
Do not commit or push.
```

Lauren recommends daily maintenance. Choose a cadence appropriate to the project's rate of change; installing the skill does not create a schedule. Prove the manual loop before adding scheduled runs or feedback-channel automation. Parallel source readers are useful, but agents must not simultaneously drive one shared app instance.

Once this loop works, consider additional scale only for a measured need. Cursor Cloud Agents require separate adoption and setup, and pstack's `swarm` is excluded from this stack. Local subagents are not equivalent infrastructure or verification coverage.
