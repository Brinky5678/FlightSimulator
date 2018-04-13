import AstroDynBase
#Define Mercury type and object
struct MercuryType <: abstractPlanet end 
Mercury = Planet(MercuryType)

#Data, as previously used in AstroDynBase
mu(::Type{MercuryType}) = 2.2032e4 #km^3/s^2
j2(::Type{MercuryType}) = 2.027e-4
mean_radius(::Type{MercuryType}) = 2439.7
equatorial_radius(::Type{MercuryType}) = 2439.7
polar_radius(::Type{MercuryType}) = 2439.7

naif_id(::Type{MercuryType}) = 199
parent(::Type{MercuryType}) = MercuryBarycenter

#Extra Data 
alpha(::Type{MercuryType}) = deg2rad.([284.0097, -0.0328, 0.])
delta(::Type{MercuryType}) = deg2rad.([61.4143, -0.0049, 0.])
omega(::Type{MercuryType}) = deg2rad.([329.5469, 6.1385025, 0.])

alpha_nut_prec(::Type{MercuryType}) = deg2rad.([0., 0., 0., 0., 0.])
delta_nut_prec(::Type{MercuryType}) = deg2rad.([0., 0., 0., 0., 0.])
omega_nut_prec(::Type{MercuryType}) = deg2rad.([ 0.00993822,
                                            -0.00104581,
                                            -0.00010280,
                                            -0.00002364,
                                            -0.00000532])  
theta0_nut_prec(::Type{MercuryType}) = deg2rad.([174.791086,     
                                             349.582171,      
                                             164.373257,     
                                             339.164343,     
                                             153.955429])     
theta1_nut_prec(::Type{MercuryType}) = deg2rad.([0.14947253587500003E+06,
                                             0.29894507175000006E+06,
                                             0.44841760762500006E+06,
                                             0.59789014350000012E+06,
                                             0.74736267937499995E+06])