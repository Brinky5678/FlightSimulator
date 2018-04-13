#Define abstract planet type that functions as a wrapper of the CelestialBody struct of AstroDynBase
abstract type abstractCelestialBody end 
abstract type abstractBarycenter <: abstractCelestialBody end 
abstract type abstractPlanet <: abstractCelestialBody end 
abstract type abstractNaturalSatellite <: abstractCelestialBody end 
abstract type abstractStar <: abstractCelestialBody end 

struct Planet <: abstractPlanet 
    Name::Type{<:abstractPlanet}
    Environment::T where {T <: AbstractPlanetEnvironment}
end 

struct NaturalSatellite <: abstractNaturalSatellite
    Name::Type{<:abstractNaturalSatellite}
    Environment::T where {T <: AbstractPlanetEnvironment}
end 

struct Star <: abstractStar
    Name::Type{<:abstractStar}
end 

#Unless otherwise defined, define initial values for each of the variables
alpha(::Type{C}) where {C <: abstractCelestialBody} = 0.
delta(::Type{C}) where {C <: abstractCelestialBody} = 0.
omega(::Type{C}) where {C <: abstractCelestialBody} = 0.
alpha_nut_prec(::Type{C}) where {C <: abstractCelestialBody} = 0.
delta_nut_prec(::Type{C}) where {C <: abstractCelestialBody} = 0.
omega_nut_prec(::Type{C}) where {C <: abstractCelestialBody} = 0. 
theta_nut_prec(::Type{C}) where {C <: abstractCelestialBody} = 0.
theta0_nut_prec(::Type{C}) where {C <: abstractCelestialBody} = 0. 
theta1_nut_prec(::Type{C}) where {C <: abstractCelestialBody} = 0.
j2(::Type{C}) where {C <: abstractCelestialBody} = 0.
j3(::Type{C}) where {C <: abstractCelestialBody} = 0.
j4(::Type{C}) where {C <: abstractCelestialBody} = 0.

#Wrap the functions
naif_id(Planet::T) where {T <: abstractCelestialBody} = naif_id(Planet.Name)
mu(Planet::T) where {T <: abstractCelestialBody} = mu(Planet.Name)
mean_radius(Planet::T) where {T <: abstractCelestialBody} = mean_radius(Planet.Name)
equatorial_radius(Planet::T) where {T <: abstractCelestialBody} = equatorial_radius(Planet.Name)
polar_radius(Planet::T) where {T <: abstractCelestialBody} = polar_radius(Planet.Name)
parent(Planet::T) where {T <: abstractCelestialBody} = parent(Planet.Name)
right_ascension(Planet::T) where {T <: abstractCelestialBody} = right_ascension(Planet.Name)
right_ascension_rate(Planet::T) where {T <: abstractCelestialBody} = right_ascension_rate(Planet.Name)
declination(Planet::T) where {T <: abstractCelestialBody} = declination(Planet.Name)
declination_rate(Planet::T) where {T <: abstractCelestialBody} = declination_rate(Planet.Name)
rotation_angle(Planet::T) where {T <: abstractCelestialBody} = rotation_angle(Planet.Name)
rotation_rate(Planet::T) where {T <: abstractCelestialBody} = rotation_rate(Planet.Name)
euler_angles(Planet::T) where {T <: abstractCelestialBody} = euler_angles(Planet.Name)
euler_derivatives(Planet::T) where {T <: abstractCelestialBody} = euler_derivatives(Planet.Name)
j2(Planet::T) where {T <: abstractCelestialBody} = j2(Planet.Name)
j3(Planet::T) where {T <: abstractCelestialBody} = j3(Planet.Name)
j4(Planet::T) where {T <: abstractCelestialBody} = j4(Planet.Name)

#Compute the flattening of a CelestialBody
flattening(Body::T) where {T <: abstractCelestialBody} = 1 - (polar_radius(Body) / equatorial_radius(Body))
theta(t, Body::Type{C}) where {C <: abstractCelestialBody} = theta0_nut_prec(Body) .+ theta1_nut_prec(Body) .* t

function right_ascension(Body::Type{C}, dt::DateTime, simtime::T = 0.0) where {C <: abstractCelestialBody, T <: Real}
    t = centuriespastJ2000(dt, simtime) 
    dot(alpha(Body), t.^(0:2)) + dot(alpha_nut_prec(Body), sin.(theta(t, Body)))
end

function declination(Body::Type{C}, dt::DateTime, simtime::T = 0.0) where {C <: abstractCelestialBody, T <: Real}
    t = centuriespastJ2000(dt, simtime)
    dot(delta(Body), t.^(0:2)) + dot(delta_nut_prec(Body), cos.(theta(t, Body)))
end

function rotation_angle(Body::Type{C}, dt::DateTime, simtime::T = 0.0) where {C <: abstractCelestialBody, T <: Real}
    t = centuriespastJ2000(dt, simtime)
    dot(omega(Body), t.^(0:2)) + dot(omega_nut_prec(Body), sin.(theta(t, Body)))
end

function right_ascension_rate(Body::Type{C}, dt::DateTime, simtime::T = 0.0) where {C <: abstractCelestialBody, T <: Real}
    t = centuriespastJ2000(dt, simtime)
    dot(alpha(Body), [0,1,2 * t]) / SECONDS_PER_CENTURY +
        sum(alpha_nut_prec(Body) .* theta1_nut_prec(Body) ./ SECONDS_PER_CENTURY .* cos.(theta(t, Body)))
end

function declination_rate(Body::Type{C}, dt::DateTime, simtime::T = 0.0) where {C <: abstractCelestialBody, T <: Real}
    t = centuriespastJ2000(dt, simtime)
    dot(delta(Body), [0,1,2 * t]) / SECONDS_PER_CENTURY -
        sum(delta_nut_prec(Body) .* theta1_nut_prec(Body) ./ SECONDS_PER_CENTURY .* sin.(theta(t, Body)))
end

function rotation_rate(Body::Type{C}, dt::DateTime, simtime::T = 0.0) where {C <: abstractCelestialBody, T <: Real}
    t = centuriespastJ2000(dt, simtime)
    dot(omega(Body), [0,1,2 * t]) / SECONDS_PER_CENTURY +
        sum(omega_nut_prec(Body) .* theta1_nut_prec(Body) ./ SECONDS_PER_CENTURY .* cos.(theta(t, Body)))
end

function euler_angles(Body::Type{C}, dt::DateTime, simtime::T = 0.0) where {C <: abstractCelestialBody, T <: Real}
    right_ascension(Body, dt, simtime) + π / 2, π / 2 - declination(Body, dt, simtime), mod2pi(rotation_angle(Body, dt, simtime))
end

function euler_derivatives(Body::Type{C}, dt::DateTime, simtime::T = 0.0) where {C <: abstractCelestialBody, T <: Real}
    right_ascension_rate(Body, dt, simtime), -declination_rate(Body, dt, simtime), rotation_rate(Body, dt, simtime)
end