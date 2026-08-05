# PersonWise CLI 工作流与恢复

## 维护一份不含秘密的记录

记录课程 brief、目标、账户 alias、逻辑幂等身份、run/project ID、来源文件名/校验和/状态、
检查点/允许动作、revision、审阅发现、图片状态、主讲人/声音/配置，以及最终访问/可播放状态。
不得记录令牌、Cookie、凭据引用、上传授权、签名 URL、私密文件原文或诊断秘密。

## 只用结构化命令

自动化使用全局 `--json`，登录后每个业务命令加 `--account <alias>`。解析 JSON envelope 和
稳定错误/退出类别，不抓取人类文本。把课程内容写入有界 JSON 文件，通过 `--input` 传入。

## 创建主题/文本课程

创建对象包含蓝图字段、`knowledge_source_mode=open`、精确 `desired_slide_count`、真实视觉能力、
显式 `distribution_target`（用户未要求更宽访问时写 `private`；省略该字段会按 OAuth 授权的发布
上限解析，可能落成 `link`）。能力支持时可加入以下准确归因；它只是可选遥测，绝不阻塞创建：

```json
{
  "skill_invocation": {
    "skill_id": "personwise-create-course-zh-cn",
    "skill_version": "2.1.1"
  }
}
```

```text
personwise --account <alias> course create --input <create.json> --json
```

立即保存 `run_id`；响应只表示持久工作已分配，不代表完成。

## 创建文档依据课程

严格资料先设置 `materials_only` 和精确保留来源数。上述显式 `distribution_target` 规则适用于
每个创建对象。对每个用户批准的 PDF、PPTX、DOCX、
Markdown 或 TXT（最大 50 MiB）：

```text
personwise --account <alias> source add --run-id <run-id> --path <精确路径> --json
personwise --account <alias> source status --run-id <run-id> --json
```

CLI 校验非 symlink 普通文件、计算校验和、初始化一次传输、隔离 bearer token、对账不确定结果并
确认规范状态。上一传输未对账前不得再上传；来源失败时不得擅自把 `materials_only` 放宽。

上传后，只要有来源处于 `pending` 或 `processing`，就不要调用 `run advance`。run 会保持在
`awaiting_sources`，直到所有已声明来源都规范地 `ready`；在这段时间里 `run advance` 是
200 无操作（仅返回当前 run 状态，不 claim 也不改动 run），`allowed_actions` 也还不包含
`continue`。继续有界地 `run wait` 和 `source status`；服务端编排（orchestrated）的 run
会在来源完成后自动继续。guided run 则在重新读取确认所有来源都 `ready` 后再调用
`run advance`。

`source status` 会同时返回上传票据生命周期（`ticket_status`：`consumed` 仅表示上传已被接收
并开始处理，不代表完成）与规范来源 `status`（`pending`、`processing`、`ready` 或 `failed`），
以及 `phase`、`processed_pages`/`total_pages` 和失败时的安全 `error`；只有 `status: ready`
才允许推进。

若来源处理失败，先重新读取 `run get` 的最新 `allowed_actions`。允许 `retry_source` 时执行一次：

```text
personwise --account <alias> source retry --run-id <run-id> --source-id <source-id> --json
```

然后继续有界 `run wait`/`source status`；若同一错误再次出现，停止并报告结构化错误。当失败来源
必须替换（例如 `page_quota_exceeded` 且需要换更小的文件）时，先 detach：

```text
personwise --account <alias> source detach --run-id <run-id> --source-id <source-id> --json
```

再用 `source add` 上传替换文件。不得为绕开失败来源另建 run，也不得放宽 `materials_only`。

## 等待并审阅检查点

```text
personwise --account <alias> run wait --run-id <run-id> --timeout-seconds 1800 --json
personwise --account <alias> run get --run-id <run-id> --json
personwise --account <alias> course snapshot --project-id <project-id> --json
```

`run wait` 在终态（`succeeded`、`failed`、`cancelled`）和审阅检查点（`paused`）都会返回：
`paused` 的 run 在 Agent 审校并推进前无法继续，等待到此立即结束。它也在
`POLL_TIMEOUT`/`WAIT_CANCELLED` 时返回。旧版 CLI 不会在 `paused` 返回，此时
`POLL_TIMEOUT` 就是检查点信号：读取 fresh `run get` 状态后审校或恢复等待。

大纲阶段检查每页稳定 ID、标题和要点。需要客观修正时，把原子 patch 写入 JSON：

```text
personwise --account <alias> course update --project-id <project-id> \
  --input <patch.json> --expected-revision <revision> --json
```

