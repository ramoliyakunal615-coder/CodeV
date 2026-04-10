---
name: codev-optimizer
description: Stage and validate CODE V lens optimization for camera and general imaging systems. Use when Codex needs to optimize or review a CODE V lens, choose system settings, build or revise AUT sequences, manage real apertures and vignetting, enforce physical constraints such as air gaps, stow length, and real-surface clearance, decide when to switch to glass optimization, and save or validate timestamped .len/.seq results.
---

# CODE V Optimizer

## Overview

Use this skill to run CODE V optimization with a physical-first, staged workflow. Prefer it when the task involves `.seq` or `.len` lenses, `AUT` design strategy, aperture and vignetting control, multi-configuration priorities, or acceptance checks.

## Workflow Decision

1. Read the current lens, specs, and user priorities.
2. Start a visible CODE V UI session before the first optimization action, unless the user explicitly wants background-only work.
3. Choose system settings and stage strategy.
4. Enforce physical constraints before pushing performance.
5. Refresh true aperture and vignetting before and after each `AUT` block.
6. Prefer `ERR CDV` while structure, thickness, glass, or residual color are still moving.
7. Use `MTF` error function only for final narrow polish.
8. Save timestamped `.len` and `.seq` outputs after meaningful runs.
9. Validate with an independent check script after the final vignetting refresh.

## Immediate Rules

- For interactive optimization, automatically launch the visible CODE V UI at the start of the task.
- Prefer opening the target `.len` directly into the visible CODE V session. Do not default to `/input=` startup for GUI work.
- After the window exists, reuse the same visible CODE V window for later stages. Let each stage script `RES` its source lens internally instead of opening a new GUI window every time.
- If the visible CODE V window has been closed, reopen the target `.len` first, then continue.
- Treat physical rules as prerequisites. If performance conflicts with real gaps, air thickness, stow length, or package limits, keep the physical rules and change the structure or glass strategy instead.
- Add standards gradually. Use a loose target first, then tighten only after the system shows it can carry the new requirement.
- When a thickness or physical quantity is identical across configurations, constrain it only once.
- Before every `AUT` block, run `SET APE -> SET VIG -> DEL APE SA`.
- Before final acceptance, run `SET APE -> SET VIG -> DEL APE SA` again.
- If you intentionally change the true limiting aperture, establish it with real aperture changes first, then regenerate vignetting.
- Do not use `FCT_FTGT` for every air gap. Use it only for key real-surface gaps, non-spherical gaps, moving groups, or cases with virtual surfaces between real surfaces.

## Read These References As Needed

- Read [references/workflow.md](references/workflow.md) for phase ordering, error-function choice, variable-release order, and result-saving rules.
- Read [references/physical-rules.md](references/physical-rules.md) for vignetting, aperture clipping, air-gap logic, `FTGT`, and stow-length rules.
- Read [references/material-and-structure.md](references/material-and-structure.md) when geometry stalls and you need to change glass, add non-spherical power, split or merge groups, or consider floating groups.
- Read [references/diagnostics.md](references/diagnostics.md) when a run misses targets and you need to diagnose whether the blocker is settings, structure, color, pupil, or architecture.

## Workspace Conventions

- If the workspace already contains helper files such as `templates/FCT_FTGT.seq`, `templates/FCT_CRA.seq`, playbooks, or acceptance scripts, prefer reusing them.
- Keep optimization scripts and acceptance scripts separate.
- Save new results with timestamps and keep the latest validation log readable.
- When the user has established house rules, follow them even if CODE V offers looser defaults.
