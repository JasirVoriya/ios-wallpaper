# Research: Multiplatform architecture

## Decision 1: Use one repository with separate iOS and macOS app targets

- **Decision**: Keep one repository and one Xcode project configuration, but
  create separate iOS and macOS app targets.
- **Rationale**: This gives each platform a native shell while preserving one
  source of truth for shared models and product logic.
- **Alternatives considered**:
  - **One universal app target**: Simpler at first, but platform conditionals
    would spread through the codebase and reduce maintainability.
  - **Separate repositories**: Creates duplicated logic, fragmented CI, and
    higher coordination cost.

## Decision 2: Keep iPhone and iPad inside one adaptive iOS target

- **Decision**: Continue to support iPhone and iPad through one iOS target with
  adaptive layouts rather than separate mobile and tablet targets.
- **Rationale**: iPhone and iPad share the same platform APIs and most product
  logic. The current app already proves that shared iOS logic with adaptive UI
  is practical.
- **Alternatives considered**:
  - **Separate iPhone and iPad targets**: Adds target sprawl without enough
    platform benefit.
  - **Catalyst-only desktop strategy**: Faster initial reach, but not aligned
    with the user's goal of first-class Mac quality.

## Decision 3: Extract a shared core before adding large macOS UI work

- **Decision**: Create a shared core boundary for models, services,
  persistence, caching, and feature logic before the macOS shell grows.
- **Rationale**: This prevents the existing iOS target from becoming the hidden
  owner of all business logic and reduces rework when desktop-specific UI is
  added.
- **Alternatives considered**:
  - **Add macOS views first and refactor later**: Faster to demo, but creates
    coupling and higher migration risk.
  - **Duplicate current logic into a Mac target**: Violates the maintenance goal
    immediately.

## Decision 4: Isolate save, share, open, and wallpaper actions behind platform adapters

- **Decision**: Define explicit platform capability adapters for actions that
  differ between iOS and macOS.
- **Rationale**: Platform capabilities are where product parity naturally
  differs. Making them explicit keeps the shared core clean and keeps user
  differences intentional.
- **Alternatives considered**:
  - **Platform checks inside views and view models**: Easy to start, but causes
    maintenance drift.
  - **Force identical actions on both platforms**: Produces unnatural UX and
    dead-end affordances.

## Decision 5: Keep shared verification at the domain layer, and add thin platform smoke checks

- **Decision**: Use shared tests for product logic and smaller platform-targeted
  smoke checks for shells and capability adapters.
- **Rationale**: The most valuable reuse comes from verifying business logic
  once. Platform-specific tests should focus on shell wiring and platform-only
  behavior.
- **Alternatives considered**:
  - **Duplicate all tests per platform**: Inflates maintenance cost.
  - **Manual testing only**: Too weak for architecture work that affects many
    future features.
