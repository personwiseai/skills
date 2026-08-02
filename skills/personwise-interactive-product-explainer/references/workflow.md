# Produce the explainer through the PersonWise MCP

## Keep a secret-free run ledger

Track the blueprint, claim ledger, run/project IDs, non-secret idempotency keys, source
filename/checksum/status, current checkpoint, allowed actions, revisions, review findings,
configuration, and final URLs. Never store OAuth tokens, cookies, upload authorization values,
browser-action fragments, or private resource grants.

## Create one durable run

Use a stable create key and these defaults:

```text
desired_slide_count = 5
stop_after = outline_ready
distribution_target = link, unless the user asked for draft or private
```

Use `materials_only` plus the exact `declared_sources` count for strict document grounding. For a
verified supplied-text brief, use `open` and place the factual constitution in `topic` and the
bounded brief in `content`.

When `supports_skill_invocation_attribution=true`, include:

```json
{
    "skill_invocation": {
      "skill_id": "personwise-interactive-product-explainer",
      "skill_version": "1.1.1"
    }
}
```

When the Host knows the installation platform, also include `surface` with one of `skills_sh`,
`clawhub`, `smithery`, `github_skill`, `skillhub_cn`, `agentskill`, or `tessl`; omit it when
unknown. Omit this object against an older contract or when the Host cannot confirm the installed
package version. Never delay or fail the user's course for attribution.

Immediately save the returned run ID and call `get_run`.

## Upload strict sources

For each retained document:

1. Compute its exact byte size and `sha256:<64 lowercase hex>` checksum.
2. Call `request_upload_ticket` with `purpose=document_source`.
3. Let a capable Host transmit the exact bytes once; otherwise return the PersonWise browser action
   so the user can choose the file.
4. Keep upload authorization out of messages and the ledger.
5. Poll `get_upload_status` to a terminal ticket state.
6. Call `get_run` and verify the canonical source checksum and status.

Do not advance a strict run while a retained source is pending, processing, failed, or missing.

## Review outline and narration

Call only a fresh `allowed_action`. One `advance_run` performs one bounded segment.

At `paused / outline_ready`:

1. Fetch `get_authoring_snapshot`.
2. Confirm exactly five pages and the five approved teaching jobs.
3. Check every title and Key-point set against the claim ledger.
4. Apply the smallest atomic `update_slides` patch with the fresh `expected_revision`.
5. Fetch the complete snapshot again.

Advance one safe segment at a time. After every mutation, call `get_run`. While the run remains
`waiting / outline_ready` and `continue` is allowed, advance again with a new key; do not merely
poll an unchanged waiting state.

At `paused / script_ready`:

1. Fetch a fresh authoring snapshot.
2. Audit every `title`, `key_points`, `page_text`, and `script` sentence against the ledger.
3. Remove fabricated specificity; qualify only where a source supports the qualification.
4. Check narration for natural transitions and avoid reading page text verbatim.
5. Apply one bounded revision-checked patch, then fetch the snapshot again.

Do not add, delete, or reorder pages through slide edits.

## Attach verified images

The upload window is only `paused / script_ready` while `upload_reference` is allowed. Use
`slide_pin` for an exact screenshot or product image and `slide_reference` for looser visual
guidance. Supply factual captions. Reconcile an ambiguous ticket before requesting another.

## Generate and review images

Immediately before generation, read both `get_run` and `get_authoring_snapshot`. Start images with
the current revision and a new idempotency key. Poll with bounded backoff until every slide's
canonical image state is complete and the run is `image_ready`.

If the Agent can consume MCP image content or its protected-resource fallback:

1. Call `get_slide_preview` for all five indexes.
2. Inspect factual implications, legibility, composition, style continuity, and the no-invented-UI
   boundary.
3. Correct content before visuals where necessary.
4. Regenerate the complete failed subset once with concrete per-slide instructions and a fresh
   revision.
5. Re-inspect every changed page.

Without image consumption, report `visual_review=not_performed`; this alone is not a publish
blocker.

## Configure and finish

Use bounded `list_presenters` pagination and compatible Voice mappings. With vision, inspect
`get_presenter_preview`; without vision, make no appearance claims. Select one compatible pair,
then re-read the run, snapshot, and configuration. Change layout only when the user requested it.

Call `first_publish` once. Re-read state before visibility mutation. For the default website result,
call `set_course_visibility` with link-only `unlisted`; do not expose that technical label as a
three-way user choice.

Return public and embed URLs only when the final state reports `playable=true`. This Skill does not
approve Topics distribution, buy credits, delete courses, transfer ownership, or administer an
organization.

## Recover safely

- Replay an idempotency key only after an ambiguous response to the exact same payload.
- Use a new key for each new logical operation.
- On revision conflict, fetch a new snapshot and merge actual changes.
- Honor `Retry-After`; never parallel-hammer one run.
- Use `retry_run` only when fresh state allows it.
- Stop for OAuth, exhausted credit, missing authoritative source, unsupported required capability,
  or an explicitly reserved user decision.
