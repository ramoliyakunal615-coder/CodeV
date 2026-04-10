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
