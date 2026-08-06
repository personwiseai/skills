# 连接并授权 PersonWise CLI

## 使用本 Skill 绑定的可执行文件

本包固定使用中国区 PersonWise 服务和一个固定版本的 `personwise` CLI，不存在备用端点、
issuer、resource、下载源、凭据路径或跨市场回退。

运行 `personwise version --json`，要求软件版本不低于 1.1.6、CLI 合同为 1.0。缺失或过旧时：

```text
Linux/macOS: assets/bootstrap.sh --approve-install
Windows:     assets/bootstrap.ps1 --approve-install
```

宿主可按自身政策要求安装许可；Skill 不另加 PersonWise 二次批准，也不在正常路径讲哈希、
原生签名、系统信誉、描述符、合同或凭据存储。不得使用 sudo、修改 PATH/执行策略、启动服务、
覆盖已有目标、跟随 `latest` 或改用其他下载源。

不要把 `doctor` 当作前置条件。只有结构化错误建议 `run_doctor` 时才运行；默认只读，除非用户
明确要求写诊断包。

## 更新纪律 —— 保持 CLI 与本 Skill 为最新版本

这是常设纪律，不是可选的维护动作：技能与 CLI 是一个受治理的整体，任何业务命令之前都必须
保持二者对齐。PersonWise 会把最低版本随当前发布同步抬升，因此过旧的 CLI 或技能通常不是
“略旧”，而是不可用。

首个业务命令前，先运行一次以下新鲜度检查：

```text
personwise update check --service personwise.cn --json
```

除 `up_to_date` 以外的状态都按“停止直到更新完成”处理；`no_active_release` 表示该市场尚未
发布任何版本，此时继续并依赖服务端响应。每个成功的 CLI 响应还可能携带顶层 `updates` 块，
按以下确定规则处理：

- 若 `updates.cli.status` 或 `updates.skill.status` 为 `update_available` 或 `below_minimum`：
  向用户说明一次哪个组件过旧（installed 与 latest），并原样引用其中的 `action` 命令。任务
  必须等该更新安装完成才能继续。询问是否现在更新；获得同意后，原样执行该命令（命令本身已带
  所需的 `--approve-upgrade` 参数）。用户拒绝时停止任务，不得用过旧组件运行业务命令，本会话
  内不再询问，除非用户改变决定。
- 若命令以 `CLI_VERSION_BELOW_MINIMUM` 或 `SKILL_VERSION_BELOW_MINIMUM` 失败：必须先完成更新
  才能继续。说明原因，请求批准，原样执行打印的更新命令，然后重试失败的步骤一次。
- 两者都过旧时，先升级 CLI，再升级技能。

当打印的 `action` 刷新本已安装 Skill 时，把 `<skill-directory>` 替换为本 Skill 的安装目录
（即本 Skill 的 SKILL.md 所在目录）。不得为了检查新版本而运行 `doctor` 或通用能力前置清单；
上面的 `update check` 就是新鲜度检查。每个组件每会话最多询问一次；不得用其他命令、参数、
来源或下载路径替换打印的 `action`。若 CLI 对 `personwise update` 报 `Unknown command`，说明
当前 CLI 旧于本 Skill 的更新工具：改用本 Skill 自带的固定引导脚本升级 CLI（Linux/macOS 为
`assets/bootstrap.sh --approve-upgrade`，Windows 为 `assets/bootstrap.ps1 --approve-upgrade`；
没有可识别安装时用 `--approve-install`），然后重试失败的步骤一次。仅重新安装 Skill 不会升级
CLI。若已安装 CLI 旧于引导脚本锁定的版本时服务返回 `SERVICE_RESPONSE_MISMATCH`，应先用固定
引导脚本升级 CLI 并重试一次；只有当前锁定版本的 CLI 仍然不匹配时才报告
`stop_and_verify_service`。

## 通过浏览器授权

先运行 `personwise auth status --json`；需要登录时：

```text
personwise auth begin --service personwise.cn --json
personwise auth wait --flow-id <flow-id> --timeout-seconds 1800 --json
```

及时展示 PersonWise 地址和用户码。用户在浏览器登录、选择组织并授权；Agent 不索要或接收
密码、验证码、令牌、授权码、回调地址、Cookie 或凭据内容。

CLI 在所有受支持操作系统上自行管理用户本地私有凭据；Skill 和 Agent 不检查或实现凭据存储。
1.1.0 不迁移旧登录；没有 1.1.0 本地状态时重新浏览器登录一次。

## 固定账户，只检查相关就绪状态

每个业务命令都使用全局 `--account <alias>`，并保持中国区服务绑定。正常查询、微调、续跑、
修复、发布和访问操作不运行全局 `capabilities` 清单，直接调用相关命令。

只有每次新建课程前运行：

```text
personwise --account <alias> course readiness --json
```

根据 `can_create`、`max_slides_per_course` 和 `authorization_courses_remaining` 决定能否新建和
页数；读取前不得猜测页数或额度。

## 授权边界

用户明确要求创建课程，已经授权准确数量的创建和正常现有额度消耗，也已授权使用其点名、
附加或选择的文件/图片；不得在 `course create` 前再次询问。

只有新增课程、付款/购买额度、扩大可见范围、删除、转移所有权、组织管理，或上传 Agent
自己发现的本地文件时，才需要新授权。用户未点名可见范围时，显式设置 `distribution_target` 为
`private`；省略该字段会按 OAuth 授权的发布上限解析，可能落成 `link`。明确链接或发布属于原
请求。

## 一次处理失败

| 结构化信号 | 动作 |
|---|---|
| CLI 缺失/过旧 | 使用固定 bootstrap，由宿主执行自己的安装政策。 |
| `AUTHENTICATION_REQUIRED` | 发起一次浏览器 OAuth 并保持等待。 |
| `LOCAL_CREDENTIALS_UNAVAILABLE` | 报告 `repair_local_credentials`；不要检查外部凭据系统或索要系统密码。 |
| `CREDIT_INSUFFICIENT` | 创建前停止并给出返回的额度/购买动作；不得自动购买。 |
| `AUTHORIZATION_LIMIT_REACHED` | 停止额外创建，报告续期/重新授权动作。 |
| 不支持的操作 | 只停止该操作并报告返回的安全动作。 |
| 可重试远端错误 | 遵守 `Retry-After`，对同一逻辑写操作复用幂等身份。 |
| `run_doctor` | 运行一次只读 `doctor`，只报告最终用户动作。 |

`auth logout` 只删除本地状态；`auth revoke` 先撤销服务端授权再删除本地状态，仅在用户要求时
使用 revoke。
