# Produce the explainer through the PersonWise CLI

## Establish only the required connection

Run `personwise version --json`; require software 1.1.1 or newer and CLI contract 1.0. If absent or
old, use the bundled `assets/bootstrap.sh --approve-install` or Windows
`assets/bootstrap.ps1 --approve-install`. The Host applies its own installation policy; do not add
a PersonWise confirmation or narrate supply-chain and credential internals on the normal path.
Never use sudo, modify PATH/policy, overwrite a target, or switch origin.

Check `auth status --json`. If needed, use `auth begin --service personwise.ai --json`, show the
PersonWise browser URL/code, and keep `auth wait --flow-id <flow-id> --json` active. Never request
or handle passwords, OTPs, tokens, codes, callback URLs, cookies, or secrets. Pin the alias with
global `--account <alias>`.

Do not run `doctor` or a general `capabilities` preflight. Use `doctor` only when a structured error
recommends `run_doctor`.

## Read creation readiness before designing

Run:

```text
personwise --account <alias> course readiness --json
```

If blocked, stop before building a blueprint and report the one returned action. Never buy credit.
The user's request already authorizes creating this explainer and using one existing course credit.

Choose an earned slide count no greater than `max_slides_per_course`. Use the five-job explainer arc
when supported; with a lower maximum, recompose the whole arc into the available pages. If the user
requested a larger count, explain the resolved count once. Never promise a count before readiness
or truncate an already-written longer outline.

## Keep a secret-free run ledger

Track the blueprint, claim ledger, account alias, run/project IDs, logical idempotency identities,
source filename/status, checkpoint/actions, revisions, review findings, configuration, and final
URLs. Never store tokens, cookies, credential references, upload grants, signed URLs, or private
resource contents.

## Create one durable run

Put one create object in a bounded JSON file:

```text
desired_slide_count = resolved count from readiness
knowledge_source_mode = materials_only for strict files, otherwise open
declared_sources = exact retained strict source count
distribution_target = the explicit user target, otherwise private
```

Include this optional telemetry only when supported:

```json
{
  "skill_invocation": {
    "skill_id": "personwise-interactive-product-explainer",
    "skill_version": "2.1.2"
  }
}
```

Run `course create --input <create.json> --json`, save the run/project IDs, and do not treat
allocation as completion.

## Upload and review

Upload each file the user named, attached, or selected with `source add`, then reconcile
`source status`. Those files and images need no extra approval. An Agent-discovered local file does.

Use bounded `run wait`, then fresh `run get` and `course snapshot` reads. At Outline, confirm the
resolved page count and teaching jobs against the claim ledger. At Script, audit every title,
key-point set, page-text line, and narration sentence. Apply the smallest revision-bound atomic
correction, fetch fresh state, and call `run advance` only when currently allowed.

Attach supplied product images in the allowed window. With vision, inspect every slide through
review sheets, correct content first, regenerate only the complete failed subset, and re-inspect.
Without vision, require canonical image completion and report `visual_review=not_performed`.

## Finish and recover

Use presenter choices only for a concrete user requirement. Keep `run wait` active to terminal
state. Default omitted visibility to private; complete explicit link/embed/publication requests
without asking again. Return URLs only when final state proves playability.

After timeout or an ambiguous response, read state and reuse the same logical idempotency identity.
Use `run retry` only when fresh state allows it, honor `Retry-After`, and never parallel-hammer a
run. Stop for structured authentication, credit, authorization-limit, or unsupported-operation
errors and report only the returned safe action.
