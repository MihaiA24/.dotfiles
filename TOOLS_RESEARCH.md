# AI Tooling — Verdicts

Every tool evaluated. Verdicts from local measurement (billed cost, not tokens). Evidence: `AI_CONTEXT_TOOLING_COMPARISON.md` (frozen).

## Compression

| Tool | For | Verdict |
|---|---|---|
| Caveman | Terse prose | **Use** (on demand) |
| Ponytail | Minimal code | **Use** (force-injected; only measured cost saver) |
| rtk | Output compression | No — bill unchanged |
| Headroom | Prompt compression | No — makes cost worse |
| LLMLingua | ML compression | No — degrades coding agents |
| Context Mode / mcp-compressor / OmniRoute / pxpipe | Various | No — duplicate native, unproven, or unneeded |

## Memory

| Tool | For | Verdict |
|---|---|---|
| Mnemopi | Per-project memory, local, keyless | **Default**. Defect: can silently stop retaining → canary hook watches |
| Hindsight | Self-hosted memory server | **Challenger only** — recall ties, needs 1.4 GiB container |
| mem0 / agentmemory / MemPalace / Letta / Zep | Various | No — unproven claims, wrong lane, or paid-only |

## Code graph

| Tool | For | Verdict |
|---|---|---|
| codebase-memory-mcp | Persistent code graph | **Gated** — costs quality for 10× tokens; enable per session only |
| Graphify | Any-input KG | On demand only |
| GitNexus / GraphRAG / cognee / Graphiti / Semantica / Serena | KG / symbol tools | No — no coding evidence, license, or paid |

## Context I/O

| Tool | For | Verdict |
|---|---|---|
| OMP native (read/grep/glob/edit/LSP + scouts) | File & symbol I/O | **Only path** |
| lean-ctx | Cached reads, semantic search | Dropped — unused in practice |
| aider repomap / Repomix | Repo summaries | Not pursued |
