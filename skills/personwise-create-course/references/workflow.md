# Remote MCP workflow and recovery

## Keep one durable, secret-free ledger

Before mutation, create a logical record containing:

```text
course brief and knowledge mode
requested/resolved distribution target
stable idempotency key per logical segment
run ID and project ID
source filename/checksum/status
checkpoint/status/allowed_actions
authoring revision used for each mutation
content and visual review findings
presenter/Voice/configuration evidence
publication, visibility, playability, and review-submission evidence
```

Never record OAuth tokens, cookies, upload authorization values, browser action fragments, source
text that the user did not ask to retain, or private image-resource grants.

Use idempotency keys at least eight characters long with a stable run stem, for example:

```text
earth-forces-20260725-create
earth-forces-20260725-to-outline
earth-forces-20260725-outline-edit-01
earth-forces-20260725-to-script
earth-forces-20260725-images-start
earth-forces-20260725-first-publish
```

One key identifies one exact logical operation and payload.

## Check capability and current state

Call `get_course_agent_capabilities` before the first credit-consuming operation. See
`connection-and-auth.md`.

For an existing run, call `get_run` before every mutation. Trust its effective:

- `status`;
- `checkpoint`;
- `allowed_actions` / returned `next_actions`;
- `authoring_revision`;
- safe `error` and retry guidance;
- source and child states;
- `project_id`, editor URL, and final links.

Call only an operation currently allowed. A stale response is not authority for the next mutation.
At `succeeded` or `cancelled`, actions must be empty.

Never chain mutating tool calls. Even when a mutation returns a new revision, perform the fresh
reads required for the next mutation before calling it.

## Start a topic-led or supplied-text run

When advertised, call `start_course_creation` once with:

- a stable `idempotency_key`;
- the blueprint fields from `course-design.md`;
- `knowledge_source_mode=open`;
- `declared_sources=0` unless documents are supplied;
- the current Agent's truthful `visual_review_capability` (`multimodal` or `none`);
- an explicit narrower `distribution_target` only when the user requests one.

Omit `distribution_target` to use the normal link-accessible completion default. The public
`courses:manage` grant supports draft, private, link-accessible completion, and an explicit Topics
review submission; it never grants Topics approval or direct platform-public distribution.

Immediately save the returned run ID. Follow its `poll_after_seconds`; do not invent a tighter
poll. The zero-source server workflow starts immediately.

## Create a document-backed run

Supported document types are PDF, PPTX, DOCX, Markdown, and TXT, up to 50 MiB each and the bounded
server source limit.

For strict materials:

1. Choose the retained files and set `knowledge_source_mode=materials_only`.
2. Set `declared_sources` to their exact count.
3. Call `start_course_creation`; project/credit materialization is deferred until sources are
   ready.
4. For each file, compute the exact byte size and a checksum formatted
   `sha256:<64 lowercase hex characters>`.
5. Call `request_upload_ticket` with:
   - `purpose=document_source`;
   - the run ID;
   - basename, supported MIME type, byte size, and checksum.
6. If the Agent host can send bytes, stream the exact file once to `upload_endpoint` using the
   returned dedicated upload header. Otherwise give control to the returned PersonWise
   `action_url` so the user chooses the file in the browser.
7. Keep the upload authorization and action fragment out of messages and the ledger.
8. Poll `get_upload_status` by the non-secret ticket ID until `consumed`, `failed`, `expired`, or
   `revoked`.
9. Call `get_run` and confirm the resulting source ID/checksum/status. When every retained source
   is ready, the server reconcile starts generation automatically (normally within 30 seconds); do
   not call `advance_run` merely to activate it.

For `open` with documents, follow the same ticket sequence but describe the course as
source-assisted, not strict.

### Recover source processing

- If a ticket response is lost, inspect `get_upload_status` and the run before requesting another
  ticket. Never blindly upload the same bytes twice.
- If canonical processing fails and `retry_source` is allowed, call it with the run/source IDs and
  a new logical idempotency key. Poll fresh state.
- If an unwanted source must be removed before project creation and `detach_source` is allowed,
  call it once. For strict mode, replace it so the retained ready count again equals
  `declared_sources`.
- Do not advance a strict run while any retained source is pending, processing, or failed.
- Never loosen `materials_only` to bypass a source blocker.

## Advance to and review `outline_ready`

Poll `get_run` no earlier than `poll_after_seconds` until `review_required / outline_ready` (public
status may remain `paused` for compatibility).

Call `get_authoring_snapshot` with the project ID. Review every slide's stable ID, position, title,
and `key_points`.

When corrections are objectively required, call `update_slides` with:

- the project ID;
- the fresh `expected_revision`;
- a new edit idempotency key;
- one atomic list of patches keyed by stable slide `id`.

Only existing `title`, `key_points`, `page_text`, and `script` fields are editable. Do not add,
delete, or reorder slides. After an accepted batch, fetch the complete snapshot again and use only
its new revision.

## Approve and review `script_ready`

