# Specs

This directory is the source of truth for planned product and engineering work
in WallpaperApp. It gives you a stable place to define what the app is, what is
next, and how each non-trivial change must be implemented and verified.

## Directory structure

This section explains how the spec set is organized. The structure is small on
purpose so it stays usable as the project grows.

- `foundation/`: living baseline documents that describe the current product,
  technical constraints, and engineering rules
- `roadmap.md`: prioritized tracks, status, and sequencing decisions
- `templates/`: starting points for new track specs and implementation plans
- `tracks/<track-slug>/spec.md`: requirements and acceptance criteria for one
  track
- `tracks/<track-slug>/plan.md`: phased task list and verification plan for one
  track

## Track lifecycle

This section defines the normal status flow for work. Keep statuses current so
it is obvious what is ready, active, blocked, or complete.

1. Create or update a roadmap entry and mark it `proposed`.
2. Write `spec.md` and move the track to `approved` once scope is clear.
3. Write `plan.md` and move the track to `in-progress` when implementation
   starts.
4. Mark the track `shipped` after code, tests, and manual verification land.
5. Mark the track `abandoned` if the work is intentionally stopped.

## Naming rules

This section keeps track names consistent so they remain readable in commits,
branches, and changelog entries.

- Use lowercase kebab-case for track directories
- Name a track after the user or system capability being added or changed
- Prefer names such as `offline-wallpaper-caching` over names such as
  `feature-3`

## Quality gates

This section defines the minimum quality bar for track documents. A track is
not ready for implementation until these gates are met.

- `spec.md` has clear goals, non-goals, and acceptance criteria
- `plan.md` has phased tasks that map to the codebase
- Risks, open questions, and deferred work are explicit
- Verification covers build, test, and manual UI checks where relevant

## Current baseline

This section points you to the documents that describe the current state of the
project.

- Start with [product-spec.md](./foundation/product-spec.md) for the current
  app definition
- Use [roadmap.md](./roadmap.md) for priorities and active tracks
- Use the templates in `templates/` when you start a new track

## Next steps

When you start the next feature, copy the templates into a new track directory,
fill them with project-specific detail, and update the roadmap before writing
code.
