# OMP Context Stack — Fast Read

> **Decision first. Detail collapses below.** Discovery snapshot: Trendshift Daily / Today (UTC) / All languages, 2026-07-24 17:37:30 UTC.[T1] Every claim re-graded against primary sources 2026-07-28; no tool earns an A. Binding decisions live in `agentic-env/docs/adr/`, not here.

## Use this stack

| Layer | Tool | What it buys | Cost | Evidence | Avoid |
|---|---|---|---|---|---|
| Host | **OMP core** | Compaction, `read`, pruning, LSP/AST/search, lazy MCP | None — already paid for | Host | Disabling compaction |
| Context I/O | **OMP core** + lean-ctx (measured 18.7% of calls) | Native `read`/`grep`/`glob`/`edit` authoritative; lean-ctx keeps `ctx_shell`, `ctx_read`, `ctx_search`, `ctx_execute` — the four actually used | 18 tool schemas resident | C (lean-ctx) | `ctx_patch` on the edit path — anchor corruption cut patch application 27/40 → 15/40[P1]; Headroom (**+48.4% cost**)[P1] |
| Memory | **Mnemopi** | Per-project transcript recall, local SQLite, no service | Structured/KG layer is noise — do not rely on it; keep `polyphonicRecall: false` | Local measurement only | A second memory owner alongside it |
| Memory (upgrade path) | Hindsight | Strongest *published* extraction quality — though mem0 posted a higher LongMemEval four months later[X1] | Service on `:8888` + DB + LLM calls, to run and back up yourself | B | Adopting before recall visibly fails |
| Code graph | codebase-memory-mcp | Persistent code/IaC graph; routes, data flow, Cypher, cross-repo | **−9 pts answer quality** (83% vs 92%) for 10× fewer tokens; index + daemon | B | Using it where quality beats token cost; replacing live LSP |
| Terse output | Caveman | Shorter model output | ~1–1.5K input tokens/turn; 0% input compression | **A** | Expecting the advertised 65% — independently measured at **−8.5%**[J1] |
| Mixed-media map | Graphify | One-shot map over code + docs + PDFs + images | Build cost excluded from its own 71.5× claim; ~1× under ~50 files | B | Small corpora; duplicate "query before read" hooks |
| Less code written | **Ponytail** | The only independently measured *saving* in this field | Must be force-injected; self-activates 0/10 times as a plain skill | **A** | Expecting −54%; measured −15% code, −10.3% cost[J3] |

### Recommended OMP config

```yaml
compaction:
  enabled: true
  strategy: snapcompact
memory:
  backend: mnemopi
mnemopi:
  scoping: per-project-tagged
  polyphonicRecall: false
```

`polyphonicRecall` stays off deliberately: it promotes the graph and fact voices into recall, and those are measurably noise (pronoun subjects, one universal `related_to` predicate). Switching backends later: run `/memory clear` first.[O3] Valid values are `off | local | hindsight | mnemopi`.[O4] Rationale and the flip trigger to Hindsight: `agentic-env/docs/adr/0006-mnemopi-owns-narrative-memory-on-omp.md`.

## Your workflow, measured

Everything above is other people's corpora. This section is yours: **934 sessions across two harnesses, 2026-05-16 → 2026-07-28, ~6.2 B tokens** — 152 OMP sessions from `~/.omp/agent/sessions` and 782 Hermes sessions from `~/.hermes/state.db`. It is the baseline arm the rest of this document lacks.

### Shape

861 user turns produced 22,653 assistant turns — **26 autonomous turns per instruction**, 149 per session, with 108 compactions across 152 sessions. This is long-horizon delegated work, not chat.

### Where the money actually goes

| Slice | Tokens | Share | Cost share |
|---|---:|---:|---:|
| **Cache reads** | 1,246,794,061 | **97.2%** | **68.6%** |
| Output | 4,661,542 | 0.4% | 12.8% |
| New input | 20,379,059 | 1.6% | 11.2% |
| Cache writes | 10,609,632 | 0.8% | 7.3% |

Cost share uses standard relative pricing (input 1×, cache-write 1.25×, cache-read 0.1×, output 5×). This independently reproduces P1's central finding on your own data: **the bill is re-reading context, not producing it.**

That converts every tool claim into an expected value:

| Intervention | Slice it can touch | Best case on your bill |
|---|---|---|
| Halve cache reads (compaction, pruning, subagents, shorter sessions) | 68.6% | **−34%** |
| Caveman at its measured −8.5% of output | 12.8% | **−1.1%** |
| rtk / Headroom / any tool-output compressor | 11.2% ceiling | ≤ −11%, both measured ≥ 0[J2][P1] |

A tool-output compressor cannot reach the 69% of your bill that is cache traffic. That is not a criticism of any tool; it is arithmetic.

### What you actually use

**OMP** — 25,182 calls

| Provider | Calls | Share | Tools used |
|---|---:|---:|---|
| OMP native | 20,407 | **81.0%** | `write` 5,170 · `read` 4,565 · `bash` 4,379 · `edit` 1,643 · `todo` 1,009 · `grep` 730 |
| lean-ctx | 4,698 | **18.7%** | 17 of 18 — `ctx_shell` 1,729 · `ctx_read` 1,263 · `ctx_search` 475 · `ctx_execute` 387 · `ctx_patch` 175 |
| codebase-memory-mcp | 77 | 0.3% | 11 of 14, but 77 calls in 152 sessions |
| **agentmemory** | **0** | **0%** | **0 of 7 — never called, in any session** |
| **node_repl** | **0** | **0%** | **0 of 3 — never called** |

**Hermes** — 48,230 calls, 87 distinct tools

| Provider | Calls | Share | Tools used |
|---|---:|---:|---|
| Hermes native | 38,514 | **79.9%** | `terminal` 11,342 · `read_file` 10,934 · `patch` 7,112 · `search_files` 4,586 · `write_file` 1,166 |
| lean-ctx | 7,507 | **15.6%** | `ctx_read` 3,506 · `ctx_shell` 1,446 · `ctx_search` 1,163 · `ctx_tree` 262 |
| skills | 1,893 | 3.9% | `skill_view` 1,812 · `skill_manage` 77 |

