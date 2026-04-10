# Diagnostics

## 1. Failure Triage

When a run misses targets, classify the failure first:

- not enough cycles yet
- converged to the wrong basin
- new constraints were introduced too early or too hard
- the model is inconsistent with true aperture or vignetting
- the structure ran out of degrees of freedom
- the architecture itself is near its limit

## 2. Read The Miss In Layers

Check in this order:

1. first-order stability
2. package and hard physical rules
3. true aperture and vignetting consistency
4. main-configuration basic aberrations
5. multi-configuration conflicts
6. distortion, color, and only then `MTF`

## 3. Spot / Ray-Fan Heuristics

- symmetric, axis-heavy swelling: think spherical or defocus
- sagittal/tangential split: think astigmatism
- one-sided tail: think coma
- refocus helps strongly: think field curvature or focus error
- color groups separate: think color
- abrupt edge change with illumination change: think clipping or vignetting

## 4. Change Only One Layer Per Iteration

On the next run, change only one main thing:

- weights
- stage strictness
- variable set
- vignetting/aperture model
- glass choices
- architecture

Do not change all of them at once.

## 5. Candidate Labeling

After every meaningful run, label the result mentally as one of:

- physically invalid
- physically valid but optically worse
- physically valid and optically improved
- physically valid and ready for final polish

## 6. Accept / Hold / Roll Back

Do not judge a stage result only by whether the error function went down.

After each meaningful stage, decide explicitly whether to:

- accept it as the new base
- hold it only as a diagnostic branch
- roll it back

### Accept as new base

Accept a stage result as the new base when:

- all hard physical rules still hold
- first-order stability is still acceptable
- the intended stage goal improved in the right direction
- no hidden regression of equal or greater importance was introduced

Examples:

- a real-gap rule is now satisfied and image quality is recoverable later
- color improved while package and true clearances stayed valid
- edge-field balance improved without breaking the main infinity configuration

### Hold as diagnostic branch

Keep a result only as a diagnostic branch when:

- it proves a constraint or variable choice is meaningful
- it reveals the direction of sensitivity
- but it is not yet good enough to become the new base

Examples:

- a branch proves `FTGT` can be satisfied, but image quality collapses
- a branch proves a certain glass family reduces color, but package stability is not yet recovered
- a branch shows a broader variable set destabilizes the stage

### Roll back

Roll back when:

- a hard physical rule fails
- the result clearly moves into a worse basin
- first-order quantities drift outside the acceptable stage envelope
- the stage objective does not improve enough to justify the new damage

Examples:

- `EFL` or package length runs away while trying to fix a local gap
- a new constraint is technically met, but the system becomes optically unusable
- a broader variable release produces no useful gain and destabilizes the stage

## 7. How To Compare A New Stage Against The Old Base

Compare in this order:

1. hard physical rules
2. first-order stability
3. main-configuration intended stage goal
4. collateral regressions in other important metrics
5. whether the new state leaves a sensible next step

If the new branch is physically invalid, reject it immediately.

If the new branch is physically valid but worse optically, keep it only if it establishes a necessary physical precondition that can reasonably be recovered later.

If two branches are both physically valid, prefer the one that:

- keeps more recovery paths open
- avoids extreme burden concentration on a few surfaces
- reduces the risk of needing a structural reset in the next stage

## 8. Typical Stage Decisions

### Early structural stage

- be willing to accept a physically stronger but optically incomplete result
- do not accept a physically invalid result even if the image quality is prettier

### Distortion stage

- keep the branch only if distortion improves without breaking the base geometry
- if distortion improves but color and package collapse, hold it as diagnostic only

### Color or glass stage

- accept only if color improves and the package remains sane
- if glass reduces color but destroys first-order stability, treat it as candidate information, not as the new base

### Final polish stage

- only accept if both physical rules and finished optical metrics improve or at least hold
- final polish should not create a new structural problem
