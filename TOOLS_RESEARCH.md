# AI Tooling Research — Catalog

Simple catalog of every tool we evaluated (discovery: trendshift.io trending lists + citation chasing; trending channel retired after 1/20, then 0/20 candidates qualified). One line per tool: what it is for, and whether it actually works **as measured**, not as advertised.

Evidence detail lives in `AI_CONTEXT_TOOLING_COMPARISON.md` (frozen) and `agentic-env/docs/memory-backend-research.md`. Rule that governs every verdict: judge by success-adjusted billed cost, never token counts.

## Output / prompt compression

| Tool | Made for | Does it work? |
|---|---|---|
| Caveman | Terse agent prose to cut output tokens | **Yes, modestly** — measured −8.5% (vendor claim −65%). Adopted on demand. |
| Ponytail | Force minimal code, fewer lines | **Yes** — −10.3% billed cost, the only measured saving. Must be force-injected (self-activates 0/10). Adopted. |
| rtk | Compress bash/tool output | **No effect** — "savings" are byte counts, bill unchanged. Rejected. |
| Headroom | Prompt compression middleware | **Harmful** — +48.4% cost in 3P benchmark. Rejected. |
| LLMLingua | ML prompt compression | Works on chat/RAG, **degrades coding agents**. Rejected. |
| Context Mode | Context byte reduction | Duplicates OMP-native spill/selectors/compaction; sits on read→edit path. Rejected. |
| mcp-compressor | Shrink MCP tool schemas | Solves a problem this stack does not have (`mcpServers: {}`). Rejected. |
| OmniRoute | Model routing for cost | Headline 89.2% is arithmetic, never measured. Rejected. |
| pxpipe | Pipeline compression | Unexamined — no evidence either way. |

## Memory backends

| Tool | Made for | Does it work? |
|---|---|---|
| Mnemopi | Per-project narrative memory, local SQLite, keyless | **Yes, with one defect** — transcript recall good, KG noisy; retention died silently 07-19→08-10 (cause unattributable). **Adopted default**; retention canary wired 08-18. |
| Hindsight | Self-hosted memory (PG/pgvector, cross-encoder) | **Yes at recall** — wins empty-store probes 1/4 vs 0/4 (tie once Mnemopi store populated); $0 retain in zero-LLM mode; needs 1.4 GiB always-on container. **Kept as sole challenger**; Stage 2 (retain-LLM, reflect) unmeasured, blocked on API key. |
| mem0 | Memory platform | 94.4% LongMemEval headline is **managed-platform-only**, OSS arm unproven. Eliminated. |
| agentmemory | Cross-harness retrieval memory | Retrieval-only; 92% figure is one example; 54-tool MCP surface. Eliminated (also violates one-memory-owner). |
| MemPalace | Memory with committed benchmarks | Best-documented candidate (publishes retractions), but 30× compression self-retracted. Not adopted. |
| Letta | Self-editing memory blocks | Competing agent runtime, not a memory backend; blocks ride every prompt. Rejected. |
| Zep | Temporal memory graph | Paid cloud only, source closed. Rejected. |

## Code graph / knowledge graph

| Tool | Made for | Does it work? |
|---|---|---|
| codebase-memory-mcp | Persistent code graph, Cypher queries | **Costs quality**: 83 vs 92 baseline (−9 pts) for 10× tokens. Kept gated behind a litmus; fired 0× since 08-05. |
| Graphify | Any-input knowledge graph | 71.5× claim excludes build cost; 3 data points. Kept on demand only. |
| GitNexus | Code graph + taint analysis | No token benchmark; PolyForm-NC license. Rejected. |
| GraphRAG / cognee / Graphiti / Semantica | Document/temporal/enterprise KGs | No coding measurement in any; wrong lane (no code semantics). Rejected. |
| Serena | Symbol-aware editing MCP | Self-graded single anecdote (1 call vs 9); paid backend. Rejected. |

## Context I/O

| Tool | Made for | Does it work? |
|---|---|---|
| OMP native (`read`/`grep`/`glob`/`edit`/LSP + scouts) | File and symbol I/O | **Yes** — prompt-cache-stable, anchor-safe. Adopted as the only context path. |
| lean-ctx | Cached reads, compressed shell, semantic search | Own benchmark contradicts its README (32.6% vs 85%). Gated to semantic-only, then **dropped 08-11**: 1 semantic call in 2 weeks vs kill threshold of 5. |
| aider repo map / Repomix / `local` | Repo summarization | No measurement. Not pursued. |

## Meta-findings

- Advertised vs measured, consistently inflated: Caveman 1/8 of claim, Ponytail ~1/3, rtk wash, Headroom sign-flipped to harmful.
- "Grade A evidence" means *measured*, not *works* — 3 of 5 A-graded tools measured not to work.
- Trending-list discovery yields ~0 adoptable tools; both useful 3P sources (JetBrains paired A/Bs, PointFive paper) came from citations.
- Full-market sweep 08-11 (17 tools): 0 adoptions — no candidate ships third-party agent-on-repo evidence.
