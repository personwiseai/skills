# PersonWise Skills

Public Agent Skills for creating PersonWise interactive digital-human courses with the pinned
`personwise` CLI. Each scenario package owns task judgment and safety while browser OAuth,
course credits, durable state, and product logic remain in the PersonWise SaaS.

## Install

Install `personwise-create-course` for the general course-design and review workflow:

```bash
npx skills add personwiseai/skills --skill personwise-create-course
```

GitHub Copilot users can also install it with GitHub CLI 2.90.0 or later:

```bash
gh skill install personwiseai/skills personwise-create-course
```

Claude Code users who prefer the plugin marketplace flow can install the Skill package:

```text
/plugin marketplace add personwiseai/skills
/plugin install personwise-create-course@personwise
```

Scenario-specific playbooks:

### Create a PersonWise Course

Market variant: `en-global` (`en`, International English)

Create, review, and publish a polished interactive PersonWise course from a topic, text, documents, or reference images through the PersonWise CLI and browser OAuth.

```bash
npx skills add personwiseai/skills --skill personwise-create-course
```

### 创建 PersonWise 课程

Market variant: `zh-cn` (`zh-CN`, Mainland China)

从主题、文本、文档或参考图片出发，通过 PersonWise CLI 和浏览器 OAuth，生成并审阅大纲、讲稿、幻灯片视觉、主讲人与配置，最终交付草稿、私有课程或中国区公开链接。

```bash
npx skills add personwiseai/skills --skill personwise-create-course-zh-cn
```

### Interactive Product Explainer

Market variant: `en-global` (`en`, International English)

Product videos are expensive and one-way. Turn verified SaaS or software product materials into an interactive digital-human PersonWise website explainer visitors can question and embed, without inventing UI, features, customers, pricing, integrations, metrics, or roadmap.

```bash
npx skills add personwiseai/skills --skill personwise-interactive-product-explainer
```

### 创建可问答的产品介绍

Market variant: `zh-cn` (`zh-CN`, Mainland China)

产品视频制作昂贵，而且观众只能单向观看。把官网、产品手册、发布资料等可信来源制作成可通过链接分享、观众可随时语音提问的数字人互动产品介绍；不得编造界面、功能、客户、价格、集成、指标、资质或路线图。

```bash
npx skills add personwiseai/skills --skill personwise-interactive-product-explainer-zh-cn
```

### Customer Education

Market variant: `en-global` (`en`, International English)

Customers keep asking the same questions, and every repeat answer costs support time. Turn your help content and product knowledge into an interactive digital-human customer education course that answers learner questions on its own — a customer academy asset for your help center, portal, or CSM follow-ups. Account-specific diagnosis always routes back to your support team.

```bash
npx skills add personwiseai/skills --skill personwise-customer-education
```

### Customer Onboarding Course

Market variant: `en-global` (`en`, International English)

Every new customer asks the same first-week questions, and your team answers them one call at a time. Turn your confirmed onboarding materials into an interactive digital-human course that walks new customers from signup to first value and answers their questions along the way. Built only on confirmed scope, timelines, and support channels — never invented promises.

```bash
npx skills add personwiseai/skills --skill personwise-customer-onboarding
```

### Product First-Success Guide

Market variant: `en-global` (`en`, International English)

New users stall before their first success, and every stalled setup costs activation. Turn your setup guides and manuals into an interactive digital-human quick start guide that walks users to first successful use and answers their questions along the way. High-risk steps always point back to qualified on-site confirmation — the course guides, it never certifies.

```bash
npx skills add personwiseai/skills --skill personwise-product-first-success
```

### Sales Enablement Training

Market variant: `en-global` (`en`, International English)

Reps repeat whatever the launch deck says — including the parts nobody approved. Turn your approved positioning and go-to-market materials into an interactive digital-human sales enablement training course that carries only cleared claims and answers rep questions on demand. Customer names, competitive advantages, and results are never invented.

