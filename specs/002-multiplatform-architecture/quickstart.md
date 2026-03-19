# Quickstart: Multiplatform architecture

This quickstart defines how to validate the repository once the multiplatform
architecture work is implemented.

## Prerequisites

- Xcode 26.3 or later
- `xcodegen` 2.44.1 or later
- An available iPhone simulator
- An available iPad simulator
- A local macOS environment that can launch the desktop target

## Local setup

1. Generate the project from `project.yml`.
   ```bash
   xcodegen generate
   ```
2. Build the iOS target.
   ```bash
   xcodebuild -project WallpaperApp.xcodeproj \
     -scheme WallpaperAppiOS \
     -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
     build
   ```
3. Build the macOS target.
   ```bash
   xcodebuild -project WallpaperApp.xcodeproj \
     -scheme WallpaperAppMac \
     build
   ```
4. Run the shared and platform tests.
   ```bash
   xcodebuild -project WallpaperApp.xcodeproj \
     -scheme WallpaperShared \
     -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
     test
   ```

## Manual verification flow

1. Launch the iOS app on an iPhone simulator and verify discovery, detail,
   favorites, settings, and save flows.
2. Launch the same iOS app on an iPad simulator and verify split navigation,
   detail presentation, favorites, settings, and save flows.
3. Launch the macOS app and verify sidebar navigation, toolbar actions,
   discovery, detail, favorites, and settings.
4. On each platform, verify user-visible save and share actions are native to
   that platform and do not show unsupported instructions.
5. Change one shared product rule, such as recommendation sorting in a shared
   test double, then verify both app targets consume the updated behavior.

## Expected outcomes

- The repository builds separate iOS and macOS app targets from one project.
- iPhone and iPad keep native iOS behavior while sharing one target.
- macOS gains a native app shell instead of iPad compatibility UI.
- Shared business logic lives in one code path rather than duplicated platform
  copies.
