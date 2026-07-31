# Connect and authorize the PersonWise Course Creation MCP

## Use one standalone MCP connection

The PersonWise MCP is a complete standalone product. No Skill is required. When this optional Skill
is installed, its dependency metadata may register the same MCP automatically:

```text
identifier: personwise-course-creation
transport:  streamable_http
URL:        https://mcp.personwise.ai/mcp
```

Verify that exact HTTPS URL. Do not substitute the main PersonWise API, an Auth URL, a local server,
or a guessed regional endpoint. Do not request, issue, store, or rotate a PersonWise API key. The
public remote connection authenticates with OAuth.

After connection, call `get_course_agent_capabilities` or read
`personwise://course-agent/capabilities`. If either works and the required tools are present, setup
is complete; do not add a duplicate server entry.

## Configure the MCP directly

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

This JSON is a descriptive shape for the host's supported setup surface, not permission for an
Agent to overwrite a user-global configuration file. Never write or rewrite a host-wide MCP
configuration from inside a running task. A live host may watch that file, remove an existing
connector, start OAuth outside its interactive connection state, or discard the callback before
the task can use the tools.

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

### WorkBuddy

In WorkBuddy, use **Connectors → Custom connectors → Configure MCP**, add the exact remote URL, and
explicitly click **Connect** in MCP Service Management. Do not have the running Agent write
`~/.workbuddy/mcp.json`. WorkBuddy 5.3.5 can observe such a background file change and begin OAuth
outside the interactive connection state; authorization can then succeed while its callback is
ignored and the upstream tools remain disconnected.

WorkBuddy aggregates custom MCP servers behind its local `connector-proxy`. Seeing only
`connector-proxy` in a generic MCP server/resource listing is therefore not evidence that
PersonWise is absent. Verify the PersonWise card's connected state, search for
`get_course_agent_capabilities`, and call that capability before any course mutation.

If browser authorization completed but the card did not become connected, fully quit and reopen
WorkBuddy, return to MCP Service Management, and click **Connect** once. Preserve the stored
credentials on this first recovery attempt; do not delete the connector, rewrite the file, or ask
the user to authorize again unless WorkBuddy opens a fresh authorization request.

WorkBuddy 5.3.5 has a separate full-restart limitation verified against the production MCP: after
the app was fully quit for longer than the 15-minute access-token lifetime, relaunch did not reuse
the previously issued refresh token. The card returned to **Needs authentication**, and clicking
**Connect** opened a fresh authorization request. This is client credential-restoration behavior;
the server did not receive a refresh attempt. Complete that fresh authorization once, then repeat
`get_course_agent_capabilities`. Do not lengthen the access-token lifetime or weaken OAuth for
other clients to mask this WorkBuddy-specific behavior.

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

The user chooses one active PersonWise organization and then authorizes or denies the connection.
The public OAuth request contains one permission, `courses:manage`. It covers the complete ordinary
course workflow in that organization: create/read/generate/edit, owned-course discovery, document
and image upload, presenter and configuration work, first publish, link access, and Topics-review
submission.

Explain the boundary precisely:

- Each new course still consumes one organization course credit and remains subject to concurrency
  and rate limits.
- Link access is technically `unlisted` and noindex. Topics submission starts a separate review; it
  never approves or directly publishes platform-wide content.
- Billing, organization administration, course deletion or transfer, Topics approval, and direct
  platform-public publication are excluded.
- Access tokens last 15 minutes. This is not the login lifetime: a compatible client keeps the
  refresh token in its credential store and can obtain a new access token after the computer was
  powered off for longer than 15 minutes. The refresh token lasts one year; reauthorization is
  required only after that token expires, is revoked, or is lost.
- The user can revoke the connection from Connected Agents at any time.

Do not ask for a second authorization when an ordinary course step becomes necessary. One grant is
bound to one organization; the same Agent may connect to another organization through a separate
authorization. Do not submit a different organization or user identity through MCP tool arguments.

## Prove readiness before creating

Read `personwise://course-agent/capabilities` when the host supports resources; otherwise call
`get_course_agent_capabilities`. Require:

```text
capabilities.resource == "https://mcp.personwise.ai/mcp"
capabilities.contract_version has compatible major version 1
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

Do not consume course credit when MCP contract compatibility or a required capability is
unresolved. Skill presence and Skill version are never compatibility inputs.

## Diagnose connection failures

| Signal | Meaning | Action |
|---|---|---|
| MCP dependency/tool is absent | Missing connection, disabled connector, or wrong host setup | Install the bundled dependency or use the client's documented remote-MCP UI; verify the exact URL. |
| Discovery or redirect is still pending | Incomplete OAuth | Resume the client's authorization flow; preserve client PKCE/state; do not call create yet. |
| 401 before first success | Missing/invalid resource token or incomplete consent | Reconnect through OAuth and verify the exact MCP resource. |
| 401 after a working connection | Revoked, expired, replaced, or otherwise invalid grant/token | Let the client refresh once; if still rejected, reauthorize. Do not extract or paste tokens. |
| 403 or `course_agent_mcp_insufficient_scope` | The connection is legacy-limited, stale, or mismatched with the current contract | Refresh once; if it remains limited, start one fresh full-course authorization. Do not request capability-by-capability consent. |
| Target-above-ceiling error | A legacy-limited connection cannot complete the requested target | Start one fresh full-course authorization; never silently change the requested result. |
| Required MCP tool is absent | The connected server cannot complete that requested workflow | Stop only the affected workflow and report the missing tool. Do not require or upgrade a Skill. |
| WorkBuddy shows OAuth success but no PersonWise tools | Its callback or reconnect state was not applied | Fully quit and reopen WorkBuddy, then click **Connect** once in MCP Service Management and repeat the capability call. If WorkBuddy opens a fresh authorization request after a full restart, complete it once. Do not infer absence from `connector-proxy`. |
| 429 | Connection/tool rate limit | Honor `Retry-After`; do not parallel-hammer. |

After reconnection, repeat the capability read. For an existing course task, call the relevant
read-only `get_run` or `get_course` before resuming any mutation.
