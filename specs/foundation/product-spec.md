# Product spec

This document defines the current product baseline for WallpaperApp. Use it as
the stable reference when you write track specs so new work stays aligned with
what the app already does and with the constraints imposed by iOS and the
current codebase.

## Metadata

This section records the status of the baseline document. Update it when the
product definition changes in a meaningful way.

- Status: `living`
- Last updated: `March 13, 2026`
- Product owner: `Repository maintainer`

## Product summary

This section describes the product at the highest level. WallpaperApp is a
SwiftUI iOS wallpaper browser for iPhone and iPad that focuses on discovery,
on-device personalization, and saving wallpapers into Photos for manual system
wallpaper setup.

## Target users

This section names the primary users the app is built for. Track specs must say
which of these users are affected.

- Users who browse and save wallpapers across iPhone and iPad
- Users who want simple on-device recommendations without account creation
- Users who care about adaptive layouts on both compact and regular-size iOS
  devices

## Product goals

This section defines the outcomes the app is trying to optimize for right now.
New tracks must support at least one of these goals.

- Make wallpaper discovery fast, visual, and easy to browse
- Keep the app usable on both iPhone and iPad without duplicating business
  logic
- Personalize ranking and recommendations with local signals only
- Keep saving and revisiting wallpapers simple and reliable

## Non-goals

This section documents what the app does not currently aim to do. Keeping these
boundaries explicit prevents tracks from growing without a decision.

- The app does not set the system wallpaper automatically
- The app does not require user accounts or cloud sync
- The app does not upload favorites or preferences for recommendation ranking
- The app does not yet provide full offline discovery browsing

## Current capabilities

This section captures the feature surface that already exists in the shipped or
active codebase.

- Adaptive root navigation for iPhone and iPad
- Discovery with search, orientation filtering, pagination, and detail previews
- Explainable recommendation cards driven by local favorites and preferences
- Favorites stored locally with SwiftData
- Download history stored locally with SwiftData
- Saving images to Photos and sharing wallpaper links
- App Intents shortcuts entry points
- Five localized language sets: English, Simplified Chinese, Traditional
  Chinese, Japanese, and Korean

## Platform scope

This section defines the current platform and toolchain commitments.

- Platform: iOS only
- Devices: iPhone and iPad
- Orientation: portrait on iPhone, portrait and landscape on iPad, and supported
  landscape on iPhone where the current layouts permit it
- Minimum deployment target: iOS 26.0
- Toolchain baseline: Xcode 26.3+, Swift 6.2, XcodeGen 2.44.1+

## Architecture baseline

This section captures the engineering constraints that already exist in code.
Track specs must align with these unless they explicitly propose a change.

- SwiftUI is the full UI layer
- SwiftData is the local persistence layer
- `AppServices` is the shared entry point for app-level services
- `DiscoverViewModel` orchestrates discovery loading and recommendation output
- `WallpaperRecommendationEngine` is an actor and is the single ranking engine
- Device-specific experience differences live mainly at the view and layout
  layer
- `project.yml` is the authoritative project configuration source

## Privacy and permissions

This section defines the current privacy boundary for the product.

- The app requests Photos add-only access when the user saves a wallpaper
- Favorites, preferences, and download history stay on device
- The current remote wallpaper source is Picsum
- Recommendation logic uses local state only

## Quality bar

This section defines what new work must preserve.

- iPhone and iPad must both remain first-class experiences
- Non-trivial UI changes must define compact and regular layout behavior
- New local persistence must document storage shape and migration risk
- User-visible recommendation changes must be testable
- Permission-related flows must define failure and denial states

## Open product gaps

This section records the biggest known gaps so roadmap work stays grounded.

- Offline discovery and image caching are not implemented
- The project does not yet support macOS despite the product direction toward
  first-class Apple-platform coverage
- UI and snapshot test coverage are limited
- Recommendation controls are still simple and mostly global
- The app still depends on one external wallpaper source

## Next steps

Use [roadmap.md](../roadmap.md) to decide which gap is tackled next, then create
or update a track spec before implementation starts.