### The mandate does not work

`~/.hermes/HERMES.md` states `NEVER use native Read/Grep/Shell when ctx_* equivalents are available` and repeats the rule block **three times**. Measured adherence:

| Harness | Instruction strength | lean-ctx share |
|---|---|---:|
| OMP | none — native tools mandated by the host | **18.7%** |
| Hermes | "MANDATORY", "NEVER use native", stated 3× | **15.6%** |

**The harness with the aggressive mandate has *lower* adoption than the one with none.** A prompt-level tool mandate buys roughly nothing; both land near one call in six regardless. This matches J3's finding that Ponytail self-activated 0/10 times as a plain skill and only worked when its ruleset was force-injected. Instructions do not route tools; wiring does.

lean-ctx is also **double-registered** on Hermes — 18 tools under `mcp_lean_ctx_*` and 16 under `mcp__lean_ctx__*` — so one server occupies 34 tool schemas in every prompt.

Conclusions, one of which reverses a decision made earlier in this document:

1. **agentmemory and node_repl are dead weight on OMP.** Ten tool schemas in every prompt, zero calls in two months. Remove.
2. **codebase-memory-mcp costs 14 schemas for 0.3% of calls.** Its measured trade — 10× fewer tokens for 9 points of answer quality — is a bad one when the tokens it saves live in the 11.2% slice. Demote to on-demand.
3. **lean-ctx is heavily used on both harnesses (18.7% / 15.6%), and ADR-0007 gated the wrong four tools.** It selected `ctx_compose`/`ctx_explore`/`ctx_overview`/`ctx_delta` (115 calls on OMP) and would have removed `ctx_shell`, `ctx_read`, `ctx_search` and `ctx_execute` (3,854). Corrected. The tool worth dropping is **`ctx_patch`/`ctx_edit`**: it maintains anchors independent of the host's snapshot store, on the exact path where P1 measured anchor corruption halving patch success.
4. **Deduplicate the Hermes registration** before anything else there: 34 schemas for one server, serving 15.6% of calls.

### Harness comparison — measured, not assumed

**Correction.** An earlier pass recorded "Hermes: 0 sessions, never used" and treated OMP as the sole harness. That was wrong: it globbed `~/.hermes/sessions/*.jsonl`, and Hermes writes `.json` with its real history in a 1.64 GB `state.db`. Hermes ran **782 sessions** — five times OMP's count — concurrently with OMP through June and July. Any earlier claim resting on Hermes being unused is withdrawn.

| | OMP | Hermes |
|---|---:|---:|
| Sessions | 152 | **782** |
| Active range | 2026-06-03 → 07-28 | 2026-05-16 → 07-14 |
| Messages / turns | 22,653 assistant turns | 73,867 messages |
| Tool calls | 25,182 | 42,181 |
| Total tokens | **3.47 B** | 2.75 B |
| Tokens per session | **22.8 M** | 3.5 M |
| **Cache-read share** | **96.5%** | **92.6%** |
| New-input share | 2.3% | 7.0% |
| Compaction | 108 events / 152 sessions | **234 of 782 sessions end on compression**; 20,245 of 94,112 messages compacted |
| Subagents | `task` 68 · `hub` 739 · `job` 63 | 153 subagent sessions · 12 async delegations |

### Quality, extracted

Quality is measurable here, but only on one side — which is itself the finding.

| Signal | OMP | Hermes |
|---|---|---|
| Verification instrumentation | **none** | `verification_evidence.db`: 248 events — 140 lint, 80 test, 28 ad-hoc |
| Verification pass rate | not recorded | **83.9%** (208/248; exit 0 = 208, exit 1 = 21, exit 2 = 19) |
| Edit/patch outcome logging | not recorded — 172 `*.bash.log`, **0** `*.edit.log` | structured `{"success": …}` on every patch |
| **Patch failure rate** | unmeasurable | **12.9%** (761 failed / 5,877 parsed) |

**Hermes keeps a quality feedback loop; OMP keeps none.** OMP spills tool output to per-call logs but records no outcome, so no pass rate, no edit-failure rate, and no regression signal can be computed from 152 sessions. That is the single largest instrumentation gap between them, and it is fixable on OMP far more cheaply than any tool in this document.

### Editing strategy is inverted between them

| | OMP | Hermes |
|---|---:|---:|
| Whole-file writes | `write` **5,170** | `write_file` 1,166 |
| Surgical edits | `edit` 1,643 | `patch` **7,112** |
| Ratio | **3.15 writes per edit** | **0.16 writes per patch** (6.1 patches per write) |

A 20× difference in strategy, and both choices have a measured price. Hermes patches and pays **12.9% patch failures**, each costing a retry — extra turns, extra cache reads. OMP overwrites and pays in output tokens: **82,019 output tokens per session against Hermes' 13,343, a 6.1× difference**. OMP's own tool policy says to prefer `edit` for modifying existing files; the measured behaviour violates that 3:1. Since output is 12.8% of billed cost and `write` is the single most-called tool, this is the most concrete cost defect the profile exposes — and OMP already ships the fix natively, with snapshot-verified anchors and stale-anchor recovery that Hermes' patch tool lacks.

### Autonomy and cost per unit of work

| | OMP | Hermes |
|---|---:|---:|
| Assistant turns per user instruction | **26.3** | 11.3 |
| Tokens per user instruction | **4,030,862** | 837,176 |
| `ask`/`clarify` per instruction | 0.62 | 0.032 |

**OMP costs 4.8× more per instruction and is 2.3× more autonomous per instruction.** Read those together before concluding anything: an OMP instruction is a bigger unit of work, so the ratio is not efficiency, it is granularity. What it does establish is that the two harnesses are not substitutes — you hand them different-sized jobs. OMP also asks the user 19× more often per instruction, which is either healthy checking-in or reluctance to commit, and the data cannot tell which.

