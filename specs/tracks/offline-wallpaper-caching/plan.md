# Offline wallpaper caching plan

This plan breaks the offline caching track into phases that match the current
WallpaperApp architecture. The sequencing starts with cache primitives, then
integrates them into product flows, and only then adds controls and cleanup.

## Metadata

This section records the current execution state.

- Track: `offline-wallpaper-caching`
- Status: `planned`
- Last updated: `March 13, 2026`

## Implementation strategy

This section explains the order of work. The cache service must exist before UI
integration is safe, and UI behavior must be stable before settings and cleanup
controls are added.

## Phase 1

This section covers the storage and service foundation.

- [ ] Define the cache data model and storage location
- [ ] Implement a cache service with async lookup, write, and eviction methods
- [ ] Add unit tests for cache keying, hits, misses, and eviction rules

## Phase 2

This section integrates cache behavior into the product experience.

- [ ] Integrate cache-aware image loading into discovery surfaces
- [ ] Integrate cache-aware image loading into wallpaper detail
- [ ] Preserve existing iPhone and iPad adaptive behavior while using the cache

## Phase 3

This section finishes the user-facing controls and verification work.

- [ ] Add cache status and clear-cache controls to Settings
- [ ] Add manual verification notes for offline simulator testing
- [ ] Update changelog, roadmap, and track status after the feature lands

## Verification checklist

This section lists the required checks before the track can move to complete.

- [ ] Command-line build passes
- [ ] Relevant automated tests pass
- [ ] Manual iPhone offline cache flow is verified
- [ ] Manual iPad offline cache flow is verified
- [ ] Settings cache-clear behavior is verified
- [ ] Changelog is updated if the change is user-visible
- [ ] Roadmap and track status are updated

## Risks and dependencies

This section records the current execution concerns.

- Dependency: a clear decision on whether cache metadata uses SwiftData or a
  filesystem index
- Risk: disk I/O on the main actor can regress discovery performance
- Risk: incorrect cache invalidation can surface stale or mismatched images

## Next steps

When implementation starts, convert this plan from a static checklist into a
live execution document by marking active tasks and recording any scope changes.
