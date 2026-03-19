# Tasks: Multiplatform architecture

**Input**: Design documents from `/specs/002-multiplatform-architecture/`  
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Add shared domain tests plus thin iOS and macOS smoke checks for the
new shell and capability boundaries.

**Organization**: Tasks are grouped by user story so implementation can land in
reviewable slices.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel when files do not overlap
- **[Story]**: Which user story the task belongs to, for example `US1`

## Phase 1: Setup (Shared scaffolding)

**Purpose**: Establish target, directory, and dependency boundaries before code
moves.

- [x] T001 Update `project.yml` to define shared, iOS, and macOS target
      scaffolding.
- [x] T002 Create `WallpaperShared/`, `WallpaperiOS/`, and `WallpaperMac/`
      source roots.
- [x] T003 [P] Create shared and platform test target scaffolding in
      `WallpaperSharedTests/`, `WallpaperiOSTests/`, and `WallpaperMacTests/`.

---

## Phase 2: Foundational (Blocking prerequisites)

**Purpose**: Move domain logic into a shared core and define platform
capability seams.

**⚠️ CRITICAL**: No platform-shell work should begin until these boundaries are
stable.

- [ ] T004 Move shared models into `WallpaperShared/Models/`.
- [ ] T005 Move shared services and recommendation logic into
      `WallpaperShared/Services/`.
- [ ] T006 Move shared persistence support into `WallpaperShared/Persistence/`.
- [ ] T007 Define platform capability protocols in
      `WallpaperShared/PlatformProtocols/`.
- [ ] T008 [P] Add shared domain tests for recommendation, persistence, and
      cache-ready service boundaries in `WallpaperSharedTests/`.
- [ ] T009 Create platform-specific service composition roots in
      `WallpaperiOS/App/` and `WallpaperMac/App/`.

**Checkpoint**: Shared core exists and both shells can depend on it.

---

## Phase 3: User Story 1 - Use a native wallpaper app on Mac (Priority: P1) 🎯 MVP

**Goal**: Ship a true macOS shell for the current core flows.

**Independent Test**: Build and launch the macOS target, then browse discovery,
wallpaper detail, favorites, and settings with Mac-native navigation and
actions.

### Tests for User Story 1 ⚠️

- [ ] T010 [P] [US1] Add macOS smoke tests for shell launch and primary
      navigation in `WallpaperMacTests/`.

### Implementation for User Story 1

- [ ] T011 [US1] Create the macOS app entry and scene composition in
      `WallpaperMac/App/`.
- [ ] T012 [US1] Create macOS navigation and window scaffolding in
      `WallpaperMac/Navigation/`.
- [ ] T013 [US1] Implement Mac versions of discovery, detail, favorites, and
      settings views in `WallpaperMac/Views/`, backed by the shared core.
- [ ] T014 [US1] Implement macOS capability adapters for save, share, and
      source-open behavior in `WallpaperMac/Platform/`.
- [ ] T015 [US1] Remove or rewrite iOS-specific copy and actions that do not
      apply on macOS.

**Checkpoint**: The Mac app is functional as a native shell for current flows.

---

## Phase 4: User Story 2 - Keep iPhone and iPad polished while the app grows to Mac (Priority: P2)

**Goal**: Preserve the current iOS and iPad quality while consuming the shared
core.

**Independent Test**: Build the iOS target and verify iPhone and iPad core
flows remain intact after the shared-core extraction.

### Tests for User Story 2 ⚠️

- [ ] T016 [P] [US2] Add iOS smoke tests for adaptive navigation and primary
      flows in `WallpaperiOSTests/`.

### Implementation for User Story 2

- [ ] T017 [US2] Move the current app entry and service composition into
      `WallpaperiOS/App/`.
- [ ] T018 [US2] Rewire the existing iPhone and iPad views to use the shared
      core from `WallpaperShared/`.
- [ ] T019 [US2] Keep iOS-only capability adapters, including Photos and
      App Intents, in `WallpaperiOS/Platform/`.
- [ ] T020 [US2] Verify regular-width iPad navigation remains separate from the
      macOS shell design.

**Checkpoint**: iPhone and iPad remain first-class after the architecture split.

---

## Phase 5: User Story 3 - Add future features once, not three times (Priority: P3)

**Goal**: Make future product work cheaper and less risky.

**Independent Test**: Update a shared behavior and confirm both platform shells
pick it up through the shared core.

### Tests for User Story 3 ⚠️

- [ ] T021 [P] [US3] Add shared verification that platform shells consume the
      same recommendation or persistence behavior in `WallpaperSharedTests/` and
      platform smoke tests.

### Implementation for User Story 3

- [ ] T022 [US3] Remove remaining duplicated domain logic from platform shell
      targets.
- [ ] T023 [US3] Document the allowed platform boundaries in
      `CONTRIBUTING.md` and feature docs if implementation changes them.
- [ ] T024 [US3] Update CI or local build scripts so iOS and macOS targets are
      both verified from one repository workflow.

**Checkpoint**: The repository has one shared core and thin platform shells.

---

## Phase 6: Polish & cross-cutting concerns

**Purpose**: Finish release hygiene, verification, and handoff.

- [ ] T025 [P] Update `CHANGELOG.md` for user-visible platform support changes.
- [ ] T026 Validate the manual matrix in
      `specs/002-multiplatform-architecture/quickstart.md`.
- [ ] T027 Regenerate the project from `project.yml` after structural changes.
- [ ] T028 Run final build and test commands for iOS and macOS targets.

## Dependencies & execution order

### Phase dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup completion and blocks shell work.
- **User Story 1 (Phase 3)**: Depends on Foundational completion.
- **User Story 2 (Phase 4)**: Depends on Foundational completion.
- **User Story 3 (Phase 5)**: Depends on both shells consuming the shared core.
- **Polish (Phase 6)**: Depends on the target user stories being complete.

### User story dependencies

- **User Story 1 (P1)**: Can begin as soon as the shared core and adapter seams
  exist.
- **User Story 2 (P2)**: Can begin as soon as the shared core exists, and must
  stay aligned with User Story 1.
- **User Story 3 (P3)**: Depends on both shells already using the shared core.

### Parallel opportunities

- Tasks marked `[P]` can run in parallel when they affect different files.
- Shared tests can progress in parallel with some shell scaffolding after the
  module boundaries are stable.

## Implementation strategy

### MVP first (User Story 1 only)

1. Create the shared module and platform seams.
2. Stand up the native macOS shell for current core flows.
3. Verify the Mac app works without breaking the existing iOS app.

### Incremental delivery

1. Extract the shared core.
2. Wire the macOS shell.
3. Rewire the iOS shell cleanly onto the same shared core.
4. Remove remaining duplicated domain logic.
5. Finish CI, docs, and verification.

## Notes

- Keep iPhone and iPad inside one iOS target.
- Treat native macOS as the target quality bar, not Catalyst parity.
- Keep platform conditionals close to capability adapters and shell entry
  points, not inside shared domain logic.