### Other harnesses — evidence, not enthusiasm

| Harness | Installed | Usage evidence | Verdict |
|---|---|---|---|
| **OMP** | yes | 152 sessions, 3.47 B tokens | in production |
| **Hermes** | yes | 782 sessions, 2.75 B tokens | in production |
| **opencode** | yes — 61 MB config, `AGENTS.md`, skills, rules, a lean-ctx config backup | **1 session, 1 project** | configured, never adopted |
| Cursor | yes — 1.2 GB | 8 projects, 226 files | IDE, different category |
| Gemini CLI | yes — 708 MB | 18 json, 60 KB history | trialled |
| Codex | yes | 73 sessions, last 07-13 | dormant |
| Claude Code | yes | 5 sessions, last 07-13 | dormant |
| qwen · factory · continue · goose | yes | 1–5 files each | installed, never run |

**opencode belongs in the conversation, but as a prospective candidate judged on capability, not on evidence** — one session is not a data point. It is the only untried harness here that plausibly clears the gates the workflow imposes (multi-provider routing, MCP, subagents, skills). Everything else on this machine is either dormant, an IDE, or an empty install. Adding a harness with no usage history to a comparison built on 6.2 B measured tokens would import exactly the unmeasured-claim problem the rest of this document exists to remove.

**The two harnesses independently confirm the central finding.** Cache reads are 96.5% of OMP tokens and 92.6% of Hermes tokens — across 6.2 B tokens, two different runtimes, two different tool vocabularies. This is no longer an inference from P1's corpus; it is reproduced twice on yours.

They are used differently, and the split is coherent: **OMP runs few, very deep sessions** (22.8 M tokens each — 6.5× Hermes) while **Hermes runs many shorter ones** (3.5 M each, 30% of them terminated by compression). OMP is where long autonomous work happens; Hermes is where volume happens.

| Models | OMP | Hermes |
|---|---|---|
| OpenAI | gpt-5.6-sol 7,802 · gpt-5.3-codex-spark 5,708 · gpt-5.5 2,049 | gpt-5.5 15,200 · gpt-5.6-sol 8,000 · gpt-5.3-codex-spark 1,140 |
| Anthropic | claude-fable-5 3,515 · claude-opus-5 2,895 · claude-opus-4-8 87 | — none |
| Other | glm-5.2 163 | deepseek-v4-flash 1,007 · glm-5.2 405 · minimax-m3 256 |

**Second correction:** multi-provider routing is *not* unique to OMP. Hermes routes six models across four providers. The real discriminator is narrower — **only OMP is observed running Anthropic models**, and only OMP has native LSP, AST-aware editing, and hashline anchored edits verified against a session snapshot store. Hermes brings 87 skills, a `memory` tool, kanban and verification-evidence stores, `delegate_task`, browser and vision.

Against Claude Code and Codex the capability gate still holds — single-provider, no role routing — and both are near-dormant here (5 and 73 sessions, last used 2026-07-13).

### One concrete defect found while measuring

`~/.hermes/HERMES.md` carries **three** lean-ctx rule blocks: a v12 "Tool Mapping (MANDATORY)" table, then two copies of a v8 "shadow mode" block. The v12 block orders `NEVER use native Read/Grep/Shell when ctx_* equivalents are available` and maps edits to `ctx_edit`. That is a triplicated read-interception policy in a single context file, in direct violation of hard rule 9 — and it points the edit path at `ctx_edit` on the harness where anchor corruption is least recoverable.

## Rankings

**Rankings withdrawn 2026-07-28.** Re-grading every claim against primary sources found that no tool here has independent third-party verification, and each category was ranked across metrics that do not compare. There is no order; see per-tool evidence below.

| Category | Why it is not rankable |
|---|---|
| Context | lean-ctx, Headroom and Caveman compress different things — file/shell I/O, JSON payloads, and model output respectively. OmniRoute composes upstream numbers arithmetically rather than measuring. |
| Memory | Hindsight reports end-to-end QA accuracy; MemPalace and agentmemory report retrieval recall. agentmemory states outright that it does "NOT claim these as LongMemEval scores".[M1] |
| Code graph | codebase-memory-mcp is the only entrant measured against an agent baseline — and scored **below** it (83% vs 92%). Graphify's ratio excludes graph-build cost. |

**Important:** OMP LSP sits outside graph ranking. LSP = live definitions, refs, diagnostics, atomic refactors. Graph = persistent multi-hop/cross-repo knowledge.[O5]

## What each tool buys, and what it costs

- **OMP core stays:** compaction preserves session history; external compression does not replace it.[O1][O2] It is also the unmeasured baseline — no tool here was ever compared against OMP core alone, so every "saving" below is relative to naive file reading, not to your actual host.
- **lean-ctx:** compresses reads, shell and tool results; reversible and local-first.[C4] Its headline is a composite of unlike measurements and one figure contradicts its own committed benchmark — use it because compressed reads help you, not because of the percentage.
- **Mnemopi:** the only backend measured on *this* corpus rather than a vendor's. Transcript recall works; the knowledge graph does not. No published benchmark exists.
- **Hindsight:** native backend, retain/recall/reflect, best-evidenced extraction quality in the field — measured by its own authors on conversational QA, not on coding work.[M3][M3P]
- **codebase-memory-mcp:** deepest persistent code graph; routes, data flow, IaC, Cypher, cross-repo, watcher.[G2] Buys a 10× token reduction by giving up 9 points of answer quality — a good trade on large repos, a bad one on small ones.

## Hard rules

