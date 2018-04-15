#This file contains all the tests of the Utils Functions
using Base.Test 
include("LoadUtils.jl")


@testset "Utility Functions Test" begin 
    @test datetime2modifiedjulian(DateTime(2016,1,1,0,0,5,0)) == datetime2modifiedjulian(DateTime(2016,1,1,0,0,0,0),5)
end


##Examples
#x = [0 pi/4 pi/2 3*pi/4 pi 5*pi/4 6*pi/4 7*pi/4 2*pi]
#y = x
#z = y
#v = sin.(x)
#v2 = repmat(sin.(x),9,1) + repmat(sin.(y)',1,9)

#vq = lininterpn(x,v,1)
#vqq = lininterp1(x,v,1)
#vq2 = lininterpn(x,y,v2,1,1)
#vqq2 = lininterp2(x,y,v2,1,1)