```bash
npx skills add personwiseai/skills --skill personwise-sales-enablement-training
```

### Employee Onboarding Course

Market variant: `en-global` (`en`, International English)

Every new hire asks the same first-week questions, and HR answers them one at a time. Turn your handbook and onboarding plan into an interactive digital-human employee onboarding course that ramps new hires and answers their questions on demand. Individual labor, compensation, or legal matters always route back to HR — the course never improvises them.

```bash
npx skills add personwiseai/skills --skill personwise-employee-onboarding
```

### SOP and Process Training

Market variant: `en-global` (`en`, International English)

SOPs get skimmed once and forgotten — until someone skips a step. Turn your SOP and policy documents into an interactive digital-human process training course that teaches the procedure exactly as written and answers questions against the source. The course always names the SOP version it teaches and never replaces supervision, licenses, or sign-off.

```bash
npx skills add personwiseai/skills --skill personwise-sop-process-training
```

### Developer Quickstart

Market variant: `en-global` (`en`, International English)

Developers abandon APIs that do not return a first success fast. Turn your API documentation and SDK guides into an interactive digital-human developer quickstart that takes them from credentials to their first successful API call — with code carried exactly from your docs, never improvised. Version-stamped and askable, so the tutorial answers follow-up questions your docs cannot.

```bash
npx skills add personwiseai/skills --skill personwise-developer-quickstart
```

### Partner Training

Market variant: `en-global` (`en`, International English)

Partners repeat what your materials say — to their customers, in public. Turn your approved partner program materials into an interactive digital-human partner training course that teaches the product story, the deal flow, and the rules exactly as approved, and answers partner questions on demand. Commissions, territories, and earnings are never promised beyond what you have approved.

```bash
npx skills add personwiseai/skills --skill personwise-partner-training
```

### Student Orientation

Market variant: `en-global` (`en`, International English)

Every cohort arrives asking the same questions, and student services answers them all term. Turn your handbook and orientation materials into an interactive digital-human student orientation course that prepares new students before day one and stays askable after. Fees, visas, housing, and policies come only from your documents — never invented.

```bash
npx skills add personwiseai/skills --skill personwise-student-orientation
```

### Compliance Training

Market variant: `en-global` (`en`, International English)

Compliance training that nobody reads becomes the incident nobody wants. Turn your policies and regulatory materials into an interactive digital-human compliance training course that employees can actually question — obligations carried exactly from your source documents. The course never claims to be legal compliance, certification, or advice itself; the authority stays with your source.

```bash
npx skills add personwiseai/skills --skill personwise-compliance-training
```

### Security Awareness Training

Market variant: `en-global` (`en`, International English)

Employees are the attack surface, and a skimmed policy PDF does not change behavior. Turn your security policies into an interactive digital-human security awareness training course that builds recognition and reporting reflexes — and answers employee questions on demand. Honest by design: awareness reduces risk, it never claims to eliminate it.

```bash
npx skills add personwiseai/skills --skill personwise-security-awareness-training
```

### Lead Magnet

Market variant: `en-global` (`en`, International English)

Most lead magnets are PDFs that get downloaded and forgotten. Build an interactive digital-human lead magnet — a free mini course that delivers real standalone value and keeps answering subscriber questions after the opt-in. No fake scarcity, no invented results: your expertise, taught well enough to earn the list.

```bash
npx skills add personwiseai/skills --skill personwise-lead-magnet
```

### Sales Onboarding

Market variant: `en-global` (`en`, International English)

New sales reps ramp on whatever they find — including claims nobody approved. Turn your sales playbook into an interactive digital-human sales onboarding course that ramps new reps on approved stories, process, and proof, and answers their questions before the first call. Scoped to the new sales rep ramp; broader readiness belongs to sales enablement.

```bash
npx skills add personwiseai/skills --skill personwise-sales-onboarding
```

### Content Repurposing

Market variant: `en-global` (`en`, International English)

