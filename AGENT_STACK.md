# Decided Agent Stack

The stack as decided, layer by layer: what we run, why, what else we considered, and when to revisit. Canonical decision log: `DECISIONS_AI_TOOLING.md`. Evidence: `TOOLS_RESEARCH.md`, `AI_CONTEXT_TOOLING_COMPARISON.md` (frozen), `agentic-env/docs/memory-backend-research.md`, ADRs `agentic-env/docs/adr/`.

## The stack

| Layer | Decided | Why | Alternatives considered | Revisit when |
|---|---|---|---|---|
| Harness | **OMP** primary | Anthropic model capability (98%+ pass vs GPT band ~75%), LSP, recoverable edit anchors; end-green 96.3% post-tuning | Hermes (tie on end-green, kept dormant; contributed two ideas: bounded work units, verification cadence), Claude Code, opencode, Codex (all dormant/no comparative evidence) | Only if OMP-primary needs to be definitive → paired benchmark (pre-registered design in comparison doc) |
| Context I/O | **OMP native only** (`read`/`grep`/`glob`/`edit`/LSP + scout subagents) | Prompt-cache-stable, anchor-safe; compressors on read→edit path cut patch success 27/40→15/40 | lean-ctx (dropped 08-11, usage below kill threshold), Headroom (+48.4% cost), Context Mode, rtk, LLMLingua | grep+LSP+scouts visibly fail on a real task |
| Compaction | `strategy: handoff`, `thresholdTokens: 150000`, `idleEnabled`, `handoffSaveToDisk` | Bundle read-out 08-11: tokens/session −43…−50%, end-green 96.3%, cadence 20.9 — 3/4 pre-registered targets pass | 120K threshold (no paired arm exists — keeping 150K is not goalpost drift) | End-green < 88% → revert `strategy` first, then threshold |
| Memory | **Mnemopi** (`backend: mnemopi`, per-project, keyless) + **retention canary** (`omp/hooks/retention-canary.ts`) | Recall ties Hindsight once store is populated; reflect works keyless; zero infra. Known defect: silent retention loss (07-19→08-10 gap, cause unattributable) — canary bounds detection to ≤7 days | **Hindsight** = sole challenger (wins empty-store recall; costs 1.4 GiB always-on container; Stage 2 unmeasured, blocked on API key — unblock paths in decisions doc line 33). Eliminated: mem0, agentmemory, MemPalace, Letta, Zep | Related-project memory sharing becomes a live need (the one thing Mnemopi structurally cannot do), or Stage 2 results overturn the tie |
| Code graph | codebase-memory-mcp **gated** (denylisted, enable per session via litmus) | −9 pts quality for 10× tokens; litmus fired 0× since 08-05 | GitNexus, GraphRAG, cognee, Graphiti, Semantica, Serena — all rejected (no coding evidence / wrong lane / license / paid) | Litmus fires ~weekly → promote to default-on per project |
| Skills | Ponytail (force-injected), Caveman + Graphify (on demand); curated roster 24 skills, agents-store disabled | Ponytail −10.3% cost is the only measured saving; Caveman −8.5%; roster curation cut prompt base ~15% | Full 53-skill store (kept as recovery-only), rtk-style output tools | A skill shows measured harm at next read-out |
| Hooks | `verification-recorder` + `cadence-governor` (N=25, silent after 3) + `retention-canary` | Recorder enables all read-outs; governor 59% first-nudge compliance; canary is the only defense against silent memory loss | External monitoring (can't reach in-session), root-causing the gap (all suspects eliminated) | Recorder shows nudges misfiring again |

## Hard rules that shaped every choice

1. Judge by success-adjusted **billed cost**, never token counts (r=0.15 between payload reduction and cost over 2,848 runs).
2. Adopt only on locally measured, **pre-registered** endpoints — vendor claims deflated 3–8× or sign-flipped every time we measured.
3. **One memory owner** (ADR-0006). One compressor per request path. No lossy compressor on read→edit path.
4. Decisions live in **committed docs** (ADR-0002) — memory is a convenience layer, docs are the safety net. The retention gap proved this.

## Open items

1. **Stage 2 memory bake-off** — Hindsight retain-LLM/reflect/observations. Blocked on an OpenAI-compatible API key (ChatGPT OAuth cannot be used). Paths: free Gemini/Groq key, OpenAI pay-as-you-go (~cents), or local Ollama as the keyless $0 arm. Skipping it leaves the decision standing on Stage 1 + 1b.
2. **Merge to main** — branch `feat/agent-stack-measured-cleanup` is publish-only by user decision; PR link in `DECISIONS_AI_TOOLING.md`.
3. **Upstream OMP issue** (draft below) — file only if wanted or if the gap recurs.

## Upstream OMP issue — draft, file if needed

**Title**: Silent per-project Mnemopi retention gap — zero retains for 23 days, no errors, self-healing

**Body facts** (all verified locally, full forensics in `agentic-env/docs/memory-backend-research.md`):
- Bank `dotfiles-28sa6aeav6z5s`: zero rows written 2026-07-19 → 2026-08-10. Works ≤07-14, works again ≥08-11. No config, version, or hook change at either edge.
- 8+ sessions ran during the gap, including one with 28 user turns → 0 retains. 1-turn sessions before the gap retained fine.
- Control: 11 sibling project banks on the same machine retained continuously through the window, on identical omp versions (17.1.5 → 17.2.14 → 17.3.5).
- `backend: mnemopi` confirmed wired mid-gap (config backup mtime 07-29).
- Not misrouted: no dotfiles-marker rows in any of 276 banks in the window.
- No errors in any session jsonl. Same class as omp #2320 / #2322.
- Conclusion: project-local, silent, self-healing retention failure; unattributable post-hoc. Detection-side workaround shipped locally (session-start staleness canary). Request: retention-side telemetry (log or counter per retain attempt/commit) so this class is attributable.