Call `get_run` again, then approve the Outline with one `advance_run` using the latest revision and
a new key. Page text and Narration run as server-side durable work. Poll using the returned
`poll_after_seconds`; never issue one mutation per page. Stop at `review_required / script_ready`,
a safe error, cancellation, or a terminal result.

Fetch a new authoring snapshot and inspect every aligned:

```text
title
key_points
page_text
script
```

Apply the smallest sufficient revision-checked `update_slides` batch. When a conceptual correction
affects multiple fields, update them together. Fetch a new snapshot after each accepted batch.

## Attach Reference or Pin images

The attachment window exists only while the effective run is `paused / script_ready` and
`upload_reference` is allowed.

Call `request_upload_ticket` with:

- `purpose=slide_reference` for subject, palette, composition, or visual grammar;
- `purpose=slide_pin` when the exact supplied image should remain the hero visual;
- run ID and project ID;
- one stable slide ID or zero-based slide index as required by the tool schema;
- image filename, MIME type (`image/png`, `image/jpeg`, or `image/webp`), size, and checksum;
- a factual caption;
- optional `extra_prompt` for placement or surrounding elements.

Use no more than the server-allowed references per slide. Do not tell the model to redraw a Pin.
After byte/browser handoff, poll `get_upload_status`, then fetch a fresh run and snapshot. An
unsupported Pin is a capability blocker; do not silently reinterpret it as Reference.

The ticket operation is one-use rather than idempotent. After an ambiguous response, reconcile the
ticket and target slide attachments before issuing a replacement.

## Generate images

Immediately before image generation:

1. Call `get_run`; confirm `script_ready` and `continue`.
2. Call `get_authoring_snapshot`; capture its fresh revision.
3. Approve the Script with one `advance_run` using that `expected_revision` and a new key.

Poll `get_run` with bounded intervals. Honor `Retry-After` or `retry_after_seconds`. When
`waiting_images` permits `continue`, first read fresh state; callbacks may already have promoted the
run. Use a new reconciliation key only for a genuinely new advance.

Do not treat run child status alone as per-slide readiness. At `image_ready`, fetch a new snapshot
and require every slide's canonical generation state to be complete.

## Follow the vision capability branch

Check both:

- the server's image-content/protected-resource capabilities;
- whether the current Agent can actually consume MCP image/resource content.

If both are true:

1. Call `get_slide_review_sheet` in ordered batches of no more than six indexes; use
   `get_slide_preview` only where more detail is needed.
2. Inspect the MCP-native image content returned by the tool. If the Agent host exposes only its
   resource link, load that protected resource instead.
3. Apply the full-deck review in `visual-quality.md`.
4. Fix content first where needed, then call `get_run` and `get_authoring_snapshot` again.
5. Call `regenerate_slide_images` once with the complete failed index subset, that fresh snapshot's
   `expected_revision`, one new key, and one `slide_instructions` entry for each slide whose visual
   defect needs a concrete correction. Each entry contains the zero-based `slide_index` and a
   bounded `additional_instructions` string. State the observed defect and required visual
   boundary (for example, “do not depict a meter, probe, numeric reading, or threshold”); do not
   submit a blind redraw when the failure is understood.
6. Poll each target slide to completed state and re-run a sheet for the changed subset.

If the run moved to `config_preparing` or `publish_blocked` before review finished, or a still-
unpublished `image_ready` run must re-enter review, fetch a current revision and call
`reopen_image_review` when allowed. Never force durable state.

For a genuinely reviewed deterministic replacement, request an upload ticket with:

- `purpose=reviewed_slide_replacement`;
- the run/project/slide target;
- current `expected_revision`;
- exact image metadata and checksum.

After handoff, reconcile `get_upload_status` and selected image/version state. Re-inspect the
selected result when the Agent has vision. Do not retry an ambiguous upload until reconciliation.

If the Agent declared `none`, the server does not pause for image review. Do not call previews
merely to claim visual review; report the returned `not_performed` reason.

## Optional deliberate casting and configuration

Call `list_presenters` with the project's concrete language, a bounded `limit` (maximum 20), an
`offset`, and only relevant optional appearance filters. Page through `total` only as needed; do
not inject the entire unfiltered catalog into one Agent turn. Require:

- `is_profile_complete=true`;
- exactly compatible target-language `voice_defaults`;
- the selected mapping has `is_ready=true`;
- an exact backend and `voice_id` or `voice_plane_voice_id`.

With vision, call `get_presenter_preview` for every serious candidate and inspect its MCP-native
image plus the exact mapping. If the Agent host does not expose inline image content, inspect the
protected resource instead. Use appearance metadata only as observable casting information; never
infer biography, nationality, identity, or personality.

Without vision, make no appearance claims. Use structured language/Voice readiness and a deliberate
system default or metadata-based selection.

Call `select_presenter` with exactly one `avatar_id` or `use_default=true` and a stable idempotency
key. Then call `get_run` and `get_authoring_snapshot` before
`get_course_configuration`; require the persisted avatar, backend, Voice lane, and non-empty
delivery instruction to match the selected compatible pair.