Your best webinar already answered the questions — once. Repurpose recordings, videos, and transcripts into an interactive digital-human course that keeps teaching and stays askable long after the live session. Off-the-cuff claims are stripped and dated content is labeled honestly, so the course is the best version of the talk.

```bash
npx skills add personwiseai/skills --skill personwise-content-repurposing
```

### Product Change Adoption Course

Market variant: `en-global` (`en`, International English)

A product update nobody understands becomes churn, not adoption. Turn release notes and migration docs into an interactive digital-human adoption course that explains what changed, who it affects, and exactly what to do by when. Compatibility, pricing, and migration outcomes are carried only from your approved materials — never promised.

```bash
npx skills add personwiseai/skills --skill personwise-product-change-adoption
```

### Report Briefing

Market variant: `en-global` (`en`, International English)

Reports get skimmed for one chart and misquoted forever. Turn your whitepaper or benchmark report into an interactive digital-human briefing course that teaches the findings with the method and the limits attached — and answers audience questions the PDF cannot. No causal leaps, no predictions beyond what the report states.

```bash
npx skills add personwiseai/skills --skill personwise-report-briefing
```

### Community Onboarding

Market variant: `en-global` (`en`, International English)

New members join, lurk, and leave — because nobody showed them how to belong. Turn your community guidelines and welcome materials into an interactive digital-human community onboarding course that turns new members into participating ones and stays askable after the welcome thread. Benefits, rules, and access come only from your documents.

```bash
npx skills add personwiseai/skills --skill personwise-community-onboarding
```

### Internal Change Adoption Course

Market variant: `en-global` (`en`, International English)

Employees hear the town hall and still ask — what changes for me? Turn your approved change communications into an interactive digital-human internal change adoption course that answers the questions people will not ask publicly. No speculation about jobs or futures: only what has been communicated, honestly including what is still undecided.

```bash
npx skills add personwiseai/skills --skill personwise-internal-change-adoption
```

### End-User Software Training

Market variant: `en-global` (`en`, International English)

End users learn systems from whoever sits nearby — and their mistakes become your support queue. Turn your training guides into an interactive digital-human end-user software training course that walks users through the real workflows from your documentation. Screens, permissions, and click paths come only from your guides; the course never invents UI.

```bash
npx skills add personwiseai/skills --skill personwise-end-user-software-training
```

### 客户支持教育

Market variant: `zh-cn` (`zh-CN`, Mainland China)

客户总在问同样的问题，每一次重复回答都在消耗支持时间。把帮助内容和产品知识变成一门数字人互动客户教育课程，自己回答学习者的问题——成为帮助中心、客户门户或 CSM 跟进的客户学院资产。账户特定诊断永远回到人工支持。

```bash
npx skills add personwiseai/skills --skill personwise-customer-education-zh-cn
```

### 客户 Onboarding

Market variant: `zh-cn` (`zh-CN`, Mainland China)

每个新客户都问同样的第一周问题，团队一单一单地接电话回答。把已确认的 Onboarding 材料变成一门数字人互动课程，带新客户从注册走到首次价值，沿途回答问题。只建立在已确认的范围、时间表和支持渠道之上——绝不编造承诺。

```bash
npx skills add personwiseai/skills --skill personwise-customer-onboarding-zh-cn
```

### 产品首次成功

Market variant: `zh-cn` (`zh-CN`, Mainland China)

新用户在首次成功之前就卡住，每一次卡住的设置都在消耗激活率。把设置指南和说明书变成一门数字人互动快速上手课程，带用户走到首次成功使用，沿途回答问题。高风险步骤永远指路现场有资质人员确认——课程负责引导，绝不认证。

```bash
npx skills add personwiseai/skills --skill personwise-product-first-success-zh-cn
```

### 销售与 GTM 就绪

Market variant: `zh-cn` (`zh-CN`, Mainland China)

