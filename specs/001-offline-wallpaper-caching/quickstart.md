# Quickstart: Offline wallpaper caching

This quickstart explains how to validate the offline wallpaper caching feature
once implementation begins.

## Prerequisites

- Xcode 26.3 or later
- `xcodegen` 2.44.1 or later
- An installed iPhone simulator and an installed iPad simulator
- Network access for the initial warm-cache pass

## Local setup

1. Generate the project.
   ```bash
   xcodegen generate
   ```
2. Build the app.
   ```bash
   xcodebuild -project WallpaperApp.xcodeproj \
     -scheme WallpaperApp \
     -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
     build
   ```
3. Run unit tests.
   ```bash
   xcodebuild -project WallpaperApp.xcodeproj \
     -scheme WallpaperApp \
     -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
     test
   ```

## Manual verification flow

1. Launch the app on an iPhone simulator and browse discovery until several
   thumbnails and at least one detail view have loaded.
2. Repeat the same on an iPad simulator so both adaptive layouts warm the
   cache.
3. Disable network access using your preferred simulator or host-level network
   control.
4. Reopen previously viewed discovery content and verify cached images still
   render.
5. Reopen a previously viewed wallpaper detail screen and verify the preview
   still renders.
6. Open Settings and confirm cache information is visible.
7. Clear the cache from Settings.
8. Repeat the offline checks and verify previously cached images are no longer
   available until fetched again online.

## Expected outcomes

- Cached discovery and detail imagery appears without fresh network access.
- Cache misses show an explicit unavailable state rather than blank content.
- Clearing cache does not remove favorites, download history, or preferences.
