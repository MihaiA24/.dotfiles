# OMP Context Stack — Fast Read

> Every claim re-graded against primary sources 2026-07-28; no vendor claim survived at face value. Binding decisions: `agentic-env/docs/adr/0006`–`0008`. Tuning applied 2026-07-28; **judged 2026-08-11: bundle kept, lean-ctx dropped, memory flip trigger fired** (§State, §Open). History: `git log` on this file — long-form analysis and the read-out method live in prior revisions.

## State as of 2026-08-11 (branch `feat/agent-stack-measured-cleanup`)

| Where | Applied | Backup |
|---|---|---|
| OMP config | `compaction.thresholdTokens=150000` · `idleEnabled=true` · `strategy=handoff` · `handoffSaveToDisk=true` | `~/.omp/agent/config.yml.bak-tuning` |
| OMP extensions | `omp/hooks/verification-recorder.ts` + `omp/hooks/cadence-governor.ts` (N=25, write-steer ≥1 KiB) | `omp config set extensions '[]'` |
| OMP MCP | `mcpServers: {}` · `disabledServers: [agentmemory, node_repl, codebase-memory-mcp, lean-ctx]` | `~/.omp/agent/mcp.json.bak-leanctx-drop` |
| Hermes | 4 dead MCP servers `enabled:false` (agentmemory·mempalace·serena·codebase-memory-mcp); HERMES.md 3 lean-ctx blocks → 1 | `config.yaml.bak-tuning`, `HERMES.md.bak-tuning` |
| Memory | `backend: mnemopi`, `polyphonicRecall: false` (ADR-0006) | `/memory clear` before backend switch |

**Checked 2026-08-05:** hooks live; the "0 rows ⇒ experiment measures nothing" failure did not occur.
**Read-out executed 2026-08-11**, exactly on the pre-registered date (recorder db + top-level session jsonl, assistant-message usage sums; full method in prior revision).

Pre-registered success (set before data existed — do not move goalposts):

| Metric | Baseline | Success | Source |
|---|---:|---|---|
| Tokens/session (median) | 22.8 M | ≤ 16 M | session jsonl |
| Sessions ending green | 91.2% (n=57) | ≥ 92% on n ≥ 40 | recorder |
| Verification cadence | ~37 calls | ≤ 25 | recorder |
| write:edit ratio | 3.15 | < 2.0 | session jsonl |
| Rollback | — | end-green < 88% → revert `strategy` first, then threshold | recorder |

Q-A/Q-B applied together → attribution is to the bundle, accepted.

**Read-out 2026-08-11** — recorder: 374 events / 54 sessions (07-29→08-11); jsonl: 52 token-bearing sessions since 07-28:

| Metric | Measured | Verdict |
|---|---|---|
| Tokens/session (median) | 6.0 M vs 11.9 M same-method baseline (incl-subagents: 8.8 M vs 15.4 M) = **−43…−50%** | **pass** (target −30%) |
| Sessions ending green | **96.3%** (52/54, n ≥ 40) | **pass** |
| Verification cadence | **20.9** calls/verify (7,826 / 374) | **pass** |
| write:edit | as-registered **7.01** (fail) · file-writes-only **0.74** vs 0.51 clean baseline | **metric invalid** — note 2 |
| Rollback | end-green 96.3% ≫ 88% | not triggered |

Notes: (1) the 22.8 M baseline anchor does not reproduce under either method variant (11.9 M top-level / 15.4 M incl-subagents, same window) — grading used same-method deltas. (2) Both the 3.15 baseline and the <2.0 target counted xd:// virtual-device invocations as writes (memory/LSP/search devices ride the `write` tool); cleaned, the ratio is 0.51 → 0.74. Partial-miss policy (pre-registered 08-11 before data): bundle kept, miss recorded honestly, no re-tuning. (3) Per-command pass 89.0% at n=374 (was 94.3% at n=281) — not a criterion.

**Bundle verdict: kept.** 3/4 pass, 4th definitionally invalid.

## Use this stack