1. **Judge by success-adjusted billed cost, never by token reduction.**[P1] Local payload reduction does not predict end-to-end cost: Pearson r = 0.15 across 2,848 billed runs.
2. Prompt-cache traffic is ~87% of reconstructed cost.[P1] A tool that cannot touch cached re-reads cannot move your bill, whatever its scoreboard says.
3. Never put a lossy compressor on the read path that feeds anchored edits. Compression corrupted verbatim edit anchors and dropped successful patch application from 27/40 to 15/40.[P1]
4. One context compressor per request path — "request path" means one interception point per tool call: hook, proxy, or MCP wrapper, not one of each.
5. One semantic-memory owner per agent.
6. OMP LSP owns live symbol truth.
7. codebase-memory-mcp owns the deep persistent code graph, where tokens matter more than the 9-point quality cost.
8. Caveman, Ponytail and Graphify run only when asked — and Ponytail only when force-injected, since it self-activates 0/10 times.[J3]
9. No duplicate "query before read" hooks.

## Context tools

| Tool | Job | Published result | Evidence | OMP call |
|---|---|---|---|---|
| lean-ctx | File/shell/request compression | 60–90% is a composite of unlike measurements (59.9% CLI vs ~99% cached map-mode). Its own committed benchmark measures `git status` at 32.6%, not the README's 85%.[C4] | C | Headline unreliable; judge on use |
| **Headroom** | JSON/tool/log compressor | Vendor: 20% coding-agent, 60–95% JSON, fleet median 4.8%. **Independently measured: +48.4% MORE expensive** [+42.3, +55.0]; cost-per-successful-execution ratio 1.464; penalty positive in all 9 model×effort cells.[C2][C2B][P1] | **A** | Do not adopt for savings |
| **Caveman** | Output brevity only | Vendor: 65% output reduction. **Independently measured on 82 paired agent tasks: −8.5%**, with activation forced (a ceiling, not typical use). Quality tied, p=0.82.[C3][J1] | **A** | On demand; expect single digits |
| OmniRoute | Provider gateway + bundled compressors | 89.2% is arithmetic composition of two upstream claims that compress different targets; never measured end-to-end.[C1] | C | Gateway only; compression off |
| **rtk** | Bash-output compression via PreToolUse hook | Vendor **README is careful**: "cuts up to 90% of the bash output your agent reads… not the same as cutting your bill by 90%." Its repo description and website are not: "reduces LLM token consumption by 60–90%", "89% average". **Two independent measurements, both ≈nil**: +7.6% cost at low effort (p=0.004), +0.1% at high[J2]; −2.7% [−5.6, −0.1] pooled, holdout −2.3% [−7.4, +2.1] crossing zero.[P1] Quality exonerated by both (sign test p=1.0; Δsuccess −0.2pp). | **A** | A wash; adopt for the UX, not the bill |
| **Ponytail** | Makes the agent write less code | Vendor: −54% code, −20% cost. **Independently measured: −15.4% code (p=0.088), −10.3% cost (p=0.004)** over 80 pairs — the only measured *saving* in the series. Self-activates 0/10 times unless force-injected.[J3] | **A** | Expect a quarter of the claim |
| LLMLingua / LLMLingua-2 | Prompt compression (Microsoft Research) | Peer-reviewed with genuine 3P reproductions — but on **chat QA, meetings and RAG**. The two high-relevance 3P studies on coding agents report **degradation, not reproduction**. Misses A on relevance alone. | B | Not for the code path |
| pxpipe | Pipeline-style context reduction | Baseline disclosed, first-party. | B | Unexamined alternative |
| Repomix | Packs a repo into one prompt payload | No measurement published. | D | Whole-repo stuffing is the thing to avoid |

<details>
<summary><strong>Context details</strong></summary>

### lean-ctx

- **Mechanism:** compressed read modes, cache, shell patterns, reversible spill, optional prompt-cache-safe proxy.
- **Speed:** cached reread ~13 tokens; raw `git status` example ~800→120. Comparable latency: Unknown.[C4]
- **MCP / graph:** MCP server; temporal knowledge graph + property/code graph.
- **Storage / privacy:** local cache, archives, session state, `.ctxpkg`; telemetry opt-in.
- **Coverage:** 30+ agents; 27 tree-sitter languages reported; Apache-2.0.
- **Cost:** overlaps OMP read/search/LSP/memory. Keep OMP LSP + one OMP memory backend authoritative.

### Headroom

- **Mechanism:** content-aware codecs for JSON, tools, logs, files, RAG; library/proxy/MCP.
- **Speed:** project examples: 1 ms for 100-item JSON, 2 ms for 500 items, 1 ms for 200 shell/build-log lines.[C2B]
- **MCP / graph:** MCP server; no graph.
- **Storage / privacy:** local/stateless path with reversible codec facilities; remote LLM traffic follows caller.
- **Cost:** duplicates lean-ctx. Use instead, never beside.

### Caveman

- **Mechanism:** prompt skill makes model terse. Does not compress input, files, history, thinking.
- **MCP / graph / storage:** none.
- **Coverage:** Claude-style skill; project lists 30+ agents.
- **Cost:** permanent prompt overhead can exceed savings on short replies.[C3]

### OmniRoute

- **Mechanism:** gateway pipeline with session dedup + RTK, Caveman, Headroom/GCF, LLMLingua-family, optional image-context engines.
- **MCP / graph:** MCP server; no graph.
- **Storage / privacy:** self-hostable gateway; provider traffic still leaves host.
- **Cost:** large routing surface; compression percentages combine unlike engines. Keep only when routing needed.[C1]

</details>

## Memory tools