重新读取完整快照，只有允许时才 `run advance --run-id <run-id> --json`。讲稿阶段同样联合检查
标题、要点、页内文字与讲稿。不得增加/删除/重排页面，也不得连续盲写。`run advance`、
`run retry`、`run cancel` 默认按 run 派生确定性幂等键；优先使用默认值，只有为一个逻辑
写操作指定稳定身份时才传 `--idempotency-key`，且只在载荷完全相同时复用。

## 参考图片和视觉审阅

仅在允许窗口，对用户批准的有界 PNG/JPEG/WebP 使用 revision 绑定的
`image attach-reference --project-id ... --slide ... --path ...`。下一图片写操作前重新读取快照。

视觉 Agent 每批最多六页运行：

```text
personwise --account <alias> image review-sheet --project-id <project-id> \
  --slides 0,1,2 --dest <新路径.jpg> --json
```

按 `visual-quality.md` 检查所有页面。先改内容，再把逐页重生成指令写入 JSON，用最新 revision
运行 `image regenerate`，等待持久状态并复检。无视觉能力时记录 `not_performed`，不编造发现。

## 可选主讲人与配置

仅针对具体选角要求使用 `presenter list`、`presenter preview` 和 revision 绑定的
`presenter select`。结构化兼容与声音就绪决定选择；预览支持选角观察，不支持身份推断。
用户要求且能力支持的版式/配置修改通过 revision 绑定的 `course configure --input`，随后读新
快照验证。

## 完成与访问

只有用户意图、能力和最新状态允许时才使用：

```text
personwise --account <alias> course publish --project-id <project-id> --json
personwise --account <alias> course set-access --project-id <project-id> --mode private|link --json
```

中国区包不调用或承诺国际 Topics。终态后读取 `course get` 与 `course snapshot`，只有状态证明
链接访问和可播放时才报告公开链接。

失败的 run 会通过 `run get` 返回安全 `error`；发布被阻塞时 `course publish` 返回
`requirements` 清单；`topic submit`/`topic status` 返回 `submission`（含 message/review
note）；按返回原样报告。

## 查询

使用 `course list --limit <1-100> --json` 并保留 opaque cursor。单条记录使用 `course get`，
只有确需授权详情时才用 `course snapshot`；不得虚构 offset 或 total。

## 安全恢复

| 信号 | 动作 |
|---|---|
| 响应丢失/超时 | 读新状态；只有状态未证明完成时才对相同载荷复用同一逻辑写操作。 |
| revision 冲突 | 获取新快照、合并真实变化、使用新的精确 revision。 |
| `CONFLICT`（`read_current_state`） | 运行 `run get` 检查最新 `status`/`allowed_actions`，用 `source status --run-id` 核对来源状态，再按新状态行动。仍允许 `continue` 时可有界重试一次（等待 `poll_after_seconds` 后执行一次 `run advance`）；同一冲突间隔重试两三次仍重复时，停止并报告精确阻塞状态。不得另建课程或 run 绕过。 |
| 来源在 `awaiting_sources` 仍为 `pending`/`processing` | `run advance` 以 200 无操作返回当前 run 状态，`allowed_actions` 在所有已声明来源 `ready` 前不含 `continue` | 继续有界地 `run wait` 与 `source status`；服务端编排的 run 会在来源完成后自动继续。这是正常处理而非死锁；不要停止、取消或另建 run。 |
| `run wait` 中断 | 远端 run 继续；用同一账户和 run ID 恢复。 |
| 失败 run 允许 `retry` | 用稳定逻辑身份执行一次 `run retry`，再等待/读取。 |
| 失败 run 不允许 `retry` | 如实报告安全状态，不绕过服务端直接改。 |
| 来源失败且允许 `retry_source` | 执行一次 `source retry --run-id <id> --source-id <id>`，再继续有界 `run wait`/`source status`；同一错误再次出现时停止并报告结构化错误。 |
| 失败来源必须替换（例如 `page_quota_exceeded`） | 先执行 `source detach --run-id <id> --source-id <id>`，再用 `source add` 上传替换文件；不得另建第二个 run。 |
| 来源传输不确定 | 使用 `source status`，不得盲目重传。 |
| 授权撤销/401 | 重新授权并固定匹配账户，写操作前再读状态。 |
| 额度不足 | 停止并报告，不购买、不另建 run。 |
| 429/临时依赖失败 | 遵守结构化重试时间并降低并发。 |
| 用户要求取消 | 使用 `run cancel` 并轮询到终态；取消是协作式的。 |

## 完成证据

报告精确 run/project ID、终态、来源、revision、客观修改、逐页图片就绪、视觉审阅状态、主讲人/
声音/配置、发布/访问/可播放状态。不得把较早检查点说成最终状态。
