module FlightSimulator


#using JPLEphemeris
import JPLEphemeris: SPK, print_segments, Dates, position, velocity, state

export Mercury, Venus, Earth, Moon, Mars, Jupiter, Saturn, Neptune, Uranus, Pluto

#Include utility functions
include("MathUtils.jl")
include("Utils.jl")

#List of constants
include("ListOfConstants.jl")

#simulator Options
include("SimulatorOptions.jl")

#Model Properties Type
include("ModelOptions.jl")

include("Models\\GravityModels\\CentralGravity.jl")
DefineGravityModel("central", CentralGravity)

include("Models\\GravityModels\\J2Gravity.jl")
DefineGravityModel("j2",J2Gravity)

include("Models\\GravityModels\\J23Gravity.jl")
DefineGravityModel("j23",J23Gravity)

include("Models\\GravityModels\\J234Gravity.jl")
DefineGravityModel("j234",J234Gravity)

include("Models\\PlanetModels\\SphericalPlanet.jl")
DefinePlanetModel("spherical", SphericalAltitude)

include("Models\\PlanetModels\\EllipsoidPlanet.jl")
DefinePlanetModel("ellipsoid", EllipsoidAltitude)

include("Models\\AtmosphereModels\\ExpoAtmos.jl")
DefineAtmosphereModel("exp", ExpoAtmos

include("Models\\AtmosphereModels\\US76Atmos.jl")
DefineAtmosphereModel("us76", US76Atmos)

include("FlightSimBase.jl")

end
