---
name: personwise-create-course-zh-cn
description: 通过中国区 OAuth 课程创作 MCP，从主题、文本、PDF/PPTX/DOCX/Markdown/TXT 文档或参考图片创建、续做、审阅、修正和发布 PersonWise 互动数字人课程。用于分阶段课程创作、资料约束教学、大纲与讲稿审阅、幻灯片视觉核验、主讲人和版式配置，以及生成私有课程或公开访问链接。
license: MIT
---

# 创建 PersonWise 课程

把 PersonWise 中国区课程创作 MCP 当作一套可续做、可审阅的课程生产系统。每次创建只产生一门
普通的持久化课程，并在稳定检查点完成内容和视觉核验，最后交付用户授权的结果。

本 Skill 只是可选的质量工作流。MCP 本身提供完整基础能力；无论 Skill 是否安装、版本是否相同，
都不得据此允许或拒绝任何 MCP 操作。

第一次使用时，由 Agent 通过当前 Host 原生支持的 MCP 安装或添加机制安装缺失的 PersonWise MCP。
这是课程任务的正常组成部分，不是交给用户的人工前置条件。Host 能读取 `agents/openai.yaml` 时优先使用
其中的依赖元数据，否则调用 Agent 可用的 Host 官方机制。存在原生机制时，不要手工改写或猜测 Host
底层配置。安装后立即启动 OAuth；用户只参与浏览器授权同意，Agent 随后继续原任务。

## 按需读取参考资料

开始任何会改变课程的任务前，完整读取：

1. [references/course-design.md](references/course-design.md)
2. [references/course-archetypes.md](references/course-archetypes.md)
3. [references/workflow.md](references/workflow.md)
4. 涉及图片，或当前 Agent 能读取 MCP 图片/资源时，再读
   [references/visual-quality.md](references/visual-quality.md)

当 MCP 缺失、OAuth 未完成、能力未确认或授权失败时，完整读取
[references/connection-and-auth.md](references/connection-and-auth.md)。只查询课程时，读取连接参考和
`workflow.md` 的查询部分即可。

## 先确认中国区 MCP 能力

在消耗课程创作额度前，读取 `personwise://course-agent/capabilities` 或调用
`get_course_agent_capabilities`，确认：

- resource 为 `https://mcp.personwise.cn/mcp`；
- 合同主版本与本工作流兼容，当前中国区合同从 `1.0.0` 起；
- `supported_tools` 正好提供中国区所需的 26 个公开工具，并包含本次任务要用的工具；
- 需要上传或视觉审阅时，相应能力确实可用；
- `supports_orchestrated_creation=true` 时优先使用编排式创作。

只有合同主版本不兼容或必需工具缺失时，才在创建前停止。不要比较或要求 Skill 版本。MCP 缺失时
使用连接参考，不要让用户安装另一个产品或粘贴任何凭证。

## 默认完成用户授权的端到端结果

用户明确要求“创建课程”时，已授权在当前 OAuth 连接范围内完成这门课程的普通生产步骤。除非用户
指定人工检查点或更窄结果，否则自主完成：

- 课程蓝图和事实边界；
- 一次持久化创建与资料处理；
- 大纲、页面文字和讲稿审阅及客观修正；
- 用户提供的参考图或固定图附件；
- 图片生成与能力匹配的视觉核验；
- 主讲人、声音和版式配置；
- 首次发布及用户要求的最终访问范围；
- 完成状态验证。

不要为内部检查点反复征求用户同意。OAuth 允许普通课程创作流程，但不会扩大用户请求：用户要草稿
就保留草稿，要私有就保持私有。未指定最终结果时，默认完成可公开访问的课程链接。

只有确实存在以下阻塞时才停下来：OAuth 必须由用户完成、课程额度不足、必需资料无法恢复、多个
方案会实质改变结果、用户明确保留检查点，或需要公开工具面以外的不可逆操作。

## 选择工作路径

- **主题或直接文本**：使用 `knowledge_source_mode=open`，把稳定约束写进 `topic`，仅在确有长文本时
  使用 `content`。
- **严格资料课程**：使用 `materials_only`，声明准确的保留文档数，上传全部文档，并等待规范处理完成。
- **资料辅助课程**：使用 `open` 加文档，让资料锚定事实，同时允许模型知识补充。
- **续做或修复**：先读取现有 run 和课程，只按最新 `allowed_actions` 继续。
- **精修**：读取新鲜 authoring snapshot，在未发布阶段只修改已有 slide 的 `title`、`key_points`、
  `page_text` 或 `script`，不改变页数和顺序。
- **查询**：先用 `list_courses` 做有界搜索，只在必要且已授权时读取单课或 authoring snapshot。

多门课程必须一门一个持久化 run。完整课程权限不会把一次创建变成无限批处理，也不会绕过额度、并发
或速率限制。

## 驱动编排式生产

### 1. 建立课程蓝图

