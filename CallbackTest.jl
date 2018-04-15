using DifferentialEquations
using ParameterizedFunctions
using PyPlot

f = @ode_def_bare BallBounce begin
  dy = v
  dv = -g
end g=9.81

abstract type DiscreteTimeSystem end

mutable struct ControlSystem{T<:Number} <: DiscreteTimeSystem
  Ts::T
  Tprev::T
end

det = ControlSystem(0.15,0.0)

function condition(det::ControlSystem,t,u,integrator)
  t - (det.Tprev + det.Ts)
end

function affect!(integrator,det::ControlSystem)
  integrator.u[2] += 1
  det.Tprev = integrator.t
end

cb = ContinuousCallback((t, u, int) -> condition(det,t,u,int),
                          (int) -> affect!(int,det))

u0 = [50.0,-10.0]
tspan = (0.0,1.5)
prob = ODEProblem(f,u0,tspan)
sol = solve(prob,Tsit5(),callback=cb,force_dtmin=true)

idx = 1
v = Vector{Float64}(length(sol.u))
for x in sol.u
  v[idx] = x[2]
  idx += 1
end

#plot(sol.t, v)
