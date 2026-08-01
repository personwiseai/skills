# PersonWise Skills

Public, optional Agent Skills for additional PersonWise course-design guidance. The standalone MCP
at `https://mcp.personwise.ai/mcp` already contains the complete basic course-creation workflow;
user identity, authorization, course credits, durable state, and product logic stay in the
OAuth-protected PersonWise SaaS.

## Install

No Skill is required to use PersonWise. Connect the remote MCP directly in any conforming Agent.
Optionally install `personwise-create-course` for extra course-design and review guidance:

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

Scenario-specific playbooks:

### Interactive Product Explainer

Product videos are expensive and one-way. Turn verified product materials into a five-page interactive PersonWise explainer visitors can ask questions and embed on a website, without inventing UI, features, customers, pricing, integrations, metrics, or roadmap.

```bash
npx skills add personwiseai/skills --skill personwise-interactive-product-explainer
```

The optional Skills point to the same standalone MCP. Authentication uses browser-based OAuth; do
not put API keys or access tokens in this repository. Skill presence or version never gates an MCP
operation.

## Current release

- Bundle: `1.3.0`
- Tag: `v1.3.0`
- Core Skill: `personwise-create-course` `1.2.0`
- Install page: https://personwise.ai/skills/personwise-create-course
- Support: support@personwise.ai
- Privacy: https://personwise.ai/privacy
- Terms: https://personwise.ai/terms

Each Skill release has a deterministic `.skill` archive and SHA-256 checksum.