| Tool | Memory model | Published result | Evidence | OMP call |
|---|---|---|---|---|
| Hindsight | Facts + experiences + mental models | ~91.4% LongMemEval; 39%→83.6% vs a full-context baseline on the same backbone. "Independently reproduced" traces to Virginia Tech/Sanghani — who are **co-authors** of the cited paper.[M3][M3P] | B | Native backend option |
| mem0 | LLM-extracted facts, hosted or self-hosted | **94.4% LongMemEval** (472/500), 92.5% LoCoMo — April 2026, so it postdates and exceeds Hindsight's 91.4%. Baseline is its own prior algorithm (67.8), not a competitor. Headline is **managed-platform only**; the OSS SDK is explicitly not the same.[X1] | B | Contradicts Hindsight's "most accurate ever tested" |
| MemPalace | Verbatim local text + semantic/hybrid retrieval | 96.6% raw R@5; 98.4% on a committed 450-question held-out split, tuned on a disjoint 50.[M2] | B | Best-documented memory claim here |
| agentmemory | Hook capture + 4-tier consolidation + hybrid retrieval | 95.2% recall_any@5 vs 86.2% BM25-only. Retrieval only — no end-to-end QA published, so no like-for-like against Hindsight exists.[M1] | B | Cross-editor alternative |
| **Mnemopi** | Working → episodic → gists → KG, local SQLite, ONNX embeddings | **No published benchmark.** Local measurement on a 15-session bank: transcript recall accurate; structured layer degenerate — pronoun subjects, one universal `related_to` predicate, duplicated triples, fabricated `location`/`emotion`.[O4] | D | Native backend; currently chosen |
| `local` | LLM-consolidated `MEMORY.md` + summary injection | **No published benchmark.** No vector store, no service.[O3] | D | Native backend; unevaluated |

**Do not rank raw numbers together.** MemPalace/agentmemory report retrieval R@5 under different configs. Hindsight reports end-to-end QA. No universal winner.[M1][M2][M3P] Note the shape of this table: the two backends OMP supports natively — the ones you can actually switch to with one config key — are the two with no published evidence, while the three that are benchmarked are the three that need extra infrastructure. The field publishes numbers where the incentive to publish exists.

<details>
<summary><strong>Memory details</strong></summary>

### Hindsight

- **Mechanism:** LLM extraction; semantic + keyword + graph + temporal recall; RRF/rerank; retain/recall/reflect.
- **Graph:** entity, relationship, temporal, causal memory graph. Not code graph.
- **Storage / privacy:** embedded/server DB or PostgreSQL/Oracle; cloud or self-host. Retain/reflect remain LLM-backed.
- **Integration:** native OMP backend; Python/TS/HTTP clients. No extra MCP needed in OMP.
- **Cost:** service + DB + model calls. Sole owner only.

### MemPalace

- **Mechanism:** original text, no summary/paraphrase; wings/rooms/drawers; ChromaDB default.
- **Graph:** temporal entity-relationship graph with validity windows in SQLite.
- **Storage / privacy:** local-first; exact SQLite, Milvus, Qdrant, pgvector options; no API key for raw benchmark.
- **Integration:** 36-tool MCP; Claude Code, Codex, Cursor hooks; other MCP clients.
- **Cost:** Python + vector store + ~300 MB recommended embedding model + hooks.[M2]
- **Trust:** corrections log retracts old universal-compression/cross-metric claims.[M2H]

### agentmemory

- **Mechanism:** hooks capture turns/tools; BM25 + vector + memory graph fused by RRF; replay + coordination.
- **Storage / privacy:** local SQLite + pinned `iii-engine`; self-hosted default.
- **Integration:** MCP server; broad editor hooks/skills; 50+ skill hosts reported.
- **Cost:** engine, server, ports, hooks, large MCP surface; biggest OMP overlap.

</details>

## Code and knowledge graphs

| Tool | Best at | Published result | Evidence | OMP call |
|---|---|---|---|---|
| codebase-memory-mcp | Persistent code/IaC graph | 31-repo study: 10× fewer tokens, 2.1× fewer calls, and **83% answer quality against 92% for file-by-file exploration** — a 9-point regression bought with the token saving.[G2][G2P] | B | Use where tokens dominate |
| Serena | Live LSP symbol truth over MCP | Cross-file rename in **1 call vs 9** (1 Grep + 4 Read + 4 Edit); `find_referencing_symbols` 63 code files vs Grep's 83 textual matches. Honestly reports its own losses: built-in `Edit` sends ~4.5× less payload on small edits. **No quality number; the agent evaluates itself, and only the paid JetBrains backend was tested.** | B | Closest analogue to OMP LSP |
| aider repo map | Tree-sitter tags + PageRank ranking | Persistent per-file tag cache; ranking recomputed per request. No published token or quality measurement. | D | Prior art, not a product to mount |
| lean-ctx | Integrated graph-guided I/O | No direct graph-product comparison.[C4] | C | Already active |
| Graphify | Mixed code/docs/PDF/image map | 71.5× fewer tokens/query on 52 files — **excludes graph-build cost**, though that corpus used LLM extraction for PDFs/images; ~1× on 6 files; three data points, no intermediates.[G1] | B | On demand |
| OMP LSP | Live symbol/refactor truth | Not token benchmark | Host | Always keep |

<details>
<summary><strong>Graph details</strong></summary>

### codebase-memory-mcp

- **Graph:** calls, imports, types, routes, data flow, cross-service, cross-repo, IaC; Cypher-like queries.
- **Speed:** project reports sub-ms structural queries; 28M LOC / 75K-file Linux kernel indexed in 3 min on documented setup.[G2]
- **Storage / privacy:** local static binary; SQLite cache; optional compressed team graph; no API key/built-in LLM.
- **Coverage:** 158 tree-sitter languages; hybrid semantic resolution for major languages; 43 client surfaces reported.
- **Ops:** watcher, route linking, impact, coverage, ADRs, visualization.
- **Cost:** persistent index + daemon; overlaps lean-ctx graph. Keep one query-before-read policy.

### Graphify

- **Graph:** NetworkX + Leiden heterogeneous graph; edges tagged extracted/inferred/ambiguous.
- **Input:** 14 listed code languages + docs + PDF + images via Claude.
- **Output:** `graph.json`, `graph.html`, Obsidian/wiki, `GRAPH_REPORT.md`, cache.
- **MCP / privacy:** optional MCP server; local files; doc/image extraction uses active Claude model.
- **Cost:** weaker code specialization; little token gain on small corpora. Run, consume output, stop.

