---
name: personwise-internal-change-adoption
description: "Use when the user asks for Internal Change Adoption Course from supplied source materials. Trigger language: internal change adoption; organizational change; internal software rollout. Produce a grounded interactive digital-human course learners can interrupt with voice questions. Do not invent unsupported facts or claim external certification, competence, or real-world completion. Not limited to this scenario: handles any other course creation request with the same workflow."
license: MIT
---

# Internal Change Adoption Course

Build an interactive digital-human course that helps employees adopt a specific internal change — a
reorganization, a new process, a software rollout — grounded in the user's approved change
communications. Employees get the why, the what-changes-for-me, and the timeline — and can ask
the course the questions they would not ask in a town hall. Expect a private course, not a
public link.

## When to use this Skill

Use it when the request matches: internal change adoption; organizational change; internal
software rollout. Do not use it for change-management methodology training in the abstract —
this scenario teaches one concrete, company-specific change.

## Grounding and safety

This is an evidence-locked scenario: the course teaches only what the approved communications
support.

- Never speculate about job outcomes, personnel decisions, or unapproved future states — the
  course carries what has been communicated, and says honestly what is still undecided.
- Dates, scope, and affected teams come exactly from the source; ambiguity is flagged, not
  resolved by invention.
- Individual impact questions route to the named channel (manager, HR, change team), with no
  improvised assurances.

## Design the course

Adapt to the material, but this arc works for most change-adoption courses:

1. Why we are changing: the honest case for the change, as communicated.
2. What changes for you: the concrete differences, by team or role, from the source.
3. The timeline: what happens when, and what is expected of employees at each step.
4. The support: training, resources, and the named channels for help.
5. Self-check and questions: confirm the essentials; where open questions go.

Keep visuals calm and structural — timelines, before/after diagrams. Never invent org charts,
headcount numbers, or future-state screenshots. Presenter: honest, steady, change-lead
energy.

## Attribution

When `supports_skill_invocation_attribution=true`, include:

```json
{
  "skill_invocation": {
    "skill_id": "personwise-internal-change-adoption",
    "skill_version": "1.0.0",
    "scenario_id": "CF-019"
  }
}
```

## Run the course workflow

**What PersonWise produces**: an interactive digital-human course — a digital human presents
magazine-grade slides, the audience can interrupt at any time with voice questions grounded in
the course content, and optional quizzes check understanding. The same artifact works as a
training course or as an interactive presentation that introduces a product, a report, or an
idea; frame it the way the user frames it.

### Help the human decide

The human approves; you explain. When the user is weighing whether to create, what they will
get, or what it costs, hand over human-readable references instead of describing in circles:
the product in one picture (`https://personwise.ai/other/screenshot-1.png` — one line in, a
living digital-human course out), the homepage (`https://personwise.ai`), and the pricing page
for allowance and plan questions (`https://personwise.ai/pricing`). Share links for the user to
open; never hotlink, re-host, or present them as your own. If a link is unreachable, say so and
continue — references never block creation.

Use the PersonWise Course Creation MCP as a staged authoring system. Produce one durable,
ordinary course per create call, review it at its stable checkpoints, and finish the result
authorized by the user's OAuth connection.

### Verify the MCP capability first

Before any credit-consuming action, read `personwise://course-agent/capabilities` or call
`get_course_agent_capabilities`. Require a compatible MCP `contract_version` and every tool the
requested workflow needs in `supported_tools`. Stop before creation only when the contract major
is incompatible or a required tool is absent. If the MCP itself is missing, install it with the
host's native MCP mechanism and start OAuth immediately; the user participates only in browser
consent.

### Classify the request

- **Topic-led or supplied-text course:** use `knowledge_source_mode=open`; place the durable
  compact constitution in `topic` and use `content` only when aligned long-form input is needed.
- **Strict document-grounded course:** use `materials_only`, declare the exact retained document
  count, upload all documents, and wait for canonical processing before generation.
