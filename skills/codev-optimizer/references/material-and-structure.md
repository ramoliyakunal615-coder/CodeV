# Material And Structure Changes

## 1. When To Switch Away From Pure Geometry

Consider glass or structure changes when:

- physical constraints are already active and geometry keeps circling
- axial or lateral color stays high while basic shape is already stable
- edge-field image quality stops improving with reasonable curvature changes
- further geometry-only pushes damage `EFL`, package, or true-gap stability

## 2. Glass Strategy

Use glass changes late enough that the geometry is recognizable, but early enough that you are not forcing impossible color correction into a bad material split.

Typical order:

1. settle a physically valid geometry
2. identify which groups carry the remaining color burden
3. change only a small number of candidate glasses
4. rebalance geometry with `ERR CDV`
5. re-run independent acceptance

Treat glass exploration as a structure-level move, not a final polish.

### Practical glass-choice rules

- First identify which real elements or groups are still carrying the unmet color burden.
- Prefer changing a small, meaningful glass set instead of opening every material at once.
- A glass variable is valid only if it belongs to a true transmissive element whose material is still part of the design space.
- Do not spend glass freedom on dummy surfaces, air spaces, or elements that the user has already fixed for supply, molding, thermal, or patent reasons.
- If a glass change mostly hurts `EFL`, package, or real gaps but barely improves color, that candidate is probably low-efficiency for the current stage.
- After any glass change, geometry must usually be rebalanced again with `ERR CDV` before judging the move.

## 3. Non-Spherical Surfaces

Choose non-spherical surfaces only after the spherical structure is basically sound.

Prefer positions that maximize performance per manufacturing cost:

- near stop for balanced all-field influence
- rear group for image-side and CRA-related cleanup
- front strong-power surfaces only when truly necessary

## 4. Split, Cement, Delete

- Delete a lens if it has become optically redundant.
- Split a lens if one surface is overloaded and the system lacks degrees of freedom.
- Cement adjacent elements if the air gap has lost function but glass pairing is still useful for color.

## 5. Floating Groups

Try pure refocus first.
Add a floating group only when near-focus errors cannot be recovered by image-plane refocus alone.
