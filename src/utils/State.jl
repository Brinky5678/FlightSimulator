#Small utility library for the definition of the State Vector 
import Base.size, Base.getindex, Base.setindex!, Base.IndexStyle
import Base.*, Base.+, Base.-, Base./

!isdefined(:Quaternion) ? include("Quatlib.jl") : nothing 

mutable struct State <: AbstractArray{Float64,1}
    vx::Float64  
    vy::Float64 
    vz::Float64 
    x::Float64 
    y::Float64 
    z::Float64 
    wx::Float64 
    wy::Float64 
    wz::Float64 
    q1::Float64
    q2::Float64 
    q3::Float64 
    q4::Float64
end 

Base.size(::State) = (13,)
Base.IndexStyle(::Type{State}) = IndexLinear() 
function Base.getindex(state::State, i::Int)
    if (i > 0 && i < 14)
        if i == 1
            return state.vx 
        elseif i == 2
            return state.vy 
        elseif i == 3
            return state.vz 
        elseif i == 4
            return state.x
        elseif i == 5
            return state.y
        elseif i == 6
            return state.z
        elseif i == 7
            return state.wx
        elseif i == 8
            return state.wy
        elseif i == 9
            return state.wz
        elseif i == 10
            return state.q1 
        elseif i == 11
            return state.q2 
        elseif i == 12
            return state.q3 
        elseif i == 13
            return state.q4
        end 
    else 
        error("index out of range")
    end 
end 

function setindex!(state::State, v::T, i::Int) where {T <: Real}
    if (i > 0 && i < 14)
        if i == 1
            state.vx = Float64(v)
        elseif i == 2
            state.vy = Float64(v)
        elseif i == 3
            state.vz = Float64(v) 
        elseif i == 4
            state.x = Float64(v)
        elseif i == 5
            state.y = Float64(v)
        elseif i == 6
            state.z = Float64(v)
        elseif i == 7
            state.wx = Float64(v)
        elseif i == 8
            state.wy = Float64(v)
        elseif i == 9
            state.wz = Float64(v)
        elseif i == 10
            state.q1 = Float64(v)
        elseif i == 11
            state.q2 = Float64(v) 
        elseif i == 12
            state.q3 = Float64(v) 
        elseif i == 13
            state.q4 = Float64(v)
        end 
    else 
        error("index out of range")
    end     
end

velocity(s::State) = s[1:3]
position(s::State) = s[4:6]
angularvelocity(s::State) = s[7:9]
orientation(s::State) = Quaternion(s[10], s[11:13])
function State(vel::Vector{T} = zeros(3),pos::Vector{S} = zeros(3),
        angvel::Vector{R} = zeros(3), quat::Quaternion = Quaternion(0., [0., 0., 0.])) where {T,S,R <: Real}
    State(vel[1], vel[2], vel[3], pos[1], pos[2], pos[3], 
        angvel[1], angvel[2], angvel[3], quat[1], quat[2], quat[3], quat[4])
end 