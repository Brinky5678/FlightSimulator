#include("utils.jl")
#include("AeroDataBase.jl")
export AbstractVehicleDataBase
export VehicleAeroDataBase


abstract type AbstractVehicleDataBase end

FM_Contributions = Dict{String, Integer}("CD" => 1,
                                          "CS" => 2,
                                          "CL" => 3,
                                          "Cl" => 4,
                                          "Cm" => 5,
                                          "Cn" => 6);

#= Can be used as an template to construct aerodynamic databases of any
   Vehicle. Includes a function field that computes the aerodynamic forces
   and moments based on the vehicle and control state.
=#
mutable struct VehicleAeroDataBase <: AbstractVehicleDataBase
  #Vehicle and Control State Contributions (can be non-linear)
  CDdb::AeroDataBase #Drag
  CSdb::AeroDataBase #Side
  CLdb::AeroDataBase #Lift
  Cldb::AeroDataBase #roll
  Cmdb::AeroDataBase #pitch
  Cndb::AeroDataBase #yaw
  AeroDBtoFunc::Function #Convert Database to array of functions

 #= Input each axis as a variable amount of arrays encoding the relation
    between the contributions and the inputs it depends on. Size of of array
    determines number of variables it depends on. After contribution array of
    size MxNx... is inputted, it is expected that, when the contribution depends
    on N inputs, that the next N inputs are the points of each variable at which
    the contribution has been measured, in order of array dimension. The inputs
    after that will be the next contribution array.
    The syntax is:
    VehicleAeroDataBase("CD",CD1,["x", CDx], ["y", Cdy],...,"CS",CS1,...) =#
function VehicleAeroDataBase(varargs...)
  this = new()
  this.CDdb = AeroDataBase("CD")
  this.CSdb = AeroDataBase("CS")
  this.CLdb = AeroDataBase("CL")
  this.Cldb = AeroDataBase("Cl")
  this.Cmdb = AeroDataBase("Cm")
  this.Cndb = AeroDataBase("Cn")

  counter = 1
  curr_key = ""
  nvarargs = length(varargs)
  while counter <= nvarargs
    if isa(varargs[counter],String) #new key
      haskey(FM_Contributions, varargs[counter]) ? nothing :
        error("An option has been selected that is not allowed")
      curr_key = varargs[counter]
      counter += 1
      #As long as no new key is inputted, assume new input
      while !isa(varargs[counter],String)
        sizeinput = ndims(varargs[counter])
        if curr_key == "CD"
          this.CDdb.AddContribution(varargs[counter],
            varargs[(counter + 1):(counter + sizeinput)])
        elseif curr_key == "CS"
          this.CSdb.AddContribution(varargs[counter],
            varargs[(counter + 1):(counter + sizeinput)])
        elseif curr_key == "CL"
          this.CLdb.AddContribution(varargs[counter],
            varargs[(counter + 1):(counter + sizeinput)])
        elseif curr_key == "Cl"
          this.Cldb.AddContribution(varargs[counter],
            varargs[(counter + 1):(counter + sizeinput)])
        elseif curr_key == "Cm"
          this.Cmdb.AddContribution(varargs[counter],
            varargs[(counter + 1):(counter + sizeinput)])
        elseif curr_key == "Cn"
          this.Cndb.AddContribution(varargs[counter],
            varargs[(counter + 1):(counter + sizeinput)])
        else
          error("Something Unexpected Happenend")
        end
        #update counter
        counter += sizeinput + 1
        #check whether more inputs exist
        if counter > nvarargs
          break
        end
      end
    else
      error("Unexpected Input")
    end
  end

  this.AeroDBtoFunc = function AeroDBtoFunc(
      VehAeroDataBaseInputOrder::Dict{String,Integer})

    FuncArray = Array{Function,1}(6)
    FuncArray[1] = AeroFuncArrayContr(this.CDdb, VehAeroDataBaseInputOrder)
    FuncArray[2] = AeroFuncArrayContr(this.CSdb, VehAeroDataBaseInputOrder)
    FuncArray[3] = AeroFuncArrayContr(this.CLdb, VehAeroDataBaseInputOrder)
    FuncArray[4] = AeroFuncArrayContr(this.Cldb, VehAeroDataBaseInputOrder)
    FuncArray[5] = AeroFuncArrayContr(this.Cmdb, VehAeroDataBaseInputOrder)
    FuncArray[6] = AeroFuncArrayContr(this.Cndb, VehAeroDataBaseInputOrder)

    CoefficientsArray = function CoefficientsArray(state::Vector{Float64})
      coeffarray = Vector{Float64}(6)
      coeffarray[1] = FuncArray[1](state)
      coeffarray[2] = FuncArray[2](state)
      coeffarray[3] = FuncArray[3](state)
      coeffarray[4] = FuncArray[4](state)
      coeffarray[5] = FuncArray[5](state)
      coeffarray[6] = FuncArray[6](state)
      return coeffarray
    end #CoefficientsArray
    return CoefficientsArray
  end #this.AeroDBtoFunc

 return this
end #Constructor
end #TypeDef

function AeroFuncArrayContr(db::AeroDataBase,
   VehAeroDataBaseInputOrder::Dict{String, Integer})
  idx = Vector{Int64}(0)
  for str in db.ListOfInputs
    idx = push!(idx, VehAeroDataBaseInputOrder[str])
  end

  Func = function AeroContr(state::Vector{Float64})
    coeff = 0.
    for i=1:length(db.ListOfContributions)
      coeff += lininterpnvar(db.ListOfInputValues[i],db.ListOfContributions[i],
        state[idx[db.ListOfInputOrder[i]]])
    end
    return coeff
  end
  return Func
end #AeroFuncArrayContribution

##Example
#CD1 = rand(7,5)
#CD2 = rand(8,7)
#x = ["alpha",1,2,3,4,5,6,7]
#y = ["beta",1,2,3,4,5]
#z = ["sigma",1,2,3,4,5,6,7,8]
#test = VehicleAeroDataBase("CD",CD1,x,y,CD2,z,x,"CS",CD2,z,x,CD1,x,y)

##Example 2
#testinputorder = Dict{String,Integer}("alpha" => 1, "beta" => 2, "sigma" => 3)
#idxCD = Vector{Int64}(0)
#for str in test.CDdb.ListOfInputs
#  idxCD = push!(idxCD, testinputorder[str])
#end
#testfunc = test.AeroDBtoFunc(testinputorder)
#blainput = [1 2 3]
#bla2 = testfunc(Array{Float64,2}(blainput))
