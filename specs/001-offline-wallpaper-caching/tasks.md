# Tasks: Offline wallpaper caching

**Input**: Design documents from `/specs/001-offline-wallpaper-caching/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Add or update automated tests for cache policy, image loading, and
feature regressions where logic can silently fail.

**Organization**: Tasks are grouped by user story so each story remains
independently testable and reviewable.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (for example `US1`)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the cache subsystem boundaries and feature scaffolding.

- [ ] T001 Create `WallpaperApp/Services/WallpaperImageCache.swift` with the
      actor boundary and public cache API.
- [ ] T002 Create `WallpaperAppTests/WallpaperImageCacheTests.swift` with test
      scaffolding for hits, misses, invalid entries, and eviction behavior.
- [ ] T003 [P] Add any required shared cache UI support in
      `WallpaperApp/Views/Shared/` for a reusable cache-aware wallpaper image
      surface.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build the cache primitives that all user stories depend on.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [ ] T004 Implement disk-backed cache write, lookup, and delete behavior in
      `WallpaperApp/Services/WallpaperImageCache.swift`.
- [ ] T005 Implement manifest loading, saving, and repair logic in
      `WallpaperApp/Services/WallpaperImageCache.swift`.
- [ ] T006 [P] Add cache budget and LRU eviction tests in
      `WallpaperAppTests/WallpaperImageCacheTests.swift`.
- [ ] T007 Wire the cache service into `WallpaperApp/App/AppServices.swift`.
- [ ] T008 Add any shared image-loading helper needed by discovery and detail
      flows in `WallpaperApp/Services/` or `WallpaperApp/Views/Shared/`.

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Revisit previously seen wallpapers offline (Priority: P1) 🎯 MVP

**Goal**: Cached discovery thumbnails and detail previews reopen without network
access.

**Independent Test**: Warm the cache online, disable network access, then
verify previously viewed discovery and detail content still renders.

### Tests for User Story 1 ⚠️

- [ ] T009 [P] [US1] Add integration-oriented cache loading tests in
      `WallpaperAppTests/WallpaperImageCacheTests.swift` or a new loader test
      file for repeat image access paths.

### Implementation for User Story 1

- [ ] T010 [US1] Replace direct discovery image loading in
      `WallpaperApp/Views/Discover/WallpaperGridItemView.swift` with the shared
      cache-aware image surface.
- [ ] T011 [US1] Replace direct preview loading in
      `WallpaperApp/Views/Discover/WallpaperDetailView.swift` with the shared
      cache-aware image surface.
- [ ] T012 [P] [US1] Update recommendation, favorites, and downloads imagery in
      `WallpaperApp/Views/Discover/WallpaperRecommendationCardView.swift`,
      `WallpaperApp/Views/Favorites/FavoritesView.swift`, and
      `WallpaperApp/Views/Settings/DownloadsView.swift` to use the same cache
      behavior where appropriate.
- [ ] T013 [US1] Ensure cache reads update access ordering so recent content is
      preserved for offline revisits.

**Checkpoint**: User Story 1 is functional and testable as the MVP.

---

## Phase 4: User Story 2 - Recover gracefully when cache is missing or invalid (Priority: P2)

**Goal**: Cache failures or misses produce clear fallback behavior.

**Independent Test**: Open uncached or invalid-cache content without network and
verify the UI shows a clear unavailable state.

### Tests for User Story 2 ⚠️

- [ ] T014 [P] [US2] Add invalid-entry and cache-miss tests in
      `WallpaperAppTests/WallpaperImageCacheTests.swift`.

### Implementation for User Story 2

- [ ] T015 [US2] Add unavailable-state handling for cache miss and invalid cache
      cases in the shared cache-aware image surface.
- [ ] T016 [US2] Remove invalid manifest entries on failed cache validation in
      `WallpaperApp/Services/WallpaperImageCache.swift`.
- [ ] T017 [US2] Preserve existing loading and error semantics in discovery and
      detail flows while distinguishing offline-unavailable states.

**Checkpoint**: User Stories 1 and 2 both work independently.

---

## Phase 5: User Story 3 - Manage cached storage from settings (Priority: P3)

**Goal**: Users can inspect and clear wallpaper cache state in Settings.

**Independent Test**: Cache content, verify cache usage is visible, clear the
cache, and confirm offline imagery disappears while other local data remains.

### Tests for User Story 3 ⚠️

- [ ] T018 [P] [US3] Add cache summary and clear-cache behavior tests in
      `WallpaperAppTests/WallpaperImageCacheTests.swift` or a new settings logic
      test file.

### Implementation for User Story 3

- [ ] T019 [US3] Add cache summary reporting APIs in
      `WallpaperApp/Services/WallpaperImageCache.swift`.
- [ ] T020 [US3] Expose cache usage and clear-cache controls in
      `WallpaperApp/Views/Settings/SettingsView.swift`.
- [ ] T021 [US3] Ensure clear-cache behavior deletes only cached image data and
      leaves favorites, downloads, and preferences intact.

**Checkpoint**: All user stories are independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Finish documentation, verification, and release hygiene.

- [ ] T022 [P] Update `CHANGELOG.md` for user-visible cache behavior.
- [ ] T023 Validate the manual flow in
      `specs/001-offline-wallpaper-caching/quickstart.md` on iPhone and iPad
      simulators.
- [ ] T024 Regenerate the project from `project.yml` if structural files change.
- [ ] T025 Run command-line build and tests before merge.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup completion and blocks all user
  stories.
- **User Stories (Phases 3-5)**: Depend on Foundational completion.
- **Polish (Phase 6)**: Depends on the desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after the foundational cache service exists.
- **User Story 2 (P2)**: Starts after User Story 1 cache loading paths exist.
- **User Story 3 (P3)**: Starts after cache summary data can be read from the
  shared cache service.

### Parallel Opportunities

- Tasks marked `[P]` can run in parallel when they do not edit the same files.
- The service tests and some view migrations can proceed in parallel once the
  foundational cache API stabilizes.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup.
2. Complete Foundational work.
3. Complete User Story 1.
4. Validate the offline revisit MVP on at least one simulator.

### Incremental Delivery

1. Land the shared cache service and tests.
2. Add discovery and detail offline behavior.
3. Harden cache-miss and invalid-entry fallback states.
4. Add Settings controls and polish.

## Notes

- Keep cache logic shared across iPhone and iPad.
- Do not add a third-party runtime image library for this feature.
- Keep explicit file paths and tests updated if implementation details shift.