### lean-ctx graph

- **Graph:** property code graph + temporal knowledge graph; BM25/semantic/graph ranking.
- **Role:** guide compressed reads. Not replacement for codebase-memory-mcp depth or OMP LSP truth.

### OMP LSP

- **Role:** definitions, refs, implementations, diagnostics, atomic rename.
- **Persistence:** live workspace/server state. No documented persistent source graph.[O5]

</details>

## OMP: core vs external

| Capability | Owner | Keep / avoid |
|---|---|---|
| Structural reads | OMP + lean-ctx | OMP reads; lean-ctx compresses. No Headroom duplicate.[O6] |
| Tool-result pruning | OMP + lean-ctx | Keep stale-read/useless-result pruning.[O1][O4] |
| Session overflow | OMP compaction | Keep Snapcompact. Pre-model compression not substitute.[O1][O2][O4] |
| Lazy tools/skills | OMP | Keep `skill://`, internal URIs, lazy MCP discovery.[O6][O7] |
| Semantic memory | Hindsight | Exactly one `memory.backend`.[O3][O4] |
| Live code truth | OMP LSP | Never replace with graph inference.[O5] |
| Persistent code graph | codebase-memory-mcp | Mnemopi graph = episodic memory, not code graph.[O4] |
| MCP client | OMP | Mount chosen servers only; disable unused.[O7] |

## Evidence key

Three axes, recorded separately so a letter can never again hide the thing that mattered.

- **Independence** — `1P` benchmark run by the tool's own maintainers; `3P` run by an unaffiliated party.
- **Baseline** — disclosed only when the source names the comparison arm *and* its number ("83% vs 92% for a file-exploration agent"). A bare percentage is undisclosed.
- **Relevance** — `high` real repositories with an agent in the loop; `med` adjacent domain (chat QA, JSON payloads); `low` synthetic microbenchmark.

| Grade | Requires |
|---|---|
| **A** | 3P **and** baseline disclosed **and** relevance high |
| **B** | 1P **but** baseline disclosed **and** a committed, rerunnable harness |
| **C** | 1P **and** (baseline undisclosed **or** demo-only) |
| **D** | claim with no measurement behind it |

**Five tools earn an A, from two independent sources.** The JetBrains AI paired-A/B series (Harbor + SkillsBench, Claude Code pinned in both arms, pre-registered endpoints, Wilcoxon/sign tests, per-trial adoption audits)[J1][J2][J3] and the PointFive campaign (`arXiv:2607.12161`: 2,908 provider-billed Claude Code runs, 2,848 analysed, 103 tasks, 7 repositories, 3 models, block-randomised paired arms, hash-frozen holdout).[P1] Interests to declare, because both have one: JetBrains ships competing agent tooling including JetBrains Context; PointFive built one of the measured arms (RTK-ML) themselves — though that arm *lost* to plain RTK, a result against their own interest, which is the kind of finding that raises credibility rather than lowering it. Both are 3P with respect to the tools they graded; neither is neutral. Every other benchmark here was run by the tool's own maintainers.

### What independent measurement did to the claims

| Tool | Advertised | Measured on real agent work | Ratio |
|---|---|---|---|
| Caveman | −65% output | −8.5% output[J1] | **1/8** |
| Ponytail | −54% code, −20% cost | −15.4% code, −10.3% cost[J3] | **~1/3, 1/2** |
| rtk | −60–90% | +7.6%[J2] / −2.7% (holdout crosses zero)[P1] | **a wash** |
| Headroom | −20% coding agent, −60–95% JSON | **+48.4% cost** [+42.3, +55.0][P1] | **strongly negative** |

Not one survived contact with a paired bill; the only measured saving in the field is Ponytail's −10.3%, and it comes from writing less code rather than compressing anything. Three mechanisms explain it, and they are the most useful findings in this document:

1. **Prompt-cache traffic is ~87% of reconstructed cost** (~80% of the actual bill).[P1] A tool that cannot touch cached re-reads cannot move your bill.
2. **Payload reduction does not predict cost.** An arm that removed 38% of raw tool-output tokens cost **6.8% more**; across tasks the association was Pearson r = 0.15.[P1]
3. **Compression can destroy action-critical evidence.** On SWE-bench-derived Go tasks it corrupted verbatim edit anchors and cut successful patch application from **27/40 to 15/40**.[P1]

And the self-reporting trap: rtk's own scoreboard claimed 96.2M tokens saved — 99.8% of everything it touched — while the measured bill went up, because it counted full raw output as its counterfactual when the harness would have truncated that output anyway.[J2] A tool's self-reported savings are a claim about its counterfactual, not about your bill.

| Tool | Independence | Baseline | Relevance | Grade | Was |
|---|---|---|---|---|---|
| lean-ctx | 1P | undisclosed | high | **C** | B |
| Headroom | **3P** | disclosed | high | **A** | B |
| Caveman | **3P** | disclosed | high | **A** | B |
| OmniRoute | 1P | derived, not measured | med | **C** | C |
| Hindsight | 1P | disclosed | med | **B** | ~~A~~ |
| MemPalace | 1P | disclosed | high | **B** | B |
| agentmemory | 1P | disclosed | high | **B** | B |
| codebase-memory-mcp | 1P | disclosed | high | **B** | ~~A~~ |
| Graphify | 1P | disclosed, build cost excluded | high | **B** | B |
| rtk | **3P** | disclosed | high | **A** | new |
| Ponytail | **3P** | disclosed | high | **A** | new |
| mem0 | 1P | disclosed (own prior algorithm) | med | **B** | new |
| Serena | 1P | disclosed (built-in tools) | high | **B** | new |
| aider repo map | — | none published | high | **D** | new |
| LLMLingua / LLMLingua-2 | **3P** | disclosed | med | **B** | new |
| pxpipe | 1P | disclosed | high | **B** | new |
| Repomix | — | none published | high | **D** | new |

