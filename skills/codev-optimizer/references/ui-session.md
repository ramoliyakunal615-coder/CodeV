# Visible UI Session

## 1. Preferred GUI Startup

For visible interactive work:

1. open the target `.len` directly
2. wait for the visible CODE V window to appear
3. reuse that same window for later stages

Do not treat `/input=` startup as the default GUI path. It can create blank or untitled windows.

## 2. Reuse The Same Window

After the first visible window exists:

- keep using that same CODE V session
- let each stage script `RES` the source lens internally
- do not open a fresh GUI window for every phase

If the user closes the window:

- reopen the target `.len`
- then continue stage execution

## 3. Interactive Progress

If the user wants to watch optimization progress:

- prefer an interactive CODE V session over `/background`
- expect the CODE V command window to show per-cycle progress more reliably than a background `.lis`

If the user wants 2D layout updates at the same time:

- keep `DRA` inside the normal stage script
- use it as real stage output, not as a detached fake visualization branch

## 4. Stable Command Injection Pattern

When a visible session must be controlled from the desktop:

- first target the already opened visible lens window
- then inject either a single command or `IN \"...seq\"`
- prefer direct UI Automation on the command input box over raw `SendKeys`

Bundled helper scripts:

- `scripts/run_example_ui_visible.ps1`
- `scripts/ui_send_codev_command.ps1`
- `scripts/ui_run_send_codev_command.vbs`
- `scripts/ui_run_current_seq.vbs`
- `scripts/interactive_prepare.template.seq`
- `scripts/interactive_cdv_stage.template.seq`
- `scripts/interactive_finish.template.seq`

Treat them as bridge examples, not universal productized tooling.

## 5. Stage Script Design For Visible Work

A visible stage script should usually:

1. `RES` the current source lens
2. state the stage purpose in the command window
3. refresh true aperture and vignetting
4. set or restore the intended variable state
5. run one stage of `AUT`
6. refresh vignetting again
7. save the updated `.len`
8. export the updated `.seq` if needed

Keep stage scope small enough that the user can understand what changed.

For reusable stage skeletons, read [stage-templates.md](stage-templates.md).

## 6. What The User Should Be Able To See

For a good interactive run, expose:

- the lens data window for current geometry
- the CODE V command window for true progress
- the active stage identity
- the source lens being restored
- the saved result name after the stage completes

If real-time command injection is unstable, fall back to:

- visible CODE V for geometry
- stage-by-stage saved outputs

but prefer true interactive execution whenever stable.
