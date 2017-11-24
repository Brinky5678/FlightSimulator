
#Define abstract enviroment type to allow for customization later.
abstract type AbstractEnvironment end

#Define the structure containing the PlanetEnvironments for each CelestialBody
struct Environment  <: AbstractEnvironment
    SunEnvironment::PlanetEnvironment
    MercuryEnvironment::PlanetEnvironment
    VenusEnvironment::PlanetEnvironment
    EarthEnvironment::PlanetEnvironment
    MoonEnvironment::PlanetEnvironment
    MarsEnvironment::PlanetEnvironment
    #CeresEnvironment::PlanetEnvironment
    JupiterEnvironment::PlanetEnvironment
    SaturnEnvironment::PlanetEnvironment
    UranusEnvironment::PlanetEnvironment
    NeptuneEnvironment::PlanetEnvironment
    PlutoEnvironment::PlanetEnvironment
end

#Alternative constructor function
function Environment(;Sun::PlanetEnvironment = PlanetEnvironment(false),
    Mercury::PlanetEnvironment = PlanetEnvironment(false),
    Venus::PlanetEnvironment = PlanetEnvironment(false),
    Earth::PlanetEnvironment = PlanetEnvironment(false),
    Moon::PlanetEnvironment = PlanetEnvironment(false),
    Mars::PlanetEnvironment = PlanetEnvironment(false),
    Jupiter::PlanetEnvironment = PlanetEnvironment(false),
    Saturn::PlanetEnvironment = PlanetEnvironment(false),
    Uranus::PlanetEnvironment = PlanetEnvironment(false),
    Neptune::PlanetEnvironment = PlanetEnvironment(false),
    Pluto::PlanetEnvironment = PlanetEnvironment(false))

    return Environment(Sun,Mercury,Venus,Earth,Moon,Mars,Jupiter,Saturn,Uranus,Neptune,Pluto)

end #end of constructor
