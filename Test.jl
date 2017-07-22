### Temporary
push!(LOAD_PATH,"C:\\Users\\TUDelft SID\\OneDrive\\Documents\\AeroSimDIY\\Julia\\FlightSimDev\\src")
## Temporary

#using FlightSimulator
import JPLEphemeris: SPK, print_segments, Dates, position, velocity, state

function state(spk::SPK, center, target,
  tdb::StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}})
  ep0 = tdb[1]
  statevals = Matrix(length(tdb),6)
  for (idx, ep) in enumerate(tdb)
    statevals[idx,:] = state(spk, center, target, ep0, ep-ep0)
  end
  return statevals
end


# Load the DE430 SPK kernel
spk = SPK("de430.bsp")

# List the available segments
print_segments(spk)


# 2016-01-01T00:00 in Julian days
jd = Dates.datetime2julian(DateTime(2016,1,1,0,0,0))

# Position of Earth's barycenter w.r.t. the Solar System's barycenter at 2016-01-01T00:00
# [km]
pos = position(spk, "earth barycenter", jd)

# Velocity of Earth w.r.t. Earth's barycentre at 2016-01-01T00:00
# [km/s]
vel = velocity(spk, "earth barycenter", "earth", jd)

# Compute the state vector (position and velocity) of Earth's barycenter (NAIF ID: 3)
# w.r.t. to the Solar System's barycenter (NAIF ID: 0) for a range of Julian days
st0 = state(spk, 0, 3, jd)
st = state(spk, 0, 3, jd, 100.0)
st1 = state(spk, 0, 3, jd:jd+100)

# Two-part Julian dates (day number and fraction) can be used for higher precision.
# For example for 2016-01-01T12:00:
#st = state(spk, 0, 3, jd, 0.5)