Use the returned configuration revision for requested updates:

- `update_course_configuration`: `dh_layout`.

Each call needs at least one actual change, the fresh `expected_revision`, and a new idempotency key.
Read configuration again after each accepted update.

## Observe server-side finish and distribution

Before publication, call `get_run`, `get_authoring_snapshot`, and `get_course_configuration` after
the latest mutation.
Confirm:

- no unresolved content/source/safety finding;
- every slide image is canonically complete;
- presenter/Voice and requested configuration persist;
- the desired target remains within the normal non-administrative course workflow;
- `first_publish` or `continue` is freshly allowed.

Visual review may be `not_performed`; that is honest evidence and not a server permission gate.

After approving the last required review, poll `get_run` according to `poll_after_seconds`. The
server completes configuration, compliance, CDN narration, first publish, visibility, and optional
Topics submission using the stored target and rechecks the live OAuth grant before mutations. Use
explicit publish/visibility tools only for repair when fresh state allows them; do not race the
orchestrated finish.

Target behavior:

- **draft**: finish generation/configuration and leave unpublished.
- **private**: first-publish and keep `private`.
- **link**: first-publish, set `unlisted`, and verify link playability.
- **topics_review**: require an explicit user request, complete link access, then submit for review.

For Topics submission, `message` is optional and should explain the review request concisely.
`advisory_hub_id` is only a non-binding hint when a real known ID was supplied; never invent it.
Call `get_topic_review` to report the latest status. Submission does not choose a Hub or grant
approval.

After `first_publish`, call `get_run` before a visibility mutation. After publication/visibility,
call `get_run` and `get_course`. Report `public_url` and `embed_url` only when `playable=true`. A
slug alone does not prove playability.

## Legacy fallback

If `start_course_creation` or orchestrated capability is absent, use `create_course` with
`stop_after=outline_ready` and the older bounded `advance_run` sequence. One legacy Narration
mutation may perform only one Page-text/Narration operation, so always read fresh state between
advances. Never choose this slower path when the connected server advertises orchestration.

## Query courses

Use `list_courses` for bounded metadata search. Available filters:

```text
q
title_contains
description_contains
public_slug
status[]
visibility[]
language
knowledge_source_mode
run_status[]
checkpoint[]
created_at_gte / created_at_lt
updated_at_gte / updated_at_lt
first_published_at_gte / first_published_at_lt
origin
sort
direction
limit
cursor
```

Time windows are half-open and timezone-aware. Sort supports `created_at`, `updated_at`,
`first_published_at`, or `name`; direction is `asc` or `desc`; limit is 1–100.

Default `origin=integration`. The public `courses:manage` connection also permits `owned` or `all`
metadata discovery. Courses outside this authorization's mutable boundary remain metadata-only.

When following an opaque cursor, preserve every original filter, origin, sort, and direction. Do
not invent offsets or an exact total. Use `get_course` for one bounded metadata record and
`get_authoring_snapshot` only for an authorization-owned editable course.

## Recover safely

| Signal | Action |
|---|---|
| Lost response or timeout | Read fresh state, then replay the exact payload with the same idempotency key only when state does not already prove completion. |
| Revision conflict | Fetch a fresh snapshot/configuration, merge real changes, and use a new key for a changed payload. |
| 401 | Let the client refresh once; if rejected, reauthorize through OAuth, then read state before resuming. |
| 403 / insufficient scope | For `courses:manage`, treat a normal workflow scope failure as a revoked/invalid connection or contract defect; do not ask for another incremental permission. A legacy limited grant may be replaced once with the current full-access consent. |
| Insufficient credit | Stop and report the exact organization credit blocker; do not purchase automatically. |
| Source not ready | Poll, then use `retry_source` or `detach_source` only when allowed. |
| Pin unsupported | Stop for an explicit product choice; do not downgrade silently. |
| 429 | Honor `Retry-After`; reduce concurrency and avoid tight loops. |
| Retryable dependency failure | Confirm recovery, then call `retry_run` only if fresh actions include `retry`. |
| First-publish-only conflict | Stop; this public workflow cannot republish. |
| Presenter has no ready target-language Voice | Choose another reviewed compatible pair or report a blocker. |
| Publish validation failure | Resolve the returned requirements without direct state changes, then replay the same logical publish operation. |

Use `cancel_run` only when the user requests stopping or continuation is no longer authorized.
Cancellation is cooperative: poll until `cancelled` or another terminal safe state.

## Completion evidence

Report:

- course identity, audience, language, class/archetype, knowledge mode, and page count;
- run/project IDs and final `status`/`checkpoint`;
- source counts and statuses;
- revisions and objective content changes;
- per-slide image readiness and visual review status;
- regenerated/replaced slide indexes;
- presenter/Voice/configuration values;
- publish result, visibility, and `playable`;
- public/embed URLs only when playable;
- Topics review status only when requested;
- any remaining blocker and its exact safe error.

Never report completion from an earlier requested state when the current durable state says
otherwise.
