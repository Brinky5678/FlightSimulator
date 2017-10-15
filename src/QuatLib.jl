#A Small utility library for Quaternions and their functions
import Base.size, Base.getindex, Base.setindex!, Base.IndexStyle
import Base.*, Base.+, Base.-

mutable struct Quaternion <: AbstractArray{Float64,1}
    q1::Float64 #<- scalar part
    q2::Float64 #
    q3::Float64 # <- Vector part
    q4::Float64 #
    norm::Bool #Boolean to indicate whether quaternion is normalized
end

Base.size(::Quaternion) = (4,)
Base.IndexStyle(::Type{<:Quaternion}) = IndexLinear()
function Base.getindex(q::Quaternion, i::Int)
    if (i>0 && i<5)
        if (i == 1)
            return q.q1
        elseif i== 2
            return q.q2
        elseif i == 3
            return q.q3
        elseif i == 4
            return q.q4
        end
    else
        error("index out of range")
    end
end

function setindex!(q::Quaternion, v::Float64, i::Int)
    if (i>0 && i<5)
        if (i == 1)
            q.q1 = v
        elseif i== 2
            q.q2 = v
        elseif i == 3
            q.q3 = v
        elseif i == 4
            q.q4 = v
        end
        q.norm = false
    else
        error("index out of range")
    end
    return q
end

Quaternion(q1::Float64, qvec::Vector{Float64}, norm=false) = Quaternion(q1, qvec[1], qvec[2], qvec[3], norm)
Quaternion(qvec::Vector{Float64}) = Quaternion(0., qvec)
Quaternion(q1::Float64) = Quaternion(q1, Float64(zeros(3)))
vec(q::Quaternion) = [q[2] q[3] q[4]]
scalar(q::Quaternion) = q[1]

norm(q::Quaternion) = sqrt(q[1]^2 + q[2]^2 + q[3]^2 + q[4]^2)
function isnormalized(q::Quaternion)
    q.norm ? true : false
end

function normalize(q::Quaternion)
    if !q.norm
        q[1:4] = q[1:4]./norm(q)
        q.norm = true
    end
    return q
end

(-)(q::Quaternion) = Quaterion(-q[1], -q[2], -q[3], -q[4], false)
(+)(q1::Quaternion, q2::Quaternion) = Quaternion(q1[1] + q2[1], q1[2] + q2[2], q1[3] + q2[3], q1[4] + q2[4],false)
(-)(q1::Quaternion, q2::Quaternion) = Quaternion(q1[1] - q2[1], q1[2] - q2[2], q1[3] - q2[3], q1[4] - q2[4],false)
(*)(q1::Quaternion, q2::Quaternion) = Quaternion(q1[1]*q2[1] - dot(vec(q1),vec(q2)),
    q[1].*vec(q1) + q2[1].*vec(q2) + cross(vec(q1),vec(q2)),false)


angleaxis2quat(angle::Float64, axis::Vector{Float64}) = Quaternion(cos(angle/2), axis.*sin(angle/2),true)

"""
```julia
DCM = quat2DCM(q::Quaternion)
```
Computes the DCM corresponding the input Quaternion.
"""
function quat2DCM(q::Quaternion)

  if norm(q) < eps()
    q = Quaternion(1., zeros(3))
  end

  q12 = q[1]^2
  q22 = q[2]^2
  q32 = q[3]^2
  q42 = q[4]^2
  q1q2 = q[1]*q[2]
  q3q4 = q[3]*q[4]
  q1q3 = q[1]*q[3]
  q2q4 = q[2]*q[4]
  q2q3 = q[2]*q[3]
  q1q4 = q[1]*q[4]

  return [[(q12 + q22 - q32 - q42) 2*(q2q3 - q1q4) 2*(q1q3 + q2q4)];
          [2*(q2q3 + q1q4) (q12 - q22 + q32 - q42) 2*(q3q4 - q1q2)];
          [2*(-q1q3 + q2q4) 2*(q1q2 + q3q4) (q12 - q22 - q32 + q42)]]
end
