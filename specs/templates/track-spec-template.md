# Track spec template

Use this template for any non-trivial feature, architecture, or behavior
change. Replace the placeholder text with concrete repository-specific detail
before implementation starts.

## Metadata

This section records the track identity and status so the work remains easy to
follow.

- Track: `<track-slug>`
- Status: `proposed | approved | in-progress | shipped | abandoned`
- Priority: `P0 | P1 | P2`
- Last updated: `<Month Day, Year>`
- Owner: `<name>`

## Summary

This section describes the change in one paragraph. Explain what changes for the
user or system and why the work matters now.

## Problem

This section explains the current problem in concrete terms. Focus on present
behavior and observable impact.

## Goals

This section lists the outcomes the track must deliver.

- `<goal 1>`
- `<goal 2>`
- `<goal 3>`

## Non-goals

This section prevents scope drift by naming what the track will not do.

- `<non-goal 1>`
- `<non-goal 2>`

## User impact

This section explains which users or workflows change and how the value is
measured.

- Primary user: `<user group>`
- Primary workflow: `<workflow>`
- Success signal: `<observable behavior or metric>`

## Scope

This section lists the product areas, screens, and systems affected.

- UI surfaces: `<views or flows>`
- Local data: `<SwiftData models or files>`
- Services: `<network, caching, ranking, or Photos behavior>`
- Tooling: `<tests, CI, project config, or build scripts>`

## Requirements

This section defines the concrete behavior required for implementation.

### Functional requirements

This subsection defines what the system must do.

- `<requirement 1>`
- `<requirement 2>`
- `<requirement 3>`

### Non-functional requirements

This subsection defines quality constraints.

- `<performance, reliability, or privacy requirement>`
- `<adaptive layout or accessibility requirement>`

## UX and adaptive behavior

This section defines how the feature behaves on iPhone, iPad, and any relevant
orientation or size-class variants.

- Compact width: `<behavior>`
- Regular width: `<behavior>`
- Empty, loading, and error states: `<behavior>`

## Data, privacy, and permissions

This section records any local storage, user data, or permission implications.

- Data created or changed: `<models or files>`
- Privacy impact: `<none or explicit change>`
- Permissions impact: `<none or explicit change>`

## Technical approach

This section captures the expected implementation shape. It does not need full
code detail, but it must be specific enough to guide review.

- Entry points: `<view models, views, services>`
- Shared logic strategy: `<how iPhone/iPad behavior stays aligned>`
- Migration or compatibility notes: `<if any>`

## Risks and open questions

This section makes uncertainty explicit before coding starts.

- Risk: `<risk 1>`
- Risk: `<risk 2>`
- Open question: `<question>`

## Acceptance criteria

This section defines the minimum bar for calling the track complete.

- [ ] `<acceptance criterion 1>`
- [ ] `<acceptance criterion 2>`
- [ ] `<acceptance criterion 3>`

## Verification

This section defines how the track is verified.

- Automated checks: `<build, tests, coverage>`
- Manual checks: `<device or simulator flows>`
- Deferred checks: `<if any>`

## Next steps

If follow-up work is intentionally deferred, list it here so it does not vanish
from planning.
