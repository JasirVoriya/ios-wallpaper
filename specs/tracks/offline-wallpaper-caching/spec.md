# Offline wallpaper caching

This track defines the first major reliability upgrade for WallpaperApp. It
introduces local image caching so discovery, detail, and revisit flows remain
useful when the network is slow or temporarily unavailable.

## Metadata

This section records the current state of the track.

- Track: `offline-wallpaper-caching`
- Status: `approved`
- Priority: `P0`
- Last updated: `March 13, 2026`
- Owner: `Repository maintainer`

## Summary

WallpaperApp currently depends on live network fetches for discovery images and
detail revisits. This track adds a local caching layer for wallpaper images and
cache metadata so the app feels faster online and remains partially usable
offline.

## Problem

This section describes the current gap. The app can store favorites,
preferences, and download history locally, but it cannot reliably reuse remote
image data after the first fetch. That creates three user-visible problems:
slower repeat browsing, blank or degraded detail states when connectivity drops,
and no clear foundation for future offline product work.

## Goals

This section lists the outcomes this track must deliver.

- Reuse previously fetched wallpaper images without refetching them every time
- Keep recent discovery and detail content useful during temporary network loss
- Establish a cache design that is explicit about storage limits and eviction

## Non-goals

This section defines the deliberate boundaries for this track.

- This track does not add full offline search across the remote catalog
- This track does not introduce background prefetch or sync services
- This track does not add a new remote wallpaper source

## User impact

This section explains who benefits and what success looks like.

- Primary user: wallpaper browsers on unstable or metered networks
- Primary workflow: reopen discovery items, revisit details, and view recent
  content without waiting for the network again
- Success signal: previously seen wallpapers render from local cache and recent
  detail views remain usable without connectivity

## Scope

This section lists the main product and engineering surfaces affected.

- UI surfaces: discovery grid, detail view, recent downloads, and relevant
  loading or error states
- Local data: cache metadata and any file-backed image storage index
- Services: API client integration, cache lookup, cache write path, and
  eviction behavior
- Tooling: unit tests for cache policy and any project config needed for new
  files or targets

## Requirements

This section defines the concrete requirements for the track.

### Functional requirements

This subsection defines what the app must do.

- The app must store fetched wallpaper image data locally after a successful
  load
- The app must read from cache before issuing a network fetch for the same
  wallpaper image when valid cached data exists
- The app must preserve enough metadata to associate cached files with
  wallpaper identifiers and variants used by the UI
- The app must expose a clear fallback state when a wallpaper is unavailable
  both remotely and in cache
- The app must let the settings surface explain cache size and provide a way to
  clear cached content

### Non-functional requirements

This subsection defines the quality constraints for the track.

- Cache storage must have an explicit size or count limit with deterministic
  eviction behavior
- Cache access must not block the main actor with synchronous disk work
- iPhone and iPad must use the same cache logic while keeping existing adaptive
  layouts intact
- The design must remain compatible with SwiftData-backed local product state

## UX and adaptive behavior

This section defines the expected user-facing behavior.

- Compact width: discovery and detail should show cached images seamlessly with
  the same layout structure used today
- Regular width: iPad split discovery must keep its persistent detail behavior
  while sourcing images from cache when available
- Empty, loading, and error states: cached content must win over generic error
  placeholders whenever valid local data exists

## Data, privacy, and permissions

This section captures local storage and privacy implications.

- Data created or changed: local cache files and cache metadata
- Privacy impact: low, because wallpaper cache content is derived from already
  viewed public remote images and stays on device
- Permissions impact: none beyond existing Photos write access

## Technical approach

This section outlines the expected implementation shape.

- Add a dedicated image cache service that owns file storage, lookup, write,
  and eviction behavior
- Keep network fetch orchestration separate from cache policy so the API client
  remains focused on remote data retrieval
- Integrate cache-aware image loading into discovery and detail flows without
  duplicating phone and iPad logic
- Keep metadata persistence explicit so cache clearing and future migration are
  manageable

## Risks and open questions

This section records the main uncertainties.

- Risk: cache growth can become unbounded without careful eviction rules
- Risk: poorly isolated disk I/O can regress startup or scroll performance
- Open question: whether cache metadata belongs in SwiftData or in a lighter
  file-backed index layer

## Acceptance criteria

This section defines the completion bar for the track.

- [ ] Previously viewed wallpapers render from local cache when the network is
      unavailable
- [ ] Discovery and detail fall back to network only when no valid cache entry
      exists
- [ ] Settings expose cache storage information and a clear-cache action
- [ ] Cache behavior is covered by automated tests for lookup and eviction
- [ ] Manual verification confirms iPhone and iPad behavior on simulator

## Verification

This section defines how the track is validated.

- Automated checks: command-line build, cache policy tests, and any updated app
  tests affected by cache integration
- Manual checks: network-off simulation for previously viewed wallpapers on
  iPhone and iPad, plus cache clear behavior in Settings
- Deferred checks: none yet; unresolved gaps must be added explicitly if they
  appear during implementation

## Next steps

If this track lands successfully, the follow-up work is likely UI regression
coverage and broader recommendation controls rather than more caching scope in
the same change.
