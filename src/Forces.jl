#Define forces
include("Frames.jl")
include("Transformables.jl")
abstract type AbstractForceMoment <: AbstractTransformable  end

mutable struct Force <: AbstractForceMoment
    Fx::Float64
    Fy::Float64
    Fz::Float64
    frame::Type{<:AbstractFrame}
end

function (force::Force)(newval::Vector{Float64})
    force.Fx = newval[1]
    force.Fy = newval[2]
    force.Fz = newval[3]
    return force
end

function (force::Force)()
    return [force.Fx force.Fy force.Fz]
end

mutable struct Moment <: AbstractForceMoment
    Mx::Float64
    My::Float64
    Mz::Float64
    frame::Type{<:AbstractFrame}
end

function (moment::Moment)(newval::Vector{Float64})
    moment.Mx = newval[1]
    moment.My = newval[2]
    moment.Mz = newval[3]
    return moment
end

function (moment::Moment)()
    return [moment.Mx moment.My moment.Mz]
end

FrameOf(fm::Type{<:AbstractForceMoment}) = fm.frame
