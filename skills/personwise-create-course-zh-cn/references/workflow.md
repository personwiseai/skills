# 远程 MCP 工作流与恢复

## 保持一份持久、无秘密的操作记录

记录：课程蓝图和知识模式、请求/实际目标、每个逻辑操作的幂等键、run/project ID、资料文件名/校验和/
状态、checkpoint/status/allowed_actions、每次变更使用的 authoring revision、内容与视觉审阅结果、
主讲人/声音/配置，以及发布、访问范围和可播放证据。

不得记录 OAuth token、cookie、授权码、一次性上传值、浏览器 action fragment、用户未要求保留的资料
正文或私有图片资源授权。

每个键只代表一个精确操作和 payload，例如：

```text
water-cycle-20260801-create
water-cycle-20260801-outline-edit-01
water-cycle-20260801-outline-approve
water-cycle-20260801-script-edit-01
water-cycle-20260801-images-approve
```

## 每次变更前读取能力和状态

首次消耗额度前调用 `get_course_agent_capabilities`。已有 run 在每次变更前调用 `get_run`，只信任最新的
`status`、`checkpoint`、`allowed_actions`、`authoring_revision`、安全错误、资料/子任务状态和最终链接。
终态不得继续变更。

任何两次变更调用之间都要重新读取要求的状态。一次变更结果中带有 revision，也不能替代下一次变更前
的新鲜读取。

## 启动主题或文本课程

能力支持时，调用一次 `start_course_creation`，传入：

- 稳定 `idempotency_key`；
- `course-design.md` 的蓝图字段；
- `knowledge_source_mode=open`；
- 没有文档时 `declared_sources=0`；
- 当前 Agent 真实的 `visual_review_capability`；
- 用户明确要求更窄结果时才显式设置 `distribution_target`。

省略目标时采用普通私有结果；只有用户明确要求公开链接时才创建公开访问链接。立即保存 run ID，严格按 `poll_after_seconds` 轮询。

## 启动资料课程并上传

支持 PDF、PPTX、DOCX、Markdown 和 TXT；每个文件遵守服务器返回的大小与数量限制。

严格资料路径：

1. 选定保留文件，设置 `materials_only` 和准确 `declared_sources`。
2. 调用 `start_course_creation`；资料准备前服务器可延迟项目/额度物化。
3. 对每个文件计算精确字节数与 `sha256:<64 位小写十六进制>`。
4. 调用 `request_upload_ticket`，用途为 `document_source`，并传 run ID、basename、MIME、大小和校验和。
5. Host 能安全传字节时，把精确文件流式发送到 `upload_endpoint` 并使用专用上传 header；否则让用户在
   返回的 PersonWise `action_url` 选择文件。
6. 不显示、不记录上传凭证；只用非秘密 ticket ID 轮询 `get_upload_status`。
7. 状态为 `consumed` 后读取 run，确认 source ID、校验和和规范处理状态。
8. 所有保留资料 ready 后等待服务器自动继续，不要为了“激活”而擅自 advance。

响应丢失时先核对 ticket、run 和目标附件，不要盲目重复上传。资料处理失败且最新 action 允许时，
使用 `retry_source`；不需要的资料只在项目创建前且允许时用 `detach_source`。严格模式不能通过切换知识
模式绕过失败资料。

## 审阅 `outline_ready`

按服务器建议轮询到 `review_required / outline_ready`。调用 `get_authoring_snapshot`，逐页检查稳定 ID、
位置、标题和关键点。

需要客观修正时，用项目 ID、最新 `expected_revision`、新幂等键和按 slide ID 标识的一组原子 patch 调用
`update_slides`。只改已有 `title`、`key_points`、`page_text`、`script`，不增删或重排页面。每次成功后
重新读取完整 snapshot。

## 审阅 `script_ready`

再次读取 run，用最新 revision 调用一次 `advance_run` 确认大纲。服务器生成页面文字与讲稿，按返回
节奏轮询到 `script_ready`。

读取新 snapshot，检查每页 title/key_points/page_text/script 对齐。概念修正涉及多个字段时一次一起改，
每次变更后重新读取。

参考图或固定图只能在 `script_ready` 且 action 允许时上传：

- `slide_reference`：主题、色彩、构图或视觉语法参考；
- `slide_pin`：用户要求保留原图主体；
- 带 run/project/slide、精确 MIME/大小/校验和、事实 caption 和必要 placement 指令。

能力不支持固定图时停下来让用户选择，不得静默降级成参考图。

## 生成和核验图片

图片生成前读取 run 和 snapshot，确认 `script_ready` 和最新 revision，再调用一次 `advance_run`。遵守
`Retry-After` 或 `retry_after_seconds`，不要根据旧状态重复 continue。

