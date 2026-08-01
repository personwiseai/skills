# WorkBuddy connection and OAuth recovery

Read this reference only when the current host is positively identified as WorkBuddy from runtime
metadata or an explicit user statement. Do not infer WorkBuddy from missing tools, a callback URL,
or the presence of this file.

In WorkBuddy, use **Connectors → Custom connectors → Configure MCP**, add
`https://mcp.personwise.ai/mcp`, and explicitly click **Connect** in MCP Service Management. Do not
have the running Agent write `~/.workbuddy/mcp.json`. WorkBuddy 5.3.5 can observe such a background
file change and begin OAuth outside the interactive connection state; authorization can then
succeed while its callback is ignored and the upstream tools remain disconnected.

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

If WorkBuddy shows OAuth success but no PersonWise tools, fully quit and reopen WorkBuddy, click
**Connect** once in MCP Service Management, and repeat the capability call. If it opens a fresh
authorization request after a full restart, complete it once. Do not infer PersonWise absence from
`connector-proxy` alone.
