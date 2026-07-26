# PersonWise Skills

Public, lightweight Agent Skills for creating with PersonWise. The instructions live here; user
identity, authorization, course credits, durable state, and product logic stay in the
OAuth-protected PersonWise SaaS.

## Install

Install `personwise-create-course` for Codex, Claude Code, Cursor, and other Agent Skills hosts:

```bash
npx skills add personwiseai/skills --skill personwise-create-course
```

GitHub Copilot users can also install it with GitHub CLI 2.90.0 or later:

```bash
gh skill install personwiseai/skills personwise-create-course
```

Claude Code users who prefer the plugin marketplace flow can install the Skill and its remote MCP
connection together:

```text
/plugin marketplace add personwiseai/skills
/plugin install personwise-create-course@personwise
```

The Skill connects to `https://mcp.personwise.ai/mcp`. Authentication uses browser-based OAuth;
do not put API keys or access tokens in this repository.

## Current release

- Skill: `personwise-create-course`
- Version: `1.1.0`
- Install page: https://personwise.ai/skills/personwise-create-course
- Support: support@personwise.ai
- Privacy: https://personwise.ai/privacy
- Terms: https://personwise.ai/terms

Each release is tagged and accompanied by a SHA-256 checksum for its packaged `.skill` artifact.
