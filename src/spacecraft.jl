#Begin Copied Code
abstract type AbstractSpacecraft end
#abstract type AbstractModule end
#End Copied Code


#original Code definition of RigidBodyVehicle with rotational inertia
struct RigidBodyVehicle <: AbstractSpacecraft
  Name::Symbol
  DryMass::Float64
  #Fuel::Float64
  RefArea::Float64
  RefLengthLon::Float64
  RefLengthLat::Float64
  #ReflecCoeff::Float64
  #SRParea::Float64
  InertiaTensor::Matrix{Float64}
  InvInertiaTensor::Matrix{Float64}
  ForceMomentFunc::Function
  #Actuators::Vector{Actuator}
  #MissionSystem::MissionProfile
  #Guidance::GuidancySystem
  #Control::ControlSystem
  #Navigation::NavigationSystem
end

RigidBodyVehicle(Name::String, Drymass, RefArea, RefLengthLon, RefLengthLat,
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
