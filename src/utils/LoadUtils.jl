#This file is simply a small script to load the Utils files/types in the correct order

#Load Constants
const SECS = 86400.0
const MJD_J2000 = 51544.5
const JULIAN_CENTURY = 36525
const GMST_CONSTS = (24110.54841, 8640184.812866, 0.093104, 6.2e-6, 1.002737909350795)
const JD_TO_MJD = 2400000.5

#include MathUtils.jl first
include("MathUtils.jl")

#then Quaterion Library
include("QuatLib.jl")

#Lastly, the Utils
include("Utils.jl")