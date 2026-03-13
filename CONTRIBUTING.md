# Contributing

This repository now uses a spec-first workflow for product and engineering
work. You must capture the intent, scope, constraints, and verification plan in
writing before you start non-trivial implementation.

## Development model

This section explains the artifacts that drive work in this repository. The
model is intentionally small so it can stay useful while the project is still
moving quickly.

- `specs/foundation/`: stable product and engineering baseline documents
- `specs/roadmap.md`: prioritized product tracks and current status
- `specs/tracks/<track-slug>/spec.md`: feature or change specification
- `specs/tracks/<track-slug>/plan.md`: implementation plan and task checklist
- `CHANGELOG.md`: user-visible changes that have shipped or are in progress

## When you must write or update a spec

This section defines the threshold for spec work. If a change affects the
product, architecture, or long-term maintenance of the app, it must start with
spec updates.

You must add or update a track spec before writing code when a change does any
of the following:

- Adds or removes a user-visible feature
- Changes navigation, layout behavior, or adaptive UI structure
- Changes persistence, caching, downloads, or recommendation logic
- Changes networking behavior, offline behavior, or third-party service usage
- Changes permissions, privacy behavior, or App Intents behavior
- Introduces a new dependency, subsystem, or architectural pattern

You can skip a new track spec only for very small changes, such as typo fixes,
comment cleanup, or narrow bug fixes that do not change behavior outside one
local area. Even then, you must keep the roadmap and changelog accurate when
relevant.

## Required workflow

This section defines the default sequence for work in this repository. Use this
flow unless the task is explicitly trivial.

1. Update `specs/roadmap.md` so the work has an explicit priority and status.
2. Create or update `specs/tracks/<track-slug>/spec.md` with goals,
   non-goals, requirements, risks, and acceptance criteria.
3. Create or update `specs/tracks/<track-slug>/plan.md` with concrete phases,
   tasks, and verification steps.
4. Review the spec against the current implementation before touching code.
5. Implement the change in small commits that still map back to the track.
6. Run the relevant verification steps, including tests and manual checks.
7. Update `CHANGELOG.md` when the change is user-visible.
8. Mark the roadmap and track status accurately after the work lands.

## Spec quality bar

This section defines what makes a spec usable. A short spec is fine, but it
must still be concrete enough that implementation and review are unambiguous.

Every track spec must answer these questions:

- What problem is being solved now
- Which user or product outcome matters
- What is explicitly out of scope
- Which screens, models, services, or flows are affected
- Which constraints come from iOS, SwiftUI, SwiftData, privacy, or current app
  architecture
- How success is verified

A spec is not ready if it contains only broad goals such as "improve
experience" or "optimize performance" without measurable outcomes or concrete
behavior changes.

## Implementation rules

This section connects the spec process to the current codebase. These rules are
project-specific, so they must be enforced alongside the spec workflow.

- Keep one shared product logic path whenever possible. Do not fork feature
  logic separately for iPhone and iPad unless the requirement demands it.
- Keep device-specific differences at the layout layer. Share models, stores,
  services, and recommendation logic.
- Use modern Swift concurrency and actor isolation for async work.
- Keep SwiftData model changes explicit in specs because they affect migration
  and local state.
- Add or update tests when you change recommendation logic, persistence, or any
  behavior that can regress silently.
- Keep `project.yml` as the project source of truth and regenerate the Xcode
  project after structural changes.

## Verification rules

This section defines the minimum verification expected before a track is marked
complete.

- Run a command-line build for app-level or project-level changes.
- Run unit tests for any logic touched by the change.
- Add manual verification steps for UI, adaptive layout, permissions, and
  simulator behavior.
- Record known gaps or deferred items in the track spec instead of leaving them
  implicit.

## Next steps

Use the documents in `specs/` as the active operating system for this
repository. When you start the next feature, begin by updating the roadmap and
creating a new track from the templates.
