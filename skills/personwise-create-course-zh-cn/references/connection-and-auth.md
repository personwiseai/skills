# 安装并授权中国区课程创作 MCP

## 使用一个独立的远程 MCP 安装

PersonWise 中国区 MCP 是可独立使用的完整产品，不要求安装 Skill。本 Skill 的依赖只声明同一个连接：

```text
标识：personwise-course-creation-cn
传输：streamable_http
地址：https://mcp.personwise.cn/mcp
```

只接受这个 HTTPS 地址。不要改成主站 API、OAuth 地址、本机服务或猜测出的其他区域地址。不要索取、
发放或保存静态密钥；公开远程连接使用 OAuth。

安装并完成 OAuth 后调用 `get_course_agent_capabilities` 或读取 `personwise://course-agent/capabilities`。只要能力读取成功
且所需工具存在，就不要再添加重复连接。

## 第一次使用时安装 MCP

立即安装缺失的远程 MCP，使用当前 Host 原生支持的 MCP 安装或添加机制。这是完成课程请求的一部分。
不要要求用户执行 Agent 能够完成的安装。

Host 能读取 `agents/openai.yaml` 时优先使用其中的依赖元数据，否则调用 Agent 可用的 Host 官方 MCP
安装命令、API 或设置机制，并使用以下公开依赖事实：

```text
标识：personwise-course-creation-cn
传输：streamable_http
地址：https://mcp.personwise.cn/mcp
```

只调用有文档的原生操作；不要猜测或手工改写底层配置文件名、目录、schema、token 字段或原始凭证。
不要把远程地址配置成本地 stdio、仅 SSE 或普通 REST API。

安装后立即启动 Host 原生 OAuth 登录或调用能力工具，让 Host 自己开始 OAuth。用户只参与浏览器 OAuth
授权同意；安装、恢复、能力验证和后续课程流程仍由 Agent 负责。Host 返回授权地址时展示给用户，等待
同意后在同一任务中继续。不要只报告标识、传输、地址或 scope 就停止。

如果 Host 不能热加载新安装的 MCP，使用它支持的 reload 或 resume 操作。只有 Host 确实要求人工重启
应用时才请求用户执行。Host 没有向 Agent 暴露任何受支持的安装机制时，才报告这个具体限制；不要把
正常安装描述成普遍的人工前置条件。Host 不支持远程 OAuth MCP 时，明确报告能力阻塞；不得让用户把
授权码、token、cookie 或一次性上传凭证粘贴到对话中。

兼容 Host 至少要支持：

- MCP Streamable HTTP；
- OAuth protected-resource discovery 和带 PKCE 的 Authorization Code；
- 浏览器授权与精确回跳；
- bearer challenge、refresh token 和重连；
- MCP tools；需要视觉工作时还要能读取受保护的图片/资源内容。

## 完成 OAuth

Host 发起连接或调用能力工具后，应当：

1. 从 MCP challenge 发现受保护资源元数据；
2. 发现路径无关的 issuer `https://oauth.personwise.cn`；
3. 注册或使用公共客户端和精确 redirect URI；
4. 自己生成并保管 PKCE verifier/challenge 与 `state`；
5. 在用户浏览器打开 PersonWise 授权页；
6. 只在精确 redirect 和 state 校验通过后继续；
7. 由 Host 自己交换授权码，并把 access/refresh token 留在凭证存储中。

除 Host 自己批准的 loopback 回跳外，只把用户带到 `oauth.personwise.cn` 或 `personwise.cn` 的 HTTPS
页面。授权页显示 Agent 名称、回跳主机和固定课程创作权限；本机或未验证客户端会显示警告，不要替
用户忽略或重新解释该警告。

用户选择一个有效团队并允许或拒绝连接。公开 OAuth 请求只包含 `courses:manage`，它覆盖该团队中的
普通课程创建、读取、生成、编辑、素材上传、主讲人/配置、首次发布和公开链接管理。它仍受课程额度、
并发和速率限制，也不包含计费、组织管理、删除、转移或平台管理权限。

用户可随时在“已连接的智能体”撤销连接。401 时让 Host 尝试一次规范刷新；刷新失败、凭证丢失或已
撤销时，重新走浏览器授权，再读取最新 run。403 不得通过扩大权限或索取秘密来绕过。

## 连接完成检查

开始创建前确认：

- capability resource 精确为 `https://mcp.personwise.cn/mcp`；
- 返回的 deployment/market 为中国区投影；
- 26 个中国区公开工具中，本次需要的工具都存在；
- 没有把另一数据平面的 token、client 或 grant 当作当前连接；
- Host 重连后仍能再次读取 capability。

只记录连接是否成功、合同版本和安全错误码；不得记录 token、cookie、授权码或用户资料内容。
