# LLM Agentic Workflow Resources

## Knowledge

- [Internal knowledge: local agentic stack runbooks](agentic-env/README.md)
  Use as background only. Do not cite this in the group presentation unless the audience specifically asks about the local installer.
- [Internal knowledge: local project memory stack guide](agentic-env/docs/project-memory-stack.md)
  Use as background for the boundary between context access, structural memory, narrative memory, and canonical plain-text records.
- [Internal knowledge: local agentic environment glossary](agentic-env/docs/CONTEXT.md)
  Use as background for consistent vocabulary: harness, global skill, MCP configuration, structural memory, narrative memory.
- [Model Context Protocol docs: introduction](https://modelcontextprotocol.io/docs/getting-started/intro)
  Official MCP overview. Use for: explaining MCP as a standard connector between AI apps and external tools/data/workflows.
- [MCP specification: server features](https://modelcontextprotocol.io/specification/2025-11-25/server/index)
  Official definition of MCP prompts, resources, and tools. Use for: separating “context”, “action”, and “workflow template”.
- [OMP / Oh My Pi site](https://omp.sh/)
  Official OMP overview. Use for: OMP as a terminal coding harness with subagents, LSP/DAP, hashline edits, and memory features.
- [Hermes Agent docs](https://hermes-agent.nousresearch.com/docs/)
  Official Hermes documentation. Use for: harness capabilities, skills, MCP commands, sessions, and Hermes-specific global config.
- [Hermes MCP docs](https://hermes-agent.nousresearch.com/docs/user-guide/features/mcp/)
  Official Hermes MCP documentation. Use for: how Hermes discovers and manages MCP servers.
- [Hermes Skills docs](https://hermes-agent.nousresearch.com/docs/user-guide/features/skills)
  Official Hermes skills documentation. Use for: how skills are installed, invoked, and stacked in Hermes.
- [Anthropic Agent Skills overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
  Official Agent Skills overview. Use for: explaining skills as packaged instructions/resources loaded when relevant.
- [Claude Code skills docs](https://code.claude.com/docs/en/slash-commands)
  Official Claude Code skill and slash-command docs. Use for: `SKILL.md`, global/project skill locations, and progressive disclosure.
- [LeanCTX official docs](https://leanctx.com/docs/getting-started/)
  Official context-engineering documentation. Use for: compressed reads, cached re-reads, shell-output compression, and MCP exposure.
- [LeanCTX MCP tool reference](https://leanctx.com/docs/tools/)
  Official tool reference. Use for: explaining `ctx_read`, `ctx_search`, `ctx_tree`, `ctx_shell`, and related context tools.
- [RTK site](https://www.rtk-ai.app/)
  Official Rust Token Killer site. Use for: RTK as an alternative CLI proxy for reducing token-heavy command output.
- [RTK GitHub](https://github.com/rtk-ai/rtk)
  Source repository. Use for: RTK installation, command-interception behavior, and claimed token savings.
- [Headroom site](https://headroomlabs.ai/)
  Official Headroom landing page. Use for: Headroom as a context-optimization layer for LLM agents.
- [Headroom MCP docs](https://headroom-docs.vercel.app/docs/mcp)
  Official MCP setup and tool reference. Use for: `headroom_compress`, `headroom_retrieve`, and `headroom_stats`.
- [Codebase Memory MCP official docs](https://deusdata.github.io/codebase-memory-mcp/)
  Official docs for the structural code graph. Use for: graph indexing, symbol/call/route queries, and codebase architecture memory.
- [Codebase Memory MCP GitHub](https://github.com/DeusData/codebase-memory-mcp)
  Source repository and tool list. Use for: current installation examples, MCP tools, graph labels, edge types, and config commands.
- [AgentMemory official site](https://www.agent-memory.dev/)
  Official site for local persistent memory for coding agents. Use for: narrative/session memory, MCP configuration, and local viewer/server mental model.
- [AgentMemory GitHub](https://github.com/rohitg00/agentmemory)
  Source repository. Use for: installation, architecture, and supported integrations.

## Wisdom (Communities)

- [Model Context Protocol GitHub organization](https://github.com/modelcontextprotocol)
  Practical implementation discussions and reference servers. Use for: seeing how MCP servers are built and maintained.
- [LeanCTX GitHub issues](https://github.com/yvgude/lean-ctx/issues)
  Project-specific community for context compression workflows. Use for: current feature behavior and bugs.
- [RTK GitHub issues](https://github.com/rtk-ai/rtk/issues)
  Project-specific community for CLI command-output compression and integration edge cases.
- [Headroom GitHub issues](https://github.com/chopratejas/headroom/issues)
  Project-specific community for context compression, proxy behavior, and MCP tool behavior.
- [Codebase Memory MCP GitHub issues](https://github.com/DeusData/codebase-memory-mcp/issues)
  Project-specific community for graph indexing behavior and edge cases. Use for: tool limitations and real repository reports.
- [AgentMemory GitHub issues](https://github.com/rohitg00/agentmemory/issues)
  Project-specific community for persistent memory behavior and integrations. Use for: storage, retrieval, and agent-connection questions.

## Gaps

- Need a live demo script if the presentation becomes a workshop rather than a 10-15 minute talk.
- RTK is best documented as a CLI proxy/token saver in the sources found; do not present it as equivalent to LeanCTX’s full MCP context runtime unless future docs show that capability.
