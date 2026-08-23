# Agent Stack

Glossary for the personal agent stack (harnesses, skills, hooks, memory) managed from this repo. Operative decisions live in `DECISIONS_AI_TOOLING.md`.

## Language

### Skill lifecycle

**Installed**:
A skill present in some skill store on this machine. Says nothing about whether it can fire or ever has.
_Avoid_: available, active

**Wired**:
A skill with a mechanical trigger (forced injection, hook, or logged event) that fires without the user remembering to invoke it.
_Avoid_: enabled, configured

**Adopted**:
A skill kept in the curated roster because it fits the user's workflows — a fit judgment by the user, not a usage-count threshold. Usage data is diagnostic input, never the verdict.
_Avoid_: proven, validated

**Curated roster**:
The set of skills bound into harnesses at install time via `skill-packs.json`. The only skills a harness can see.
_Avoid_: pack (ambiguous), skill list

**Recovery store**:
`~/.agents/skills` — holds everything ever installed; invisible to harnesses (`enableAgentsUser: false`). Not part of the stack.
_Avoid_: backup, archive

### Usage measurement

**User-invoked**:
A skill activation explicitly requested by the user (slash command or named request). Counted per top-level session.
_Avoid_: explicit use, activation (unqualified)

**Model-invoked**:
A skill loaded by the model on its own judgment (registry `use_count`). Answers "does the model reach for it", a different question than user-invoked.
_Avoid_: registry use, load count
