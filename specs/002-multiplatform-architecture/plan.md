# Implementation Plan: Multiplatform architecture

**Branch**: `002-multiplatform-architecture` | **Date**: March 13, 2026 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-multiplatform-architecture/spec.md`

## Summary

Restructure WallpaperApp into one repository with a shared core and separate
native iOS and macOS app shells. Keep iPhone and iPad in one adaptive iOS
target, add a first-class macOS target, and isolate platform-only capabilities
behind explicit adapters so future features remain maintainable.

## Technical Context

**Language/Version**: Swift 6.2  
**Primary Dependencies**: SwiftUI, SwiftData, Foundation, AppIntents (iOS
only), Photos (iOS only), AppKit and macOS scene APIs for the desktop shell  
**Storage**: Shared on-device SwiftData models plus file-backed cache data when
present  
**Testing**: XCTest through `xcodebuild build` and `xcodebuild test`, plus
manual smoke checks on iPhone, iPad, and macOS  
**Target Platform**: iOS 26.0+ on iPhone and iPad, plus macOS 26.0+  
**Project Type**: multiplatform mobile and desktop app  
**Performance Goals**: Preserve current iOS responsiveness, avoid synchronous
main-actor disk or network work, and keep macOS launch and navigation free of
obvious platform-compatibility friction  
**Constraints**: No third-party runtime dependency, `project.yml` remains the
project source of truth, App Intents may stay iOS-only, and local privacy rules
must remain consistent across platforms  
**Scale/Scope**: One repository, two app targets, one shared core, and the
existing current feature set

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Shared product logic, adaptive presentation**: PASS. The plan uses one
  shared core with separate iOS and macOS shells.
- **Spec-first delivery**: PASS. The feature has a numbered spec and plan
  before implementation.
- **Modern Swift concurrency and actor isolation**: PASS. Shared async services
  remain in one concurrency-safe core.
- **Local-first privacy and explicit permissions**: PASS. Platform capabilities
  differ, but local-only storage and clear permission boundaries remain intact.
- **Verifiable quality gates and one project source of truth**: PASS. The plan
  requires both targets to build from `project.yml` and adds cross-platform
  verification.

## Project Structure

### Documentation (this feature)

```text
specs/002-multiplatform-architecture/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

### Source Code (repository root)

```text
WallpaperShared/
├── Models/
├── Persistence/
├── Services/
├── Features/
└── PlatformProtocols/

WallpaperiOS/
├── App/
├── Navigation/
├── Views/
└── Platform/

WallpaperMac/
├── App/
├── Navigation/
├── Views/
└── Platform/

WallpaperSharedTests/
WallpaperiOSTests/
WallpaperMacTests/
project.yml
```

**Structure Decision**: Move current cross-platform logic out of `WallpaperApp/`
into a new shared core target, then create thin native shells for iOS and
macOS. Keep platform-specific scenes, navigation, and capability adapters in
platform folders and keep shared business logic out of app-specific targets.

## Complexity Tracking

No constitution violations are expected for this track.
