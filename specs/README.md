# Specs

This directory is the source of truth for product planning and feature
specifications in WallpaperApp. The repository now uses GitHub Spec-Kit for the
feature workflow, with stable project context stored alongside numbered feature
directories.

## Directory structure

This section explains how planning files are split between stable project
context and per-feature artifacts.

- `.specify/`: Spec-Kit constitution, templates, and workflow scripts
- `specs/foundation/`: stable baseline documents about the current product
- `specs/roadmap.md`: prioritized track view for what the product should tackle
  next
- `specs/NNN-feature-name/`: one numbered feature specification with its own
  spec, plan, and supporting artifacts

## How feature work starts

This section explains the expected flow for new feature work.

1. Check `specs/roadmap.md` and confirm the next feature priority.
2. Create a numbered branch and feature directory with Spec-Kit.
3. Write or update `spec.md` for the feature.
4. Create `plan.md`, then supporting artifacts such as `research.md`,
   `data-model.md`, `quickstart.md`, and `tasks.md` as needed.
5. Implement only after the spec and plan are concrete enough to review.

## Current baseline

This section points to the documents that define the current app before new work
starts.

- Start with [product-spec.md](./foundation/product-spec.md)
- Use [roadmap.md](./roadmap.md) to choose or update the active feature
- Use [002-multiplatform-architecture](./002-multiplatform-architecture/spec.md)
  as the current active Spec-Kit feature
- Use [001-offline-wallpaper-caching](./001-offline-wallpaper-caching/spec.md)
  as the adjacent follow-up feature

## Next steps

Create future features as numbered directories in `specs/` and keep
`.specify/memory/constitution.md` aligned with the way the repository actually
works.
