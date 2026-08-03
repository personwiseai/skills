# Install and authorize the PersonWise CLI

## Use the executable bound to this Skill release

This package uses one reviewed `personwise` executable and the international PersonWise service
declared in its signed descriptor. There is no endpoint, issuer, resource, download-origin, or
market selector and no alternate runtime path.

Start with `personwise version --json`. Require:

```text
software_version >= 1.0.1
contract_version == 1.0
```

If `personwise` is missing or older, tell the user that executable code will be installed and name
the user-local destination reported by the bundled bootstrap. Obtain explicit approval, then use:

```text
Linux/macOS: assets/bootstrap.sh --approve-install
Windows:     assets/bootstrap.ps1 --approve-install
```

The bootstrap is pinned to the immutable CLI release, signed descriptor, release manifest, target
size/hash, detached trust root, and declared native-signing policy. It must not use sudo, edit
PATH/profile/execution policy, start a daemon, follow redirects, resolve `latest`, overwrite an
occupied path, or run hooks. Invoke the absolute executable path returned in its JSON envelope if
PATH has not changed. Upgrade and rollback are separate explicit approvals.

The current v1.0.1 release uses `deferred-founder-approved` for Apple/Windows native signing. The
bootstrap still verifies exact hashes and PersonWise detached signatures; an OS reputation warning
may appear. Do not claim Apple notarization or Authenticode, and do not make the OS trust decision
for the user.

Run `<absolute-personwise-path> doctor --service personwise.ai --json`. Stop before mutation if
any required trust, descriptor, credential-store, contract, or release check fails. Do not write a
diagnostic bundle unless the user explicitly requests one and approves its path.

## Authenticate through the browser

For Agent automation, use Device Flow:

```text
personwise auth begin --service personwise.ai --json
personwise auth wait --flow-id <flow-id> --timeout-seconds 1800 --json
```

Show the returned `verification_uri_complete` or verification URI plus `user_code` promptly. The
user signs in, chooses an organization, and approves access in the browser. The Agent never asks
for or receives a password, OTP, token, authorization code, callback URL, cookie, D16 key, or
credential-store content.

Interactive human terminals may use `personwise auth login`. Public Skills never mention or invoke
test-only authorization modes.

Refresh tokens remain in the operating-system credential store. Headless Linux file storage is
allowed only through the CLI's explicit opt-in and risk disclosure; never implement credential
storage in Skill prose or shell commands.

## Pin the account and prove capability

Read safe local metadata:

```text
personwise account list --json
personwise --account <alias> account show --alias <alias> --json
personwise --account <alias> auth status --json
personwise --account <alias> capabilities --json
```

Use global `--account <alias>` on every business command. Require the account's public service,
issuer, resource, organization, and scopes to match the selected authorization and this Skill.
Cross-service account state must fail closed; never switch service as a fallback.

Before course creation, require named capabilities for durable run creation/read/wait/advance,
snapshot/update, source transfer when used, image operations when used, presenter/configuration,
and the requested publication/access target. Require the advertised page/source/file limits.
Unknown or absent capabilities stop only the affected path before mutation.

## Approval boundary

One OAuth grant covers the ordinary course workflow in one organization. It does not authorize
billing, credit purchase, organization administration, deletion, ownership transfer, direct
platform-public publication, or Topics approval.

Before `course create`, explain the intended page count, that one course credit will be consumed,
and the final access target; obtain explicit approval. Installation approval and course-credit
approval are distinct. A prior repository owner authorization cannot be silently reused for an
unrelated end user's machine or credits.

## Diagnose failures

| Signal | Action |
|---|---|
| CLI absent or too old | Explain the pinned user-local install/update and obtain approval; use only the bundled bootstrap. |
| Bootstrap target occupied | Do not overwrite it; report the absolute path and inspect separately. |
| Any required `doctor` check unhealthy | Stop mutation and report the failing structured check/action. |
| Authorization pending | Keep the real `auth wait` active within its timeout. |
| Authorization denied or expired | Report the exact state; begin one new flow only after the user asks to retry. |
| 401 after prior success | Allow the CLI refresh path; if still rejected, reauthorize and then read state. |
| Account/service mismatch | Select an already-bound matching account or reauthorize; never switch endpoint. |
| Capability unavailable | Stop only the affected workflow and report the missing named capability. |
| Insufficient credit | Stop before duplicate creation; direct the user to PersonWise billing. |
| 429 or retryable remote error | Honor the structured retry guidance and `Retry-After`; do not hammer. |

`auth logout` removes local state. `auth revoke` first revokes the server grant and then removes
local state. Use revoke only when requested; never represent logout as revocation.
