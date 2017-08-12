#Dictionaries containing ModelProperties options (standard ones)
GRAVITYMODELTYPES = Dict{String, Integer}("none" => 0);
PLANETMODELTYPES = Dict{String, Integer}("none" => 0); #done
ATMOSPHEREMODELTYPES = Dict{String, Integer}("none" => 0); #done
WINDMODELTYPES = Dict{String, Integer}("none" => 0) #<- not implemented

#Function dictionaries
GRAVITYMODELFUNC = Dict{String, Function}()
PLANETMODELFUNC = Dict{String, Function}()
ATMOSPHEREMODELFUNC = Dict{String, Function}()
WINDMODELFUNC = Dict{String, Function}() #<- not implemented

#Model Properties Type
struct ModelProperties
  GravityModelType::String
  PlanetModelType::String
  AtmosphereModelType::String
  #WindModelType::String #<- to be implemented

  function ModelProperties(;GravityModelIn::String = "none",
                    PlanetModelIn::String = "none",
                    AtmosphereModelIn::String = "none")

     # Gravity Model Checker
     if !haskey(GRAVITYMODELTYPES, lowercase(GravityModelIn))
       warn("Gravity Model $GravityModelIn is Not Found, Setting Gravity Model
        to Default (Central)")
       GravityModelIn::String = "Central"
     end

     #Planetary Model Checker
     if !haskey(PLANETMODELTYPES, lowercase(PlanetModelIn))
       warn("Planetary Model is Not Found, Setting Planetary Model to Default
        (Spherical)")
       PlanetModelIn = "Spherical"
     end

     #Atmosphere Model checker
     if !haskey(ATMOSPHEREMODELTYPES, lowercase(AtmosphereModelIn))
       warn("Atmosphere Model is not Found, Setting Atmosphere Model to
        Default (exp)")
       AtmosphereModelIn = "exp"
     end

     # If GravityModelType is chosen to be J2, J23, or J234, the PlanetModelType
     # should be ellipsoid. Likewise, if the GravityModelType is chosen to be
     # central, then the PlanetModelType should be spherical.Provide appropriate
     # warning.
     if (lowercase(PlanetModelIn) == "spherical") && (lowercase(GravityModelIn)
        != "central")
       warn("Planetary Model is set to spherical, but Gravity Model is not
        selected to be central")
     end
     if (lowercase(PlanetModelIn) == "ellipse") && !(lowercase(GravityModelIn)
        in ["j2", "j23", "j234"])
        warn("Planetary Model is set to ellipse, but Gravity Model is not
         selected to be J2, J23, or J234")
     end

     #When no planet models is selected, it makes no sense to have a gravity
     #or atmosphere model defined, so they are set to zero if not done so by
     #default.
     if (lowercase(PlanetModelIn) == "none" ) &&
          ((lowercase(GravityModelIn) != "none") ||
          (lowercase(AtmosphereModelIn != "none")))
        warn("No planet Model selected, yet Gravity and Atmosphere
                Models are selected. Setting Gravity and Atmosphere models to
                \"none\"")
              GravityModelIn = AtmosphereModelIn = "none"
      end

     # Run Constructor with checked inputs
     this = new(lowercase(GravityModelIn),
                lowercase(PlanetModelIn),
                lowercase(AtmosphereModelIn));
  end
end

#Define functions for adding new, custom, model types to the existing
#Dictionary
function DefineGravityModel(NewModel::String, NewFunction::Function)
  GRAVITYMODELTYPES[NewModel] = length(GRAVITYMODELTYPES) + 1
  GRAVITYMODELFUNC[NewModel] = NewFunction
end

function DefineAtmosphereModel(NewModel::String, NewFunction::Function)
  ATMOSPHEREMODELTYPES[NewModel] = length(ATMOSPHEREMODELTYPES) + 1
  ATMOSPHEREMODELFUNC[NewModel] = NewFunction
end

function DefinePlanetModel(NewModel::String, NewFunction::Function)
  PLANETMODELTYPES[NewModel] = length(PLANETMODELTYPES) + 1
  PLANETMODELFUNC[NewModel] = NewFunction
end

function DefineWindModel(NewModel::String, NewFunction::Function)
  WINDMODELTYPES[NewModel] = length(WINDMODELTYPES) + 1
  WINDMODELFUNC[NewModel] = NewFunction
end
