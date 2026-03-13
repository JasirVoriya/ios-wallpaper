# Plan template

Use this template after a track spec is approved. The plan turns the spec into
an execution checklist that maps directly to the repository.

## Metadata

This section identifies the plan and keeps progress visible.

- Track: `<track-slug>`
- Status: `planned | in-progress | blocked | complete`
- Last updated: `<Month Day, Year>`

## Implementation strategy

This section explains the sequencing logic for the work. State why the phases
are ordered this way and what must land before later steps are safe.

## Phase 1

This section groups the first coherent block of work.

- [ ] `<task 1>`
- [ ] `<task 2>`
- [ ] `<task 3>`

## Phase 2

This section groups the next coherent block of work.

- [ ] `<task 1>`
- [ ] `<task 2>`
- [ ] `<task 3>`

## Phase 3

This section groups the final coherent block of work.

- [ ] `<task 1>`
- [ ] `<task 2>`
- [ ] `<task 3>`

## Verification checklist

This section lists the checks required before the track can move to complete.

- [ ] Command-line build passes
- [ ] Relevant automated tests pass
- [ ] Manual UI checks are complete
- [ ] Changelog is updated if the change is user-visible
- [ ] Roadmap and track status are updated

## Risks and dependencies

This section captures execution-time concerns that can block or reshape the
plan.

- Dependency: `<dependency or prerequisite>`
- Risk: `<risk>`

## Next steps

When the implementation changes scope, update the track spec first and then
bring this plan back into sync.
