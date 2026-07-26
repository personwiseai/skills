# Connect and authorize the PersonWise Course Creation MCP

## Use the bundled dependency first

The Skill and MCP are one product. Prefer the host Agent's native Skill dependency installer, which
reads `agents/openai.yaml` and registers:

```text
identifier: personwise-course-creation
transport:  streamable_http
URL:        https://mcp.personwise.ai/mcp
```

Verify that exact HTTPS URL. Do not substitute the main PersonWise API, an Auth URL, a local server,
or a guessed regional endpoint. Do not request, issue, store, or rotate a PersonWise API key. The
public remote connection authenticates with OAuth.

After dependency installation, call `get_course_agent_capabilities` or read
`personwise://course-agent/capabilities`. If either works and the contract is compatible, setup is
complete; do not add a duplicate server entry.

## Configure a host without Skill dependency support

Use the host's documented **remote MCP** or **custom connector** UI when available. Create one entry
named `personwise-course-creation`, select Streamable HTTP, and enter only:

```text
https://mcp.personwise.ai/mcp
```

For clients whose documented configuration uses an `mcpServers` map, adapt this shape to the
client's published schema:

```json
{
  "mcpServers": {
    "personwise-course-creation": {
      "url": "https://mcp.personwise.ai/mcp",
      "transport": "streamable_http"
    }
  }
}
```

For clients whose registry uses typed tool dependencies, adapt this equivalent shape:

```yaml
type: mcp
value: personwise-course-creation
transport: streamable_http
url: https://mcp.personwise.ai/mcp
```

Do not guess a configuration filename, directory, field alias, command, or token field. If the
client rejects the documented shape, consult that client's current remote-MCP documentation or ask
the user where it manages connectors. Do not configure the endpoint as local stdio, SSE-only, or a
generic REST API.

A standards-compatible fallback client must support:

- MCP Streamable HTTP;
- OAuth protected-resource discovery and Authorization Code with PKCE;
- browser authorization and redirect resumption;
- bearer challenges and refresh-token handling;
- MCP tools and, for visual work, protected resource/image content.

If the client lacks remote OAuth MCP support, report that client capability blocker. Never work
around it by asking the user to paste credentials or access tokens.

## Complete OAuth in the client

Start connection or invoke the capability tool. The client should:

1. Receive the MCP bearer challenge and discover the protected-resource metadata.
2. Discover the pathless authorization issuer at `https://auth.personwise.ai`.
3. Register or use its public client and exact redirect URI.
4. Generate and retain its own PKCE verifier/challenge and `state`.
5. Open the returned PersonWise authorization URL in the user's browser.
6. Resume only after the exact redirect and state validation.
7. Exchange the code itself and keep access/refresh tokens inside the client's credential store.

Send the user only to HTTPS pages on `auth.personwise.ai` or `personwise.ai`, except when the
client's own approved loopback redirect returns control to a local app. Never ask the user to paste
an authorization code, access token, refresh token, ticket secret, or cookie into chat.

The consent page shows the Agent/client name and redirect host. Localhost or unverified clients may
receive a prominent warning. Do not dismiss or reinterpret that warning; let the user decide
whether they recognize the client.

The user chooses:

- one active PersonWise organization;
- a positive course-count limit or `Unlimited`;
- the requested creation capabilities;
- a publication ceiling of draft, private, or link;
- optional Topics-review submission permission.

Explain the defaults precisely:

- `Unlimited` removes an additional lifetime connection count limit; each new course still consumes
  one organization course credit and remains subject to concurrency and rate limits.
- `link` means link-accessible, technically `unlisted`, and noindex. It does not list the course in
  Topics, hubs, sitemaps, or search.
- The Agent can always request a narrower final result than the ceiling.
- Expanding scopes or the ceiling requires new consent. Revocation and narrowing take effect on
  subsequent tool use.

Do not submit a different organization, user identity, scope set, course limit, or ceiling through
MCP tool arguments. Those values come only from the approved OAuth authorization.

## Prove readiness before creating

Read `personwise://course-agent/capabilities` when the host supports resources; otherwise call
`get_course_agent_capabilities`. Require:

```text
capabilities.resource == "https://mcp.personwise.ai/mcp"
capabilities.contract_version has compatible major version 1
capabilities.minimum_skill_version <= "1.0.0"
minimum_remote_mcp_version is supported by the connected server
```

Compare `supported_tools` with the operations needed for the request. At minimum, normal staged
creation needs:

```text
get_course_agent_capabilities
create_course
get_run
advance_run
get_authoring_snapshot
update_slides
list_presenters
select_presenter
get_course_configuration
first_publish
```

Add upload, visual, configuration, visibility, query, or Topics tools only as the requested
workflow requires them. Check `supports_machine_upload`, `supports_browser_upload`,
`supports_image_content`, and `supports_protected_image_resources` rather than assuming them.

Do not consume course credit when contract compatibility or a required capability is unresolved.

## Diagnose connection failures

| Signal | Meaning | Action |
|---|---|---|
| MCP dependency/tool is absent | Missing connection, disabled connector, or wrong host setup | Install the bundled dependency or use the client's documented remote-MCP UI; verify the exact URL. |
| Discovery or redirect is still pending | Incomplete OAuth | Resume the client's authorization flow; preserve client PKCE/state; do not call create yet. |
| 401 before first success | Missing/invalid resource token or incomplete consent | Reconnect through OAuth and verify the exact MCP resource. |
| 401 after a working connection | Revoked, expired, replaced, or otherwise invalid grant/token | Let the client refresh once; if still rejected, reauthorize. Do not extract or paste tokens. |
| 403 or `course_agent_mcp_insufficient_scope` | Valid connection lacks a required capability | Keep narrower work within scope or ask the user whether to start new consent for the added capability. Do not retry unchanged. |
| Target-above-ceiling error | Requested completion exceeds consent | Narrow the target or obtain new consent; never silently widen or clamp it. |
| Capability version/tool mismatch | Skill and server are not a safe pair | Stop before creation and update the Skill/connection. |
| 429 | Connection/tool rate limit | Honor `Retry-After`; do not parallel-hammer. |

After reconnection, repeat the capability read. For an existing course task, call the relevant
read-only `get_run` or `get_course` before resuming any mutation.