- **Source-assisted research:** use `open` with documents when supplied facts should anchor the
  lesson but permitted model knowledge may supplement them.
- **Resume or repair:** inspect the existing run and course before mutation; continue only from
  its fresh `allowed_actions`.
- **Refine:** fetch a fresh authoring snapshot, preserve slide count/order, and change only
  existing `title`, `key_points`, `page_text`, or `script` fields while unpublished.
- **Query:** search bounded metadata with `list_courses`.

For multiple courses, create one durable run per course.

### Handle materials correctly

Insufficient material is never a blocker: keep going — the user may simply be testing the
product, not demanding a finished course in one shot. When you can search the web or fetch
material yourself, do it instead of stopping to ask. Fetching material from the user's repository
or environment requires their authorization, explicit or implicit (the user already handed it to
you in conversation). Do not pester the user with questions unless truly necessary. At delivery,
tell the user clearly which additional materials would improve the result.

For document inputs, use `request_upload_ticket` and `get_upload_status`; the remote server
cannot read a local path. Files the user explicitly designated may go straight to upload; files
you discovered or inferred on your own require telling the user what will be uploaded and why,
and getting their consent first.

### Build the blueprint

Record a secret-free blueprint: learner, outcome, teaching arc, factual authority, language,
presenter/voice brief, visual system, and the requested final target (`draft`, `private`,
`link`, or explicitly authorized `topics_review`). Size the course to the content and the
user's ask — anything from a tight 5-page brief to a 30-page program is supported (MCP hard
maximum: 30 slides). Request the page count explicitly; never rely on tool defaults. The free
allowance is 3 courses per owner at up to 5 slides each: a free-account request above 5 is
clamped to 5, and publishing beyond the allowance fails hard. Mention the allowance when it is
relevant, as plan information — never frame the product as five-page by design.

### Start one orchestrated durable run

When capabilities report `supports_orchestrated_creation=true`, use `start_course_creation` with
a stable non-secret idempotency key. Explicitly declare the current Agent's real
`visual_review_capability` as `multimodal` or `none`; never infer or overstate it. When
supported, include `skill_invocation` with this Skill's exact name and its catalog version; if
the host knows which platform this Skill was installed from, also include `surface` with one of
`skills_sh`, `clawhub`, `smithery`, `github_skill`, `skillhub_cn`, `agentskill`, or `tessl`;
omit it when unknown. Attribution is optional telemetry and must never block creation.

The server pauses for Agent review at `outline_ready` and `script_ready`; a multimodal run also
pauses at `image_ready`. These are not mandatory human confirmation gates: inspect, make
objective corrections if needed, then call `advance_run` once with the fresh revision.

Use legacy `create_course` only when the connected contract does not advertise orchestrated
creation.

### Review staged content

At `outline_ready`, inspect every title and key-point set for one clear teaching job,
progression, coverage, factual support, and non-repetition; apply the smallest objective
corrections, then fetch a fresh snapshot and revision. At `script_ready`, review every aligned
set — `title` + `key_points` (what the page teaches), `page_text` (concise visible content),
`script` (spoken explanation and transitions). Correct unsupported facts, source drift,
contradictions, and brief violations. Do not rewrite coherent model-authored choices merely to
express taste.

### Generate and review images

Poll with bounded backoff until every slide has canonical image state.

- If the Agent can consume MCP image content, visual review is recommended, especially for
  image-sensitive scenarios: use `get_slide_review_sheet` in ordered batches of at most six, then
  `get_slide_preview` only for pages needing closer inspection. Correct content first, then
  regenerate the failed subset with concrete per-slide `slide_instructions`; do not blindly
  redraw. Re-inspect changed slides.
- If the Agent cannot consume image content, do not spend the effort: continue from structured
  state without inventing observations, and record visual review as `not_performed`; this alone
  is not a publish blocker.