| Layer | Tool | Buys | Cost | Ev | Avoid |
|---|---|---|---|---|---|
| Host | **OMP core** | compaction, `read`, pruning, LSP/AST, lazy MCP | none | Host | disabling compaction |
| Context I/O | **OMP native only** — `read`·`grep`·`glob`·`edit`·LSP + scout subagents | prompt-cache-stable, anchor-safe | lean-ctx **dropped 08-11**: 1 semantic call since 07-28 < 5 kill threshold (ADR-0008 fallback); re-shop only when grep+LSP+scouts visibly fail on a real task | — | any compressor on read→edit path: anchor corruption 27/40→15/40[P1]; Headroom **+48.4%**[P1] |
| Memory | **Mnemopi** — flip trigger **FIRED 08-11** | per-project transcript recall, local SQLite | decision recall failed 4/4 probes (§Open); plain-text ADRs carried the truth | D (local meas. only) | second memory owner |
| Memory upgrade path | Hindsight vs **mem0** | local bake-off **now due** (ADR-0006 flip fired) | service+DB / platform-only headline | B | adopting without pre-registered endpoints |
| Code graph | codebase-memory-mcp | persistent graph, Cypher, cross-repo | **−9 pts quality** (83 vs 92) for 10× tokens; litmus fired **0×** since 08-05 (rechecked 08-11) | B | keep Gated; promotion trigger unchanged (litmus ~weekly → default-on per project) |
| Terse output | Caveman | shorter output | measured **−8.5%**, not 65%[J1] | A | expecting vendor claim |
| Less code | **Ponytail** | only measured *saving*: −10.3% cost[J3] | self-activates 0/10 — must force-inject | A | expecting −54% |

```yaml
compaction: { enabled: true, strategy: handoff, thresholdTokens: 150000, idleEnabled: true, handoffSaveToDisk: true }
memory: { backend: mnemopi }
mnemopi: { scoping: per-project-tagged, polyphonicRecall: false }
```

## Hard rules

1. **Judge by success-adjusted billed cost, never token reduction.**[P1] Payload reduction ⌐ cost: r=0.15 over 2,848 billed runs.
2. Prompt-cache traffic ≈ 87% of cost.[P1] Tool that can't touch cached re-reads can't move bill.
3. No lossy compressor on read→edit path: anchor corruption cut patch success 27/40 → 15/40.[P1]
4. One compressor per request path (one interception point per tool call).
5. One semantic-memory owner per agent.
6. OMP LSP owns live symbol truth.
7. codebase-memory-mcp only where tokens beat the 9-pt quality cost.
8. Caveman/Ponytail/Graphify on demand; Ponytail force-injected only.[J3]
9. No duplicate query-before-read hooks. **Wiring routes tools; prose doesn't** — 3×-repeated mandate = 15.6% adherence.

## Workflow, measured (934 sessions, 6.2 B tokens, 05-16→07-28)

Cost shares (OMP, rel. pricing in 1× / cw 1.25× / cr 0.1× / out 5×): **cache reads 68.6%** · output 12.8% · new input 11.2% · cache writes 7.3%. Cache-read token share: OMP 96.5%, Hermes 92.6% — P1 reproduced twice locally. Leverage: halve cache reads → **−34%**; Caveman at measured −8.5% → −1.1%; any tool-output compressor ceiling 11.2%.

Usage: host-native ~70–74%, lean-ctx 15.6–18.7%, orchestration 5–10%, **all else < 0.5%** (agentmemory 0 calls, node_repl 0, cbm 0.3%) — same distribution on both harnesses.

## Harness verdict

| | OMP | Hermes |
|---|---:|---:|
| Sessions · tokens/session | 152 · **22.8 M** | 782 · 3.5 M |
| Per instruction: tokens · turns | 4.03 M · 26.3 | 837 K · 11.3 |
| Per-command verify pass | **96.4%** (687) | 81.7% (2,734; own db 83.9%) |
| Same project (paw-backend) | **98.4%** (319) | 79.2% (130) |
| **Sessions end green** | 91.2% (57) | 94.2% (326) — **tie** |
| Verify cadence | every ~37 calls | every ~18 |
| Editing | write:edit **3.15** → 82 K out-tok/session | 6.1 patches/write → **12.9% patch fail** |

