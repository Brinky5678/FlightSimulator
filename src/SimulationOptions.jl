#Dictionaries containing options
ODETYPES = Dict{String, Integer}("ode23" => 1,
                "ode45" => 2,
                "ode78" => 3,
                "ode23s" => 4);

DOFSIMTYPES = Dict{String, Integer}("trans" => 1,
                                    "rot" => 2,
                                    "transrot" => 3);

#SimulationProperties Type
struct SimulationProperties
  ODE_SolverType::String
  DofSimType::String

  function SimulationProperties(;ODE_SolverIn::String = "ODE45",
                    DofSimTypeIn::String = "Trans")
    #ODE Type Checker
    if !haskey(ODETYPES, lowercase(ODE_SolverIn))
      warn("ODE Solver Type Not Found, Setting Solver Type to Default (ODE45)")
      ODE_SolverIn::String = "ode45"
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
function NewODEType(odetype::String)
    ODETYPES[odetype] = length(ODETYPES) + 1
end #NewODEType