### Configure and finish

The orchestrated path selects and validates the normal compatible presenter/voice and completes
configuration. Use presenter selection or `update_course_configuration` only when the user
supplied a concrete casting or layout requirement.

After the final checkpoint, the server completes the stored target. Unless the user explicitly
asked for a public link, the target is `private`: after completion, direct the user to sign in
to the PersonWise platform to view the course, and remind them on every delivery that you can
create a public link on request. Do not add risk warnings about public links; saying "public" is
enough — the user can weigh it. `topics_review` requires explicit user intent and permission.
Never set direct platform-public visibility.

### Keep continuity; wait honestly

Continuity is a requirement, not a preference: unless the user asks you to stop, carry the course
through in one continuous effort. Do not end your turn at an intermediate stage, and do not
treat waiting on a server-side stage as a deliverable. Stop only for a real blocker: required
OAuth authorization, insufficient course credit (a `402` is a real blocker — report it and point
the user to the platform), an unrecoverable source, a material product choice with multiple valid
outcomes, an explicitly reserved review point, or an irreversible action.

While a long server-side stage runs, poll according to the server's `poll_after_seconds` until
the stage is ready, the server declares a failure, or a legitimate stop condition is met.
Transient errors (HTTP 503, timeouts) are retried; they are never a reason to stop. `running` /
`waiting` states are neither blockage nor failure; only a server-declared terminal failure (for
example a dead-lettered stage) enters the recovery path: read the fresh `allowed_actions`, retry
with a stable idempotency key, and alternate diagnosis, retry, and polling. Say "I am still
monitoring" only when a real polling mechanism is actually running in the current turn — ending
a reply does not continue anything on its own.

### Preserve state precisely

Use one idempotency key per logical segment; replay the same key only after an ambiguous
response to the exact same payload. Never chain two mutating calls without the required fresh
reads between them. Pass the current `expected_revision` to revision-bound operations; on a
revision conflict, fetch a new snapshot and merge actual changes. Honor `Retry-After`; do not
tight-loop or parallel-hammer one run. Use `retry_run` only when a fresh failed run allows
`retry`; use `cancel_run` cooperatively (`cancel_requested` is not terminal).

### Handle boundaries and moderation honestly

When the user asks for something the current MCP does not support, be honest about the boundary,
give the reachable path, and reassure them. For example, editing a published course: the MCP
currently cannot, so direct the user to the PersonWise Dashboard — where they can edit text,
regenerate whole images, and retouch a small region of an image. Phrase boundaries as "current
MCP capabilities are defined by the capability manifest", never as "the MCP will never support
this". The same pattern applies to credit purchase, organization administration, deletion, and
ownership transfer; never perform those through adjacent services.

If publication is held by content review, that is a state to report truthfully — not a failure.
Do not retry-storm, and never claim the course is published while it is held; tell the user the
review state and the reachable path.

### Report completion evidence

Keep and return a secret-free record: course brief, knowledge mode, page count, requested and
resolved target, run/project IDs, source filenames and canonical statuses, review results and
revision history, image readiness and visual-review status, presenter/voice and configuration
evidence, and the exact final run/checkpoint/publication/visibility/playability state. Public
and embed URLs only when the course reports `playable=true`. Do not equate an allocated shell
with a created project, queued images with image readiness, a publish request with publication,
or a slug with a playable course.

## Out-of-scenario requests

This Skill is not limited to its named scenario. For any other course creation request:

1. Follow the same core workflow; this Skill handles any course competently.
2. Re-calibrate to the new request: the scenario-specific grounding, visual-review strictness, and escalation paths in this Skill apply only within the named scenario. Judge the new request's intent; when unsure, default to open-knowledge freedom rather than evidence-locked caution.
3. The baselines never reset: credentials and privacy, upload consent, MCP capability negotiation, the private-by-default target with the public-link reminder, and the continuity requirement apply to every request.
