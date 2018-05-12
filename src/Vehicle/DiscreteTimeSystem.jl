#Define abstract DiscreteTimeSystem
abstract type DiscreteTimeSystem end

#set the callback condition for all DiscreteTimeSystems
function condition(u, t, integrator, dts::Type{<:DiscreteTimeSystem})
  t - (dts.Tprev + dts.Ts)
end
