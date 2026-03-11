# Changelog

Use this file to track notable changes to WallpaperApp. It separates committed
release content from in-progress work so you can see what is stable and what is
still changing.

## Unreleased

Use this section to track changes that exist in the working tree and are not
yet committed or released.

### Added

This update adds new product features that deepen discovery and retention.

- Added a recent downloads screen in Settings so you can reopen, delete, and
  clear saved download history.
- Added explanation-backed recommendation cards on iPhone and iPad so you can
  see why a wallpaper was promoted.
- Added a dedicated recommendation model and card component to keep the UI and
  recommendation text maintainable.

### Changed

This update improves adaptive layout behavior and detail flows.

- Changed iPad discovery into a master-detail experience with a persistent
  selection pane and a placeholder state.
- Expanded wallpaper detail with source and share actions, and let the detail
  view hide navigation chrome when embedded in the iPad split layout.
- Stored richer download metadata so saved history can recreate full wallpaper
  details instead of showing only basic identifiers.
- Updated the settings copy to explain that recommendation cards expose their
  ranking signals.

### Fixed

This update tightens state handling and request behavior.

- Fixed selection synchronization after reloads so the iPad detail pane stays
  aligned with the current list.
- Fixed duplicate reload work by cancelling stale discovery reload tasks when
  search text or filters change.
- Fixed paging state after load-more failures by rolling back the page counter
  instead of skipping pages.

## 0.1.0 - March 11, 2026

Use this section to review the first committed version of WallpaperApp.

### Added

This initial release establishes the core app experience.

- Added a SwiftUI wallpaper browser backed by Picsum, including search,
  orientation filtering, large previews, and saving to Photos.
- Added local favorites, local preference storage, and on-device recommendation
  ranking with SwiftData-backed models.
- Added adaptive navigation for iPhone and iPad, including phone tabs and an
  iPad split navigation shell.
- Added settings, App Intents shortcuts, XcodeGen project generation, and unit
  coverage for recommendation ranking.

### Fixed

This initial release also includes the setup and runtime fixes required for a
usable build.

- Fixed the project configuration so the app builds cleanly from the command
  line with Xcode 26.3 and Swift 6.2.
- Fixed launch and device behavior with a launch screen, iPhone and iPad
  orientation support, and full-screen presentation on the simulator.