Spec conflicts found while grading: codebase-memory-mcp states 158 languages (README), 66 (paper), 63 (committed benchmark), and publishes 99%, 120× and 10× as token reductions of the same product. Graphify states ~40 languages against 12 implemented extractors. lean-ctx's README `git status` figure contradicts its own benchmark file. Serena's published evaluation ran only on its **paid** JetBrains backend; the free LSP backend most users run is unevaluated, and the agent grades itself by design.

**Still unmeasured by anyone independent:** lean-ctx, OmniRoute, and every memory and code-graph tool. Of the four tools that *were* independently measured on agent work, one saved ~10%, one was a wash, and two cost more than they saved. LLMLingua is the near-miss worth noting: it has genuine peer-reviewed third-party reproductions, but on chat QA, meetings and RAG — and the two high-relevance studies that did put it on a coding agent report **degradation**. Treat every remaining headline as an upper bound on a best case, not an expected value.

The uncomfortable summary: **every tool that earned an A did so because somebody bothered to disprove it.** Grade A here does not mean "works" — it means "measured". Three of the five A-graded tools are measured not to work.

<details>
<summary><strong>Trendshift screening — and why this method was retired</strong></summary>

**The discovery method is unsound and has been abandoned.** First capture, 2026-07-24 17:37:30 UTC: 1 of 20 repos qualified.[T1] Re-run on 2026-07-28 19:49 UTC: **0 of 20 qualified** — the top of the list was a frontier model release, a video-transcription skill, an agent sandbox platform, a social-media scraper and a GIS platform. A daily trending list measures novelty, not category membership, so it cannot enumerate a field: every incumbent that matters here (mem0, Zep, Letta, Serena, aider, LLMLingua, RTK) was invisible to it, and the two independent benchmark sources that reshaped this entire document surfaced from following citations, not from trending. Retained below as a record of the original frame.

Include rule: repo directly compresses, routes, or persists agent/LLM context or memory, with a public implementation.

| ID | Rank | Repository | Screen | Reason |
|---|---:|---|---|---|
| TS-01 | 1 | `block/buzz` | Exclude | Agent comms, not context compression |
| TS-02 | 2 | `koala73/worldmonitor` | Exclude | Monitoring dashboard |
| TS-03 | 3 | `hoainho/img2threejs` | Exclude | Image-to-3D generator |
| TS-04 | 4 | `alibaba/open-code-review` | Exclude | Code review product |
| TS-05 | 5 | `citrolabs/ego-lite` | Exclude | Browser, no context reduction |
| TS-06 | 6 | `permissionlesstech/bitchat` | Exclude | Bluetooth chat |
| TS-07 | 7 | `Automattic/harper` | Exclude | Grammar checker |
| TS-08 | 8 | `diegosouzapw/OmniRoute` | **Include** | Gateway with RTK+Caveman compression |
| TS-09 | 9 | `mattpocock/skills` | Exclude | Skill collection |
| TS-10 | 10 | `palmier-io/palmier-pro` | Exclude | Video editor |
| TS-11 | 11 | `ComposioHQ/awesome-claude-skills` | Exclude | Curated list |
| TS-12 | 12 | `stablyai/orca` | Exclude | Agent environment |
| TS-13 | 13 | `marcelroed/gigatoken` | Exclude | Tokenizer speed, not reduction |
| TS-14 | 14 | `DavidHDev/canvas-ui` | Exclude | UI library |
| TS-15 | 15 | `Vincentwei1021/video-shotcraft` | Exclude | Video skill |
| TS-16 | 16 | `earendil-works/pi` | Exclude | General agent toolkit |
| TS-17 | 17 | `ruvnet/RuView` | Exclude | Wi-Fi sensing |
| TS-18 | 18 | `yorukot/superfile` | Exclude | File manager |
| TS-19 | 19 | `shiyu-coder/Kronos` | Exclude | Finance model |
| TS-20 | 20 | `ifixai-ai/iFixAi` | Exclude | Model diagnostics |

</details>

<details>
<summary><strong>Primary sources</strong></summary>

