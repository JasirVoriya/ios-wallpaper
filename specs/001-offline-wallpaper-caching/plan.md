# Implementation Plan: Offline wallpaper caching

**Branch**: `001-offline-wallpaper-caching` | **Date**: March 13, 2026 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-offline-wallpaper-caching/spec.md`

## Summary

Add a bounded on-device wallpaper image cache that powers repeat discovery and
detail viewing, exposes cache controls in Settings, and preserves the app's
existing adaptive iPhone and iPad behavior without duplicating business logic.

## Technical Context

**Language/Version**: Swift 6.2  
**Primary Dependencies**: SwiftUI, SwiftData, Foundation file APIs, URLSession  
**Storage**: Disk-backed image cache in the app cache directory with a JSON
manifest for cache metadata  
**Testing**: XCTest via `xcodebuild test` on iOS Simulator  
**Target Platform**: iOS 26.0+ on iPhone and iPad  
**Project Type**: mobile-app  
**Performance Goals**: Warm-cache wallpaper rendering under 1 second for repeat
views, no visible scroll hitching introduced by cache reads, and no main-actor
synchronous disk access  
**Constraints**: No new runtime dependency, keep user data on device, preserve
existing adaptive layouts, and keep `project.yml` as project source of truth  
**Scale/Scope**: One cache subsystem covering discovery thumbnails, detail
previews, and settings cache management for the current single-app codebase

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Shared product logic, adaptive presentation**: PASS. The cache will be one
  shared service used by all layouts.
- **Spec-first delivery**: PASS. This feature has a numbered spec, checklist,
  and implementation artifacts before code changes.
- **Modern Swift concurrency and actor isolation**: PASS. Cache access will be
  isolated behind an actor-based service.
- **Local-first privacy and explicit permissions**: PASS. Cache data stays on
  device and does not change the current permission model.
- **Verifiable quality gates and one project source of truth**: PASS. The plan
  includes build, test, and manual offline verification, with no direct Xcode
  project editing.

## Project Structure

### Documentation (this feature)

```text
specs/001-offline-wallpaper-caching/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

### Source Code (repository root)

```text
WallpaperApp/
├── App/
├── Models/
├── Services/
├── ViewModels/
├── Views/
└── Resources/

WallpaperAppTests/
project.yml
```

**Structure Decision**: Keep the existing single-target iOS app layout. Add the
cache subsystem under `WallpaperApp/Services/`, reuse existing models only where
appropriate, and introduce any cache-specific view support under `WallpaperApp/Views/Shared/`.

## Complexity Tracking

No constitution violations are expected for this track.
