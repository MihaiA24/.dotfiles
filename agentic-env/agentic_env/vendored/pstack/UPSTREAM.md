# pstack (vendored)

Copied from `cursor/plugins`, directory `pstack/`.

- The nine skills vendored first were taken at commit
  `c1c0a32802223f4be824112dd83d33ad29a8b26c` (2026-09-14T21:56:29-04:00).
- `technical-writing/` and `maintain-verification-skill/` were added later from
  `640ea3abfbdef74aad432b58d8586e4bf645f42d`. The `pstack/` subtree is unchanged
  between those two commits (`docs/skills-workflow-recheck-2026-09-21.md`
  §Pstack: zero changed `pstack/` paths), so all eleven skills share one
  upstream baseline.

Licence: `LICENSE` (MIT, Lauren Tan), byte-identical to upstream.

Why a copy, not a pinned fetch: upstream publishes no tags, only a curated
subset of `pstack/` is wanted here, and the copy now carries local adaptations
that a fetch would overwrite. The copy is the pin. (The published `skills` CLI
can pin a `#ref`, including a full SHA; that is not the reason.)

Contents: the eleven skills in `skills/`. Everything else under `pstack/`
(agents, automations, the other skills) is deliberately not copied; the roster
and its reasons are in `DECISIONS_AI_TOOLING.md` §6.

## Local modifications

Every skill keeps `disable-model-invocation: true`. Hermes does not implement
that flag, so each description is prefixed `Manual only: ...` and each body
carries an explicit line refusing unsolicited invocation while still allowing a
user-invoked recipe to compose the skill by name. Cursor-specific dispatch
(`Task`, `subagent_type`, `readonly:`), Cursor paths (`.cursor/`,
`agent-transcripts/`, `~/.cursor/projects/`) and Cursor-only model slugs are
replaced throughout by OMP (`task` + `scout`, `skill://`, `~/.omp/agent/sessions/`)
and Hermes (`delegate_task`, `skill_view`, `~/.hermes/sessions`) equivalents, and
read-only is stated as a tool grant rather than prompt wording. Beyond that:

- `how`: simple questions answered inline instead of via a subagent, fan-out
  restricted to genuinely independent slices; explorer/explainer prompts
  reworded runtime-neutral and explicitly read-only. Both reference prompts
  otherwise unchanged.
- `why`: Cursor MCP discovery and the `readonly: false` worker workaround
  replaced by runtime source discovery (tool/server metadata, without opening
  credential-bearing configuration; gated servers count as unavailable) and
  native read-and-query grants when delegation is justified. Small questions
  stay inline; unavailable restricted grants mean parent-only investigation.
  Two failure modes added (dispatch count is not coverage, prompt is not permission). Seven
  evidence categories, coverage map, skip justifications and confidence tiers
  unchanged; `epistemics.md`, `source-playbook.md` and all eight `sources/*.md`
  unchanged; investigator/synthesizer prompts gained one authorization or
  verification line each.
- `blast-radius`: manual and report-only; explicit allowed-actions section
  (local proof scripts, throwaway tests, local runs; no production changes,
  commits, pushes, PRs or publication) plus runtime notes; step 6 no longer
  depends on `arena` — multi-model escalation routes to `interrogate` and must
  report "multi-model unavailable" instead of dressing one model up as several.
  Five-step certainty ladder and handback format unchanged.
- `unslop`: description no longer says "Must always apply"; added "When to run
  it" (explicit invocation or a named recipe cleanup step, one pass over the
  finished draft) and "What not to touch" (domain vocabulary, identifiers and
  literals, quotations, calibrated uncertainty, the file's own conventions; no
  mechanical word-list sweeps). Rule ids 3-33 verbatim, stable-id note
  strengthened.
- `interrogate`: scope replaced by the shared `review_snapshot.py` contract
  (refs vs WIP modes, scoped `--path`, frozen output dir, `--verify`); Cursor
  model rules and invented slugs replaced by runtime discovery via
  `omp models --json` exact selectors, no silent same-family substitution;
  reviewers run as separate OMP CLI processes
  (`-p --mode json --no-tools --no-skills --no-rules --no-extensions --no-session`)
  with identity read back from the returned provider/model, blocked if fewer
  than two distinct models answered; upstream's "open a separate PR to fix the
  slug" fallback deleted (report-only). Hermes can use the same installed OMP
  route; a native Hermes route first needs verified flags and identity output.
  Added `scripts/run_reviewers.py`; `references/` byte-unchanged.
- `create-verification-skill`: generated skills now land in `.agents/skills/verify-<app>/`;
  the drive step says to use the repo's own runner rather than introduce a
  second test framework; feature-map example addressed through the installed
  skill directory; new section 6 on registering the generated skill, including
  that Hermes only discovers a project's `.agents/skills/` after the human runs
  `hermes skills trust` (never auto-trust, never edit global config) with the
  explicit-file route as the fallback.
- `maintain-verification-skill`: outcomes stated as clean / changed / blocked,
  where "changed" means corrections applied inside the verification skill's own
  directory; new Permissions section (branch, commit, push and PR are four
  separate effects, none granted by running the skill). One mapped feature is
  read inline; independent feature readers may run concurrently under actual
  read-only grants. The live pass keeps all three invariants
  and is driven serially by the coordinator; product gaps are reported, not
  fixed; no automatic PR.
- `technical-writing`: trigger narrowed to substantial human-facing documents,
  routine commit messages scoped out and agent-facing instructions routed to
  `writing-for-agents`; the repo's own vocabulary and format conventions
  declared to outrank a general style rule; `unslop` composed as an explicit
  manual pass instead of "apply to every doc"; tab-indentation rule replaced by
  matching the surrounding file; `unslop` rule ids called stable citation
  references. Four layers, sources, worked example and checklist unchanged.
- `show-me-your-work`: `scripts/log.sh` resolved through the installed skill
  directory; committing the log requires the user's go-ahead; the
  `encode-lessons-in-structure` pointer reworded inline (principle skills are
  not installed here); the transcript audit covers this run and its named children;
  cross-model review resolves a real model with `omp models --json`, runs the
  reviewer as a snapshot-only CLI process, confirms which model actually
  answered, and reports `reviewed by: blocked — <reason>` when a second family
  cannot be confirmed. `scripts/log.sh` unchanged.
- `reflect`: native current-session handles/paths replace newest-file guessing.
  Synthesis stays inline unless transcript volume justifies independent lenses
  with actual read-and-query grants; no claim that same-model lenses establish
  model diversity. The structural check no longer cites a principle skill;
  backlog items are reported, never filed automatically. Skill authoring
  routes to `writing-for-agents`. Templates retain their lenses, criteria,
  prompt-injection warnings and output tables with native paths and dispatch.
- `recall`: explicit current-workspace/session scoping replaces Cursor paths,
  guessed OMP slugs and `ls -t` selection. Native timestamp ordering and
  role/type-aware transcript records drive retrieval. Resume uses the native
  client; delegation requires genuinely independent scope and restricted tools. A paragraph
  separates this skill from the durable memory backend (the memory tools return
  stored memories, this skill reconstructs context from transcripts, live
  `git`/`gh` state and the shared record); `unslop` named as an explicit final
  pass. The **why** sweep and output contract are unchanged.

Bump: re-copy the same directories at a reviewed commit, update the commits and
dates above, re-apply these adaptations, note it in `DECISIONS_AI_TOOLING.md`
Upstream watch.
