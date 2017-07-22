#Define constants for US76 atmosphere modelE
function GetUS76AtmosPrms()
  return Vector{Float64}(0)
end

warn("Not Correct Format yet, need to create getprms function")
const g0 = 9.80665
const r0 = 6356.766
const rs = 8314.32
const na = Float64(6.022169*10^26)
const m0 = 28.9644
const r0m = 6356755.
const ρ0 = 1.225 #kg/m^3
const R = 287 #J/Kg K For Earth Air
const γ = 1.4 #For Earth Air
#const r = rs/m0

#Starting Temperature per Interval (per airlayer)
const tms = [288.15, 216.65, 216.65, 228.65, 270.65, 270.65, 214.65, 186.87]

#dT/dG (Thermal Lapse rate) per intercal (tropo-, strato-, meso-, and thermosphere)
const tg = [-6.5, 0., 1., 2.8, 0., -2.8, -2., 0.]

#Starting Pressure per interval
const ps = [101325., 22632., 5474.87, 868.014, 110.905, 66.938, 3.9564, .39814]
const m_m0 = [1., .999996, .999989, .999971, .999941, .999909, .99987, .999829,
                             .999786, .999741, .999694, .999641, .999579]

#Volume Percentage of element in Air, He, ...., N2, O2, Ar
const fi = [5.24e-6, 0.0, .78084, .209476, .00934]
const zss = [86.,87.,88.,89.,90.,91.,92.,93.,94.,95.,96.,
                97.,98.,99.,100.,101.,102.,103.,104.,105.,106.,107.,108.,
                109.,110.,111.,112.,113.,114.,115.,116.,117.,118.,119.,120.]
const dnss = [1.447e20,1.212e20,1.014e20,8.496e19,
                7.116e19,5.962e19,4.993e19,4.178e19,3.494e19,2.92e19,
                2.44e19,2.038e19,1.702e19,1.422e19,1.189e19,9.99e18,
                8.402e18,7.071e18, 5.956e18,5.021e18,4.237e18,3.578e18,
                3.023e18,2.552e18,2.144e18,1.8e18,1.524e18,1.301e18,
                1.118e18,9.681e17,8.43e17,7.382e17,
                6.498e17,5.748e17,5.107e17]
const mss = [28.95,28.95,28.94,28.93,28.91,28.89,28.86,
              28.82,28.78,28.73,28.68,28.62,28.55,28.48,28.4,28.3,28.21,28.1,
              28.,27.88,27.77,27.64,27.52,27.39,27.27,27.14,27.02,26.9,26.79,
              26.68,26.58,26.48,26.38,26.29,26.2]
const zs = [0.,11.019,20.063,32.162,47.35,51.413,71.802, 86.]
const c_b5 = 0.0
const c_b6 = 1e-10

const z7 = 86.
const t7 = 186.8673
const z8 = 91.
const z9 = 110.
const t9 = 240.
const z10 = 120.
const t10 = 360.
const tinf = 1000.
const tlk9 = 12.
const tc = 263.1905
const ta = -76.3232
const sa = -19.9426
const rlam = 0.01875



function US76Atmos(PosRsph::Vector{Float64}, planetvars::Vector{Any}, t::Number)
  AltitudeFunction = planetvars[6]
  zm = AltitudeFunction(PosRsph, planetvars)
  zKm = zm/1000;
  if (zKm < 86.)
    for i=1:7
      if (zs[i] <= zKm) && (zKm < zs[i + 1])
        zl = Int(round(zs[i]))
        zlm = zl*1000
        m = m0;
        if zKm > 80.
          #Linear Interpolation on molecular weight
          iz = Int(round(((zKm - 80.)*2) + 1))
          zz1 = (iz - 1)*0.5 + 80.
          zz2 = zz1 + 0.5
          aux = (zKm - zz1)/(zz2 - zz1)
          m = m0*(m_m0[iz] + aux*(m_m0[iz + 1] - m_m0[iz]))
        end #if zKm > 80.
        ht = r0*zKm/(r0 + zKm)
        hm = ht*1000

        #Pressure
        if abs(tg[i] - c_b5 <= c_b6)
          p = ps[i]*exp(-(g0*m0*(hm - zlm))/(rs*tms[i]))
        else
          d1 = tms[i]/(tms[i] + tg[i] * (ht - zl))
          d2 = g0*m0/(rs*tg[i]*0.001)
          p = ps[i]*d1^d2
        end

        #molecular scale temperature
        tm = tms[i] + tg[i]*(ht-zl)

        #Kinetic temperature
        tkin = tm*m/m0

        break;
      end #if (zs[i] <= zKm) && (zKm < zs[i + 1])
    end #for i=1:7
  elseif (zKm >= 86.) && (zKm < 120.)
    tkin = tempr_(zKm)

    #linear inteprolation on molecular weight
    iz = Int(round((zKm - 86) + 1))
    aux = (zKm - zss[iz])/(zss[iz+1] - zss[iz])
    m = mss[iz] + aux*(mss[iz + 1] - mss[iz])

    #linear interpolation on logarithm of totanl number Density
    aux = log(dnss[iz + 1]/dnss[iz])/(zss[iz+1] - zss[iz])
    d = dnns[iz] *exp(aux*(zKm - zss[iz]))

    #Molecular scale temperature
    tm = tkin*m0/m

    #Pressure
    p = d*rs*tkin/na

  end #if (zKm < 86.)
  #check whether altitude is in the range of 0 - 120 km
  if (zKm < 0) || (zKm > 120)
    p = 0.0
    p = 0.0
    tkin = 0.0
    a = 0.0
  else
    ρ = m*p/rs/tkin
    a = sqrt(γ*rs*tkin/m0)
  end #if
  return [ρ, p, tkin, a]
end #US76Atmos

function tempr_(zKm::Float64)
  #= This function calculates the kinetic temperature for altitudes
   greater than 86 km, according to the US Standard Atmosphere 1976. =#
  if (zKm >= z7) && (zKm < z8)
    return t = t7
  elseif (zKm >= z8) && (zKm < z9)
    return t = tc + ta*sqrt(1-(zKm - z8)/sa*((zKm - z8)/sa))
  elseif (zKm >= z9) && (zKm < z10)
    return t = t9 + tlk9*(zKm - z9)
  elseif zkM >= z10
    zeta = (zKm - z10)*(r0 + z10)/(r0 + zKm)
    return t = tinf - (tin - t10)*exp(-rlam*zeta)
  end #if
end #tempr_
