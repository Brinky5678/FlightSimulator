struct EarthType <: abstractPlanet end 
Earth = Planet(EarthType)

#Data, as previously used in AstroDynBase
mu(::Type{EarthType}) = 3.986004418e5 #km^3/s^2
j2(::Type{EarthType}) = 1.08262668e-3
j3(::Type{EarthType}) = -2.532e-6
j4(::Type{EarthType}) = -1.61e-6
mean_radius(::Type{EarthType}) = 6371.0084
equatorial_radius(::Type{EarthType}) = 6378.1366
polar_radius(::Type{EarthType}) = 6356.7519

naif_id(::Type{EarthType}) = 399
parent(::Type{EarthType}) = EarthMoonBarycenter

#Extra Data 
alpha(::Type{EarthType}) = deg2rad.([0., -0.641, 0.])
delta(::Type{EarthType}) = deg2rad.([90., -0.557, 0.])
omega(::Type{EarthType}) = deg2rad.([190.147, 360.9856235, 0.])

alpha_nut_prec(::Type{EarthType}) = 0.
delta_nut_prec(::Type{EarthType}) = 0.
omega_nut_prec(::Type{EarthType}) = 0. 
theta_nut_prec(::Type{EarthType}) = deg2rad.([125.045         -1935.5364525000
                                    250.089         -3871.0729050000
                                    260.008        475263.3328725000  
                                    176.625        487269.6299850000
                                    357.529         35999.0509575000
                                    311.589        964468.4993100000
                                    134.963        477198.8693250000
                                    276.617         12006.3007650000
                                     34.226         63863.5132425000 
                                     15.134         -5806.6093575000
                                    119.743           131.8406400000
                                    239.961          6003.1503825000 
                                     25.053        473327.7964200000])
theta0_nut_prec(::Type{EarthType}) = theta_nut_prec(EarthType)[:,1]  
theta1_nut_prec(::Type{EarthType}) = theta_nut_prec(EarthType)[:,2] 