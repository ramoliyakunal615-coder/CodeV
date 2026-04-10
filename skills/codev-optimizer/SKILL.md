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
- If the user wants to watch optimization progress cycle by cycle, prefer an interactive CODE V session over `/background`. Do not assume a background `.lis` file will flush per-cycle updates in real time.
- If the user wants 2D layout visualization during optimization, enable `DRA` as part of the normal optimization run. Treat it as a stage output aid, not as a separate fake visualization mode.
- Treat physical rules as prerequisites. If performance conflicts with real gaps, air thickness, stow length, or package limits, keep the physical rules and change the structure or glass strategy instead.
- Add standards gradually. Use a loose target first, then tighten only after the system shows it can carry the new requirement.
- When a thickness or physical quantity is identical across configurations, constrain it only once.
- Before every `AUT` block, run `SET APE -> SET VIG -> DEL APE SA`.
- Before final acceptance, run `SET APE -> SET VIG -> DEL APE SA` again.
- If you intentionally change the true limiting aperture, establish it with real aperture changes first, then regenerate vignetting.
- Do not use `FCT_FTGT` for every air gap. Use it only for key real-surface gaps, non-spherical gaps, moving groups, or cases with virtual surfaces between real surfaces.

## Read These References As Needed

- Read [references/workflow.md](references/workflow.md) for phase ordering, error-function choice, variable-release order, and result-saving rules.
- Read [references/system-settings.md](references/system-settings.md) when deciding conjugate type, aperture definition, field definition, field sampling density, and configuration priority.
- Read [references/variables.md](references/variables.md) when deciding which curvature, thickness, glass, or motion variables are valid, high-efficiency, low-efficiency, coupled, or invalid.
- Read [references/physical-rules.md](references/physical-rules.md) for vignetting, aperture clipping, air-gap logic, `FTGT`, and stow-length rules.
- Read [references/material-and-structure.md](references/material-and-structure.md) when geometry stalls and you need to change glass, add non-spherical power, split or merge groups, or consider floating groups.
- Read [references/diagnostics.md](references/diagnostics.md) when a run misses targets and you need to diagnose whether the blocker is settings, structure, color, pupil, or architecture.
- Read [references/ui-session.md](references/ui-session.md) when the user wants a visible CODE V session, interactive progress, or stage-by-stage GUI execution.
  - Use that same diagnostics reference to decide whether a stage result becomes the new base, stays only as a diagnostic branch, or must be rolled back.

## Workspace Conventions

- If the workspace already contains helper files such as `templates/FCT_FTGT.seq`, `templates/FCT_CRA.seq`, playbooks, or acceptance scripts, prefer reusing them.
- Keep optimization scripts and acceptance scripts separate.
- Save new results with timestamps and keep the latest validation log readable.
- When the user has established house rules, follow them even if CODE V offers looser defaults.

## Bundled UI Helper Scripts

This skill can be paired with visible CODE V UI automation when the user wants to watch optimization progress in the real GUI.

- `scripts/run_example_ui_visible.ps1`
  - Opens a known-good `.len` directly in a visible CODE V session.
  - Use this pattern for the first visible launch of a task.
- `scripts/ui_send_codev_command.ps1`
  - Sends a command or `IN "...seq"` into the visible CODE V command input box by UI Automation.
  - Prefer this over raw `SendKeys`.
- `scripts/ui_run_send_codev_command.vbs`
  - Thin launcher for the PowerShell bridge when a desktop-session handoff is needed.
- `scripts/ui_run_current_seq.vbs`
  - Sends a single sequence file into the current visible CODE V window.

Usage notes:

- For visible interactive work, first open the target `.len`, then inject later stage scripts into that same window.
- Do not default to opening a new GUI window for every stage.
- Let each stage script `RES` its source lens internally.
- Treat these scripts as desktop-session bridge examples. They may need path or title adjustments when reused in another workspace.

## House-Style Defaults To Preserve

- Physical rules win over performance.
- Add performance targets gradually: basic aberrations, then distortion, then color, and only then `MTF`.
- Treat all true optical refracting surfaces as valid curvature-variable candidates in principle; separate valid from invalid first, then high-efficiency from low-efficiency.
- Treat effective-variable all-open as the first-priority branch after invalid variables have been removed.
- Treat ordinary structural thickness variables, motion variables, pickup followers, and return/closure variables as different classes. Do not mix them casually.
