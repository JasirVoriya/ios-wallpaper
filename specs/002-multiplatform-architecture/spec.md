# Feature Specification: Multiplatform architecture

**Feature Branch**: `002-multiplatform-architecture`  
**Created**: March 13, 2026  
**Status**: Draft  
**Input**: User description: "Create a first-class iPhone, iPad, and macOS
architecture with shared core modules and native platform shells"

## User scenarios & testing *(mandatory)*

This feature defines how WallpaperApp grows from an iPhone and iPad app into a
first-class Apple-platform product without copying product logic across
platforms.

### User Story 1 - Use a native wallpaper app on Mac (Priority: P1)

As a Mac user, I want discovery, detail, favorites, and settings to exist in a
native macOS app so the product feels designed for Mac rather than stretched
from iPad.

**Why this priority**: The user's explicit goal is first-class support across
all Apple platforms. Mac is the missing platform today and requires deliberate
architecture before feature work continues.

**Independent Test**: Build and launch a macOS target, open the main sections,
then verify that navigation, window structure, toolbar actions, and save flows
match Mac expectations without showing iOS-only dead ends.

**Acceptance Scenarios**:

1. **Given** the macOS app launches, **When** the user opens the main product
   areas, **Then** the app presents a Mac-native shell with sidebar, toolbar,
   and window behavior rather than iOS compatibility chrome.
2. **Given** the user opens a wallpaper on macOS, **When** they save, share, or
   open the source, **Then** the app uses Mac-appropriate actions and messages.

---

### User Story 2 - Keep iPhone and iPad polished while the app grows to Mac (Priority: P2)

As an iPhone or iPad user, I want existing mobile and tablet flows to stay
fast, adaptive, and familiar while macOS support is added, so the current
experience does not regress.

**Why this priority**: A multiplatform expansion that damages the existing iOS
product is a regression, not progress.

**Independent Test**: Build the iOS target, run it on iPhone and iPad
simulators, then verify discovery, detail, favorites, settings, and save flows
still match the current mobile and tablet expectations.

**Acceptance Scenarios**:

1. **Given** the iOS app runs on iPhone, **When** the user browses the current
   core flows, **Then** the app keeps phone-appropriate navigation and actions.
2. **Given** the iOS app runs on iPad, **When** the user browses the current
   core flows, **Then** the app keeps regular-width layouts and split behavior
   without adopting Mac-only interaction patterns.

---

### User Story 3 - Add future features once, not three times (Priority: P3)

As the maintainer, I want shared business logic and isolated platform shells so
future features can be delivered across iPhone, iPad, and Mac without copying
core logic into multiple app-specific code paths.

**Why this priority**: Long-term product quality depends on maintainability.
Without clear boundaries, every future feature will become slower and riskier to
ship.

**Independent Test**: Review the resulting module and target boundaries, then
confirm that a shared domain change such as recommendation or persistence logic
can be made once and consumed by both app targets without duplicated business
implementations.

**Acceptance Scenarios**:

1. **Given** a shared product rule changes, **When** the maintainer updates the
   shared core, **Then** iOS and macOS both consume the new behavior without
   separate copies of the same business logic.
2. **Given** a platform-only action changes, **When** the maintainer updates the
   relevant platform adapter, **Then** the shared domain logic remains unchanged.

### Edge cases

This section captures the known product and architecture boundaries that the
track must handle explicitly.

- What happens when a capability exists on one platform but not another, such
  as Photos add-only access on iOS versus file-save or desktop-wallpaper actions
  on macOS?
- How does the app preserve shared local data behavior when iOS and macOS
  targets both evolve the same persistence schema?
- What happens when macOS needs multiwindow or toolbar behavior that has no
  direct equivalent on iPhone or iPad?
- How does the project keep App Intents or other iOS-only integrations from
  leaking compile-time assumptions into the macOS target?

## Requirements *(mandatory)*

This section defines the required behavior and engineering boundaries for the
multiplatform architecture track.

### Functional requirements

- **FR-001**: The system MUST provide separate iOS and macOS app targets from
  one repository and one Xcode project or workspace.
- **FR-002**: The iOS target MUST continue to support both iPhone and iPad
  within one adaptive iOS app target.
- **FR-003**: The macOS target MUST expose the current core product areas,
  including discovery, detail, favorites, and settings, through native macOS
  navigation and window patterns.
- **FR-004**: The system MUST keep core models, recommendation logic,
  networking, caching, and persistence logic shared unless a platform-specific
  requirement makes shared behavior impossible.
- **FR-005**: Platform-only actions such as save, share, open-source, or
  wallpaper-application affordances MUST be isolated behind explicit platform
  adapters.
- **FR-006**: The system MUST present user-visible capability differences
  clearly when one platform cannot or does not support the same action as
  another platform.
- **FR-007**: The project structure MUST let future non-trivial features add
  shared business logic once and attach platform presentation separately.
- **FR-008**: The system MUST preserve current iPhone and iPad behavior quality
  while macOS support is introduced.
- **FR-009**: Build and verification workflows MUST cover both the iOS and
  macOS targets from the same repository.
- **FR-010**: The system MUST keep local-only privacy behavior consistent across
  platforms unless a later spec explicitly changes that boundary.

### Key entities *(include if feature involves data)*

- **Shared core module boundary**: The repository area that owns cross-platform
  models, product rules, networking, caching, persistence, and feature logic.
- **Platform shell**: The iOS or macOS-specific app layer that owns scenes,
  navigation, window structure, toolbars, and platform-native interaction
  patterns.
- **Platform capability adapter**: The platform-bound service that performs
  save, share, open, and wallpaper-related actions that differ by OS.
- **Cross-platform verification matrix**: The set of build, test, and manual
  checks that proves shared logic and platform shells both behave correctly.

## Success criteria *(mandatory)*

This section defines the observable outcomes that determine whether the track is
successful.

### Measurable outcomes

- **SC-001**: The repository can build and launch the current core app flows on
  iPhone, iPad, and macOS from the same project configuration.
- **SC-002**: iPhone and iPad users can still reach discovery, favorites,
  settings, and wallpaper detail from launch using the same or fewer navigation
  steps as the current app.
- **SC-003**: macOS users can reach discovery, favorites, settings, and
  wallpaper detail through Mac-native navigation without encountering iOS-only
  labels, instructions, or dead-end actions.
- **SC-004**: Shared product logic for current core flows exists in one shared
  code path, and duplicated platform copies of networking, recommendation,
  caching, or persistence logic are eliminated.
