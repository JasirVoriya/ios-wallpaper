# Data model: Offline wallpaper caching

## Overview

This feature adds an internal cache subsystem for wallpaper imagery. The data is
operational and disposable, but it still needs a clear model so cache behavior,
size accounting, and eviction remain deterministic.

## Entities

### CachedWallpaperAsset

Represents one cached wallpaper image variant.

| Field | Type | Description |
| --- | --- | --- |
| `cacheKey` | String | Stable key derived from wallpaper identity and asset role |
| `wallpaperID` | String | Remote wallpaper identifier |
| `assetKind` | Enum | Thumbnail, preview, or download asset |
| `relativePath` | String | File path under the cache root |
| `byteCount` | Int64 | Stored file size |
| `pixelWidth` | Int | Cached image width if known |
| `pixelHeight` | Int | Cached image height if known |
| `createdAt` | Date | First cache write timestamp |
| `lastAccessedAt` | Date | Last successful read timestamp |
| `checksum` | String? | Optional integrity marker for invalidation or corruption checks |

### CacheManifest

Represents the persisted metadata index for all cached assets.

| Field | Type | Description |
| --- | --- | --- |
| `version` | Int | Manifest schema version |
| `maxByteCount` | Int64 | Configured cache budget |
| `currentByteCount` | Int64 | Current total size of cached assets |
| `assets` | [CachedWallpaperAsset] | Cache entries tracked by the manifest |
| `updatedAt` | Date | Last manifest write timestamp |

### CacheSummary

Represents the user-facing cache state shown in Settings.

| Field | Type | Description |
| --- | --- | --- |
| `assetCount` | Int | Number of valid cached assets |
| `totalByteCount` | Int64 | Total local storage used by cache |
| `lastUpdatedAt` | Date | Last successful cache state refresh |
| `isEmpty` | Bool | Whether the cache currently contains any valid assets |

## Relationships

- One `CacheManifest` tracks many `CachedWallpaperAsset` records.
- `CacheSummary` is a derived view over the current manifest and file state.
- Cached assets are associated with wallpapers by remote identifier but do not
  replace favorites, downloads, or preferences.

## Validation rules

- `cacheKey` must be unique within the manifest.
- `relativePath` must resolve inside the cache root only.
- `byteCount` must be non-negative and match the on-disk file size after write.
- Invalid or missing files cause the corresponding asset to be removed from the
  manifest on the next maintenance pass.

## State transitions

1. **Miss**: No matching asset exists in the manifest.
2. **Write pending**: Remote image load succeeds and is being persisted.
3. **Hit**: A valid asset exists and the file is readable.
4. **Invalid**: Manifest entry exists but the file fails validation.
5. **Evicted**: Asset is removed because of budget pressure or manual cache
   clearing.