销售会复述发布 deck 里的一切——包括没人批准过的部分。把已批准的定位和 GTM 材料变成一门数字人互动销售赋能课程，只承载已批准的主张，并按需回答销售的问题。客户名称、竞争优势和业绩结果绝不编造。

```bash
npx skills add personwiseai/skills --skill personwise-sales-enablement-training-zh-cn
```

### 员工 Onboarding

Market variant: `zh-cn` (`zh-CN`, Mainland China)

每个新员工都问同样的第一周问题，HR 一个一个回答。把员工手册和入职计划变成一门数字人互动员工 Onboarding 课程，让新员工 ramp，并按需回答问题。个案的劳动、薪酬或法律问题永远回到 HR——课程绝不即兴解读。

```bash
npx skills add personwiseai/skills --skill personwise-employee-onboarding-zh-cn
```

### SOP 与流程培训

Market variant: `zh-cn` (`zh-CN`, Mainland China)

SOP 被翻一遍就忘——直到有人跳过一个步骤。把 SOP 和制度文件变成一门数字人互动流程培训课程，严格按原文教程序，对照来源回答问题。课程永远标明所教授的 SOP 版本，绝不替代现场监督、执照或签署。

```bash
npx skills add personwiseai/skills --skill personwise-sop-process-training-zh-cn
```

### 开发者 Onboarding

Market variant: `zh-cn` (`zh-CN`, Mainland China)

开发者会放弃不能快速返回首次成功的 API。把 API 文档和 SDK 指南变成一门数字人互动开发者快速上手课程，带他们从凭据走到首次成功调用——代码严格按文档承载，绝不即兴。版本标明、保持可问，教程能回答文档回答不了的追问。

```bash
npx skills add personwiseai/skills --skill personwise-developer-quickstart-zh-cn
```

### 合作伙伴 Onboarding

Market variant: `zh-cn` (`zh-CN`, Mainland China)

伙伴会复述你材料里的话——对他们的客户，在公开场合。把已批准的伙伴项目材料变成一门数字人互动伙伴培训课程，严格按批准的版本教产品故事、成交流程和规则，并按需回答伙伴问题。佣金、区域和收益绝不做超出批准的承诺。

```bash
npx skills add personwiseai/skills --skill personwise-partner-training-zh-cn
```

### 新生 Orientation

Market variant: `zh-cn` (`zh-CN`, Mainland China)

每一届新生都问同样的问题，学生服务处答一整个学期。把学生手册和 Orientation 材料变成一门数字人互动新生 Orientation 课程，开学前就让新生准备好，之后保持可问。费用、签证、住宿和政策只来自你的文件——绝不编造。

```bash
npx skills add personwiseai/skills --skill personwise-student-orientation-zh-cn
```

### 合规培训

Market variant: `zh-cn` (`zh-CN`, Mainland China)

没人读的合规培训，会变成没人想要的事故。把制度和法规材料变成一门数字人互动合规培训课程，让员工真的能提问——义务严格按来源文件承载。课程绝不声称自己就是法律合规、认证或专业意见；权威永远在你的来源。

```bash
npx skills add personwiseai/skills --skill personwise-compliance-training-zh-cn
```

### 安全意识培训

Market variant: `zh-cn` (`zh-CN`, Mainland China)

员工就是攻击面，一份被扫一眼的制度 PDF 改变不了行为。把安全制度变成一门数字人互动安全意识培训课程，建立识别和上报条件反射——并按需回答员工问题。诚实设计：意识降低风险，绝不声称消除风险。

```bash
npx skills add personwiseai/skills --skill personwise-security-awareness-training-zh-cn
```

### 互动 Lead Magnet

Market variant: `zh-cn` (`zh-CN`, Mainland China)

大多数引流磁铁是被下载后遗忘的 PDF。做一门数字人互动引流磁铁——一门交付真实独立价值、订阅后仍能回答问题的免费小课。不要虚假稀缺，不要编造结果：把你的专业，教到足以赢得名单。

