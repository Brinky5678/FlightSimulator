#Define abstract DiscreteTimeSystem
abstract type DiscreteTimeSystem end

#set the callback condition for all DiscreteTimeSystems
function condition(dts::Type{<:DiscreteTimeSystem},t,u,integrator)
  t - (dts.Tprev + dts.Ts)
end