记录一份不含秘密的蓝图：学习者、学习结果、课程类型、教学结构、语言、事实权威、合理页数、逐页
教学弧线、视觉系统、图表任务、讲述风格、排除项、主讲人与声音要求，以及最终目标 `draft`、
`private` 或 `link`。按 `course-design.md` 判断，不要把所有主题硬塞进同一模板。

### 2. 只启动一个持久化 run

当能力支持编排时，使用 `start_course_creation` 和稳定、无秘密的幂等键。按当前 Agent 的真实能力显式
填写 `visual_review_capability=multimodal|none`，不得夸大视觉能力。服务器负责耗时的大纲、讲稿、图片、
配置、发布和链接阶段；工具快速返回后，最早按 `poll_after_seconds` 再调用 `get_run`。

服务器在 `outline_ready` 和 `script_ready` 暂停给 Agent 审阅；这不是强制人工确认。检查并做必要修正，
再用最新 revision 调用一次 `advance_run`。多模态 Agent 还会在 `image_ready` 审阅；无视觉能力的 Agent
继续结构化流程，并如实记录视觉审阅未执行及原因。

只有连接合同不提供编排式创建时才使用 `create_course` 兼容路径。任何两次变更调用之间都要先重新
读取状态；一次变更返回的新 revision 不能替代下一次变更前要求的新鲜读取。

文档和图片使用 `request_upload_ticket` 与 `get_upload_status`。远程服务不能读取本机路径。Host 能传字节
时使用机器交接，否则让用户在返回的 PersonWise 浏览器页面选择文件。不得在消息或记录中暴露一次性
上传凭证。

### 3. 审阅大纲与讲稿

在 `outline_ready` 检查每页标题和关键点是否只有一个清晰教学任务，整体是否递进、覆盖完整、事实有据
且不重复。只做客观必要的 `update_slides` 修正，然后重新获取完整 snapshot 和 revision。

大纲确认后，服务器持久化生成页面文字与讲稿。到 `script_ready` 时逐页对齐检查：

```text
title + key_points -> 本页教什么
page_text          -> 屏幕上简洁呈现什么
script             -> 主讲人如何解释和过渡
```

修正无依据事实、资料漂移、矛盾、教学失败和明确违反蓝图的内容。不要只因个人措辞偏好重写连贯结果。
用户提供的参考图或固定图只在该检查点允许的窗口上传；响应不明确时先核对状态，不要再开一张票。

### 4. 生成并审阅视觉

使用最新 revision 继续，按返回节奏轮询，直到每页图片达到规范完成状态。

- 当前 Agent 确实能理解 MCP 图片内容时，使用 `get_slide_review_sheet`，每批最多六页；仅对需要细查的
  页面调用 `get_slide_preview`。按 `visual-quality.md` 检查全部页面。先修内容，再用新鲜 revision 和
  明确的逐页指令调用 `regenerate_slide_images` 修复完整失败子集，并复查变更页。
- 当前 Agent 不能理解图片时，不得编造观察或假装完成视觉审阅。依靠结构化完成状态继续，并如实记录
  未执行视觉审阅；这本身不是发布阻塞。

只有人或真正具备视觉能力的 Agent 审阅过素材后，才能把它作为“已审阅替换图”使用。

### 5. 配置并完成

编排路径会选择正常兼容的主讲人与声音并完成配置。只有用户提出具体形象、声音或版式要求时，才在
检查点使用 `list_presenters`、`get_presenter_preview`、`select_presenter`、
`get_course_configuration` 或 `update_course_configuration`。选择后重新读取并验证持久化结果。

最终检查点通过后，服务器按已存目标完成后续动作：

- `draft`：保持未发布；
- `private`：首次发布并保持私有；
- `link`：首次发布，开启公开访问链接，并验证课程可播放。

不得直接操作平台管理、购买额度、删除或转移课程、重新发布已有版本，或通过相邻服务绕过公开工具面。

## 精确恢复，不猜状态

- 每个新逻辑操作使用一个幂等键；只有同一请求响应不明确时才用同键重放同一 payload。
- 每次变更前读取新鲜 run/snapshot/configuration，并使用当前 `expected_revision`。
- revision 冲突时重新读取并合并真实变化。
- 遵守 `Retry-After`，不要紧轮询或并行敲击同一 run。
- 只有最新失败 run 允许 `retry` 时才调用 `retry_run`。
- `cancel_run` 是协作式取消；`cancel_requested` 不是终态。
- 不得绕开 MCP 工具直接修改 run、资料、图片、项目或发布状态。

## 返回完成证据

返回不含秘密的记录，包括：课程蓝图、知识模式、页数、请求与实际目标、run/project ID、幂等键、资料
文件名/校验和/规范状态、大纲与讲稿审阅、revision 历史、逐页图片完成状态、视觉审阅状态、修正与重生
页码、主讲人/声音/配置、最终 run/checkpoint/发布/访问范围/可播放状态。只有 `playable=true` 时才返回
公开课程地址。

不要把已分配 shell 当作已创建项目，不要把图片排队当作图片完成，不要把发布请求当作发布成功，也
不要把一个 slug 当作可播放课程。
