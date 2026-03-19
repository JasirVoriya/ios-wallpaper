# Data model: Multiplatform architecture

## Overview

This track is mostly architectural, but it still introduces stable conceptual
entities that define ownership across the repository.

## Entities

### SharedCoreModule

Represents the reusable code boundary consumed by both app targets.

| Field | Type | Description |
| --- | --- | --- |
| `name` | String | Module or target name |
| `ownedDomains` | [String] | Product logic areas owned by the module |
| `supportedPlatforms` | [String] | Platforms that consume the module |
| `publicInterfaces` | [String] | Stable interfaces exposed to app shells |

### PlatformShell

Represents an app target that owns scenes, navigation, toolbars, and platform
presentation.

| Field | Type | Description |
| --- | --- | --- |
| `platform` | Enum | iOS or macOS |
| `targetName` | String | App target name |
| `navigationStyle` | String | Primary navigation and window pattern |
| `capabilityAdapters` | [String] | Platform services injected into the shell |
| `ownedUIAreas` | [String] | UI surfaces unique to that shell |

### PlatformCapabilityAdapter

Represents a platform-specific implementation of a cross-platform product
action.

| Field | Type | Description |
| --- | --- | --- |
| `capabilityName` | String | Save, share, source-open, wallpaper-apply, etc. |
| `platform` | Enum | iOS or macOS |
| `userFacingBehavior` | String | Observable result for the user |
| `fallbackBehavior` | String | What happens when the capability is unavailable |

### VerificationSurface

Represents a build, test, or manual validation responsibility.

| Field | Type | Description |
| --- | --- | --- |
| `surface` | String | Shared tests, iOS smoke tests, macOS smoke tests |
| `ownedBy` | String | Shared core or platform shell |
| `verificationType` | String | Build, automated test, or manual check |
| `scope` | String | What behavior the check proves |

## Relationships

- One `SharedCoreModule` is consumed by multiple `PlatformShell` targets.
- Each `PlatformShell` uses one or more `PlatformCapabilityAdapter`
  implementations.
- `VerificationSurface` spans both the shared core and each platform shell.

## Validation rules

- Shared business logic cannot live exclusively in a platform shell unless it is
  truly platform-specific.
- A platform shell must not expose a capability action unless a matching adapter
  exists.
- User-visible capability differences must be intentional and documented.
- Shared persistence and cache behavior must remain consistent across platform
  shells.

## State transitions

1. **Current state**: Single iOS target owns both shared logic and platform UI.
2. **Extraction**: Shared logic moves into a reusable core boundary.
3. **Split shell state**: iOS and macOS app shells both consume the shared core.
4. **Platform-specific refinement**: Native shell behavior evolves without
   duplicating shared domain logic.