By model, pass rate: claude-fable-5 **98.6** · claude-opus-5 **98.1** · gpt-5.5 84.5 · gpt-5.6-sol 76.9 · **gpt-5.3-codex-spark on OMP 73.5** · deepseek 69.7. GPT on OMP lands in Hermes' GPT band → **gap is model, not harness. Model choice = largest quality effect measured in this document.** Confound: task→model never random.

**Verdict: OMP primary (capability: Anthropic models, LSP, recoverable anchors; revealed preference), tuned via Hermes' two good ideas (bounded units, verification cadence). Not substitutes; definitive answer needs paired benchmark (§Open).** Others: opencode installed+configured, 1 session (capability candidate, zero evidence); Codex 73 / Claude Code 5 sessions, dormant; cursor=IDE; qwen/factory/continue/goose empty. Dead on inspection: Hermes kanban (0 rows), "OMP under-delegates" (219 subagent files), Hermes lean-ctx "duplicate" (version rename).

## Skills on OMP — how selection works

No selection algorithm. Startup scan → every discovered skill's `name`+`description` injected into system prompt → model self-picks by description → content lazy-loads via `skill://<name>`; `/skill:<name>` = manual force-inject. Dedup by name, first-wins across provider priority (`omp://skills.md`):

| Pri | Provider | This host (08-07) | Skills |
|---:|---|---|---:|
| 100 | native `.omp`/`.pi` | empty (pruned 08-05) | 0 |
| 90 | omp-plugins | — | — |
| 80 | claude | `~/.claude/skills` (curated root) | 24 |
| 70 | claude-plugins · **agents** · codex | marketplace (caveman×5, karpathy, ponytail×6) · `~/.agents/skills` **disabled 08-07** | ~12 · ~~53~~ |
| 55 | opencode | `~/.config/opencode/skills` | 1 |
| 30 | github `.github/skills` | — | — |
| 5 | omp-managed (autolearn) | `~/.omp/agent/managed-skills` | — |

Same-name collision → higher pri wins. Scan non-recursive: `<root>/skills/<name>/SKILL.md` only; symlinked dirs followed, deduped by realpath; `disable-model-invocation: true` (7 of the mattpocock 13: wayfinder, grill-with-docs, to-spec, to-tickets, implement, teach, handoff) excludes a skill from the prompt roster **by design** — still loads via `skill://`/`/skill:`. Roster is an instance-start snapshot. Pruning levers: `skills.ignoredSkills`/`includeSkills`, per-source toggles — `skills.enableAgentsUser: false` set 08-07 (see §Open).

## Evidence

Axes: **Independence** (1P vendor / 3P unaffiliated) · **Baseline** (arm named with number) · **Relevance** (agent-on-real-repos). A=3P+baseline+high · B=1P+baseline+harness · C=1P, baseline undisclosed · D=no measurement.

3P sources, both with interests declared: JetBrains paired A/B (Harbor+SkillsBench, pre-registered, adoption-audited; ships competing tooling)[J1][J2][J3]; PointFive `arXiv:2607.12161` (2,908 billed runs; built losing RTK-ML arm themselves)[P1].

| Advertised → measured | ratio |
|---|---|
| Caveman −65% → −8.5%[J1] | 1/8 |
| Ponytail −54%/−20% → −15.4%/−10.3%[J3] | ~1/3 |
| rtk −60–90% → +7.6%[J2] / −2.7% holdout crosses 0[P1] | wash |
| Headroom −20% → **+48.4%** [+42.3,+55.0][P1] | negative |

**Grade A means "measured", not "works" — 3 of 5 A-grades are measured not to work.** rtk README itself is honest ("not the same as cutting your bill"); its site isn't. rtk's own scoreboard: 96.2 M tokens "saved" while bill rose — self-reported savings are claims about counterfactuals, not bills.