```bash
npx skills add personwiseai/skills --skill personwise-lead-magnet-zh-cn
```

### 销售入职培训

Market variant: `zh-cn` (`zh-CN`, Mainland China)

新销售遇到什么就用什么 ramp——包括没人批准过的主张。把销售手册变成一门数字人互动销售入职课程，用已批准的故事、流程和证据带新销售 ramp，在上战场前回答问题。窄守新销售 ramp；更广的就绪需求归销售赋能。

```bash
npx skills add personwiseai/skills --skill personwise-sales-onboarding-zh-cn
```

### 录制知识转互动课程

Market variant: `zh-cn` (`zh-CN`, Mainland China)

你最好的研讨会已经回答过那些问题——一次。把录像、视频和文稿再利用成一门数字人互动课程，在直播结束很久之后继续教学、保持可问。临场无据说法被剔除，旧内容诚实标注时效，课程是这场分享的最好版本。

```bash
npx skills add personwiseai/skills --skill personwise-content-repurposing-zh-cn
```

### 产品变化采用

Market variant: `zh-cn` (`zh-CN`, Mainland China)

没人理解的产品更新会变成流失，不是采用。把发布说明和迁移文档变成一门数字人互动采用课程，讲清变了什么、影响谁、什么时候之前做什么。兼容性、价格和迁移结果只按已批准材料承载——绝不承诺。

```bash
npx skills add personwiseai/skills --skill personwise-product-change-adoption-zh-cn
```

### 报告转决策简报

Market variant: `zh-cn` (`zh-CN`, Mainland China)

报告被扫一眼图、永远被错引。把白皮书或基准报告变成一门数字人互动简报课程，结论带着方法和局限一起教——并回答 PDF 回答不了的受众问题。不做因果跳跃，不做超出报告的预测。

```bash
npx skills add personwiseai/skills --skill personwise-report-briefing-zh-cn
```

### 会员与社区 Start Here

Market variant: `zh-cn` (`zh-CN`, Mainland China)

新会员加入、潜水、离开——因为没人教过他们怎么融入。把社区守则和欢迎材料变成一门数字人互动 Onboarding 课程，把新会员变成会参与的会员，欢迎帖沉了之后依然可问。权益、规则和访问只来自你的文件。

```bash
npx skills add personwiseai/skills --skill personwise-community-onboarding-zh-cn
```

### 内部变化采用

Market variant: `zh-cn` (`zh-CN`, Mainland China)

员工听完全员会，还是会问：对我意味着什么？把已批准的变革沟通材料变成一门数字人互动内部变革采用课程，回答大家不愿公开问的问题。不推测岗位或未来：只承载已沟通的内容，包括诚实说明哪些还没定论。

```bash
npx skills add personwiseai/skills --skill personwise-internal-change-adoption-zh-cn
```

### 终端用户软件培训

Market variant: `zh-cn` (`zh-CN`, Mainland China)

终端用户跟旁边同事学系统——他们的错误变成你的支持队列。把培训指南变成一门数字人互动终端用户软件培训课程，按文档里的真实流程一步步带。界面、权限和点击路径只来自你的指南；课程绝不编造界面。

```bash
npx skills add personwiseai/skills --skill personwise-end-user-software-training-zh-cn
```

Each Skill is bound to one PersonWise market and includes pinned user-local CLI bootstrap assets.
A course-creation request authorizes its requested course count and normal existing-credit use;
authentication uses browser OAuth and credentials never belong in this repository.

## Current release

- Bundle: `2.1.7`
- Tag: `v2.1.7`
- Core Skill: `personwise-create-course` `2.1.7`
- Install page: https://personwise.ai/skills/personwise-create-course
- Support: support@personwise.ai
- Privacy: https://personwise.ai/privacy
- Terms: https://personwise.ai/terms

Each Skill release has a deterministic `.skill` archive and SHA-256 checksum.
