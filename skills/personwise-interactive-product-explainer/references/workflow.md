# Produce the explainer through the PersonWise CLI

## Establish trust, authorization, and account binding

Run `personwise version --json`; require software 1.0.1 or newer and CLI contract 1.0. If absent or
older, explain the user-local executable install and obtain explicit approval, then run the bundled
`assets/bootstrap.sh --approve-install` or Windows `assets/bootstrap.ps1 --approve-install`. Use
the returned absolute path. Do not use sudo, modify PATH/policy, overwrite a target, or switch
origin.

Run `personwise doctor --service personwise.ai --json`. Stop before mutation if any required
trust, descriptor, credential-store, contract, or release check fails. The v1.0.1 release has
founder-approved deferred Apple/Windows native signing; do not claim native
signing or dismiss an OS warning.

For automation, run `personwise auth begin --service personwise.ai --json`, show the PersonWise
browser verification URL
and code, then keep `personwise auth wait --flow-id <flow-id> --json` active. Never request or
handle passwords, OTPs, tokens, codes, callback URLs, cookies, D16 keys, or secrets.

Pin the resulting alias with global `--account <alias>`, verify `auth status`, then run
`capabilities --json`. Require exact capabilities for create, durable run reads/waits/advances,
source transfer, snapshot/update, image review/regeneration, presenter/configuration, publish, link
access, and asset download.

## Keep a secret-free run ledger

Track the blueprint, claim ledger, account alias, run/project IDs, logical idempotency identities,
source filename/checksum/status, checkpoint/allowed actions, revisions, review findings,
configuration, and final URLs. Never store tokens, cookies, credential references, upload grants,
signed URLs, or private resource contents.

## Create one durable run

After explicit approval to consume one course credit, put a create object in a bounded JSON file:

```text
desired_slide_count = 5
knowledge_source_mode = materials_only for strict files, otherwise open
declared_sources = exact retained strict source count
distribution_target = link unless the user asked for draft or private
```

Include this exact Skill attribution only when supported; it is optional telemetry and never blocks
creation:

```json
{
  "skill_invocation": {
    "skill_id": "personwise-interactive-product-explainer",
    "skill_version": "2.0.0",
    "scenario_id": "CF-001"
  }
}
```

Then run:

```text
personwise --account <alias> course create --input <create.json> --json
```

Immediately save the returned run ID. Do not treat allocation as completion.

## Upload strict sources

For each exact user-approved PDF/PPTX/DOCX/Markdown/TXT path:

```text
personwise --account <alias> source add --run-id <run-id> --path <path> --json
personwise --account <alias> source status --run-id <run-id> --json
```

The CLI owns file validation, checksum, init, byte upload, ambiguous-result reconciliation, and
confirmation. Never duplicate an unresolved transfer or relax strict grounding because one source
failed.

## Review Outline and Script

Use bounded `run wait`, then fresh `run get` and `course snapshot` reads. At Outline:

1. Confirm exactly five pages and the approved teaching jobs.
2. Check every title/key-point set against the claim ledger.
3. Apply the smallest atomic correction through revision-bound `course update --input`.
4. Fetch the complete snapshot again.

Call `run advance` only when fresh `allowed_actions` permits it. At Script, audit every title, key
point, page-text line, and narration sentence against the ledger; remove fabricated specificity and
qualify only where evidence supports it. Do not add, delete, or reorder pages.

## Attach and review images

Use revision-bound `image attach-reference` only for a user-approved bounded product image in an
allowed window. Reconcile it before another mutation.

At image readiness, a vision-capable Agent uses `image review-sheet` to download all five pages in
batches of at most six to new local destinations. Inspect factual implications, legibility,
composition, continuity, and the no-invented-UI boundary. Correct content first, then run
revision-bound `image regenerate` once for the complete failed subset with concrete JSON
instructions, wait for durable state, and re-inspect changed pages.

Without vision, require canonical image completion and report `visual_review=not_performed`; this
alone is not a publish blocker.

## Configure, publish, and verify

Use `presenter list/preview/select` only for a concrete casting requirement; otherwise accept the
validated default. Change layout through revision-bound `course configure` only when requested.

Keep `run wait` active to terminal state. Use `course publish` and `course set-access --mode link`
only when the orchestrator needs a fresh-state repair and the user authorized the target. Read
`course get` and `course snapshot` afterward. Return public/embed URLs only when the final state
proves playability.

## Recover safely

- After a timeout or lost response, read state before replaying the exact logical mutation.
- On revision conflict, fetch a fresh snapshot and merge actual changes.
- An interrupted `run wait` does not cancel the remote run; resume with the same alias and run ID.
- Use `run retry` only when fresh state permits it; otherwise report the exact failed state.
- Honor `Retry-After`; never parallel-hammer one run.
- Stop for invalid authorization, exhausted credit, missing authoritative source, unsupported
  required capability, or an explicitly reserved user decision.
- `auth logout` removes local state; `auth revoke` also revokes the server grant.
