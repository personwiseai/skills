# Connect and authorize the PersonWise CLI

## Use the executable bound to this Skill

This package uses the international PersonWise service and one pinned `personwise` CLI. There is
no alternate endpoint, issuer, resource, origin, credential path, or market fallback.

Run `personwise version --json` and require software version 1.1.0 or newer with CLI contract 1.0.
If it is missing or old, use the bundled bootstrap:

```text
Linux/macOS: assets/bootstrap.sh --approve-install
Windows:     assets/bootstrap.ps1 --approve-install
```

The Host may ask for installation permission under its own policy. The Skill must not add a
second PersonWise approval or narrate installation internals on the normal path. Never use sudo,
edit PATH/profile/execution policy, start a daemon, overwrite an occupied path, follow `latest`,
or use another origin.

Do not run `doctor` as a prerequisite. Run it only when a structured CLI failure recommends
`run_doctor`; it is a read-only diagnostic unless the user explicitly requests a bundle path.

## Authenticate through the browser

Check `personwise auth status --json`. If needed, use:

```text
personwise auth begin --service personwise.ai --json
personwise auth wait --flow-id <flow-id> --timeout-seconds 1800 --json
```

Show the returned PersonWise URL and user code promptly. The user signs in, chooses an organization,
and approves access in the browser. The Agent never asks for or receives a password, OTP, token,
authorization code, callback URL, cookie, or credential-store content.

The CLI owns private user-local credential storage on every supported operating system; Skills and
Agents never inspect or implement it. Existing pre-1.1.0 logins are not migrated, so complete
browser OAuth once when no 1.1.0 login is present.

## Pin the account and check only relevant readiness

Use global `--account <alias>` on every business command and keep the account bound to this Skill's
international service. Cross-service state must fail closed.

Do not run a general `capabilities` checklist before every task. Query, refine, resume, repair,
publish, and access tasks go directly to their relevant read/business command, which returns a
structured unsupported or authorization error when necessary.

Before each new course only, run:

```text
personwise --account <alias> course readiness --json
```

Use `can_create`, `max_slides_per_course`, and `authorization_courses_remaining` to decide whether
and how large a new course can be. Do not infer page count or credit availability before this read.

## Authorization boundary

An explicit request to create courses authorizes exactly that course count and the normal existing
credit consumption. It also authorizes using files and images the user named, attached, or selected.
Do not ask again before `course create`.

Require new authorization only for additional courses, payment or credit purchase, broader
visibility than requested, deletion, ownership transfer, organization administration, or a local
file the Agent discovered itself. An omitted visibility target is `private`; explicit link access,
publication, or Topics submission is part of the original request.

## Handle failures once

| Structured signal | Action |
|---|---|
| CLI absent/old | Use the pinned bootstrap; let the Host apply its install policy. |
| `AUTHENTICATION_REQUIRED` | Start one browser OAuth flow and keep the wait active. |
| `LOCAL_CREDENTIALS_UNAVAILABLE` | Report `repair_local_credentials`; do not inspect external credential systems or ask for a system password. |
| `CREDIT_INSUFFICIENT` | Stop before create and provide the returned credit/purchase action; never purchase automatically. |
| `AUTHORIZATION_LIMIT_REACHED` | Stop the additional create and report renewal/reauthorization action. |
| Unsupported operation | Stop only that operation and report the returned safe action. |
| Retryable remote error | Honor structured retry guidance and `Retry-After`; reuse the same idempotency identity. |
| `run_doctor` | Run read-only `doctor` once and report only the resulting user action. |

`auth logout` removes local state. `auth revoke` first revokes the server grant and then removes
local state; use revoke only when requested.
