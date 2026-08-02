# 通过 PersonWise MCP 制作中文产品介绍

## 保存不含秘密的 run ledger

记录五页蓝图、claim ledger、run/project ID、不含秘密的幂等键、来源文件名与 checksum、处理状态、
当前 checkpoint、allowed actions、revision、审阅发现、配置和最终 URL。

不得保存 OAuth token、cookie、上传授权值、browser-action fragment 或私有 resource grant。

## 创建一个持久 run

使用稳定的创建幂等键和以下默认值：

```text
desired_slide_count = 5
stop_after = outline_ready
distribution_target = link，除非用户要求草稿或私有
```

严格文档依据时使用 `materials_only` 和准确的 `declared_sources`。已核实的文本 brief 使用
`open`，并在 `topic` 写入事实边界，在 `content` 写入有限 brief。

当 `supports_skill_invocation_attribution=true` 时附带：

```json
{
  "skill_invocation": {
    "skill_id": "personwise-interactive-product-explainer-zh-cn",
    "skill_version": "1.1.0"
  }
}
```

旧 contract 或 Host 无法确认安装版本时省略。不得为了归因延迟或阻止课程创建。保存返回的 run ID，
随后立即调用 `get_run`。

## 上传严格来源

对每份保留文档：

1. 计算准确字节数和 `sha256:<64 lowercase hex>`。
2. 使用 `purpose=document_source` 请求上传 ticket。
3. Host 能传输时只上传一次完全相同的字节；否则返回 PersonWise browser action 让用户选择文件。
4. 不在消息或 ledger 中保留上传授权。
5. 轮询 `get_upload_status` 到终态。
6. 调用 `get_run`，核对权威来源 checksum 和处理状态。

任一来源仍在 pending、processing、failed 或 missing 时，不推进严格模式 run。

## 审阅大纲与讲解词

每次只调用最新 `allowed_action`。一次 `advance_run` 只推进一个有界阶段。

在 `paused / outline_ready`：

1. 调用 `get_authoring_snapshot`。
2. 确认恰好五页，并覆盖五个既定说明任务。
3. 用 claim ledger 检查每个标题和 key points。
4. 使用最新 `expected_revision` 做最小原子 `update_slides` patch。
5. 再次获取完整 snapshot。

每次 mutation 后调用 `get_run`。如果 run 仍处于 `waiting / outline_ready` 且允许
`continue`，使用新幂等键再推进一次；不要只轮询不变的 waiting 状态。

在 `paused / script_ready`：

1. 获取最新 authoring snapshot。
2. 逐句核对 `title`、`key_points`、`page_text` 和 `script`。
3. 删除虚构的具体信息；只有来源支持时才降低表述强度。
4. 确保讲解词自然衔接，不照读页面文字。
5. 做一次带 revision 的有限修订，再重新读取 snapshot。

不得通过 slide edit 增删或调换页面。

## 添加真实图片

只有 `paused / script_ready` 且允许 `upload_reference` 时可以上传。真实截图或产品图使用
`slide_pin`；允许新视觉借鉴主题、配色或构图时使用 `slide_reference`。caption 只能描述可信事实。
ticket 结果不明确时先对账，不得立即申请新的 ticket。

## 生成并审阅图片

生成前重新读取 `get_run` 和 `get_authoring_snapshot`，使用当前 revision 与新幂等键启动图片。
有界轮询，直到五页权威图片状态全部 complete 且 run 达到 `image_ready`。

Host 能读取 MCP 图片内容或受保护资源 fallback 时：

1. 获取五页 `get_slide_preview`。
2. 检查事实暗示、文字可读性、构图、风格连续性和禁止虚构 UI 的边界。
3. 内容问题先修内容，再修视觉。
4. 使用新 revision 和具体逐页要求，一次性重新生成完整的不合格子集。
5. 复查全部变化页面。

不能读取图片时记录 `visual_review=not_performed`，但不得虚构视觉观察。

## 配置、发布与访问

有界分页调用 `list_presenters`，选择与目标语言兼容的 Voice。具备视觉能力时检查
`get_presenter_preview`；否则不评价外观。选择一组兼容的数字人和 Voice 后，重新读取 run、
snapshot 和 configuration。只有用户明确要求时才改变布局。

调用一次 `first_publish`。修改访问范围前重新读取状态。默认网站成果使用按链接公开的访问方式；
调用 `set_course_visibility` 时使用技术值 `unlisted`，但不要把它作为与 private/public 并列的
三选一文案暴露给用户。

只有最终状态报告 `playable=true` 时才返回公开和嵌入 URL。本 Skill 不申请 Topics 收录、不购买
额度、不删除或转移课程，也不管理组织。

## 安全恢复

- 只有同一 payload 的响应不明确时才重放原幂等键。
- 每个新的逻辑操作使用新幂等键。
- revision 冲突时获取新 snapshot，并以实际差异重新合并。
- 遵守 `Retry-After`，不得并行轰击同一 run。
- 只有最新状态允许时才调用 `retry_run`。
- OAuth、额度耗尽、缺少权威来源、必要能力不支持或用户明确保留决定时停止。
