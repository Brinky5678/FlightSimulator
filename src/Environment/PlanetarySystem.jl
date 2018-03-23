#define abstract planetary system 
abstract type abstractPlanetarySystem end 

#define structure that contains all (actively selected) plantery bodies in the system
# some validation is included to determine no unphysical combinations are selected! (only the Sun and the Moon, for example)
struct PlanetarySystem <: abstractPlanetarySystem 
    Bodies::Vector{T} where {T <: abstractCelestialBody}

    #Define constructor and validate entries
    function PlanetarySystem(Bodies::Vector{B}) where {B <: abstractCelestialBody}
        if SystemValidation(Bodies)
            return new(Bodies)
        else
            error("Unphysical system was proposed!")
        end 
    end #constructor 
end #struct 

#Check if the system is physically reasonable
function SystemValidation(Bodies::Vector{T}) where {T <: abstractCelestialBody}
    #If true then more than one planet is selected without the Sun! 
    StarSelected = 0
    PlanetSelected = 0 
    MoonSelected = 0
    MoonValidated = 0
    result = false 
    for body in Bodies 
        if typeof(body) <: abstractStar #if currently selected body is a Star
            StarSelected += 1 
        elseif typeof(body) <: abstractPlanet  #if currently selected body is a Planet
            PlanetSelected += 1
        elseif typeof(body) <: abstractMoon  #if currently selected body is a Moon
            MoonSelected += 1
        end 
    end 

    #its okay when only the star, one planet, or a moon (with or without its main body) is selected
    if StarSelected == 1 #if star is selected 
        if PlanetSelected == 0 && MoonSelected == 0 #only star selected 
            return true 
        elseif PlanetSelected >= 1 && MoonSelected == 0 #only planets selected 
            return true 
        elseif PlanetSelected >= 1 && MoonSelected >= 1 #Planets and moons selected -> must check if moon have their main bodies (because sun is present)
            for body in Bodies #loop over all bodies to find all moons  
                if typeof(body) <: abstractMoon #check if currently selected object is a moon 
                    for body2 in Bodies #loop over all bodies to find the planet of the moon
                        if typeof(body2) <: abstractPlanet #check if currently selected body is a planet
                            if parent(body) == parent(body2)  #check if both share the same parent (the common barycenter of the planet-moon system)
                                MoonValidated += 1
                            end #validate
                        end #check if planet
                    end #loop over planets
                end #check if moon
            end #loop over moons
            if MoonSelected == MoonValidated #if the number of selected moons equals the number of validated moons, than OK
                return true 
            else
                return false 
            end 
        else 
            return false 
        end 

    elseif StarSelected == 0 #star not selected 
        if PlanetSelected == 0 && MoonSelected == 0 #nothing selected, technically valid
            return true 
        elseif PlanetSelected == 1 && MoonSelected == 0 #Single planet selected 
            return true 
        elseif PlanetSelected >= 2 #Two or more planets selected without star, not valid 
            return false 
        elseif PlanetSelected == 0 && MoonSelected == 1 #Single Moon Selected, is valid 
            return true 
        elseif PlanetSelected ==0 && MoonSelected >= 2 #Two or more Moons selected, not valid 
            return false 
        elseif PlanetSelected == 1 && MoonSelected >= 1 #Can be valid, if the single planet shares the barycenter with all moons (for example, jupiter system)
            for mooncand in Bodies 
                if typeof(mooncand) <: abstractMoon 
                    for planetcand in Bodies
                        if typeof(planetcand) <: abstractPlanet
                            if parent(mooncand) == parent(planetcand)
                                MoonValidated += 1
                            end 
                        end
                    end  
                end 
            end
            #Only valid if number of moons selected equal the number of moons validated
            (MoonSelected == MoonValidated)  ? result = true : result = false 
            return result             
        else 
            return false 
        end 
    end 

    #If the codes makes it to here, the validation has failed
    return false 
 
end #Function TwoPlanetsWithoutSunSelected