| Tool | Ind | Grade | Key fact |
|---|---|---|---|
| Caveman | 3P | **A** | −8.5% ceiling, quality tied |
| rtk | 3P | **A** | wash; quality exonerated |
| Ponytail | 3P | **A** | −10.3% real; force-inject only |
| Headroom | 3P | **A** | +48.4%; fleet median was 4.8% vs 20% claim |
| Hindsight | 1P | B (was A) | 91.4% LongMemEval; "independent repro" = co-authors |
| mem0 | 1P | B | **94.4% LongMemEval 04/2026 > Hindsight**; platform-only headline |
| MemPalace | 1P | B | best-documented: committed splits, retractions log |
| agentmemory | 1P | B | retrieval-only; no like-for-like vs Hindsight exists |
| codebase-memory-mcp | 1P | B (was A) | **83% vs 92% baseline** = −9 pts; langs 158/66/63 conflict |
| Graphify | 1P | B | 71.5× excludes build cost; 3 data points |
| Serena | 1P | B | 1 call vs 9 rename; self-graded, paid backend only |
| LLMLingua | 3P | B | reproduces on chat/RAG; **degrades on code agents** |
| pxpipe | 1P | B | unexamined |
| lean-ctx | 1P | **C** | headline composite; own benchmark contradicts README (32.6% vs 85%) |
| OmniRoute | 1P | C | 89.2% = arithmetic composition, never measured |
| Mnemopi | — | D | no published bench; local: transcript recall good, KG noise |
| `local` / aider / Repomix | — | D | no measurement |

