# Teaching Notes

- User refined the presentation: focus harnesses on OMP and Hermes only.
- Skills focus should be installed/global behavior rules: Matt Pocock (`ask-matt`, `tdd`), caveman, and Karpathy guidelines.
- MCP context focus: LeanCTX / `lean-ctx` as the used context runtime; RTK and Headroom as alternatives. Keep the “used vs alternative” distinction explicit.
- Add long-lived context handling: `codebase-memory-mcp` for structural graph memory and `agentmemory` for narrative/session memory.
- Presentation should not cite or foreground `agentic-env`; use it only as internal knowledge for shaping the talk.
- Keep warning: `codebase-memory-mcp` is long-lived structural memory but rebuildable from code; durable accepted project truth still belongs in plain text ADRs/CONTEXT.md.
- User later requested more detailed diagrams, more detail for every part, removal of explicit per-slide duration labels, and a longer walkthrough format.
- User clarified Matt Pocock skills should be shown as the actual implementation order: wayfinder/grill-with-docs → to-spec → to-tickets → implement → code review.
- User requested final addition: more detailed long-term memory visual focused on `codebase-memory-mcp` structural memory vs `agentmemory` narrative memory, plus copy-paste links for repos/docs at the bottom.
