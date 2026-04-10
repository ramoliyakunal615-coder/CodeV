# Physical Rules

## 1. Vignetting and True Aperture

Default sequence before and after each `AUT` block:

```text
SET APE
SET VIG
DEL APE SA
```

If you intentionally want a stronger true limiting aperture:

1. Use a real aperture change such as `CIR S'Gx' value`
2. Regenerate vignetting
3. Remove the temporary aperture lock with `DEL APE SA`
4. Keep the regenerated vignetting for the next solve or acceptance step

Only do this when center field remains unblocked and the illumination budget permits it.

## 2. Air Gaps and Virtual Surfaces

Use general constraints for most ordinary gaps:

```text
MXT 8
MNT 0.8
MNE 0.8
MNA 0.08
MAE 0.1
```

But treat them as adjacent-surface checks only.

`CT/ET` can control air gaps as well as glass thicknesses, but they still act on adjacent thickness definitions. Do not treat them as full substitutes for a real physical clearance across virtual surfaces.

If real surfaces have virtual surfaces between them, `general constraints` and `CT/ET` are not enough to represent the real physical gap. In those cases, control the real gap with `FTGT`.

Use `FCT_FTGT` when:

- Real surfaces are separated by virtual surfaces
- The real surfaces are non-spherical
- The gap belongs to a moving group
- The real physical minimum clearance matters more than local adjacent thickness

If two nearby thickness variables jointly define one real air space, usually open only one of them during optimization. Keep the other fixed or coupled unless the user explicitly wants redundant freedom in that local package definition.

## 3. Hard-Rule Priority

These are usually hard rules:

- real-surface clearance
- minimum air thickness
- stop-adjacent gap
- stow-length proxy
- package length
- sign constraints that define geometry direction

When these conflict with performance, keep the physical rule and change the optical strategy.

## 4. Stow-Length Proxy

Default proxy idea:

```text
group length = OAL(group) + front protrusion + rear protrusion
stow total = sum(group lengths)
```

Use group-level package proxies directly in the error function unless a separate stowed mechanical state is absolutely necessary.

## 5. Acceptance Order

- First verify the hard physical rules.
- Then verify the independent optical acceptance.
- If the optical result is better but the physical rule fails, reject that candidate.
