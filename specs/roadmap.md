# Roadmap

This roadmap lists the major product tracks that matter next for WallpaperApp.
It is intentionally short and prioritized so you can see what deserves spec and
implementation time first.

## Prioritization rules

This section explains how to read the list. Priority reflects product leverage,
user impact, and architectural urgency rather than rough implementation effort.

- `P0`: blocks core product quality or scale
- `P1`: meaningfully improves retention, polish, or maintainability
- `P2`: valuable follow-up work after the higher priorities are stable

## Active roadmap

This section records the current known tracks. Update statuses when the work
moves so this file remains the top-level planning view.

| Priority | Track | Status | Why it matters now |
| --- | --- | --- | --- |
| P0 | `offline-wallpaper-caching` | `approved` | The app still depends on live network fetches for discovery and detail use. |
| P1 | `adaptive-ui-regression-tests` | `proposed` | iPhone and iPad behavior is now a core product promise and needs stronger verification. |
| P1 | `recommendation-controls-and-feedback` | `proposed` | Recommendation logic exists, but the user cannot fine-tune or explain preference signals deeply enough. |
| P2 | `multi-source-wallpaper-ingestion` | `proposed` | The app depends on a single content source, which limits resilience and curation options. |

## Current active track

This section points to the track that is ready to guide the next feature.

The next implementation track is
[`offline-wallpaper-caching`](./tracks/offline-wallpaper-caching/spec.md).
It is the highest-value gap because it improves baseline reliability, perceived
speed, and future product flexibility.

## Next steps

When priorities change, update this file first, then make sure the matching
track directory reflects the new status and scope.
