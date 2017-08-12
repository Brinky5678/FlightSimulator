
import AstroDynBase: AbstractState, Frame, GCRF, epoch, isrotating
import AstroDynBase: CelestialBody, Planet, NaturalSatellite, MinorBody, Barycenter,
    Sun, SSB, SolarSystemBarycenter
import AstroDynBase: naif_id, μ, mu, j2, mean_radius, equatorial_radius, polar_radius,
    maximum_elevation, maximum_depression, deviation, parent, show,
    right_ascension, right_ascension_rate, declination, declination_rate,
    rotation_angle, rotation_rate, euler_angles, euler_derivatives
import AstroDynBase: PLANETS, MINORBODIES, SATELLITES, Sun

#Extract Planet Types
Mercury = PLANETS[1]
Venus = PLANETS[2]
Earth = PLANETS[3]
Mars = PLANETS[4]
Jupiter = PLANETS[5]
Saturn = PLANETS[6]
Uranus = PLANETS[7]
Neptune = PLANETS[8]

#Extract Minor Bodies Types
Pluto = MINORBODIES[1]

#Extract Satellties Types
Moon = SATELLITES[1]