Discovery via trending lists retired: 1/20 then 0/20 qualified; both 3P sources found via citations. **Re-checked 2026-08-10:** trendshift top-20 → 1/20 qualifies (Ponytail #17 — already tracked via J3, zero new information; new non-qualifiers incl. semantica, code-graph-rag: 1P microbenchmarks, no agent-on-repo arm). Same-day sweep of all tracked sources: no evidence-relevant change (P1 v3 08-02 = identical numbers; JetBrains new post not paired A/B; mem0/Hindsight/Headroom/lean-ctx benchmark docs unchanged; rtk v0.45 + ponytail v4.9 functional only). Retirement stands.

## Open

**Executed 2026-08-11 (both pre-registered gates):** read-out graded against the frozen table — bundle kept, 3/4 pass (§State) — and the lean-ctx kill threshold fired. Final semantic count **sem=1** since 07-28: one `ctx_search(action=semantic)` call (mimir, 08-10T18:32Z), landed after the 08-10 `sem=0` sweep of all 54 sessions; still < 5 with margin. Drop executed as pre-registered: `mcpServers.lean-ctx` removed from `~/.omp/agent/mcp.json` AND `"lean-ctx"` added to `disabledServers` (backup `mcp.json.bak-leanctx-drop`); `~/.claude.json` still registers lean-ctx + cbm and the denylist covers both, so the import cannot resurface them. Live omp instances started 08-10 (pre-edit) still hold lean-ctx children per the connect-time staleness rule — restart them; a fresh instance must show no lean-ctx child and no `ctx_search` in inventory. Hook live-load confirmed 08-10: `verification_events` 281 → 308. Remaining time-gated: round-3 re-grill of the Q-A number and Q-C constant against the read-out data.

**Implemented 2026-08-05:** lean-ctx → semantic-search-only on OMP (ADR-0008). Mechanism: OMP-native `~/.omp/agent/mcp.json` entry shadows the `~/.claude.json` registration; `LEAN_CTX_TOOL_PROFILE=minimal` + `LEAN_CTX_DISABLED_TOOLS=ctx_read,ctx_shell,ctx_glob,ctx_tree,ctx_call`; verified stdio `tools/list` → `["ctx_search"]` (OMP mcp.json has no per-tool filter — gate is server-side env). cbm → `disabledServers` on OMP (registered in `~/.claude.json`, hidden by denylist; `/mcp enable` lifts it per the litmus, run `fast` reindex at enable). Q8 block scoped to Claude Code in `~/.claude/CLAUDE.md` (marker `lean-ctx-claude-v6` — a lean-ctx updater rewrite would clobber the scoping; re-check after `lean-ctx update`). **cbm litmus:** enable for a session only when the question needs >10 native calls, crosses repo boundaries, or aggregates the whole graph; **promotion trigger:** litmus firing ~weekly in a project → default-on for that project scope, re-measure quality there. Q-F(a) Hermes: parked for future introspection (user, 08-05).

**Q-H implemented 2026-08-05:** curation moved to install time; no `includeSkills` layer. `skill-packs.json` is the curation point: mattpocock 13 (core `wayfinder`+`grill-with-docs`, transitive closure `grilling`/`domain-modeling`/`research`/`prototype`/`to-spec`/`to-tickets`/`implement`/`tdd`/`code-review`, direct-use `teach`/`handoff`); caveman pack `caveman`+`caveman-commit`; ponytail full. Pi target dropped from `SKILL_AGENTS` (installer no longer writes `~/.pi`; stale `ohmipy` refs purged from README/help/tests). Host converged: `~/.claude/skills` pruned 47→17 (single root; cut set recoverable from `~/.agents/skills`, untouched); `~/.pi/agent/skills` 39 symlink dupes removed. skill_bodies corrected in repo AND on host claude root: lean-ctx → semantic-only (ADR-0008), codebase-memory → enable litmus; agentmemory body skipped on OMP roots in `configure_agent_mcps.install_skills` (ADR-0006). `caveman-commit` lands via next installer run (already OMP-visible through the plugin marketplace). Cut-until-first-miss recovery: copy from `~/.agents/skills` or `skills add`. Stale manifest `"ask"` entry confirmed gone with the rewrite.

**Host converged 2026-08-07:** installer re-run (`--skill-profile default --yes`) refreshed the 13 mattpocock bodies from upstream main (catalog now 35 skills; all 13 present, exact names) and landed `caveman-commit` + the 6-skill ponytail pack in `~/.claude/skills` (17→24; ponytail was previously marketplace-only — now also in the curated root per `skill-packs.json`). Verified post-run: no cut skills re-added; hand-corrected `lean-ctx`/`codebase-memory` SKILL.md checksums unchanged; `~/.claude/CLAUDE.md` marker `lean-ctx-claude-v6` intact; 37 tests OK.

**User decisions still open:** merge/push branch. Q8 resolved as *scope* (08-05, conservative — Claude Code behavior untouched); switch to *delete* only if Claude Code replace-mode is retired.

**Grilled 2026-08-07 — item 8 (schema cost/turn) + wiring audit.** Three findings, all measured live:
1. **MCP config applies at connect time, not per session.** OMP connects stdio MCP servers eagerly at instance start; a long-lived instance spans config edits. Proven: omp PID started Aug 5 00:23 (pre-gate) still served disabled `ctx_glob` and denylisted cbm `list_projects` on 08-07 (live probes). A fresh 08-07 instance honored the denylist (lean-ctx child, no cbm child) — wiring correct, staleness operational. **Rule: after any `mcp.json` edit, `/mcp reload` or restart every live omp instance.** Same staleness applies to the skill roster (instance-start snapshot).
2. **Q-H roster cut never landed on OMP:** `~/.agents/skills` (the "recovery source", 53 dirs) is itself a scanned skill root (agents provider, pri 70) — all 31 cut skills kept riding the prompt, and the 08-07 installer run grew the store. Fixed by wiring: `skills.enableAgentsUser: false` (08-07; `enableAgentsProject` left on). Store is now recovery-only. **Verified in situ 08-10:** fresh-session roster = 21 visible skills (9 curated + 12 marketplace), zero agents-store entries.
3. **Item 8 measured:** initial prompt footprint (first-turn `cacheWrite+input`) ≈ 44–46K tokens/session (post-08-05 n=6: 40.5–46.4K). Same-project paired (paw-backend): median ~47.5K pre-curation → ~44.5K post = **−6%** — small because of finding 2. Prompt base × turns ≈ 40% of a 50-turn session's cache-read volume, so base cuts do move the 68.6% cache-read cost share; the −3K cut ≈ −2% of bill. **Re-measured 08-10 post store-root fix** (fresh sessions 08-08+, n=5): base 39.6–42K, median ~40.4K = additional **−9%**; one 44.3K outlier predates the 08-10 instance restarts (stale roster snapshot).

**Phase 2 (agentic-env) closed 2026-08-11:** the smoke-contract contradiction is fixed — `configure_agent_mcps` writes only `codebase-memory-mcp` to OMP-family MCP config, skipping `agentmemory` (ADR-0006) and `lean-ctx` (ADR-0008 fallback) with matching skill-root exclusions; the PI agentmemory extension wiring is deleted (`_configure_pi_agentmemory`, pinned `index.ts` remote + sha, `settings.json` check); docker smoke asserts cbm present AND agentmemory/lean-ctx absent on OMP. Verified: 39 unit tests + 3 `--verify-remote-contract` checks green (docker run itself not re-executed). Still parked: per-tool gating support (moot on OMP after the drop; secondary agents keep full wiring until Q-F(a)), Hermes CI gate, stack-doctor hook-conflict checks (Q3 decision, unimplemented; Claude Code has 4× cbm-session-reminder + 2 read-interception policies).

**ADR-0006 flip trigger FIRED 2026-08-11:** decision recall failed 4/4 probes; plain-text ADRs carried the truth (§State). Next: local Hindsight-vs-mem0 bake-off, endpoints pre-registered before any adoption — same trigger discipline as ADR-0006.

**Paired harness benchmark (if OMP-primary ever needs to be definitive):** arms OMP/Hermes, same repo snapshot + model (gpt-5.6-sol only overlap); tasks from the 934 recorded sessions; ladder replay→10-smoke→k=3→full (never trust k=1 — JetBrains' smokes lied both directions); endpoints pre-registered: paired billed cost, verify pass, edit-fail; sign test + Wilcoxon on medians; adoption audited per trial. Cost anchor: $106–320/tool (JetBrains), ~5,500 runs (PointFive).

**Unmeasured, dormant:** harness-minus-tools baseline (9); version pinning (11); opencode trial; 458 MB Mnemopi benchmark-residue banks sweep. Item 8 measured 08-07 (§above). Graph staleness (13) resolved 08-05: enable-time `fast` reindex; no between-use policy needed.

<details>
<summary><strong>Primary sources</strong></summary>

- [J1 — JetBrains: Caveman paired A/B](https://blog.jetbrains.com/ai/2026/07/speak-to-ai-agents-like-cavemen-tosave-tokens/)
- [J2 — JetBrains: rtk paired A/B](https://blog.jetbrains.com/ai/2026/07/rtk-claude-code-token-savings/)
- [J3 — JetBrains: Ponytail paired A/B](https://blog.jetbrains.com/ai/2026/07/ponytail-skill-claude-tested/)
- [P1 — Token Reduction Is Not Cost Reduction (PointFive)](https://arxiv.org/abs/2607.12161)
- [C1 — OmniRoute](https://github.com/diegosouzapw/OmniRoute) · [C2 — Headroom](https://github.com/headroomlabs-ai/headroom) · [C2B — benchmarks](https://headroom-docs.vercel.app/docs/benchmarks) · [C3 — Caveman honest numbers](https://github.com/JuliusBrussee/caveman/blob/main/docs/HONEST-NUMBERS.md) · [C4 — lean-ctx](https://github.com/yvgude/lean-ctx)
- [M1 — agentmemory](https://github.com/rohitg00/agentmemory) · [M2 — MemPalace](https://github.com/MemPalace/mempalace) · [M2H — corrections](https://github.com/MemPalace/mempalace/blob/develop/docs/HISTORY.md) · [M3 — Hindsight](https://github.com/vectorize-io/hindsight) · [M3P — paper](https://arxiv.org/abs/2512.12818) · [X1 — mem0](https://github.com/mem0ai/mem0)
- [G1 — Graphify](https://github.com/Graphify-Labs/graphify) · [G2 — codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp) · [G2P — paper](https://arxiv.org/abs/2603.27277) · [X2 — Serena](https://github.com/oraios/serena) · [X3 — aider repo map](https://github.com/Aider-AI/aider/blob/main/aider/repomap.py)
- [O3 — OMP memory docs](https://omp.sh/docs/memory) · [O4 — settings schema](https://github.com/can1357/oh-my-pi/blob/main/packages/coding-agent/src/config/settings-schema.ts) · [O5 — LSP docs](https://omp.sh/docs/code-intelligence)

</details>

[J1]: https://blog.jetbrains.com/ai/2026/07/speak-to-ai-agents-like-cavemen-tosave-tokens/
[J2]: https://blog.jetbrains.com/ai/2026/07/rtk-claude-code-token-savings/
[J3]: https://blog.jetbrains.com/ai/2026/07/ponytail-skill-claude-tested/
[P1]: https://arxiv.org/abs/2607.12161
