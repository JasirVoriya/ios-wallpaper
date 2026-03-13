# WallpaperApp Constitution

## Core Principles

### I. Shared product logic, adaptive presentation
WallpaperApp MUST keep feature logic shared across iPhone and iPad whenever
possible. Device-specific differences belong at the layout and navigation layer,
not in duplicated business rules, recommendation logic, or persistence flows.
Any change that forks logic by device MUST justify why a shared path is not
sufficient.

### II. Spec-first delivery
Non-trivial work MUST begin with a written spec before implementation starts.
The minimum path is: define or update the product baseline, create a numbered
feature spec under `specs/`, clarify ambiguous requirements, and create an
implementation plan before code changes land. Small typo fixes and narrowly
local bug fixes may skip a new feature spec, but they MUST still preserve the
constitution.

### III. Modern Swift concurrency and actor isolation
Async behavior MUST use modern Swift concurrency patterns. Long-running or
shared mutable work MUST be isolated behind actors or explicit main-actor
boundaries. Synchronous disk or network work on the main actor is a violation
unless there is a narrow, documented reason.

### IV. Local-first privacy and explicit permissions
WallpaperApp MUST keep user preferences, favorites, download history, and any
future personalization state on device unless a spec explicitly introduces cloud
behavior. Permission-gated features MUST define denial, failure, and recovery
states. The app MUST not imply it can bypass iOS privacy restrictions, such as
setting the system wallpaper automatically.

### V. Verifiable quality gates and one project source of truth
Every meaningful change MUST be verifiable with explicit build, test, and
manual checks that match the affected scope. Recommendation, persistence,
caching, and permissions behavior require automated coverage where regressions
can hide silently. `project.yml` remains the authoritative project
configuration source, and structural changes MUST regenerate the Xcode project.

## Product and Platform Constraints

WallpaperApp is an iOS-only SwiftUI application for iPhone and iPad. The current
technical baseline is Swift 6.2, Xcode 26.3 or later, SwiftData for local
persistence, and XcodeGen as the project configuration source. The current
remote wallpaper source is Picsum. Any feature that changes platform support,
storage shape, privacy behavior, or remote-source strategy MUST document that
change in the corresponding feature spec and plan.

## Development Workflow

Feature work follows the Spec-Kit sequence:

1. Keep the baseline documents in `specs/foundation/` and `specs/roadmap.md`
   current.
2. Create a numbered feature branch and matching spec directory such as
   `specs/001-example-feature/`.
3. Write or update `spec.md`, then resolve critical ambiguity before planning.
4. Create `plan.md` and any supporting design artifacts before implementation.
5. Generate or maintain `tasks.md` so implementation can proceed in clear,
   reviewable slices.
6. Update `CHANGELOG.md` for user-visible shipped behavior.

## Governance

This constitution supersedes ad hoc workflow preferences for this repository.
Every feature spec, plan, and implementation review MUST be checked against it.
Amendments require updating this file and any affected baseline documents in the
same change.

**Version**: 1.0.0 | **Ratified**: March 13, 2026 | **Last Amended**: March 13, 2026