- [T1 — Trendshift snapshot](https://trendshift.io/)
- [C1 — OmniRoute](https://github.com/diegosouzapw/OmniRoute)
- [C2 — Headroom](https://github.com/headroomlabs-ai/headroom)
- [C2B — Headroom benchmarks](https://headroom-docs.vercel.app/docs/benchmarks)
- [C3 — Caveman honest numbers](https://github.com/JuliusBrussee/caveman/blob/main/docs/HONEST-NUMBERS.md)
- [C4 — lean-ctx](https://github.com/yvgude/lean-ctx)
- [M1 — agentmemory](https://github.com/rohitg00/agentmemory)
- [M2 — MemPalace](https://github.com/MemPalace/mempalace)
- [M2H — MemPalace corrections](https://github.com/MemPalace/mempalace/blob/develop/docs/HISTORY.md)
- [M3 — Hindsight](https://github.com/vectorize-io/hindsight)
- [M3P — Hindsight paper](https://arxiv.org/abs/2512.12818)
- [G1 — Graphify](https://github.com/Graphify-Labs/graphify)
- [G2 — codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp)
- [G2P — Codebase-Memory paper](https://arxiv.org/abs/2603.27277)
- [J1 — JetBrains: Caveman paired A/B](https://blog.jetbrains.com/ai/2026/07/speak-to-ai-agents-like-cavemen-tosave-tokens/)
- [J2 — JetBrains: rtk paired A/B](https://blog.jetbrains.com/ai/2026/07/rtk-claude-code-token-savings/)
- [J3 — JetBrains: Ponytail paired A/B](https://blog.jetbrains.com/ai/2026/07/ponytail-skill-claude-tested/)
- [P1 — Token Reduction Is Not Cost Reduction (PointFive)](https://arxiv.org/abs/2607.12161)
- [X1 — mem0](https://github.com/mem0ai/mem0)
- [X2 — Serena](https://github.com/oraios/serena)
- [X3 — aider repo map](https://github.com/Aider-AI/aider/blob/main/aider/repomap.py)
- [O1 — OMP compaction source](https://github.com/can1357/oh-my-pi/blob/main/docs/compaction.md)
- [O2 — OMP compaction docs](https://omp.sh/docs/compaction)
- [O3 — OMP memory docs](https://omp.sh/docs/memory)
- [O4 — OMP settings schema](https://github.com/can1357/oh-my-pi/blob/main/packages/coding-agent/src/config/settings-schema.ts)
- [O5 — OMP LSP docs](https://omp.sh/docs/code-intelligence)
- [O6 — OMP file docs](https://omp.sh/docs/files)
- [O7 — OMP MCP docs](https://omp.sh/docs/mcp)

</details>

## Open for grilling

Everything above is settled or measured. These are not.

### 1. The harness decision is deferred, not made

OMP and Hermes are both in production and are **not substitutes** — 4.03 M tokens per instruction against 837 K, 26.3 autonomous turns against 11.3. The split is coherent, but nobody chose it; it accumulated. Choosing requires a paired measurement neither harness currently supports.

### 2. The blocker: OMP records no outcomes

**A harness A/B is impossible today.** Hermes records verification events (83.9% pass over 248) and structured patch outcomes (12.9% failure over 5,877). OMP records neither — 172 `*.bash.log` files, zero `*.edit.log`, no exit codes, no pass rate. Any comparison run tomorrow would have a measured arm and an unmeasurable one.

Instrumenting OMP is therefore a **prerequisite**, not a parallel task. It is also cheap: a hook that records `{command, kind, exit_code, session, cwd}` for lint/test/build invocations, mirroring `~/.hermes/verification_evidence.db`.

### 3. Proposed paired benchmark, once instrumentation exists

Modelled on the only two designs in this document that produced trustworthy numbers.[J1][J2][J3][P1]

| | |
|---|---|
| Arms | A = OMP, B = Hermes; identical task, identical repo snapshot, identical model where both support it (`gpt-5.6-sol` is the only overlap with real volume) |
| Task set | Drawn from the 934 recorded sessions — real tasks with known-good outcomes, not synthetic |
| Ladder | transcript replay (free) → 10-task smoke → same 10 at k=3 → full set. **Never trust k=1**: JetBrains' smoke said −29.5% and −30%, both of which dissolved |
| Primary endpoints, pre-registered | per-task paired billed cost; verification pass rate; edit/patch failure rate |
| Secondary | turns to completion, `ask`/`clarify` rate, output tokens |
| Statistics | paired only; sign test for quality, Wilcoxon on per-task medians for cost — arm totals are outlier-dominated |
| Adoption audit | prove per trial which harness ran and that instrumentation fired, so "no difference" can never be confused with "never ran" |

**Cost anchor:** JetBrains spent ≈USD 106 (240 trials) and ≈USD 320 (425 trials) per tool; PointFive ran ≈5,500 billed executions. Budget accordingly, or accept a narrower claim.

### 4. Cheap fixes that do not need the benchmark

| Fix | Cost | How it is verified |
|---|---|---|
| Dedupe Hermes lean-ctx registration (34 schemas → 17) | one config edit | tool count after restart |
| OMP `write`:`edit` ratio — 3.15:1 against its own policy, on the top output-token consumer | policy/prompt change | ratio in subsequent sessions |
| Remove agentmemory + node_repl from OMP (0 calls, 10 schemas) | one config edit | tool count after restart |

### 5. Still unmeasured from the audit

- **Item 8** — the resident MCP tool-schema cost per turn has never been quantified on either harness.
- **Item 9** — no harness has been measured against itself with tools removed. Every "saving" here is relative to naive file reading.
- **Item 11** — tool versions are pinned nowhere in this document, so no claim is reproducible six months out.
- **Item 13** — no staleness policy for graph-versus-worktree divergence.
- **opencode** — installed and configured, one session. A capability candidate with no evidence; including it would require running it, not reading about it.

[T1]: https://trendshift.io/ "Trendshift snapshot"
[C1]: https://github.com/diegosouzapw/OmniRoute
[C2]: https://github.com/headroomlabs-ai/headroom
[C2B]: https://headroom-docs.vercel.app/docs/benchmarks
[C3]: https://github.com/JuliusBrussee/caveman/blob/main/docs/HONEST-NUMBERS.md
[C4]: https://github.com/yvgude/lean-ctx
[M1]: https://github.com/rohitg00/agentmemory
[M2]: https://github.com/MemPalace/mempalace
[M2H]: https://github.com/MemPalace/mempalace/blob/develop/docs/HISTORY.md
[M3]: https://github.com/vectorize-io/hindsight
[M3P]: https://arxiv.org/abs/2512.12818
[G1]: https://github.com/Graphify-Labs/graphify
[G2]: https://github.com/DeusData/codebase-memory-mcp
[G2P]: https://arxiv.org/abs/2603.27277
[O1]: https://github.com/can1357/oh-my-pi/blob/main/docs/compaction.md
[O2]: https://omp.sh/docs/compaction
[O3]: https://omp.sh/docs/memory
[O4]: https://github.com/can1357/oh-my-pi/blob/main/packages/coding-agent/src/config/settings-schema.ts
[O5]: https://omp.sh/docs/code-intelligence
[O6]: https://omp.sh/docs/files
[O7]: https://omp.sh/docs/mcp
[J1]: https://blog.jetbrains.com/ai/2026/07/speak-to-ai-agents-like-cavemen-tosave-tokens/
[J2]: https://blog.jetbrains.com/ai/2026/07/rtk-claude-code-token-savings/
[J3]: https://blog.jetbrains.com/ai/2026/07/ponytail-skill-claude-tested/
[P1]: https://arxiv.org/abs/2607.12161
[X1]: https://github.com/mem0ai/mem0
[X2]: https://github.com/oraios/serena
[X3]: https://github.com/Aider-AI/aider/blob/main/aider/repomap.py
