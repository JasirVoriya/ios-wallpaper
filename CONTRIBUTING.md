# Contributing

WallpaperApp now uses GitHub Spec-Kit as its default workflow for non-trivial
product and engineering changes. If a change affects behavior, architecture,
persistence, offline support, recommendations, permissions, or adaptive UI, it
must start with Spec-Kit artifacts before implementation begins.

## Workflow artifacts

This section explains where the repository's planning and governance documents
live.

- `.specify/memory/constitution.md`: repository constitution and non-negotiable
  engineering rules
- `.specify/templates/`: Spec-Kit templates used to generate feature artifacts
- `.codex/prompts/speckit.*`: Codex prompt entry points for the Spec-Kit phases
- `specs/foundation/`: stable baseline documents about the current product
- `specs/roadmap.md`: top-level priority list for upcoming features
- `specs/NNN-feature-name/`: numbered feature specs, plans, and task artifacts
- `CHANGELOG.md`: user-visible shipped and in-progress change history

## When a spec is required

You must use the Spec-Kit flow before implementation when a change does any of
the following:

- Adds or removes a user-visible feature
- Changes navigation, layout behavior, or adaptive UI structure
- Changes persistence, caching, downloads, or recommendation logic
- Changes networking behavior, offline behavior, or third-party service usage
- Changes permissions, privacy behavior, or App Intents behavior
- Introduces a new dependency, subsystem, or architectural pattern

Small typo fixes, comment cleanup, and narrowly local bug fixes may skip a new
feature spec, but they still must respect the constitution.

## Required feature flow

Use this sequence for normal feature work:

1. Update `specs/roadmap.md` if priorities or status changed.
2. Create a numbered branch and feature directory with Spec-Kit.
3. Write or update `spec.md` for the feature.
4. Resolve critical ambiguity before planning.
5. Create `plan.md` and supporting design artifacts before code changes.
6. Create or update `tasks.md` so implementation can proceed in clear slices.
7. Implement the feature and run the relevant verification steps.
8. Update `CHANGELOG.md` and roadmap status when the feature ships.

## Project-specific engineering rules

- Keep one shared product logic path whenever possible. Device-specific
  differences belong at the layout layer.
- Use modern Swift concurrency and actor isolation for async and shared mutable
  work.
- Keep SwiftData changes explicit in specs because they affect migration and
  local state.
- Add or update tests when you change recommendation logic, persistence,
  caching, or permissions behavior.
- Keep `project.yml` as the project source of truth and regenerate the Xcode
  project after structural changes.

## Verification rules

Before a feature is considered complete:

- Run a command-line build for app-level or project-level changes.
- Run relevant unit tests for touched logic.
- Add manual verification for adaptive UI, permissions, simulator behavior, and
  offline flows when relevant.
- Record known gaps or deferred items explicitly in the feature artifacts.

## Next steps

Use the numbered feature directories under `specs/` as the canonical path for
future work. Keep the constitution and roadmap honest as the app evolves.
