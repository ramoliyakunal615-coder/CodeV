# Variable Selection

## 1. Classify Variables In Two Steps

Always classify variables in this order:

1. valid versus invalid
2. high-efficiency versus low-efficiency

Do not collapse low-efficiency into invalid. A low-efficiency variable can still carry essential correction burden.

## 2. Curvature Variables

### Valid

- all true optical refracting or reflecting surfaces

### Invalid

- dummy surfaces
- stop reference surfaces
- image-plane helper surfaces
- pure return/helper/reference surfaces that are not true optical surfaces

Default rule:

- any true optical surface is a valid curvature-variable candidate
- the stage decision is about efficiency and risk, not validity

## 3. Thickness Variables

A thickness variable is valid only if it represents an independent real physical quantity.

### Valid ordinary thickness variables

- real glass center thickness
- real air spacing between neighboring true surfaces
- a true downstream spacing after a return or helper structure, when that spacing really controls package geometry

### Invalid ordinary thickness variables

- pickup follower thicknesses
- dummy-segment spans that do not represent an independent package degree of freedom
- helper-surface thicknesses whose only job is local closure
- virtual-surface fragments that split one real physical gap into multiple bookkeeping pieces

## 4. Motion Variables

Treat motion variables separately from ordinary structural thickness variables.

### Usually keep open

- `ZOO THI` terms that implement true refocus
- `ZOO THI` terms that implement a floating group
- OIS primary motion variables

### Usually keep closed or coupled

- pickup followers that preserve the intended mechanism geometry
- return/closure variables that restore the downstream frame
- mirror-image or opposite-sign companion variables used only to keep the mechanism closed

## 5. Infinity As Anchor

Default camera-style rule:

- infinity is the anchor configuration
- refocus variables are usually zero or inactive in infinity

Do not treat the infinity refocus state as a free ordinary variable unless the user explicitly defines a different mechanism.

## 6. Return-To-Surface (`RET`) Logic

`RET` changes thickness interpretation.

- the span between a reference surface and its `RET` surface can contain local thickness terms that do not move the downstream system in the usual way
- nearby paired thicknesses can jointly define one real air space
- in those paired cases, usually open only one member of the pair

If the goal is to move the downstream segment relative to the upstream segment:

- choose one true controlling thickness
- do not open both members of a closure pair by default

## 7. Effective-Variable All-Open Policy

After invalid variables are excluded:

- first try an all-open branch across the effective variable pool
- use tighter subsets only for stabilization, comparison, or diagnosis

Keep the all-open branch if:

- hard physical rules remain valid
- the system does not collapse into an obviously worse basin
- the direction of improvement is better than the conservative branch

Roll back to a tighter branch only if the broader release clearly destabilizes the stage.

## 8. Stagewise Opening Guidance

### Early structural stage

- open the strongest effective variables first
- then test a broader release quickly
- if stable, test an effective-variable all-open branch

### Distortion and color stages

- explicitly include low-power but valid surfaces
- do not let a few strong surfaces carry all correction burden

### Final polish

- keep only the variables still contributing
- do not use `MTF` as a structure-rearrangement tool

## 9. Glass Variables

Treat glass changes as structure-level variables, not final-polish variables.

### Valid glass variables

- true transmissive elements whose material choice is still part of the design space
- elements or groups that still carry real residual color burden
- cemented pairs or nearby groups where glass pairing is one of the main color-correction tools

### Invalid glass variables

- dummy or helper surfaces
- air spaces
- mirrors or non-transmissive placeholder surfaces that are not being redesigned as glass elements
- user-fixed materials that are constrained by supply, cost, thermal, mold, or patent-matching requirements
- pickup-style or bookkeeping locations that do not correspond to a real glass assignment

### High-efficiency glass candidates

These usually deserve first attention:

- elements that dominate axial or lateral color residuals
- elements inside strong achromatizing pairs or cemented color-balance groups
- elements whose glass swap can reduce color without immediately breaking the package
- groups that are optically important but already geometrically recognizable

### Low-efficiency glass candidates

These are still valid, but should usually be changed later or in a comparison branch:

- very weak elements whose glass change barely changes residual color
- elements whose material is serving mostly package, thermal, or manufacturability roles
- elements whose glass swap mostly shifts first-order power or package length without helping the real miss

Use glass changes when:

- geometry is physically valid
- residual color remains high
- geometry-only pushes are starting to damage package or first-order stability

### Opening policy for glass variables

- start with a small candidate set, not a blanket glass release
- prefer changing the glasses that carry the clearest residual color burden first
- after a successful small-set glass move, compare it against a slightly broader glass set if the system remains physically stable
- keep `ERR CDV` during the geometry rebalance after a glass change
- do not jump straight from glass selection into `MTF`

### What to compare after a glass change

Always check:

- whether color actually improved
- whether `EFL`, package length, real gaps, and stow length stayed valid
- whether the system now needs a new geometry rebalance
- whether the glass move reduced the burden on a few overworked strong surfaces
