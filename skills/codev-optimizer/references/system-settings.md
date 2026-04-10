# System Settings

## 1. Choose The Conjugate Model First

Decide this before writing the optimization stages:

- infinite-conjugate imaging
- finite-conjugate imaging
- mixed multi-distance imaging

This choice drives field type, aperture definition, and which first-order quantities should be anchored.

## 2. Aperture Definition Rules

### Prefer `FNO` when

- the system is an ordinary camera lens
- the primary product language is focal length plus `F/#`
- image-space cone behavior is the natural starting specification

### Prefer `EPD` or a real stop-driven model when

- the true stop or pupil diameter must remain physically realistic
- near-focus behavior or effective aperture realism matters
- the user cares about how real stop size and vignetting interact during optimization

### Prefer `NA` or `NAO` when

- the system is finite conjugate
- the task is inspection, microscopy, coupling, or illumination-like work
- object-space acceptance angle is the more natural specification than image-space `F/#`

Default camera rule:

- start with `FNO`
- switch toward real stop or `EPD` control when the user wants higher pupil realism or near-focus realism

## 3. Field Definition Rules

### Prefer `XAN/YAN` when

- the main specification is field of view
- the system is a normal camera or imaging lens described by angle coverage
- infinity is the main configuration

### Prefer `XIM/YIM` when

- the system is still a camera
- but the evaluation should stay tied to fixed sensor positions while focus changes
- you want the sensor sampling points to remain stable across multi-distance work

### Prefer `XOB/YOB` when

- the task is finite-conjugate imaging with fixed object size coverage
- the specification is written in object-space dimensions rather than field angle

### Avoid `XRI/YRI` as the normal camera default

Use `XRI/YRI` only when true image height itself is the target quantity. For ordinary camera optimization, it can hide distortion behavior by letting the field definition move with the actual image position.

## 4. Rotational Symmetry Rules

For rotationally symmetric systems:

- usually prefer a single radial field line
- usually keep `X = 0` and sample only `Y`

Use full `X/Y` field bookkeeping only when:

- the user wants sensor-corner bookkeeping explicitly
- the system is no longer effectively rotationally symmetric
- OIS, decenter, or other asymmetry makes azimuth matter

## 5. Field Sampling Density

### Start-up stage

- three fields can be enough for initial structure shaping

### Main optimization

- usually move to at least five radial fields
- use more if the edge behavior is uneven or if corner quality matters strongly

### Final evaluation

- do not stop at three fields
- use a denser field sweep or enough radial samples to expose mid-field and edge-field failures

Practical rule:

- three fields are a starting convenience
- they are not a final acceptance sampling plan

## 6. Configuration Priority

Default camera-style priority:

1. infinity
2. near-focus configurations
3. OIS

Unless the user says otherwise:

- lock first-order mainly on infinity
- apply full distortion and color control mainly on infinity
- let near-focus and OIS carry downgraded optical goals if the user has chosen that policy

## 7. First-Order Locking Rules

Usually lock these first on the main infinity configuration only:

- `EFL`
- package length or `OAL`
- main image-height or image-circle intent

Do not automatically force identical first-order locks on every configuration unless the user explicitly wants that.

## 8. Distortion And Illumination Setting Style

- do not assume the distortion target is exactly zero
- use the user’s allowed range or preferred sign
- introduce distortion control only after the structure is out of the `ROU` regime

If the user accepts downgraded non-main configurations:

- keep full distortion/color control on the main configuration
- allow near-focus or OIS to emphasize image quality first

## 9. Refocus / Floating Setup

For multi-configuration imaging systems:

- keep object distance changes and motion variables conceptually separate
- treat refocus or floating variables as motion variables, not ordinary package thicknesses
- usually keep the motion variables open
- keep their pickup follower variables coupled

Infinity is usually the anchor state:

- refocus there is usually zero or inactive
- near-focus and other work states carry the actual motion

## 10. Default Decision Order

Before building or revising an `AUT` script, choose settings in this order:

1. conjugate model
2. aperture definition
3. field definition
4. field sampling density
5. configuration priority
6. first-order locking policy
7. downgrade policy for secondary configurations

If these are chosen poorly, later optimization settings will often look wrong even when the AUT logic itself is reasonable.
