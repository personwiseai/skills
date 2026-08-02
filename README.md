# PersonWise Skills

Public, optional Agent Skills for additional PersonWise course-design guidance. The standalone MCP
at `https://mcp.personwise.ai/mcp` already contains the complete international course-creation workflow;
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

### 创建 PersonWise 课程

Market variant: `zh-cn` (`zh-CN`, Mainland China)

从一个主题、文本、文档或参考图片出发，通过中国区 OAuth 连接的课程创作 MCP，生成并审阅大纲、讲稿、幻灯片视觉、主讲人与课程配置，最终交付草稿、私有课程或可公开访问的课程链接。

```bash
npx skills add personwiseai/skills --skill personwise-create-course-zh-cn
```

### Interactive Product Explainer

Market variant: `en-global` (`en`, International English)

Product videos are expensive and one-way. Turn verified SaaS or software product materials into a five-page interactive PersonWise website explainer visitors can question and embed, without inventing UI, features, customers, pricing, integrations, metrics, or roadmap.

```bash
npx skills add personwiseai/skills --skill personwise-interactive-product-explainer
```

### 创建可问答的产品介绍

Market variant: `zh-cn` (`zh-CN`, Mainland China)

产品视频制作昂贵，而且观众只能单向观看。把官网、产品手册、发布资料等可信来源制作成可嵌入网站、访客可以直接提问的五页互动产品介绍；不得编造界面、功能、客户、价格、集成、指标、资质或路线图。

```bash
npx skills add personwiseai/skills --skill personwise-interactive-product-explainer-zh-cn
```

Each optional Skill declares its catalog-approved standalone MCP deployment. Authentication uses
browser-based OAuth; do not put API keys or access tokens in this repository. Skill presence or
version never gates an MCP operation.

## Current release

- Bundle: `1.4.0`
- Tag: `v1.4.0`
- Core Skill: `personwise-create-course` `1.3.2`
- Install page: https://personwise.ai/skills/personwise-create-course
- Support: support@personwise.ai
- Privacy: https://personwise.ai/privacy
- Terms: https://personwise.ai/terms

Each Skill release has a deterministic `.skill` archive and SHA-256 checksum.
