#Defines a realistic model of a nozzle, to be used in the RealisticThruster type

#Define AbstractNozzle type
abstract type AbstractNozzle end

#= Define Nozzle type, which includes
    - Flag that indicates whether to use tabulated data or a function to determine the
        thrust as function of fuel rate and pressure
    - Matrices that determines the exhaust velocity and pressure as function of fuel rate
    - Function that determines the exhaust velocity and pressure as function of fuel ratee
    - minimum fuel rate for choked flow
    - maximum fuel rate
    - Exhaust Area

=#
struct Nozzle <: AbstractNozzle
    ExhaustVelocityData
    ExhaustPressureData
    DataFlag::Bool
    ExhaustArea::Float64
    MinFuelRate::Float64
    MaxFuelRate::Float64

    #Constructor function
    function Nozzle(ExhaustVelocityData, ExhaustPressureData, DataFlag::Bool,
        ExhaustArea::Number, MinFuelRate::Number, MaxFuelRate::Number)
        if DataFlag == false
            if ((typeof(ExhaustVelocityData) != Matrix{Float64}) ||
                (typeof(ExhaustPressureData) != Matrix{Float64}))
                error("Expected Exhaust velocity and pressure data to be matrices.")
            end
        else
            if ((typeof(ExhaustVelocityData) != Function ||
                (typeof(ExhaustPressureData) != Function))
                error("Expected Exhaust velocity and pressure data to be functions.")
            end
        end
        new(ExhaustVelocityData, ExhaustPressureData, DataFlag, Float64(ExhaustArea),
                Float64(MinFuelRate), Float64(MaxFuelRate))
    end #Constructor

end

function Nozzle()
    return nothing
end
