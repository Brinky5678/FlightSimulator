#Dictionaries containing options
ODETYPES = Dict{String, Integer}("bs3" => 1,
                "tsit5" => 2,
                "vern7" => 3,
                "rodas4" => 4);

DOFSIMTYPES = Dict{String, Integer}("trans" => 1,
                                    "rot" => 2,
                                    "transrot" => 3);

ODEALG = Dict{String, Any}("bs3" => BS3(),
                           "tsit5" => Tsit5(),
                           "vern7" => Vern7(),
                           "rodas4" => Rodas4());
#SimulationOptions Type
struct SimulatationOptions
  ODE_SolverType::String
  DofSimType::String

  function SimulationOptions(;ODE_SolverIn::String = "tsit5",
                    DofSimTypeIn::String = "Trans")
    #ODE Type Checker
    if !haskey(ODETYPES, lowercase(ODE_SolverIn))
      warn("ODE Solver Type Not Found, Setting Solver Type to Default (Tsit5)")
      ODE_SolverIn::String = "tsit5"
    end

    #DofSimType Checker
    if !haskey(DOFSIMTYPES, lowercase(DofSimTypeIn))
      warn("Degrees of Freedom Type Not Found, Setting Degrees
            of Freedom Type to Default (Trans)")
      DofSimTypeIn::String = "trans"
    end

    this = new(lowercase(ODE_SolverIn),
               lowercase(DofSimTypeIn));

  end
end

#Add function to allow for custom ode solvers
function NewODEType(odetype::String, odealg)
    ODETYPES[odetype] = length(ODETYPES) + 1
    ODEALG[odetype] = odealg
end #NewODEType
