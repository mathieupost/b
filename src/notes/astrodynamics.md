---
title: Astrodynamics
date:  2017-07-08
...

*I'm on vacation and I find myself partway down a rabbit hole that started by reading about the
moon's orbit. Here are some notes on my way down.*

### Kepler's Laws of Planetary Motion

1. The orbit of a planet is an ellipse with the Sun at one of its foci;

2. The line joining the planet to the sun sweeps out equal areas in equal amount of time;

3. The square of the planet's orbital period is proportional to the cube of its average distance
   from the sun.

The major axis of an ellipse is the line drawn through both foci, and the minor axis is the longest
perpendicular line to the major axis. The semi-major axis is half of the major axis (i.e. half of
the distance joining the perihelion to the aphelion). The semi-major axis of the Earth's orbit around the sun is defined to be 1 AU.

The orbital period in years can be found by taking the length of the semi-major axis to the power of $3/2$; that is, $T = D^{3/2}$, where $T$ is orbital period and $D$ is distance.

### Perihelion, Perigee, Periapsis

Periapsis is the nearest point of an orbit around
an arbitrary body. Perigee is the periapsis of an earth-centric orbit, and perihelion is that of
a sun-centric orbit. The same is true for apoapsis, aphelion, and apogee.

Periastron and apastron are sometimes use for non-solar star-centric orbits.

Pericynthion and apocynthion or perilune and apolune are sometimes used for lunar orbits.

### Newton's Law of Gravitation

$$
\mathbf{F}_g = -\frac{Gm_1m_2}{r^2}\hat{\mathbf{r}}
$$

$G$ is the gravitational constant, which is some large number that I'm not going to bother remembering.

### Sidereal vs. Solar Time

**Sidereal Time** is based on the period over which 360º of rotation occur in inertial space, or,
more plainly, the time it takes for stars to return to the same apparent position in the sky.

**Solar Time** (or, more generally, **Synodic Time**) refers to the time it takes for the Sun (or other orbited body) to return to the same point in the sky.

With prograde rotation, a synodic day will be longer than a sidereal day. With retrograde rotation,
a synodic day will be shorter than a sidereal day (because with clockwise rotation whilst orbiting
a body counter-clockwise, the orbited body will cross the same point on the horizon before
completing one full rotation).

Since Earth's orbit is somewhat elliptical, and its rotational axis is somewhat oblique with respect to the ecliptic plane, we can measure solar time in **apparent solar time** or **mean solar time**. Apparent solar time refers to the absolute position of the sun, and mean solar time is an average to provide equal days. UTC is basically mean solar time at the prime meridian.

On earth, sidereal time is measured using GMST, or Greenwich Mean Sidereal Time. GMST is basically the angle between the vernal equinox direction and the component of the vector formed by joining the center of the earth and the intersection of the prime meridian and the equator, in the ecliptic plane.

### Coordinate Systems
