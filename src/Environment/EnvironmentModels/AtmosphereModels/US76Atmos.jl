#Define constants for US76 atmosphere model
g0us76(::Type{Earth}) = 9.80665
r0us76(::Type{Earth}) = 6356.766
rsus76(::Type{Earth}) = 8314.32
naus76(::Type{Earth}) = Float64(6.022169*10^26)
m0us76(::Type{Earth}) = 28.9644
r0mus76(::Type{Earth}) = 6356755.
ρ0us76(::Type{Earth}) = 1.225 #kg/m^3
Rus76(::Type{Earth}) = 287 #J/Kg K For Earth Air
γus76(::Type{Earth}) = 1.4 #For Earth Air
#const r = rs/m0

#Starting Temperature per Interval (per airlayer)
tmsus76(::Type{Earth}) = [288.15, 216.65, 216.65, 228.65, 270.65, 270.65, 214.65, 186.87]

#dT/dG (Thermal Lapse rate) per intercal (tropo-, strato-, meso-, and thermosphere)
tgus76(::Type{Earth}) = [-6.5, 0., 1., 2.8, 0., -2.8, -2., 0.]

#Starting Pressure per interval
psus76(::Type{Earth}) = [101325., 22632., 5474.87, 868.014, 110.905, 66.938, 3.9564, .39814]
m_m0us76(::Type{Earth}) = [1., .999996, .999989, .999971, .999941, .999909, .99987, .999829,
                             .999786, .999741, .999694, .999641, .999579]

#Volume Percentage of element in Air, He, ...., N2, O2, Ar
fius76(::Type{Earth}) = [5.24e-6, 0.0, .78084, .209476, .00934]
zssus76(::Type{Earth}) = [86.,87.,88.,89.,90.,91.,92.,93.,94.,95.,96.,
                97.,98.,99.,100.,101.,102.,103.,104.,105.,106.,107.,108.,
                109.,110.,111.,112.,113.,114.,115.,116.,117.,118.,119.,120.]
dnssus76(::Type{Earth}) = [1.447e20,1.212e20,1.014e20,8.496e19,
                7.116e19,5.962e19,4.993e19,4.178e19,3.494e19,2.92e19,
                2.44e19,2.038e19,1.702e19,1.422e19,1.189e19,9.99e18,
                8.402e18,7.071e18, 5.956e18,5.021e18,4.237e18,3.578e18,
                3.023e18,2.552e18,2.144e18,1.8e18,1.524e18,1.301e18,
                1.118e18,9.681e17,8.43e17,7.382e17,
                6.498e17,5.748e17,5.107e17]
mssus76(::Type{Earth}) = [28.95,28.95,28.94,28.93,28.91,28.89,28.86,
              28.82,28.78,28.73,28.68,28.62,28.55,28.48,28.4,28.3,28.21,28.1,
              28.,27.88,27.77,27.64,27.52,27.39,27.27,27.14,27.02,26.9,26.79,
              26.68,26.58,26.48,26.38,26.29,26.2]
zsus76(::Type{Earth}) = [0.,11.019,20.063,32.162,47.35,51.413,71.802, 86.]
c_b5us76(::Type{Earth}) = 0.0
c_b6us76(::Type{Earth}) = 1e-10

z7us76(::Type{Earth}) = 86.
t7us76(::Type{Earth}) = 186.8673
z8us76(::Type{Earth}) = 91.
z9us76(::Type{Earth}) = 110.
t9us76(::Type{Earth}) = 240.
z10us76(::Type{Earth}) = 120.
t10us76(::Type{Earth}) = 360.
tinfus76(::Type{Earth}) = 1000.
tlk9us76(::Type{Earth}) = 12.
tcus76(::Type{Earth}) = 263.1905
taus76(::Type{Earth}) = -76.3232
saus76(::Type{Earth}) = -19.9426
rlamus76(::Type{Earth}) = 0.01875

import AstroDynBase: CelestialBody

