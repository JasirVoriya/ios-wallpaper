# Research: Offline wallpaper caching

## Decision 1: Store image bytes in the app cache directory

- **Decision**: Store cached wallpaper files under the app's cache directory in
  a dedicated wallpaper cache folder.
- **Rationale**: Wallpaper imagery is reproducible remote content, so it fits
  cache semantics better than durable user-authored storage. The app still gets
  meaningful offline reuse while keeping it clear that the data is reclaimable.
- **Alternatives considered**:
  - **Application Support**: More durable, but heavier for recreatable content
    and increases cleanup responsibilities.
  - **Rely on AsyncImage default behavior only**: Too implicit and not
    sufficient for bounded, inspectable, user-clearable offline behavior.

## Decision 2: Keep cache metadata in a lightweight JSON manifest instead of SwiftData

- **Decision**: Persist cache metadata in a JSON manifest managed by the cache
  service rather than introducing a new SwiftData model.
- **Rationale**: Cache metadata is ephemeral operational state, not core user
  product state. A manifest avoids schema migration overhead and keeps cache
  cleanup independent from favorites, downloads, and preferences.
- **Alternatives considered**:
  - **SwiftData model**: Easier querying, but adds migration and container
    complexity for data that is intentionally disposable.
  - **Pure file-system scan with no manifest**: Simpler at first, but weak for
    deterministic eviction and fast cache usage summaries.

## Decision 3: Replace direct AsyncImage usage with a shared cache-aware image surface

- **Decision**: Introduce a reusable cache-aware wallpaper image component or
  loader that discovery, detail, favorites, and recent downloads can share.
- **Rationale**: The current UI uses `AsyncImage` directly in several places.
  A shared image surface keeps caching logic in one place and prevents device-
  specific divergence.
- **Alternatives considered**:
  - **Patch each AsyncImage call site separately**: Would spread cache logic
    across multiple views and create higher regression risk.
  - **Global URLCache configuration only**: Too implicit for explicit cache
    inspection, invalidation, and user-facing controls.

## Decision 4: Use LRU-style eviction with an explicit size budget

- **Decision**: Cap the wallpaper cache with a fixed disk budget and evict the
  least recently used assets first.
- **Rationale**: This keeps cache growth predictable and matches the product
  goal of preserving the most recently useful content.
- **Alternatives considered**:
  - **Time-based expiry only**: Can keep cold data too long or remove useful
    recently viewed data unpredictably.
  - **Unlimited growth**: Violates the product requirement for bounded local
    storage.
