# Matt + pstack workflow reassessment — TASK rerun

Reviewed 2026-09-21 for [issue #42](https://github.com/MihaiA24/.dotfiles/issues/42), at the user's explicit request to reopen current-source and all-available-host-history research before implementation.

**Research record, followed by the approved implementation below.** [DECISIONS_AI_TOOLING.md §6](../DECISIONS_AI_TOOLING.md) is operative. The source/history findings and acceptance table below preserve the pre-implementation state; their “current” counts and unanswered recommendations refer to that research phase, not the subsequent installation. The earlier [source comparison](skills-development-comparison.md) and [installation assessment](skills-fit-review.md) also remain historical evidence. No tracker issue, project commit or PR was changed.

This rerun used four **TASK agents**, not SCOUT agents: `MattTask`, `PstackTask`, `OmpTask`, and `HermesTask`. Each investigated primary sources before comparing the earlier report. Main reconciled their claims against source contracts and database metadata rather than accepting agreement as proof. Each produced a separate local JSON evidence artifact; only Main edited this report.

Load-bearing counts and byte comparisons were recomputed in isolated scripts after shared Eval state proved unsafe for concurrent analysis. The earlier installation census, doctor failure and four-case Git experiment remain explicitly attributed to the preceding pass; they were not silently presented as newly executed checks.

## Conclusion

Keep the mixed, job-routed approach. Matt supplies requirements interviews, domain language, interface design, diagnosis, durable planning and Standards/Spec review. Pstack adds distinct methods for understanding behavior, recovering rationale, practical bug regression, live verification and downstream safety. Native tools supply capabilities, not automatically those method contracts.

**Corrected priorities: repair reproducibility and review scope; preserve useful methods; add only the missing job contracts.** The rerun changes earlier recommendations and rejects several initial TASK interpretations:

| Earlier report or TASK draft framing | Reconciled finding | Consequence |
|---|---|---|
| Consider upgrading installed Matt skills from the release to reviewed HEAD | All 19 Matt-derived descriptors in the OMP-loaded Claude root match reviewed HEAD; 18 differ from the release. The selected 15 are among them. | Decide the reproducible source for the selected roster, not an assumed local upgrade. Installed bytes do not establish the command or revision originally used. |
| A benchmark remark supports a general preference for fewer tests | The surrounding conversation explicitly concerns cheaper benchmark tasks. | Require credible runtime evidence and bound paid-run cost. Do not cite this exchange as an anti-testing preference. |
| Curriculum work supports Matt `teach` broadly | Course/notebook **authoring** and coaching the user through a learning workspace are different jobs. | Use research, human-facing writing and executable exercises for authoring; reserve Matt `teach` for explicitly requested personal learning. |
| Prioritize verification maintenance as a general addition | Existing runbooks already cover some repeated verification. Pstack maintenance specifically consumes a mapped verification skill and drives its whole map. | Make maintenance conditional on that asset and observed drift, not a default extra check on every change. |
| Missing model-roster entries indicate a discovery defect | Many methods are deliberately manual-only upstream. | Repair missing files and broken dependencies; do not silently convert manual methods to automatic invocation. |
| All-history counts can approximate human workflows | OMP has indexed paths whose transcripts are unavailable; Hermes includes benchmark runs, replay and delegated prompts. | Retain file/record units and targeted semantic evidence, not a synthetic “human workflow” denominator. |

Recommended mix, still pending adoption:

- Keep known small changes direct; use `wayfinder` only for multi-session **decision uncertainty**, not routine implementation.
- Restore the five already-selected missing pstack skills; keep `how`, `why` and `blast-radius` distinct.
- Keep Matt's public `/tdd` for deliberate feature TDD. Preserve pstack's complete bug-regression contract in the diagnosis recipe; a separately named regression entry remains an option if independent invocation is wanted.
- Prioritize `writing-for-agents` for agent-facing documents. Treat `technical-writing` as a separate, justified candidate for substantial human/learner-facing materials, not as a substitute for it.
- Reuse existing runtime drivers. Add verification creation only for a missing reusable path, and maintenance only for an existing mapped verification skill.
- Repair WIP snapshots, dependency recovery and action permissions before calling the selected recipes executable.

No roster, source pin or invocation policy has been changed by this report.

## Current sources: three different baselines

### Matt Pocock

| Baseline | Observed state |
|---|---|
| Manifest-pinned source | `mattpocock/skills#v1.2.3`, resolving to `6acc160e4e0cd062dbbbd7a1b26ae92855edf07e`; latest release remains `v1.2.3` |
| Prior source review | `3cca18b368ae95cdbdebbff572ccafa662551015` |
| Current default branch | `c55ee46073ed923f86ce59a5eb3b6d895095d1b7` |

Current tree: **38 skill bodies = 25 promoted + nine beta + four misc**. The plugin manifest contains 18 engineering and seven productivity entries and still reports version `1.2.3`. Version text is therefore not proof that default-branch bodies equal the release. [Manifest][m-manifest], [tree][m-tree], [release][m-release].

Two comparisons matter:

1. **Since the September 13 review:** 13 commits, seven changed files, no promoted-skill changes. The delta is new beta `pr` files, its beta catalogue entry, a four-line `retro` change, and two changesets. Historical promotions/renames discussed in older reports are not new changes in this interval. [Exact comparison][m-recent].
2. **Since the manifest-pinned `v1.2.3` source:** 54 commits and **119 repository-wide changed files**. The release is an ancestor of HEAD; this is not a merge-base-versus-endpoint discrepancy. All 15 selected Matt `SKILL.md` bodies differ. Much of the textual delta comes from the em-dash removal pass; changed-file volume is not a measure of method improvement. [Release comparison][m-pin-diff].

The method changes are mixed: grilling gains a more explicit question/recommendation format; several consumers stop automatically invoking manual-only setup; domain-modeling's trigger changes; composition instructions become Claude-specific “Call the Skill tool” wording. Diagnosis removes its automatic post-mortem/architecture handoff, while `ask-matt` still describes that handoff. The removal is observed; whether to restore it is a tradeoff between follow-through and unnecessary escalation, not an established regression in outcomes. The stale reference is a source inconsistency. [Diagnosis change][m-diagnosis-change], [router][m-router].

**Installed bytes now checked:** all 19 Matt-derived descriptors under `~/.claude/skills` equal the reviewed HEAD bodies; all compared upstream supporting assets also match. Eighteen descriptors differ from `v1.2.3`; `implement` matches both and cannot distinguish the refs. This does **not** establish that HEAD itself was installed, when installation happened, or that the installer ignored a tag.

Published `skills` CLI **1.7.0** source supports `#ref`, including tags, and a fetch/checkout fallback for full 40-character commit SHAs. The TASK agent checked the published package, not just its README. Thus “the README omits it” is not evidence that pinning is unsupported. This inspection did not establish behavior at every older CLI version allowed by the repository's floor. No installation was performed. [Published CLI][skills-cli].

The new beta [`pr`][m-pr] is a PR-body reference: compact structural summary, before/after evidence and reversibility/blast radius. It is not a scheduler or runtime verifier. The [`retro` body][m-retro] now has a substantive procedure and stronger deterministic-check guidance, **but the current beta README still labels it “STUB: design notes only, not functional yet.”** Treat that source/documentation mismatch as a maturity caveat, not a graduation announcement. Both remain excluded from the plugin. [Beta policy][m-beta].

### Pstack

Current repository HEAD: `640ea3abfbdef74aad432b58d8586e4bf645f42d`; plugin version `0.15.2`. Catalogue remains **24 workflow/utility skills plus 23 principles**. The TASK rerun independently resolved HEAD and found zero tags with `git ls-remote`; an immutable commit pin remains possible.

Subtree comparisons independently reproduced **zero changed `pstack/` paths** from both:

- prior reviewed `5bf2b1544db739998121a306340631963c2ff3de` — repository 15 commits ahead;
- vendored `c1c0a32802223f4be824112dd83d33ad29a8b26c` — repository 11 commits ahead.

A newer monorepo HEAD does not justify refreshing an unchanged vendored subtree. The last commit touching `pstack/` is the prior-review commit itself. The TASK agent also byte-compared the nine vendored skill packages and LICENSE against upstream; they match. [Review comparison][p-review-diff], [vendor comparison][p-vendor-diff], [local provenance](../agentic_env/vendored/pstack/UPSTREAM.md).

**Invocation is part of the contract:** 46 of 47 pstack descriptors set `disable-model-invocation: true`; `setup-pstack` is the exception. Preserving or deliberately changing that policy is a separate adoption choice, not an incidental porting detail.

## Host-history coverage and limits

### What “all available” means here

Both passes enumerated the available conversation stores and structurally parsed every discovered historical OMP JSONL and Hermes archive. The TASK rerun independently reconciled the stores and reviewed requests, surrounding responses and corrections across the date range.

**Coverage is complete inventory/structured parsing plus bounded semantic review, not exhaustive adjudication of every conversation:**

- **OMP:** opening-request digests for all 293 top-level files, generally truncated to 150 characters; targeted reading with context of 116 test/verification, 96 correction/drift, 57 boundary and 31 delegation turns. These categories can overlap. Not every user turn, assistant reply or nested transcript body was semantically read.
- **Hermes:** approximately 120 distinct message records read at 150–400 characters, 24 aggregate archive-only text fingerprints and roughly 30 tool-call samples, alongside full programmatic parsing. No session was read end-to-end. Six theme frames were counted rather than systematically drilled. Education/content-authoring method assessment remains a Hermes coverage gap; the recommendation below rests on OMP evidence and upstream contracts, not Hermes keyword totals.

Keyword misses and truncation can hide relevant context. These limits prevent exhaustive preference or outcome claims. Approvals and short steering messages remain meaningful human instructions, not disposable noise; “not matched by a machine-message marker” does not certify human authorship.

No credentials/auth files were inspected. Request-dump headers and raw private transcripts are not reproduced here. Private evidence is identified by local session/record pointers only.

### OMP

Source: `~/.omp/agent/sessions`; reconciled against `~/.omp/stats.db`. Checked the legacy `~/.pi/agent` root; it contains no session store. Additional OMP storage directories without top-level date-named sessions contained no JSONLs.

| Measurement | Result |
|---|---:|
| Raw JSONL files at TASK census | 1,002 |
| Excluded research lineage, including both rounds' children | 9 |
| Historical files parsed | **993** |
| Historical top-level date-named files | **293** |
| Nested historical files | **700** |
| Populated project directories | 24 |
| Parsed JSONL records, all types | 233,331 |
| Malformed/inaccessible historical files or records observed | 0 |
| Top-level files with user-message records | 269 |
| Top-level user-message records | 1,762 |
| Nested user-message records | 860 |

Top-level file timestamps span **2026-06-03 to 2026-09-21**. Six user-bearing top-level headers have `parentSession`. Subtracting them leaves 263 user-bearing files without that field, **not 263 proven independent human workflows**.

The stats snapshot's `file_offsets` table contains 988 paths, all present on disk. Fourteen raw paths were not indexed at the TASK census, versus ten in the earlier census; four new research children explain the difference. A separate check of the `messages` table found **44 referenced transcript paths unavailable on disk**, including 11 top-level paths: 3,135 indexed message rows and 159 user-row metadata entries totaling 87,064 recorded characters. These tables retain metrics, not recoverable transcript bodies. Those conversations could not be semantically reviewed from the checked stores. This is not proof of permanent deletion or its cause.

Missing paths include worktree-associated projects and a course project, so the surviving raw corpus may underrepresent those jobs. The earlier “953 human workflows” denominator remains invalid. Likewise, neither 293 top-level files nor 263 parentless user-bearing files is a substitute for semantic workflow segmentation.

The TASK agent reconstructed model-visible skill rosters from all 700 nested session initializations across 53 observed days. Manual-only methods such as `grill-with-docs`, `wayfinder` and `teach` are absent from those rosters while explicit loads/invocations exist. That is consistent with their declared invocation policy, not proof of a loader bug.

Explicit `skill://` reads and skill-prompt records are **load/invocation attempts in observable formats**, not universal activation counts, successful execution or measured benefit. Co-occurrence does not isolate a method's contribution. Exposure-adjusted non-use still cannot decide job fit; historical loads of removed skills do not justify reinstalling them.

### Hermes

Sources: `~/.hermes/state.db`, `~/.hermes/sessions`, `~/.hermes/.hermes_history`, and the July 18 pre-update snapshot. All SQLite connections were read-only.

| Measurement | Result |
|---|---:|
| Canonical DB session IDs | **782** |
| Root sessions | 344 |
| Parent-linked sessions | 438 |
| CLI sessions / subagent sessions | 629 / 153 |
| Canonical message rows | **94,112** |
| User / assistant / tool rows | 3,282 / 36,943 / 53,887 |
| JSON archives parsed | **334** |
| Session exports / request dumps | 263 / 71 |
| Archive-only session IDs absent from canonical DB | **77** |
| Malformed archive files observed | 0 |
| Readline history entries | 1,305 |

Canonical conversation history ends **2026-07-14** and begins May 16. The readline history has the same date range; 321 entries start with a slash command. It is not evidence of September Hermes usage.

The 77 archive-only IDs are represented by 77 session exports and one associated request dump. Their user text was included as a separate stratum. Within-ID exact user-text deduplication yields 366 texts; inherited/replayed requests prevent interpreting these as new human requests. Matching-ID archives contain another 188 distinct user texts not text-identical to DB rows; these are supplemental context, not automatically new conversations. Archives also contain automatic curator and continuation messages.

The snapshot has exactly the same session-ID set as the current DB. Its **94,112 messages equal the current rows across all shared schema columns**. Whole-row hashes initially differed because current schemas have added columns. Session differences in shared columns concern `system_prompt`, not extra conversation IDs. The snapshot therefore adds no distinct historical message content in the compared fields.

The TASK rerun identified **179 templated benchmark prompts in 179 sessions over 11 synthetic tasks**, concentrated on June 26–28. A broader working-directory/lineage grouping marks 204 sessions and 187 roots as benchmark-related; its remainder is not a certified “human workflow” count. Benchmark execution is genuine user work, but repeated harness prompts are not independent demand for each skill.

Continuation replay is directly evidenced by the same request and accompanying reply in successive sessions (`1598`, `1923`, `2194`, `2433`) with different timestamps. Content-equality measures detect repeated-content candidates, not exclusively replay: legitimate repeated approvals and identical tool output also recur. Marker-based classifications help navigate the corpus; they do not establish an exact human-request denominator.

The call/result distinction also matters: the rerun counted **2,055 `skill_view` call records versus 1,812 result rows**. These are not equivalent measures. Names such as `wayfinder`, `code-review` and `research` first appear in that call format on July 11, four days before cutoff; first observed load is not an adoption date. Current file mtimes cannot establish historical installation or exposure.

Seven literal “Failed to load skill” records concern `grill-with-docs` during May 16–22. Later loads are observable and no later instance of that exact failure marker was found; this does not prove every discovery issue was resolved. Keep this historical problem separate from the live five-file OMP installation gap and the observed concurrent-review snapshot races.

## What the history actually supports

| Observed work or friction | Implication for method choice | Sanitized local evidence |
|---|---|---|
| Standards/Spec review across both runtimes, including reviewer-reported snapshot changes | Keep two-axis review over one stable, explicitly scoped snapshot | OMP `01a0c556-3b19-75ce-ade4-a7362134ca16`; Hermes assistant findings `89011`, `89523`; reviewer dispatches `88914`, `89392`, `93016–93017`, `94049–94050` |
| Requests for runnable examples, runtime checks and existing release-verification execution | Exercise the existing driver/runbook first; create a reusable verification asset only when missing | OMP `01a0b11f-c1d2-706a-9e6a-f3534879370c`, line 436; `019fb6e5-19ef-7000-bcb5-592b0b42c670`, line 836; Hermes `93379`, `93866` |
| Benchmark scope constrained by paid-run cost | Choose a representative, bounded run; do not generalize this into opposition to regression tests | OMP `01a05955-d095-7593-827d-d73bd75e1cb9`, lines 154 **and 263** |
| Decision interviews alongside implementation-ready requests | Batch the answerable frontier; route settled work directly rather than mandate another interview | OMP `019f04e3-3089-7000-aaee-973be9b8c8cc`; implementation-ready runbook instances `019f66a2`, line 5, and `019f669a`, line 7 |
| Explicit handoffs, worktree batches and separately withheld commit/push/merge actions | Preserve transferable handoffs where requested; grant each publication action separately | OMP `01a0b13b-d8d1-7566-9d79-2d0efe89ee66`, line 1666; `01a0b0db-4249-7438-8c5f-aad00b34c97e`, line 205; Hermes `93889`, `93900` |
| Course/notebook production, runnable local/platform exercises and factual scrutiny of materials | Give authoring its own recipe; do not equate it with coaching the user through Matt's learning workspace | OMP `01a0bf85-a7f5-7169-b905-b2464b49842d`, line 6; `01a0b977-55e7-7362-b4e1-24480fd54689`, line 25; `01a05df3`, `01a05ece`; July `019f42d2-0414-7000-a98c-f58f5e815eb6` |
| Report-only security work followed by separately authorized remediation | Keep specialist security review; `blast-radius` is not a replacement audit | OMP `01a0b13b-d8d1-7566-9d79-2d0efe89ee66`, line 1402; `01a0ba99-f32d-7388-a2d0-6825bdfd749a`, line 172 |
| Delegation friction and explicit requests to spawn fewer workers | Partition ownership and require aggregation/coverage accounting; fan-out is not a default quality multiplier | OMP `01a0b0db`, line 43; Hermes `86807`, `87031` |
| Native memory/search and repeated checkpoint reattachment | Keep durable memory, transcript reconstruction and transfer documents as different jobs | Hermes memory/session-search calls; May 20 continuation chain and readline `/clear`/reattachment patterns |

**Attribution correction:** Hermes `88914`, `89392`, `93016`, `93017`, `94049` and `94050` are first `user`-role messages in **subagent** sessions: reviewer dispatches, not direct human requests. The actual snapshot-change findings are assistant records **`89011` and `89523`**. Notably, `89523` reports a mismatch despite dispatch `89392` already requiring a frozen staged snapshot. A written snapshot instruction alone did not guarantee a stable review input in that instance.

The earlier benchmark citation was misread. It does not justify “the user wants fewer tests.” Cheap meaningful regressions versus brittle test scaffolding remains a method/design tradeoff supported by pstack's explicit fallback, not a preference inferred from that conversation.

Native OMP compaction/handoff artifacts and Hermes checkpoint practices already serve context continuation. Reuse them when sufficient; an explicit repository handoff for another person, worktree or runtime is a different transfer requirement. Artifact volume proves neither successful transfer nor that a second skill is necessary.

These are observed requests and qualitative findings, not causal measurements. No success rate, skill productivity ranking, wall-time advantage or adoption decision follows from usage counts.

## Installed, wired and adopted are different

The manifest already selects **32 = Matt 15 + pstack nine + Ponytail six + Caveman two**. Issue #42's “nothing changed yet” premise predates the September 15 adoption/vendoring decisions now in `main`.

| Live top-level root | Valid skills | Curated present |
|---|---:|---:|
| `~/.agents/skills` | 40 | 27/32 |
| `~/.claude/skills` | 34 | 27/32 |
| `~/.hermes/skills` | 51 | 27/32 |

All three lack **`how`, `why`, `blast-radius`, `interrogate`, `unslop`**. Eleven curated Claude/Hermes directories are copies rather than symlinks; their present `SKILL.md` bodies match the store. Installed pstack `recall`, `reflect` and `show-me-your-work` differ from vendored bodies; `create-verification-skill` matches. This census compared top-level descriptors, not every supporting asset.

The TASK source audit extends the Matt portion beyond descriptor presence: the Claude root has all 15 selected Matt packages plus **`implement`, `improve-codebase-architecture`, `wait-what` and `wizard`**. All 19 descriptors and the compared upstream assets match reviewed HEAD. One additional local `research/DESCRIPTION.md` is not in that upstream package; its runtime effect was not established. Do not delete it or expand the manifest to absorb extras without a separate provenance/fit decision.

`setup-matt-pocock-skills` is absent although review/spec/ticket/decision methods name it as setup or recovery. This repo already has `docs/agents/issue-tracker.md`, so the pointer is a **fresh-repo/recovery gap**, not proof that every current invocation fails. Provide the required configuration through one supported setup path; do not add a second setup owner merely to satisfy a name.

OMP `18.2.8` loads the curated set through Claude's root: `skills.enableClaudeUser: true`, `skills.enableAgentsUser: false`. Its own two-skill root is not the curated inventory. Hermes is a separate secondary runtime, not proof that OMP adaptations execute there.

Ten present curated descriptors are manual-only: `create-verification-skill`, `grill-with-docs`, `handoff`, `recall`, `reflect`, `show-me-your-work`, `teach`, `to-spec`, `to-tickets`, `wayfinder`. The blanket policy statement that all Pocock skills are model-invocable is inaccurate. A **Core** recipe role does not imply automatic invocation; the existing [glossary](CONTEXT.md#skill-lifecycle) already makes that distinction.

Executed in the **preceding pass**, from `agentic-env`; not rerun to reconfirm the known failure:

```text
uv run --frozen agentic-stack-doctor
exit 1
mandatory failure: curated roster (default) under ~/.claude/skills
missing: how, why, blast-radius, interrogate, unslop
```

Exactly one mandatory check failed. Other reported mandatory gates passed. Doctor currently establishes descriptor presence, not dependency completeness, provenance equality, review coverage or actual skill execution.

## Preferred recipes and their work products

“Core” below means the default method **for its named job**, not a universal pipeline. Supporting skill bodies and assets must resolve before a composed recipe is advertised as executable.

Source contracts for the main additions and distinctions: [`how`][p-how], [`why`][p-why], [`blast-radius`][p-blast], [pstack bug-regression TDD][p-tdd], [explanation-only teaching][p-teach], [`writing-for-agents`][m-writing], and [`technical-writing`][p-writing]. Writing guidance must preserve valid repository terminology and formatting conventions; punctuation and indentation preferences are not universal correctness rules.

| Job and trigger | Proposed core | Escalation and trigger | Required work product |
|---|---|---|---|
| Small, explicit, low-risk change | Direct implementation using existing context | `how` only if current behavior is unclear | Changed behavior plus the smallest credible check |
| Requirements with consequential open choices | `grill-with-docs` → `grilling` + `domain-modeling` | `wayfinder` for a multi-session decision graph; `prototype` for a concrete state/UI question | Answered frontier, consistent vocabulary; prototype evidence when used |
| Understand existing behavior | pstack `how` | `why` when rationale matters; Matt `research` for external facts | Entry points, ownership, runtime flow and constraints; rationale with confidence labels |
| Feature/interface design | Matt `codebase-design` | Matt `tdd` when deliberate test-first development is wanted; competing designs only when wrong seams are expensive | A narrow interface and consumer-visible contract; independent red/green evidence where appropriate |
| Hard bug or performance regression | Matt `diagnosing-bugs` plus pstack's full practical bug-regression contract | `blast-radius` for cross-cutting effects | Reproduction, falsifiable hypotheses, before/after evidence; cheap meaningful regression test or explicit executable fallback |
| Nontrivial delivery review | Matt `code-review` | `blast-radius` for runtime/downstream risk; `interrogate` for high-stakes disagreement | Standards and Spec findings against the intended complete snapshot; separate executed safety facts |
| Repeated app/runtime verification | Existing repository driver or runbook | `create-verification-skill` only when missing; `maintain-verification-skill` only for an existing mapped verification skill that needs maintenance | Reproducible launch/doctor/drive/evidence/cleanup; normal work exercises affected paths |
| Durable multi-session delivery | `to-spec`, then `to-tickets` when implementation slices are needed | Native continuation first; explicit `handoff` for a transfer not already served; `wayfinder` for unresolved decisions | Approved spec/tickets/dependencies or one bounded handoff; no implicit publication |
| External research | Matt `research` | `how`/`why` only for unresolved repository facts | One cited, source-checked findings artifact |
| Personal, sustained learning | Matt `teach`, explicitly requested | `research` and runnable examples | Mission, resources, lessons and learner records; this is coaching, not a general course generator |
| Course, notebook or training-material authoring | Source-backed `research`, existing project authoring conventions and runnable exercises | `technical-writing` for substantial human-facing documents; prototypes only for uncertain teaching interactions | Correct materials, executable examples, checked answers and clear local/platform prerequisites |
| One-off code explanation | Read-only `how` and, where useful, `why`, composed with pstack `teach`'s explanation rules | `unslop` when prose needs cleanup | Audience-appropriate explanation preserving confidence language and skipped-source limitations; no learning workspace |
| Agent/process documentation | Proposed `writing-for-agents` with `SKILL-MECHANICS.md` | `unslop` for editorial cleanup | Discoverable triggers, dependencies, information hierarchy and completion criteria, not merely shorter prose |

`resolving-merge-conflicts` remains the situational merge-conflict procedure. Existing Ponytail/Caveman presentation and simplicity modes do not replace diagnosis, verification, documentation design or review. No roster change to those packs is proposed by this source refresh.

Pstack `/tdd` is a real, separately invocable **TDD Bug Fix** skill. Its trigger is an explicit request **or** an obvious cheap local bug test. Preserve the whole contract: choose the narrowest check, establish the right failure before changing production code, fix, rerun, exercise nearby risk, and explain an executable fallback when a new test is impractical. Folding that into diagnosis is a selection recommendation, not a claim that the two upstream TDD methods are equivalent. It trades a separate public entry point for fewer names. [Source][p-tdd].

Pstack's broader `poteto-mode` bug-fix playbook adds evidence-driven hypothesis elimination and verification on the original runtime surface. Those ideas can inform diagnosis without importing its whole persona, mandatory architecture escalation or commit/PR sequence. [Playbook][p-bug-playbook].

The teaching distinction is source-level: Matt `teach` manages the user's multi-session learning state; pstack `teach` composes `how`/`why` into an explanation and explicitly preserves epistemic hedges. Matt's misc `scaffold-exercises` instead assumes `pnpm ai-hero-cli internal lint`, a specific exercise layout and a commit. It is not a ready-made solution for the observed notebook/course authoring work. [Matt teach][m-teach], [pstack teach][p-teach], [exercise scaffold][m-exercises].

### Expensive and retrospective methods

- **`architect` + `arena`:** valuable for expensive competing designs, not an everyday planning layer. Dependencies include `how`, `why`, a model runner and isolated candidate outputs. Arena adds a rubric, cross-judging, base selection, selective grafting and verification. Native fan-out alone supplies none of that. Design-only use must stop before architect's default implementation phase. [Architect][p-architect], [arena][p-arena].
- **`swarm`:** adds a done predicate, worker shape, output ownership, dropout accounting and aggregation; native fan-out is not the same contract. Upstream explicitly requires Cursor cloud workers (`environment: "cloud"` and `cloud_base_branch`). Keep the method available for deliberate adaptation, not an unmodified default. [Swarm][p-swarm].
- **`reflect`:** explicit retrospective only. Accepted skill edits require approval but Backlog filing is automatic upstream; gate both independently. It also requires Cursor `create-skill` and write-capable investigator/synthesizer modes to retain MCP access. That is not an enforced read-only boundary. [Reflect][p-reflect].
- **`recall`:** transcript/context reconstruction, **not Mnemopi or the Hermes memory bank**. The operative memory-bank description is inaccurate. It depends on transcript access, `why`, live repository/PR checks and `unslop`. Keep a single durable-memory owner and distinguish the skill from memory retrieval tools. [Recall][p-recall].
- **`show-me-your-work`:** useful decision/evidence pointers across sessions. Its TSV is not revision-bound or freshness-checked proof. Re-run the relevant scenario after the code changes. [Source][p-work].

## Integration blockers, not reasons to dismiss methods

### Review scope: executed counterexample

In the preceding pass, Main created a disposable Git repository with one committed change, one staged change, one unstaged change and one untracked new file. Results:

```text
git diff --name-only <base>...HEAD
  committed.txt

git diff --name-only <base> --
  committed.txt
  staged.txt
  unstaged.txt

git ls-files --others --exclude-standard
  new.txt
```

The repository was removed automatically afterward; the real checkout was untouched. This proves the HEAD-ended contract omits legitimate WIP. It does not by itself implement a complete replacement review.

The selected review must name its baseline, capture intended committed/staged/unstaged/untracked content, exclude unrelated user work, and give both review axes the same stable snapshot. It must distinguish explicit-ref review from WIP review, rather than silently widen every request. “Commit first” is not a fix: it forbids legitimate pre-commit review and can require an unauthorized commit. Matt `implement` still invokes review before committing without supplying the required fixed point; pstack `interrogate` also defaults to `main...HEAD`. [Matt review][m-review], [implement][m-implement], [interrogate][p-interrogate].

`MattTask` independently reproduced the modified/untracked case: both the HEAD-ended diff and `<base>..HEAD` commit log are empty when all new work is uncommitted. This can also defeat commit-message-based spec discovery. The defect exists at both audited Matt baselines; changing the source pin does not repair it.

### Names, dependencies and permissions

- The installer selects names; it has no rename layer. Do not let discovery order choose between the two `tdd` or two `teach` contracts. Recommended public names remain Matt's, with the distinct pstack regression/explanation contracts preserved in named recipes. Separate source-qualified entries are an alternative, not an implemented feature.
- Upstream manual-only flags are intentional defaults. Missing descriptors, absent supporting assets, manual invocation and missing model-roster advertisements are different states. Verify the chosen policy on the real runtime before claiming a recipe is wired.
- `why` and `reflect` explicitly require `readonly: false` workers for Cursor MCP access. Keep the research read-only in intent and adapt capability access deliberately; do not treat a prompt prohibition as a permission boundary. [Why][p-why], [reflect][p-reflect].
- `create-verification-skill` writes `.cursor/skills/verify-<app>/` and initially proves **one** mapped feature. Maintenance checks coverage and drives **every** mapped feature, confines edits to the verification-skill directory and can open a PR. Adapt paths and publication authorization; do not turn full-map maintenance into a mandatory per-change suite. [Create][p-create], [maintain][p-maintain].
- Preserve complete packages and references: `writing-for-agents` needs `SKILL-MECHANICS.md`; explanation depends on `how`/`why`; `reflect` relies on `create-skill`; a future `no-comments` port needs its custom `Comment Sicko` agent. `no-comments` is not among the current vendored nine.
- OMP and Hermes delegation APIs differ from Cursor's. Model aliases or vendor labels do not establish independent model behavior. Record substitutions, ownership, worker failures and aggregation rather than claiming diversity or complete coverage from dispatch count.
- File writes, credential access, tracker writes, branch creation, commits, pushes, PR creation and merging are separate effects. Neither model invocation nor a slash invocation authorizes every downstream action. `wizard` deserves particular scoping: it is model-invocable and its source asks to read `.env` files while authoring a human-run setup script. This research did **not** inspect those files or execute that workflow. [Wizard][m-wizard].
- `writing-for-agents` and `technical-writing` solve different jobs. Preserve valid repository vocabulary and formatting. `unslop` rule numbers are stable cross-skill citation IDs, not a list to renumber casually; technical-writing explicitly allows exceptions when a rule harms the reader. [Agent writing][m-writing], [human writing][p-writing].
- Import useful principles with their boundaries, not all descriptors. Upstream presents the principle names as steering vocabulary read through `poteto-mode`'s index. A blanket undefined-import test-deletion classifier is unsound; `build-the-lever` really does demand an artifact for nontrivial work, including one-offs. Retain meaningful behavioral tests and reuse existing proof mechanisms rather than copying those absolutes. Do not drop the irreversible-action boundaries from `never-block-on-the-human`. [Principle guide][p-principles], [test principle][p-test-principle], [lever principle][p-lever], [human boundary][p-human-boundary].

## Explicit non-selections and reopening conditions

| Not selected as a default addition | Reason | Reopen when |
|---|---|---|
| Both full packs / all 23 pstack principles | Job fit does not require every descriptor; principle vocabulary has its own index/composition contract and several rules need narrowing | A specific missing job contract is identified |
| A second unqualified `tdd` or `teach` | Flat-name collision; two different products | User chooses explicit source-qualified entry points |
| Matt `implement` | WIP-blind review-before-commit sequence and an unconditional commit instruction; currently present outside the curated roster | Review and authorization integration is resolved and the wrapper adds needed behavior |
| Beta `implement-spec` | Introduces a second ticket/worktree/PR scheduler | One scheduler is deliberately assigned ownership and tested |
| Beta `pr` | Useful output template, but not promoted and no installation need shown | An explicit bounded PR-authoring trial |
| Beta `retro` | Substantive body but still beta; stale README label; depends on `writing-for-agents` | Explicit trial with dependencies available, not an inferred graduation |
| `automate-me` | Personal-skill authoring with worktree/commit/PR side effects | User explicitly wants that artifact and authorizes landing |
| Mandatory arena/swarm/panel on all work | Coordination does not pay for small deterministic tasks | Expensive alternatives or genuinely partitionable evidence gathering |
| A second durable-memory owner | `recall` is not a memory-bank method | Never by accidental naming; only a separate product decision |

### Catalogue-wide disposition

The TASK agents dispositioned every discovered body: Matt **38** and pstack **24 workflow/utility skills**, with pstack's **23 principles** considered separately as vocabulary/standards candidates. “Keep” below means proposed job fit, not newly adopted or automatically invoked.

| Matt group | Disposition |
|---|---|
| Selected 15: `wayfinder`, `grill-with-docs`, `grilling`, `domain-modeling`, `research`, `prototype`, `to-spec`, `to-tickets`, `codebase-design`, `tdd`, `code-review`, `teach`, `handoff`, `resolving-merge-conflicts`, `diagnosing-bugs` | Keep their named jobs with the narrower routing, scope and permission contracts above |
| `writing-for-agents` | Priority addition for agent-facing documentation, including its mechanics asset |
| `improve-codebase-architecture`, `wizard`, `wait-what` | Existing uncurated extras: architecture survey, human-only setup and message clarification respectively; separate situational fit decisions, not automatic manifest expansion |
| `implement` | Do not route through the unadapted wrapper |
| `setup-matt-pocock-skills`, `triage`, `to-questionnaire` | Supported setup/recovery path, issue-state management and asynchronous decisions are distinct jobs; no automatic addition without the corresponding need |
| `ask-matt`, `grill-me` | No default addition: router depends on a broader catalogue; separate interview entry overlaps selected routing |
| Beta `pr`, `retro`, `implement-spec` | PR-format reference, retrospective and full-delivery scheduler: bounded trials only; resolve dependencies and ownership |
| Beta `claude-handoff`, `loop-me`, `setup-ts-deep-modules`, `writing-beats`, `writing-fragments`, `writing-shape` | Specialized background-session, workflow-spec, TypeScript or article-authoring jobs; not selected for the current recipes |
| Misc `git-guardrails-claude-code`, `migrate-to-shoehorn`, `setup-pre-commit`, `scaffold-exercises` | Harness/language/toolchain-specific jobs; preserve useful ideas without importing unrelated setup or course tooling |

| Pstack workflow/utility group | Disposition |
|---|---|
| `how`, `why`, `blast-radius` | Preserve distinct behavior, rationale and executed-safety methods |
| `interrogate` | High-stakes adversarial review with real, declared model configuration |
| `unslop`, `technical-writing` | Editorial cleanup and substantial human-facing writing, with domain-language exceptions |
| `create-verification-skill`, `maintain-verification-skill` | Conditional asset creation and maintenance; existing runtime drivers first |
| `show-me-your-work`, `recall`, `reflect` | Audit trail, transcript reconstruction and explicit retrospective; different artifacts and permission boundaries |
| `tdd`, `teach` | Preserve their distinct regression and explanation contracts; resolve public-name collisions deliberately |
| `architect`, `arena`, `swarm` | Expensive design alternatives or partitioned coverage only, after runtime/ownership adaptation |
| `poteto-mode`, `figure-it-out`, `setup-pstack` | Do not import a second working persona or Cursor configuration owner |
| `automate-me`, `no-comments` | Personal-method authoring or custom-agent comment review only on explicit need; not default additions |
| `bro`, `make-bot-ui`, `typescript-best-practices` | Message simplification, vendor-specific bot exposure or TypeScript guidance; no missing core job established here |

Existing specialist security auditing, architecture surveying and human-only setup/wizard tools remain situational capabilities, not silently removed because this reassessment centers Matt and pstack. Their presence outside the curated manifest is not adoption proof.

## Research-phase acceptance state (before approval)

| Acceptance area | Evidence at research time | What remained before implementation |
|---|---|---|
| Job-routed selection and dependencies | September 15 policy plus this proposed correction | User decisions; operative recipe/role update |
| Installer/discovery/provenance | Manifest and vendoring exist; five curated descriptors missing; live Matt bytes differ from release pin | Agreed source for selected skills, reproducible package/assets, supported setup recovery and actual dependency-load checks |
| Collision resolution | Existing public names select Matt; distinct pstack contracts retained in recommendations | Adopted regression, explanation, personal-learning and authoring routes with unambiguous dispatch |
| Complete review scope | Defect reproduced in scratch Git repository | Implement and exercise committed/staged/unstaged/new-file review |
| Bounded side effects | Specific filesystem, credential, tracker, write-capable-worker and publication paths inspected | Runtime-appropriate boundaries; explicit design-only stop; invocation policy preserved or deliberately changed |
| Safe principles | Narrowed standards exist; unsafe source absolutes identified | Keep adopted language consistent across effective prompts/docs |
| End-to-end scenarios | Doctor and scope experiment only | Small known change, meaningful bug, risky downstream/runtime scenario on the supported runtime |
| Consistent documentation | This research artifact only | Update decisions, README/overview and affected runtime docs after approval |

No selected-skill end-to-end run, controlled performance experiment or Hermes portability test occurred in either research pass. Source inspection, package byte comparisons, corpus parsing and Git scope experiments must not be presented as that proof. No project build, lint or test suite was needed for this research document.

## Approved selection and implementation (2026-09-21)

The user subsequently authorized implementation. The selected default roster is **38 skills: 19 Matt, 11 pstack, six ponytail and two caveman**. This supersedes the research-phase decision frontier, not its historical observations.

- **Routing:** keep direct work direct; `wayfinder` serves multi-session decision uncertainty. No universal chain, mandatory lone worker, blanket verification maintenance or global `unslop` injection.
- **Reproducibility:** vendor the nineteen complete Matt packages at `c55ee46073ed923f86ce59a5eb3b6d895095d1b7`, with documented local adaptations. Keep the pstack baseline; record `640ea3abfbdef74aad432b58d8586e4bf645f42d` for the two added packages without claiming an upstream subtree refresh. Both vendored roots retain licences and provenance.
- **Selection:** add `writing-for-agents`, `technical-writing` and `maintain-verification-skill`; curate existing architecture survey, `wizard` and `wait-what`; restore `how`, `why`, `blast-radius`, `interrogate` and `unslop`; retain verifier creation. Remove the unadapted installed `implement`. No `bro`, second public `tdd` or second public `teach`. Folding the full pstack regression/teaching contracts into Matt's methods was **not approved**.
- **Authority:** all eleven pstack skills and `wizard` remain manual-only; `writing-for-agents` keeps its narrow agent-document trigger. Named composition does not authorize credential inspection, infrastructure mutation or publication. Actual read-only grants are distinguished from prompt-only prohibitions; unrestrictable delegation falls back to parent investigation or tool-less snapshot review.
- **Review:** `refs` and explicit-path `wip` modes use a shared frozen snapshot, covering intended committed/staged/unstaged/untracked changes without altering user staging. Integrity checks run before and after review; prompts/results stay outside the snapshot. Checksums detect mutation, not prohibit writes. Actual returned provider/model identities determine diversity.
- **Verification lifecycle:** generated verifiers live in project `.agents/skills/verify-<app>`. Creation proves one mapped feature; maintenance exercises every mapped feature and edits only the verifier directory. Routine changes exercise affected paths, not the whole map automatically.

### Exercised evidence and limits

| Check | Observed result |
|---|---|
| Distributable wheel | Built successfully; all **98 vendored files**, including both licences/provenance records, and `skill-packs.json` matched source bytes |
| Isolated installer | Nineteen Matt + eleven pstack packages installed through `python -m agentic_env.install_skills_mcps`; 94 supporting/package files matched vendored bytes |
| Live default installation | All 38 descriptors present; all 38 Claude and 38 Hermes links resolve to the canonical store; final vendored bytes match; the user's extra `research/DESCRIPTION.md` preserved |
| OMP named discovery | All 38 installed skills resolved through `omp read`; authoring reference and wizard descriptor loaded; disposable project `.agents/skills` verifier resolved |
| OMP automatic visibility | With read capability and a wizard/authoring filter, the runtime advertised only `writing-for-agents`; named manual loading still works. A no-tools probe advertised neither, so it was not used as evidence of the manual flag |
| Hermes discovery | All 38 catalog entries and named views succeeded; authoring, explorer and reviewer supporting files loaded |
| Hermes project trust | Disposable verifier absent before trust, discovered after `hermes skills trust`, then trust revoked—all in isolated `HERMES_HOME`; real trust settings untouched |
| Frozen review and real models | Requested and returned `anthropic/claude-haiku-4-5` and `openai-codex/gpt-5.6-luna`; both found the planted `eligible(18)` boundary bug from identical prompt bytes, no substitutions; snapshot integrity passed afterward |
| Regression checks | `uv run --frozen --with pytest python -m pytest`: **69 passed**. Includes WIP/index preservation and rejection of failed/aliased responses as model diversity. Snapshot check also passed on host Python 3.10 |
| Stack doctor | `stack OK (0 secondary warning(s))`, including the complete 38-skill roster |

**Compatibility limits:** installed Hermes still advertises manual-only skills because it ignores `disable-model-invocation`; descriptions and body guards are behavioral, not enforced hiding. Its loader also emits warnings for canonical-store symlink targets, while loading succeeds. Neither warning was suppressed by relaxing trust. Native Hermes model-provider review was not established; the working multi-model path uses OMP from either client. These checks establish installation, discovery, scope/integrity and the reviewer path—not end-to-end execution of every skill, a performance comparison or closure of every broader issue acceptance scenario. No project commits, pushes, PRs or tracker writes were made.

## Sources

Primary source links identify the audited revisions or published package version. The TASK evidence artifacts are `local://redo42-matt.json`, `local://redo42-pstack.json`, `local://redo42-omp.json` and `local://redo42-hermes.json` in this research session. They retain measurements, coverage limits and agent judgments; their drafts are not independent authority, and this report adopts only the reconciled claims above. Private corpus evidence remains local session/record pointers, not published transcripts. Prior practitioner comparisons were not rerun and are not controlled efficiency evidence.

[m-tree]: https://github.com/mattpocock/skills/tree/c55ee46073ed923f86ce59a5eb3b6d895095d1b7
[m-manifest]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/.claude-plugin/plugin.json
[m-release]: https://github.com/mattpocock/skills/releases/tag/v1.2.3
[m-recent]: https://github.com/mattpocock/skills/compare/3cca18b368ae95cdbdebbff572ccafa662551015...c55ee46073ed923f86ce59a5eb3b6d895095d1b7
[m-pin-diff]: https://github.com/mattpocock/skills/compare/6acc160e4e0cd062dbbbd7a1b26ae92855edf07e...c55ee46073ed923f86ce59a5eb3b6d895095d1b7
[m-beta]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/in-progress/README.md
[m-pr]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/in-progress/pr/SKILL.md
[m-retro]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/in-progress/retro/SKILL.md
[m-review]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/code-review/SKILL.md
[m-implement]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/implement/SKILL.md
[p-review-diff]: https://github.com/cursor/plugins/compare/5bf2b1544db739998121a306340631963c2ff3de...640ea3abfbdef74aad432b58d8586e4bf645f42d
[p-vendor-diff]: https://github.com/cursor/plugins/compare/c1c0a32802223f4be824112dd83d33ad29a8b26c...640ea3abfbdef74aad432b58d8586e4bf645f42d
[p-architect]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/architect/SKILL.md
[p-arena]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/arena/SKILL.md
[p-swarm]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/swarm/SKILL.md
[p-reflect]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/reflect/SKILL.md
[p-recall]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/recall/SKILL.md
[p-work]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/show-me-your-work/SKILL.md
[p-interrogate]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/interrogate/SKILL.md
[p-create]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/create-verification-skill/SKILL.md
[p-maintain]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/maintain-verification-skill/SKILL.md
[p-test-principle]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/principle-test-behavior-not-implementation/SKILL.md
[p-lever]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/principle-build-the-lever/SKILL.md
[p-types]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/principle-type-system-discipline/SKILL.md
[p-how]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/how/SKILL.md
[p-why]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/why/SKILL.md
[p-blast]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/blast-radius/SKILL.md
[p-tdd]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/tdd/SKILL.md
[p-teach]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/teach/SKILL.md
[m-writing]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/productivity/writing-for-agents/SKILL.md
[p-writing]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/technical-writing/SKILL.md
[m-diagnosis-change]: https://github.com/mattpocock/skills/commit/1dab98299c3b81f560026c01b7ebf55ed5d91373
[m-router]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/ask-matt/SKILL.md
[skills-cli]: https://registry.npmjs.org/skills/-/skills-1.7.0.tgz
[m-teach]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/productivity/teach/SKILL.md
[m-exercises]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/misc/scaffold-exercises/SKILL.md
[m-wizard]: https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/wizard/SKILL.md
[p-bug-playbook]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/poteto-mode/playbooks/bug-fix.md
[p-principles]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/docs/guide/08-principles.md
[p-human-boundary]: https://github.com/cursor/plugins/blob/640ea3abfbdef74aad432b58d8586e4bf645f42d/pstack/skills/principle-never-block-on-the-human/SKILL.md