function US76Atmos(Body::Type{<:CelestialBody}, PosRsph::Vector{Float64})
  zm = Altitude(Body, PosRsph)
  zKm = zm/1000;
  if (zKm < 86.)
    for i=1:7
      if (zsus76(Body)[i] <= zKm) && (zKm < zsus76(Body)[i + 1])
        zl = Int(round(zsus76(Body)[i]))
        zlm = zl*1000
        m = m0us76(Body);
        if zKm > 80.
          #Linear Interpolation on molecular weight
          iz = Int(round(((zKm - 80.)*2) + 1))
          zz1 = (iz - 1)*0.5 + 80.
          zz2 = zz1 + 0.5
          aux = (zKm - zz1)/(zz2 - zz1)
          m = m0us76(Body)*(m_m0us76(Body)[iz] + aux*(m_m0us76(Body)[iz + 1] - m_m0us76(Body)[iz]))
        end #if zKm > 80.
        ht = r0us76(Body)*zKm/(r0us76(Body) + zKm)
        hm = ht*1000

        #Pressure
        if abs(tgus76(Body)[i] - c_b5us76(Body) <= c_b6us76(Body))
          p = psus76(Body)[i]*exp(-(g0us76(Body)*m0us76(Body)*(hm - zlm))/(rsus76(Body)*tmsus76(Body)[i]))
        else
          d1 = tmsus76(Body)[i]/(tmsus76(Body)[i] + tgus76(Body)[i] * (ht - zl))
          d2 = g0us76(Body)*m0us76(Body)/(rsus76(Body)*tgus76(Body)[i]*0.001)
          p = psus76(Body)[i]*d1^d2
        end

        #molecular scale temperature
        tm = tmsus76(Body)[i] + tgus76(Body)[i]*(ht-zl)

        #Kinetic temperature
        tkin = tm*m/m0us76(Body)

        break;
      end #if (zs[i] <= zKm) && (zKm < zs[i + 1])
    end #for i=1:7
  elseif (zKm >= 86.) && (zKm < 120.)
    tkin = tempr_(zKm)

    #linear inteprolation on molecular weight
    iz = Int(round((zKm - 86) + 1))
    aux = (zKm - zssus76(Body)[iz])/(zssus76(Body)[iz+1] - zssus76(Body)[iz])
    m = mssus76(Body)[iz] + aux*(mssus76(Body)[iz + 1] - mssus76(Body)[iz])

    #linear interpolation on logarithm of totanl number Density
    aux = log(dnssus76(Body)[iz + 1]/dnssus76(Body)[iz])/(zssus76(Body)[iz+1] - zssus76(Body)[iz])
    d = dnssus76(Body)[iz] *exp(aux*(zKm - zssus76(Body)[iz]))

    #Molecular scale temperature
    tm = tkin*m0us76(Body)/m

    #Pressure
    p = d*rsus76(Body)*tkin/naus76(Body)

  end #if (zKm < 86.)
  #check whether altitude is in the range of 0 - 120 km
  if (zKm < 0) || (zKm > 120)
    p = 0.0
    p = 0.0
    tkin = 0.0
    a = 0.0
  else
    ρ = m*p/rsus76(Body)/tkin
    a = sqrt(γus76(Body)*rsus76(Body)*tkin/m0us76(Body))
  end #if
  return [ρ, p, tkin, a]
end #US76Atmos

function tempr_(Body::Type{<:CelestialBody},zKm::Float64)
  #= This function calculates the kinetic temperature for altitudes
   greater than 86 km, according to the US Standard Atmosphere 1976. =#
  if (zKm >= z7us76(Body)) && (zKm < z8us76(Body))
    return t = t7us76(Body)
  elseif (zKm >= z8us76(Body)) && (zKm < z9us76(Body))
    return t = tcus76(Body) + taus76(Body)*sqrt(1-(zKm - z8us76(Body))/saus76(Body)*((zKm - z8us76(Body))/saus76(Body)))
  elseif (zKm >= z9us76(Body)) && (zKm < z10us76(Body))
    return t = t9us76(Body) + tlk9us76(Body)*(zKm - z9us76(Body))
  elseif zKm >= z10us76(Body)
    zeta = (zKm - z10us76(Body))*(r0us76(Body) + z10us76(Body))/(r0us76(Body) + zKm)
    return t = tinfus76(Body) - (tinfus76(Body) - t10us76(Body))*exp(-rlamus76(Body)*zeta)
  end #if
end #tempr_
