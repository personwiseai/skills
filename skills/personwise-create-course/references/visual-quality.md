# Capability-aware visual quality

## Decide whether visual review is possible

Check two independent capabilities:

1. The MCP reports `supports_image_content` or `supports_protected_image_resources`.
2. The current Agent can actually load and understand the returned MCP image/resource content.

If either is false, use the non-vision path. Never infer visual quality from filenames, alt text,
dimensions, generation status, or an image URL.

Record one honest result:

- `completed`: every slide and every serious presenter candidate required by the workflow was
  inspected, and all findings were resolved;
- `partial`: some content was inspectable but the full required set was not;
- `not_performed`: the Agent could not consume the visual content.

This status is completion evidence, not a publish permission or MCP attestation. The server does not
require visual review for first publish.

## Vision-capable full-deck review

At canonical `image_ready`, call `get_slide_review_sheet` with ordered batches of at most six
zero-based slide indexes. This replaces one authorization/tool round trip per page while retaining
protected-media rules. Use `get_slide_preview` for any page that needs closer inspection. Cover
every page; sample-only review is insufficient.

Keep a page ledger:

```text
index | title | intended visual job | Reference/Pin expectation
text fidelity | semantics/facts | layout/legibility | preservation
result | corrective change | regeneration key | recheck
```

For every slide, inspect:

- semantic and factual alignment with title, Key points, Page text, Narration, and sources;
- visible text fidelity, spelling, hierarchy, size, overlap, clipping, and table legibility;
- whether the visual actually explains the intended mechanism, process, comparison, evidence, or
  interpretation;
- useful deck-level variety without style drift or duplicated composition;
- invented numbers, charts, quotations, maps, artifacts, customers, logos, UI, workflow states, or
  source-looking material;
- unsafe advice, inappropriate imagery, watermarks, and intellectual-property problems;
- Reference-image influence without unwanted subject leakage;
- Pin preservation against the supplied source.

Treat icons and composition as claims:

- a checkmark or green status implies success;
- a padlock implies security;
- a rising chart implies growth;
- a dashboard implies observed data or interface;
- an archival/photo/document treatment implies a real artifact.

Reject unsupported implications even when printed words are accurate.

Pin is a strong generation instruction, not deterministic compositing. Compare the supplied Pin and
result side by side. If regulated pixel identity is required, stop and request an authorized
deterministic asset workflow.

## Correct and regenerate

Fix factual or content causes before regenerating:

1. Fetch a fresh authoring snapshot.
2. Apply the smallest aligned `update_slides` batch.
3. Fetch the new revision.
4. Put the complete failed slide-index subset in one `regenerate_slide_images` call. Add a
   `slide_instructions` entry for every understood visual failure, pairing its zero-based
   `slide_index` with concrete `additional_instructions` that exclude the observed defect.
5. Poll each target's own canonical generation state; run-level image status is insufficient.
6. Call `get_slide_review_sheet` for the regenerated subset (or individual preview for detail) and
   inspect again.
7. Repeat only for concrete unresolved findings.

Do not split one intended failed subset into many single-slide requests. A regeneration without
`slide_instructions` is appropriate only when content changed and no separate visual defect remains
to describe. Do not use regeneration as prompt-lottery after the same unsupported pseudo-interface,
metric, or workflow state repeatedly returns.

## Use a reviewed replacement narrowly

Use `reviewed_slide_replacement` only when a human or vision-capable Agent has genuinely reviewed
the exact PNG, JPEG, or WebP asset and it is safer than another generated attempt.

Before upload:

- correct the underlying Title, Key points, Page text, and Narration;
- verify 4:3 composition and every visible fact/text element;
- fetch the current snapshot and revision;
- capture the target slide's selected image/version state.

Request one bounded upload ticket with the target and `expected_revision`. The upload is one-use and
not idempotent. After a timeout, inspect `get_upload_status` and the fresh selected version before
requesting another ticket.

When vision is available, call `get_slide_preview` and re-inspect the selected replacement. A
successful upload response alone is not a visual pass. Do not use a replacement to hide a bad
lesson, unsupported claim, or missing source.

## Review presenter candidates

First use `list_presenters` to establish exact target-language Voice readiness. With vision, call
`get_presenter_preview` for every serious candidate and inspect:

- perceived formality, warmth/authority, energy, expression, clothing, and framing;
- fit with the learner and teaching job;
- consistency between the visible presenter and the intended Voice delivery;
- exact compatible target-language Voice mapping.

Treat these as casting heuristics, not identity or biography. Appearance-region, age, hair, skin,
role, and expression metadata do not establish nationality, ethnicity, profession, personality, or
life history.

Select the best complete image-and-Voice pair, not an image with an unrelated Voice.

## Non-vision path

When the Agent cannot understand image content:

- require canonical completed generation state for every slide;
- do not claim that text, layout, semantics, variety, Reference influence, or Pin preservation
  passed;
- do not regenerate based on fabricated findings;
- do not upload an allegedly reviewed replacement;
- select a presenter only from structured active/profile/language/Voice compatibility, using the
  deliberate default when appropriate;
- make no presenter appearance or cultural-fit claim;
- record visual review as `not_performed`;
- continue configuration and authorized publication from structured state.

Missing vision alone must not remove a legal `first_publish` action or become an invented user
approval gate.

## Reopen review when necessary

If an unpublished run moved to `config_preparing` or `publish_blocked` before visual work finished,
or a still-unpublished `image_ready` run needs correction, fetch the fresh revision and use
`reopen_image_review` only when allowed.

Never edit durable state directly. After reopening, correct content, regenerate the exact failed
subset, and re-inspect it before completing the final target.
