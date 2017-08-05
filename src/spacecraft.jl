#Begin Copied Code
abstract type AbstractSpacecraft end
#abstract type AbstractModule end
#End Copied Code

#Create Vehicle Dictionary that allows for multiple vehicle definitions with each a
#varying amount of properties, that can also be defined by the user according to his/her
# needs and requirements of the module. Probably quite slow though.
VehicleDictionary = Dict{DataType, Dict{String, Any}}()

#Create a new vehicle
function NewVehicle(name::String)
    VehicleName = Symbol(name)
    @eval begin
        #Generate Vehicle Type
        struct $VehicleName <: AbstractSpacecraft end
        #Add Vehicle to dictionary
        VehicleDictionary[$VehicleName] = Dict{String, Any}()
        #Generate Setter function for dry mass of the vehicle
        function SetDryMass(::Type{$VehicleName}, drymass::Number)
            VehicleDictionary[$VehicleName]["DryMass"] = Float64(drymass)
            return nothing
        end
        #Make Getter function for the DryMass of the vehicle
        DryMass(::Type{$VehicleName}) = VehicleDictionary[$VehicleName]["DryMass"]
     end #@eval
end # NewVehicle



#original Code definition of RigidBodyVehicle with rotational inertia
#struct RigidBodyVehicle <: AbstractSpacecraft
 # Name::Symbol
  #DryMass::Float64
  #Fuel::Float64
  #RefArea::Float64
  #RefLengthLon::Float64
  #RefLengthLat::Float64
  #ReflecCoeff::Float64
  #SRParea::Float64
  #InertiaTensor::Matrix{Float64}
  #InvInertiaTensor::Matrix{Float64}
  #ForceMomentFunc::Function
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
