#To Do: Make it possible to load from file
#To Do: for the simulation, write states to vehicle
# States should belong to the vehicle

#Create AbstractSpacecraft type
abstract type AbstractSpacecraft end

#Create Vehicle Dictionary that allows for multiple vehicle definitions with each a
#varying amount of properties, that can also be defined by the user according to his/her
# needs and requirements of the module. Probably quite slow though.
VehicleDictionary = Dict{DataType, Dict{String, Any}}()

#Create single vehicle
function NewVehicle(name::String)
    VehicleName = Symbol(name)
    @eval begin
        #Add Vehicle to dictionary
        VehicleDictionary[$VehicleName] = Dict{String, Any}()

        #Generate Vehicle Type
        struct $VehicleName <: AbstractSpacecraft end

        #Generate Constructor for the new vehicle type
        function ($VehicleName)()
            println("Full constructor yet to be implemented!")
        end #($VehicleName)()
    end #@eval
end #NewVehicle

#Create a new vehicles
function NewVehicle(names::Array{String})
    for name in names
        NewVehicle(name)
    end
end # NewVehicle

#Alternate way of creating new vehicles
function NewVehicle(namesargs...)
    NewVehicle([namesargs...])
end #NewVehicle

#Generate Setter and getter functions for dry mass of the vehicle
function SetDryMass(vehicle::Type{<:AbstractSpacecraft}, drymass::Number)
    VehicleDictionary[vehicle]["DryMass"] = Float64(drymass)
    return nothing
end #SetDryMass
DryMass(vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["DryMass"]

#Setter and Getter function for Fuel of OMS
function SetFuelOMS(vehicle::Type{<:AbstractSpacecraft}, fuelOMS::Number)
    VehicleDictionary[vehicle]["FuelOMS"] = Float64(fuelOMS)
    return nothing
end #SetFuel
FuelOMS(Vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["FuelOMS"]

#Setter and Getter function for Fuel of RCS
function SetFuelRCS(vehicle::Type{<:AbstractSpacecraft}, fuelRCS::Number)
    VehicleDictionary[vehicle]["FuelRCS"] = Float64(fuelOMS)
    return nothing
end #SetFuel
FuelRCS(Vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["FuelRCS"]

#Generate Setter and getter functions for reference area
function SetRefArea(vehicle::Type{<:AbstractSpacecraft}, refarea::Number)
    VehicleDictionary[vehicle]["RefArea"] = Float64(refarea)
    return nothing
end #SetRefArea
ReferenceArea(vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["RefArea"]

#Setter and Getter function for longitudinal reference length
function SetRefLengthLon(vehicle::Type{<:AbstractSpacecraft}, reflengthlon::Number)
    VehicleDictionary[vehicle]["RefLengthLon"] = Float64(reflengthlon)
    return nothing
end #SetRefLengthLon
RefLengthLon(vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["RefLengthLon"]

#Setter and Getter function for lateral reference length
function SetRefLengthLat(vehicle::Type{<:AbstractSpacecraft}, reflengthlat::Number)
    VehicleDictionary[vehicle]["RefLengthLat"] = Float64(reflengthlat)
    return nothing
end #SetRefLengthLon
RefLengthLat(vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["RefLengthLat"]

#Setter and Getter function for the reflection coefficient
function SetReflectionCoeff(vehicle::Type{<:AbstractSpacecraft}, refleccoeff::Number)
    VehicleDictionary[vehicle]["ReflectionCoefficient"] = Float64(refleccoeff)
    return nothing
end #SetReflectionCoeff
ReflectionCoeff(vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["ReflectionCoefficient"]

#Setter and Getter function for the solar radiation pressure area (SRParea)
function SetSRPArea(vehicle::Type{<:AbstractSpacecraft}, SRParea::Number)
    VehicleDictionary[vehicle]["SRPArea"] = Float64(SRParea)
    return nothing
end #SetSRPArea
SRPArea(vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["SRPArea"]

#Setter and Getter functions for the Inertia Tensor and its inverse
function SetInertiaTensor(vehicle::Type{<:AbstractSpacecraft}, InertiaTensor::Matrix{Float64},
    InvInertiaTensor::Matrix{Float64} = inv(InertiaTensor))
    VehicleDictionary[vehicle]["InertiaTensor"] = InertiaTensor
    VehicleDictionary[vehicle]["InvInertiaTensor"] = InvInertiaTensor
    return nothing
end #SetInertiaTensor
InertiaTensor(vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["InertiaTensor"]
InvInertiaTensor(vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["InvInertiaTensor"]

#Setter and Getter function for the aerodynamic database of the vehicle
function SetAerodynamicDatabase(vehicle::Type{<:AbstractSpacecraft}, AeroDB::VehicleAeroDataBase)
    VehicleDictionary[vehicle]["AerodynamicDatabase"] = AeroDB
    return nothing
end #SetAerodynamicDatabase
AerodynamicDatabase(vehicle::Type{<:AbstractSpacecraft}) = VehicleDictionary[vehicle]["AerodynamicDatabase"]

function FrameTransformation(vehicle::Type{<:AbstractSpacecraft}, fm::Type{<:AbstractTransformable},
     newframe::Type{<:AbstractTransformable})


end

#original Code definition of RigidBodyVehicle with rotational inertia
#struct RigidBodyVehicle <: AbstractSpacecraft
 # Name::Symbol - Check
  #DryMass::Float64 - Check
  #Fuel::Float64 - Check
  #RefArea::Float64 - Check
  #RefLengthLon::Float64 - Check
  #RefLengthLat::Float64 - Check
  #ReflecCoeff::Float64 - Check
  #SRParea::Float64 - Check
  #InertiaTensor::Matrix{Float64} - Check
  #InvInertiaTensor::Matrix{Float64} - Check
  #ForceMomentFunc::Function - Check, but in Database form
  #Actuators::Vector{Actuator}
  #MissionSystem::MissionProfile
  #Guidance::GuidancySystem
  #Control::ControlSystem
  #Navigation::NavigationSystem
#end

#=RigidBodyVehicle(Name::String, Drymass, RefArea, RefLengthLon, RefLengthLat,
                  InertiaTensor, InvInertiaTensor, ForceMomentFunc) =
                  RigidBodyVehicle(Symbol(Name), Drymass, RefArea, RefLengthLon,
                    RefLengthLat, InertiaTensor, InvInertiaTensor, ForceMomentFunc)
                    #,Actuators, #MissionSystem, Guidance, Control, Navigation )

function RigidBodyVehicle(Name::Symbol, Drymass, RefArea, RefLengthLon,
  RefLengthLat, InertiaTensor, InvInertiaTensor, AeroDataBase::VehicleAeroDataBase,
   AeroDataBaseInputOrder::Dict{String,Integer})

   FMfunc = AeroDataBase.AeroDBtoFunc(AeroDataBaseInputOrder)
   return RigidBodyVehicle(Symbol(Name), Drymass, RefArea, RefLengthLon,
     RefLengthLat, InertiaTensor, InvInertiaTensor, FMfunc)
end

RigidBodyVehicle(Name::String, Drymass, RefArea, RefLengthLon,
  RefLengthLat, InertiaTensor, InvInertiaTensor, AeroDataBase::VehicleAeroDataBase,
   AeroDataBaseInputOrder::Dict{String,Integer}) = RigidBodyVehicle(Symbol(Name),
   Drymass, RefArea, RefLengthLon, RefLengthLat, InertiaTensor, InvInertiaTensor,
   AeroDataBase::VehicleAeroDataBase, AeroDataBaseInputOrder::Dict{String,Integer})
=#
