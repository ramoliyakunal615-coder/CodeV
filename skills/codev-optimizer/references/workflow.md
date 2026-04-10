# Workflow

## 1. Start From Clear Targets

Confirm or infer these in order:

- Main configuration priority
- First-order targets: `EFL`, `F/#`, `OAL`, image height, package limits
- Which configurations get full specs and which are downgraded
- Which constraints are hard physical rules
- Which metrics are acceptance-only versus optimization-stage guides

## 1A. Visible UI Startup And Reuse

- For optimization tasks, default to a visible CODE V UI session.
- On the first step of a task, open the target `.len` directly into CODE V so the user can see the real lens data immediately.
- Do not rely on `/input=` startup as the default GUI path. It can create blank or untitled sessions even when the backend process exists.
- After the visible window is open, reuse that same CODE V window for later stages.
- Subsequent stage scripts should `RES` the current source lens inside the script, then continue with the next stage in the same window.
- If the user has closed the visible CODE V window, reopen the target `.len` first and only then continue with stage execution.
- If the user wants real-time progress, run `AUT` interactively in CODE V instead of assuming `/background` plus `.lis` tailing will be equivalent.
- When real-time 2D layout is requested, keep `DRA` inside the normal stage script. Use it to expose the true stage run, not to build a separate “view-only” branch.

## 2. Default Stage Order

1. Basic aberrations and structure shaping
2. Distortion, early but loose
3. Color, late and gradual
4. `MTF`, only as final narrow polish

Do not jump straight to `MTF` if structure, thickness, air gaps, glass allocation, or larger residual color are still changing.

## 3. Error-Function Guidance

- Prefer `ERR CDV` for structure adjustment.
- Keep `WFR NO` while structure is still moving unless there is a strong reason otherwise.
- Use `STP YES` for early or middle acceleration.
- Use `ROU` only for clearly bad starting points.
- Use `Standard` to settle a stable local solution.
- Treat `MTF` error function as a finish pass only.

## 4. Variable Release Order

- First: main power surfaces and key air spaces
- Next: secondary curvatures and selected thicknesses
- Later: more sensitive local thicknesses, glass changes, non-spherical surfaces, floating groups
- At every active stage, after the current variable set stabilizes, try a broader release on top of the current set. First add a few more variables; if the system can carry it, also try an all-open branch for that stage.
- After invalid variables have been excluded, treat the effective-variable all-open branch as the first-priority optimization tactic. Conservative subsets are mainly for stabilization, comparison, and diagnosis.
- Keep the broader-release trial only if it preserves the hard physical rules and gives a better direction. If it destabilizes the stage, roll back to the tighter set.
- Do not classify low-efficiency variables as invalid variables. In imaging lenses, any true optical refracting surface is an effective variable in principle; what changes by stage is its efficiency, coupling strength, and risk.
- Keep invalid variables limited to non-physical or non-optical-control surfaces such as dummy surfaces, stop references, image plane placeholders, or other helper surfaces that should not carry optical correction burden.
- Low-power surfaces can still carry essential work in color correction, field curvature balance, pupil control, or distortion balance. If they are never opened, the optimizer can over-concentrate correction on a few strong surfaces and drive the design toward an unnecessarily extreme form.
- Treat `ZOO THI` style motion variables differently from ordinary structural thickness variables. If a `ZOO THI` term is the real refocus, floating-group, or motion-control degree of freedom of the lens, keep it open by default instead of repeatedly freezing and reopening it as if it were an ordinary package thickness.
- For thickness variables, classify validity by physical meaning, not only by surface type. A valid ordinary thickness variable must represent an independent real physical quantity such as a real glass center thickness or a real air spacing.
- In camera-style multi-configuration work, the refocus variable is usually not an active variable in the infinity configuration and is often zero there. Treat infinity as the anchor state unless the user explicitly defines a different motion strategy.
- If a refocus or OIS variable has a paired pickup variable that preserves the intended mechanism geometry, do not independently free the pickup follower. Keep the pickup relationship intact unless the user explicitly wants to redesign that mechanism.
- Apply the same logic to decenter and tilt mechanisms. Distinguish between the primary motion variable that actually moves the group and the return/closure variable that restores the downstream reference frame. Keep the return variable coupled or frozen by default; do not free it as an ordinary variable.
- If the lens uses `RET` (`Return to Surface`), classify nearby thickness variables by scope before opening them. Some thicknesses around the return act as a pair that jointly defines one real local air space or local closure condition.
- For that kind of paired `RET` geometry, do not free both members of the pair at the same time unless the user explicitly wants redundant freedom. Usually one is enough.
- When the goal is to move the downstream segment relative to the upstream system, the thickness on the `RET` surface itself or the first true downstream spacing after the return can both be effective control variables. Choose one as the primary variable instead of opening both by default.
- By default, do not treat dummy-segment thicknesses, helper-surface spans, or pickup follower thicknesses as ordinary structural thickness variables. They may still matter geometrically, but they should stay in the motion/closure layer unless the user explicitly wants to redesign that mechanism.

If a run blows up after adding variables, close the most sensitive variables first instead of changing everything.

## 5. Multi-Configuration Priority

For camera-style systems, default priority is:

- Infinity first
- Near focus next
- OIS lowest

Usually lock first-order only on the main infinity configuration unless the user asks otherwise.

## 6. Save and Validate

After a meaningful run:

1. Refresh vignetting
2. Save timestamped `.len`
3. Save timestamped `.seq`
4. Run independent acceptance
5. Record whether the new version is physically valid, optically improved, or both.
