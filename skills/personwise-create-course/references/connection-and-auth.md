# Install and authorize the PersonWise Course Creation MCP

## Use one standalone MCP installation

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

After installation and OAuth, call `get_course_agent_capabilities` or read
`personwise://course-agent/capabilities`. If either works and the required tools are present, setup
is complete; do not add a duplicate server entry.

## Install the MCP on first use

Install the missing remote MCP now using the current host's native supported MCP install or add
mechanism. This is part of fulfilling the course request. Do not ask the user to perform an
installation that the Agent can complete through the current host.

Prefer the dependency metadata in `agents/openai.yaml` when the host consumes it. Otherwise invoke
the host's official MCP installation command, API, or Agent-accessible setup mechanism with these
public dependency facts:

```text
identifier: personwise-course-creation
transport:  streamable_http
URL:        https://mcp.personwise.ai/mcp
```

Use only documented native operations; do not guess or manually patch a backing configuration
filename, directory, schema, token field, or raw credential. Do not configure the endpoint as
local stdio, SSE-only, or a generic REST API.

Immediately after installation, start the host's native OAuth login or invoke the capability tool
so the host begins OAuth itself. The user participates only in browser OAuth consent; the Agent
retains responsibility for installation, resumption, capability verification, and the course
workflow. Show the authorization URL when the host returns one, wait for consent, then continue in
the same task. Do not stop after merely reporting the identifier, transport, URL, or scope.

If the host cannot hot-load a newly installed MCP, use its supported reload or resume operation.
Ask the user for an application restart only when the host truly requires that human action. If the
host exposes no supported installation mechanism to the Agent, report that specific host
limitation; do not present ordinary installation as a general manual prerequisite.

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
client's own approved loopback redirect returns control to a local app. Never ask the user to
extract, paste, or manage an authorization code, access token, refresh token, ticket secret, or
cookie. The one supported exception is the complete loopback callback URL recovery below: the user
hands the whole unmodified URL to the same host, which consumes it internally. That handoff is not
code or token handling.

Authorization links are short-lived: an unopened consent request expires after about 10 minutes.
Show the authorization URL promptly and ask the user to open it without delay. If the consent page
reports the request as unavailable or expired, start the host-native login once more so the client
issues a fresh authorization URL. If a fresh login fails again immediately, stop and report the
exact error state; do not loop authorization restarts.

### Recover when the browser does not resume the client

The default flow is automatic. After the user approves on the consent page, the browser redirects
to the client's loopback address and the same client resumes itself, exchanges the code against its
retained PKCE verifier, and stores tokens in its own credential store. The user does nothing after
approval.

When the browser shows a completed authorization but the client does not resume, use the supported
recovery exactly once: the user copies the COMPLETE loopback callback URL from the browser address
bar and gives it to the same Agent in the same task, and the Agent hands the unmodified URL to the
host's native OAuth continuation. The host consumes the URL whole: it validates `state`, reads the
code internally, and completes the exchange inside its own credential store.

The user never extracts the `code` value, never pastes a bare code, and never sees or handles
access or refresh tokens. The URL is valid only for the same host, client, and login attempt that
generated it; do not move it across hosts, clients, organizations, or tasks, and do not retry a
consumed or expired URL.

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
start_course_creation
get_run
advance_run
get_authoring_snapshot
update_slides
```

Require `supports_orchestrated_creation=true` and
`requires_visual_capability_declaration=true`. Add upload, visual, casting, configuration, query,
or repair tools only as the requested workflow requires them. For multimodal review, prefer
`get_slide_review_sheet` when `supports_slide_review_sheet=true`; otherwise use bounded individual
previews. Check upload and image capabilities rather than assuming them.

Do not consume course credit when MCP contract compatibility or a required capability is
unresolved. Skill presence and Skill version are never compatibility inputs.

## Diagnose connection failures

| Signal | Meaning | Action |
|---|---|---|
| MCP dependency/tool is absent | The remote dependency was not installed, connected, or injected into this task | Use the positively identified host's published remote-MCP installation method and verify the exact URL. If the host is unknown, report the missing dependency without inventing setup steps. |
| Discovery or redirect is still pending | Incomplete OAuth | Resume the client's authorization flow; preserve client PKCE/state; do not call create yet. |
| Consent page reports the request unavailable or a 400 error | The authorization link expired (links live about 10 minutes) or the client sent an incomplete OAuth request | Start the host-native login once so the client issues a fresh complete authorization URL. If it fails again, report the exact page error; do not loop restarts. |
| Client reports an issuer or authorization-server mismatch | A defect class in some released client versions drops callback parameters and then fails its own validation | Update the client to a fixed release, then start one fresh login. Do not re-register or reconfigure the server entry. |
| OAuth succeeded in the browser but the client did not resume | The loopback redirect did not reach the client | Use the complete loopback callback URL recovery above: the user gives the whole URL from the browser address bar to the same Agent for the host's native continuation. |
| 401 before first success | Missing/invalid resource token or incomplete consent | Reconnect through OAuth and verify the exact MCP resource. |
| 401 after a working connection | Revoked, expired, replaced, or otherwise invalid grant/token | Let the client refresh once; if still rejected, reauthorize. Do not extract or paste tokens. |
| 403 or `course_agent_mcp_insufficient_scope` | The connection is legacy-limited, stale, or mismatched with the current contract | Refresh once; if it remains limited, start one fresh full-course authorization. Do not request capability-by-capability consent. |
| Target-above-ceiling error | A legacy-limited connection cannot complete the requested target | Start one fresh full-course authorization; never silently change the requested result. |
| Required MCP tool is absent | The connected server cannot complete that requested workflow | Stop only the affected workflow and report the missing tool. Do not require or upgrade a Skill. |
| 429 | Connection/tool rate limit | Honor `Retry-After`; do not parallel-hammer. |
| 429 during client registration | Registration rate limit (registrations are bounded per 15 minutes per IP) | Wait 15 minutes before the next attempt; do not delete and re-add the server entry or re-register to work around it. |

Never delete and re-add the MCP server entry, re-register the client, or reinstall the Skill as a
first response to an OAuth failure. Identify one cause, correct it, then allow exactly one fresh
host-native login retry per corrected cause. Repeated identical failure is a reportable state, not
a retry loop.

After reconnection, repeat the capability read. For an existing course task, call the relevant
read-only `get_run` or `get_course` before resuming any mutation.
