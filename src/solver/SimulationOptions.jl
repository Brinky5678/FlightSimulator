#SimulationOptions Type
struct SimulationOptions
  ODE_SolverType::String
  DofSimType::String
  SimulationTime::Float64

  function SimulationOptions(;ODE_SolverIn::String = "tsit5",
                    DofSimTypeIn::String = "Trans", SimulationTime::Float64 = 50.0)
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

    #SimulationTime Checker
    if SimulationTime <= 0
        warn("Simulation Time must be positive, Setting Simulation Time
            to Default (50.0 sec)")
        SimulationTime = 50.0
    end

    this = new(lowercase(ODE_SolverIn),
               lowercase(DofSimTypeIn),
               SimulationTime);

  end
end
