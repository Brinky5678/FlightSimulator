# Collect SimulationProperties and VehicleProperties, and create the
# the custom simulation and plotting functions

#Custom Type to encode the sim results easily
struct SimResults
  StateOut::Vector{Array{Float64,1}}
  TimeOut::Vector{Float64}
  #ControlStateOut::Array{Float64,1} #To be Implmented in the future
  SimProp::SimulationProperties

  function SimResults(SO::Vector{Array{Float64,1}}, TO::Vector{Float64},
    SP::SimulationProperties)
    return new(SO, TO, SP)
  end #SimResults
end #constructor

#Run Simulation
function sim()
    println("Simulation not yet implemented!")
end


#function sim(VehPropIn::VehicleProperties, y0::Vector{Float64},
#  ts::Vector{Float64}, SimPropIn::SimulationProperties = SimulationProperties())
#    return sim(EOM(VehPropIn,SimPropIn), y0, ts)
#end  #sim

#function sim(m_EOM::EOM_TYPE, y0::Vector{Float64}, ts::Vector{Float64})
#  ODE_TYPE = m_EOM.simprop.ODE_SolverType
#  if (lowercase(ODE_TYPE) == "ode45")
#    t, res = ode45(m_EOM.dy, y0, ts);
#  elseif (lowercase(ODE_TYPE) == "ode23")
#    t, res = ode23(m_EOM.dy, y0, ts);
#  elseif (lowercase(ODE_TYPE) == "ode78")
#    t, res = ode78(m_EOM.dy, y0, ts);
#  elseif (lowercase(ODE_TYPE) == "ode23s")
#    t, res = ode23s(m_EOM.dy, y0, ts);
#  else
#    error("This Type of option is not supported")
#  end
#  return SimResults(res,t,m_EOM.simprop)
#end #sim

#Plot Sim Results;
#function simplot()

end #simplot
