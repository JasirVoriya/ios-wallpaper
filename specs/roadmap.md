# Roadmap

This roadmap lists the major product tracks that matter next for WallpaperApp.
It stays intentionally short so priorities remain explicit and connected to the
current product baseline.

## Prioritization rules

This section explains how to read the list.

- `P0`: blocks core product quality or reliability
- `P1`: meaningfully improves retention, polish, or maintainability
- `P2`: valuable follow-up work after higher priorities stabilize

## Active roadmap

This section records the current known tracks and where their canonical specs
live.

| Priority | Track | Status | Canonical spec | Why it matters now |
| --- | --- | --- | --- | --- |
| P0 | `multiplatform-architecture` | `approved` | [`specs/002-multiplatform-architecture/spec.md`](./002-multiplatform-architecture/spec.md) | Perfect iPhone, iPad, and Mac support needs clear target and module boundaries before more feature work compounds platform debt. |
| P0 | `offline-wallpaper-caching` | `approved` | [`specs/001-offline-wallpaper-caching/spec.md`](./001-offline-wallpaper-caching/spec.md) | Offline support is still important, but shared-core extraction will reduce rework before caching expands beyond the current iOS target. |
| P1 | `adaptive-ui-regression-tests` | `proposed` | Not created yet | iPhone and iPad behavior is a core product promise and needs stronger verification. |
| P1 | `recommendation-controls-and-feedback` | `proposed` | Not created yet | Recommendation logic exists, but the user cannot tune or audit preference signals deeply enough. |
| P2 | `multi-source-wallpaper-ingestion` | `proposed` | Not created yet | The app depends on a single content source, which limits resilience and curation options. |

## Current active feature

The current active Spec-Kit feature is
[`002-multiplatform-architecture`](./002-multiplatform-architecture/spec.md).
That feature defines the repository shape required for a first-class iPhone,
iPad, and macOS product. The offline caching track remains approved and should
continue on top of the shared-core boundaries introduced here.

## Next steps

When a roadmap item becomes active, create a numbered feature directory with
Spec-Kit and update this file to point at the new canonical spec.
