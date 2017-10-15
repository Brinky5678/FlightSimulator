#Define forces
include("Frames.jl")
include("Transformables.jl")
abstract type AbstractForceMoment <: AbstractTransformable  end

mutable struct Force <: AbstractForceMoment
    val::Vector{Float64}
    frame::Type{<:AbstractFrame}
end

function (force::Force)(newval::Vector{Float64})
    force.val = newval
    return force
end

function (force::Force)()
    return force.val
end

FrameOf(fm::Type{<:AbstractForceMoment}) = fm.frame
