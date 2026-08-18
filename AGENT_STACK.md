# Agent Stack — Decisions

| Layer | Decided | Why | Alternatives | Revisit when |
|---|---|---|---|---|
| Harness | OMP | Best model + LSP + edit anchors | Hermes, Claude Code, opencode, Codex | Never unless OMP fails |
| Context I/O | OMP native only | Cache-stable, anchor-safe; compressors break edits | lean-ctx (dropped), Headroom, rtk | Native tools visibly fail |
| Compaction | handoff @ 150K, idle on, save-to-disk | −43–50% tokens, quality held | 120K threshold | End-green < 88% → revert |
| Memory | Mnemopi + retention-canary hook | Recall good, keyless, zero infra; canary covers silent-loss defect | Hindsight (sole challenger), mem0, agentmemory, Letta, Zep | Cross-project memory sharing needed → Hindsight |
| Code graph | codebase-memory-mcp gated off | Costs quality, 10× tokens | GitNexus, GraphRAG, Serena, etc. | Litmus fires weekly |
| Skills | Ponytail forced, Caveman + Graphify on demand; curated roster | Only measured savers | Full 53-skill store | Measured harm |
| Hooks | verification-recorder, cadence-governor, retention-canary | Enable read-outs, verify cadence, detect memory loss | External monitoring | Nudges misfire |

## Rules

1. Judge by billed cost, never tokens.
2. Adopt only on local measurement.
3. One memory owner. No lossy compressor on read→edit path.
4. Decisions live in committed docs; memory is convenience.

## Open

1. Stage 2 memory bake-off — blocked on OpenAI-compatible key (or skip).
2. Merge to main — user's call.
3. Upstream OMP issue, file if wanted: silent Mnemopi retention gap, bank `dotfiles-28sa6aeav6z5s`, zero retains 07-19→08-10, self-healed, no errors, 11 sibling banks fine same days. Ask for retain-attempt telemetry. Forensics: `agentic-env/docs/memory-backend-research.md`.
