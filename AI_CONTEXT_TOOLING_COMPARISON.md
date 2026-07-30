# OMP Context Stack — Fast Read

> Every claim re-graded against primary sources 2026-07-28; no vendor claim survived at face value. Binding decisions: `agentic-env/docs/adr/0006`, `0007`. Tuning applied 2026-07-28; **judgment 2026-08-11** (§Open). History: `git log` on this file — long-form analysis lives in prior revisions.

## State as of 2026-07-28 (branch `feat/agent-stack-measured-cleanup`)

| Where | Applied | Backup |
|---|---|---|
| OMP config | `compaction.thresholdTokens=150000` · `idleEnabled=true` · `strategy=handoff` · `handoffSaveToDisk=true` | `~/.omp/agent/config.yml.bak-tuning` |
| OMP extensions | `omp/hooks/verification-recorder.ts` + `omp/hooks/cadence-governor.ts` (N=25, write-steer ≥1 KiB) | `omp config set extensions '[]'` |
| OMP MCP | `disabledServers: [agentmemory, node_repl]` | `~/.omp/agent/mcp.json.bak` |
| Hermes | 4 dead MCP servers `enabled:false` (agentmemory·mempalace·serena·codebase-memory-mcp); HERMES.md 3 lean-ctx blocks → 1 | `config.yaml.bak-tuning`, `HERMES.md.bak-tuning` |
| Memory | `backend: mnemopi`, `polyphonicRecall: false` (ADR-0006) | `/memory clear` before backend switch |

**First check, next session:** hooks test-verified but never live-loaded. After any test/lint runs:

```bash
sqlite3 ~/.omp/agent/verification_evidence.db "select count(*) from verification_events"
# 0 rows after a session that ran tests => hooks not loading => experiment measures nothing
```

**Read-out procedure (2026-08-11):**

```bash
# pass rate + cadence source
sqlite3 ~/.omp/agent/verification_evidence.db "select kind,status,count(*) from verification_events group by 1,2"
sqlite3 ~/.omp/agent/verification_evidence.db "select round(100.0*sum(status='passed')/count(*),1)||'%' from verification_events"
# end-green = last event per session_id passed
# tokens/session + write:edit: parse ~/.omp/agent/sessions/*/*.jsonl —
#   usage sums from toolResult-bearing messages; count toolCall name write vs edit
#   (method: prior revision of this file, "Your workflow, measured")
```

Pre-registered success (set before data existed — do not move goalposts):

| Metric | Baseline | Success | Source |
|---|---:|---|---|
| Tokens/session (median) | 22.8 M | ≤ 16 M | session jsonl |
| Sessions ending green | 91.2% (n=57) | ≥ 92% on n ≥ 40 | recorder |
| Verification cadence | ~37 calls | ≤ 25 | recorder |
| write:edit ratio | 3.15 | < 2.0 | session jsonl |
| Rollback | — | end-green < 88% → revert `strategy` first, then threshold | recorder |

Q-A/Q-B applied together → attribution is to the bundle, accepted.

## Use this stack

| Layer | Tool | Buys | Cost | Ev | Avoid |
|---|---|---|---|---|---|
| Host | **OMP core** | compaction, `read`, pruning, LSP/AST, lazy MCP | none | Host | disabling compaction |
| Context I/O | OMP native + lean-ctx | lean-ctx carries 18.7% of real calls | 18 schemas; `ctx_patch` dropped (independent anchors) | C | any compressor on read→edit path: anchor corruption 27/40→15/40[P1]; Headroom **+48.4%**[P1] |
| Memory | **Mnemopi** | per-project transcript recall, local SQLite | KG layer is noise — `polyphonicRecall` off | D (local meas. only) | second memory owner |
| Memory upgrade path | Hindsight vs **mem0** | re-evaluate at flip trigger (ADR-0006) | service+DB / platform-only headline | B | adopting before recall visibly fails |
| Code graph | codebase-memory-mcp | persistent graph, Cypher, cross-repo | **−9 pts quality** (83 vs 92) for 10× tokens; 0.3% of calls | B | default-mounted; demote to on-demand (pending) |
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

| Pri | Provider | This host | Skills |
|---:|---|---|---:|
| 100 | native `.omp`/`.pi` | `~/.pi/agent/skills` (agentic-env-installed) | 40 |
| 90 | omp-plugins | — | — |
| 80 | claude | `~/.claude/skills` | 48 |
| 70 | claude-plugins · agents · codex | — | — |
| 55 | opencode | `~/.config/opencode/skills` | 1 |
| 30 | github `.github/skills` | — | — |
| 5 | omp-managed (autolearn) | `~/.omp/agent/managed-skills` | — |

Same-name collision → higher pri wins (`ponytail` in both `.pi` and `.claude` → `.pi` copy served). Scan non-recursive: `<root>/skills/<name>/SKILL.md` only. Consequences: ~88 name+description entries ride **every** system prompt (item-8 cost, skill flavor); measured usage this corpus = 3 skills invoked per grilling session, `skill_view` heavy only on Hermes. Pruning levers exist, all unused: `skills.ignoredSkills` / `includeSkills` (globs), per-source toggles (`enableClaudeUser` etc.). Duplicate skill *sets* across `~/.claude` and `~/.pi` = same pack installed twice by different installers — dedup hides it, cost remains.

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

Discovery via trending lists retired: 1/20 then 0/20 qualified; both 3P sources found via citations.

## Open

**Time-gated:** hook live-load check (next session, see State); read-out 2026-08-11; then re-grill Q-A number, Q-C constant.

**User decisions:** Q-F(a) Hermes fate (keep/fade/decommission — idle since 07-14); merge/push branch (6 commits); Q8 `~/.claude/CLAUDE.md` lean-ctx "native denied" block false on OMP — scope per harness (ADR-0007 consequence, undone); cbm demotion to on-demand (still mounted via claude discovery).

**Phase 2 (agentic-env, parked):** smoke contract still *requires* agentmemory on OMP — now contradicts ADR-0006/0007; per-tool gating support; Hermes CI gate; stack-doctor hook-conflict checks (Q3 decision, unimplemented; Claude Code has 4× cbm-session-reminder + 2 read-interception policies).

**Trigger-gated:** ADR-0006 flip — Mnemopi → Hindsight-vs-mem0 when recall returns sludge instead of decisions.

**Paired harness benchmark (if OMP-primary ever needs to be definitive):** arms OMP/Hermes, same repo snapshot + model (gpt-5.6-sol only overlap); tasks from the 934 recorded sessions; ladder replay→10-smoke→k=3→full (never trust k=1 — JetBrains' smokes lied both directions); endpoints pre-registered: paired billed cost, verify pass, edit-fail; sign test + Wilcoxon on medians; adoption audited per trial. Cost anchor: $106–320/tool (JetBrains), ~5,500 runs (PointFive).

**Unmeasured, dormant:** schema cost/turn (item 8); harness-minus-tools baseline (9); version pinning (11); graph staleness policy (13); opencode trial; 458 MB Mnemopi benchmark-residue banks sweep.

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
