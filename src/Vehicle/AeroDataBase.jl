#Type definition for the aerodynamic database, including a function to
# add new contributions per contribution. (TBD: Including a remove function)
export AbstractDataBase

export AeroDataBase

abstract type AbstractDataBase end

mutable struct AeroDataBase <: AbstractDataBase
  Variable::String
  ListOfInputs::Array{String}
  ListOfContributions::Array{Any}
  ListOfInputValues::Array{Any}
  ListOfInputOrder::Array{Any}
  AddContribution::Function

  function AeroDataBase(varkey::String)
    this = new()
    this.Variable = varkey
    this.ListOfInputs = []
    this.ListOfContributions = []
    this.ListOfInputValues = []
    this.ListOfInputOrder = []

    #Add method to add contributions to this specific database
    this.AddContribution = function (Contr::Array{Float64},varargs::Tuple)
      #check if correct number of dimensions have been assigned
      nvarargs = length(varargs)
      ndims(Contr) != nvarargs ? error("Incorrect number of inputs") : nothing

      #Add Contr to ListOfContributions
      this.ListOfContributions = [this.ListOfContributions..., Contr]
      NewInput = Vector(nvarargs)
      NewInputOrder = Vector(nvarargs)

      for i=1:length(varargs)
        if IsContainedInStringArray(this.ListOfInputs,varargs[i][1])
          NewInput[i] = varargs[i][2:end]
          NewInputOrder[i] = IdInStringArray(this.ListOfInputs,varargs[i][1])
        else
          this.ListOfInputs = [this.ListOfInputs...,varargs[i][1]]
          NewInput[i] = varargs[i][2:end]
          NewInputOrder[i] = length(this.ListOfInputs)
        end
      end
      this.ListOfInputValues = push!(this.ListOfInputValues, NewInput)
      this.ListOfInputOrder = push!(this.ListOfInputOrder, NewInputOrder)
      return nothing
    end #this.AddContribution
    return this
  end #Constructor
end #typedef

#Example
#=
Cm1 = rand(4,7)
Cm2 = rand(5,7)
x = ["alpha", 2,3,4,5]
y = ["beta",1,5,2,7,9,4,9]
z = ["sigma",1,2,3,4,5]
Cmdb = AeroDataBase("Cm")
Cmdb.AddContribution(Cm1,(x,y))
Cmdb.AddContribution(Cm2,(z,y))
=#
