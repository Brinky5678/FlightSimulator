#A need for getting the atmospheric properties at the given location (and velocity) of the vehicle was found 
function AtmosphericVariables(sys::PlanetarySystem, Pos::Vector{T}, ep::S) where {T,S <: Real}
    atmosprop = zeros(4)
    for body in sys.bodies 
        #for each body, check if spacecraft is more than the planetary radius away from the body, 
        #It is unlikely that atmosphere still has an effect at those altitudes
        if (altitude(body, Pos) < mean_radius(body))
            atmosprop += atmosphere(body, Pos, ep)
        end
    end 
    return atmosprop
end 