到 `image_ready` 时读取 snapshot，要求每页规范生成状态完成。视觉 Agent 使用
`get_slide_review_sheet` 和必要的 `get_slide_preview`，按 `visual-quality.md` 核验。内容错误先修内容，
再读取新状态，用 `regenerate_slide_images` 一次修复完整失败子集并复查。

若未发布 run 已离开图片审阅点但仍允许修正，先读取当前 revision，再按最新 action 使用
`reopen_image_review`。不得直接改数据库或强制 checkpoint。

真正审阅过的替换图使用 `reviewed_slide_replacement` ticket，且要带当前 revision 和精确文件元数据。
上传后核对 ticket 和已选版本；有视觉能力时再次审阅。

## 主讲人与配置

`list_presenters` 使用具体课程语言和有界分页，只读取必要候选。必须确认 profile 完整、目标语言声音
映射 `is_ready=true`，并保存精确 backend/voice ID。

有视觉能力时对认真候选调用 `get_presenter_preview`；无视觉能力时不作外观判断。用
`select_presenter` 选择一个 avatar 或显式默认值，随后重新读取 run/snapshot，再读
`get_course_configuration` 核对持久化结果。

只有用户要求版式变更时调用 `update_course_configuration`。使用最新 configuration revision，每次至少
包含一个真实变化，成功后再读取确认。

## 完成发布和访问范围

最终动作前读取 run、snapshot 和 configuration，确认资料/内容/安全问题已解决、每页图片完成、
主讲人与声音兼容、配置持久化、目标在公开工作流内，且最新 action 允许继续或首次发布。

最后一个 Agent 检查点通过后，让编排服务器完成配置、合规、CDN、首次发布和访问范围，并在每个变更前
复查实时 OAuth grant。显式 `first_publish` 和 `set_course_visibility` 只用于新鲜状态允许的修复，不要和
编排收尾竞争。

目标行为：

- `draft`：生成和配置完成，保持未发布；
- `private`：首次发布，保持私有；
- `link`：首次发布，开启公开访问链接并验证可播放。

发布或访问范围变化后，再次调用 `get_run` 和 `get_course`。只有 `playable=true` 才报告公开课程 URL；
slug 本身不是可播放证据。

## 兼容路径

只有 capability 不提供 `start_course_creation` 时，才使用 `create_course` 并以
`stop_after=outline_ready` 开始，再执行有界 `advance_run` 流程。兼容路径每次也必须先读新状态，不能
因为更慢而批量串联变更。

## 查询课程

先用 `list_courses` 搜索有界 metadata，可按标题、描述、公开 slug、状态、访问范围、语言、知识模式、
run/checkpoint、时间窗口和 origin 过滤，并使用 opaque cursor。跟随 cursor 时保留原过滤、排序和方向；
不要发明 offset 或精确总数。

默认只查当前连接创建的课程；需要时可请求当前用户自有或全部可见 metadata。授权边界外课程仍只读
metadata。单课细节用 `get_course`，只有授权可编辑课程才用 `get_authoring_snapshot`。

## 安全恢复表

| 信号 | 动作 |
|---|---|
| 响应丢失或超时 | 读取新状态；只有状态未证明完成时，才用同键重放完全相同 payload。 |
| revision 冲突 | 读取新 snapshot/config，合并真实变化；payload 改变时使用新键。 |
| 401 | 让 Host 刷新一次；失败则重新 OAuth，再读状态。 |
| 403 | 视为连接失效、撤销或合同缺陷；不要请求增量权限或秘密。 |
| 额度不足 | 报告团队额度阻塞，不自动购买。 |
| 资料未就绪 | 轮询；只按最新 action 重试或移除。 |
| 429 | 遵守 `Retry-After`，降低并发。 |
| 可重试依赖失败 | 确认恢复后，只在 action 含 `retry` 时调用 `retry_run`。 |
| 首次发布冲突 | 停止；公开工作流不能重发已有版本。 |
| 目标语言声音未就绪 | 换一个兼容组合或报告阻塞。 |

用户要求停止或继续已不再授权时才用 `cancel_run`，并轮询到真实终态。

## 完成证据与 Skill 归因

完成报告包含课程身份、受众、语言、蓝图、知识模式、页数、run/project ID、最终 status/checkpoint、资料
状态、revision 与客观修正、逐页图片状态、视觉审阅状态、重生/替换页码、主讲人/声音/配置、发布结果、
访问范围、`playable`、可用的公开 URL 和剩余阻塞。

若 Host 支持可选归因，可发送不含用户内容和凭证的：

```json
{
  "skill_invocation": {
    "skill_id": "personwise-create-course-zh-cn",
    "skill_version": "1.1.0",
    "scenario_id": "CORE-001"
  }
}
```

归因只是可选遥测，绝不能阻止创建。不得从旧状态宣称完成。
