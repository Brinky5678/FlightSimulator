#This file is simply a small script to load the Utils files/types in the correct order

#import needed libraries
import Base: norm

#include MathUtils.jl first
include("MathUtils.jl")

#then Quaterion Library
include("QuatLib.jl")
include("State.jl")

