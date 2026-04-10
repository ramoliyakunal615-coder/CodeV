# Interactive Stage Templates

Use these templates when the user wants a visible CODE V session and the run should stay in the same GUI window.

Bundled templates:

- [scripts/interactive_prepare.template.seq](../scripts/interactive_prepare.template.seq)
- [scripts/interactive_cdv_stage.template.seq](../scripts/interactive_cdv_stage.template.seq)
- [scripts/interactive_finish.template.seq](../scripts/interactive_finish.template.seq)

## 1. Template Roles

### Prepare template

Use the prepare template when a stage needs a clean visible-session setup before `AUT`.

It is meant to:

1. `RES` the source lens into the existing visible window
2. refresh true aperture and vignetting
3. freeze and reopen the intended variable set
4. save a clean pre-stage lens snapshot

### CDV stage template

Use the CDV stage template for the main structure, distortion, or color stages where geometry is still moving.

It is meant to:

1. `RES` the prepared source lens
2. run one bounded `AUT` stage with `ERR CDV`
3. preserve physical rules
4. refresh vignetting again
5. save/export the stage result

### Finish/export template

Use the finish/export template when the stage has already finished and the job is to create a clean visible-session export and optionally run acceptance.

## 2. Default Execution Pattern

In a visible interactive session, prefer this sequence:

1. prepare
2. one bounded `AUT` stage
3. finish/export

Do not make a single monolithic sequence unless the user explicitly prefers that style.

## 3. Placeholder Discipline

Before executing a template:

- replace every `<...>` placeholder
- replace example surface numbers with the real stage variable set
- keep only the active rules for that stage
- delete unused optional lines instead of leaving them ambiguous

## 4. Visible-Session Notes

- Reuse the same CODE V GUI window.
- Let each stage script `RES` its source lens internally.
- Do not reopen a fresh GUI window for each stage.
- If the user wants to see cycle-by-cycle progress, keep the stage interactive and bounded rather than overly long.

## 5. What To Keep Stage-Local

Each stage template should expose:

- stage identity
- source lens name
- result lens name
- active variable set
- active hard physical rules

That keeps the CODE V command window readable and makes it easier to decide whether to accept, hold, or roll back the result.
