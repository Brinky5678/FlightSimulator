#To Do: Make it possible to load from file

#original Code definition of RigidBodyVehicle with rotational inertia
struct RigidBodyVehicle <: AbstractSpacecraft
  Name::String
  DryMass::Float64
  Fuel::Float64
  RefArea::Float64
  RefLengthLon::Float64
  RefLengthLat::Float64
  ReflecCoeff::Float64
  SRParea::Float64
  InertiaTensor::Matrix{Float64}
  InvInertiaTensor::Matrix{Float64}
  VehicleAeroDataBase::T where {T <: AbstractVehicleDataBase}
  #Actuators::Vector{Type{<:AbstractActuator}}
  MissionSystem::S where {S <: AbstractMissionSystem}
  GuidanceSystem::S where {S <: AbstractGuidanceSystem}
  ControlSystem::S where {S <: AbstractControlSystem}
  NavigationSystem::S where {S <: AbstractNavigationSystem}
  InitialState::SimState
  Trajectory::Vector{SimState}
end

#Constructor for vehicle type
function RigidBodyVehicle(;Name::String = "MySpacecraft", Drymass::Float64 = 1000.,
  Fuel::Float64 = 0., ReferenceArea::Float64 = 100., ReferenceLengthLongitude::Float64 = 23.,
  ReferenceLengthLatitude::Float64 = 12., ReflectionCoefficient::Float64 = 0.5,
  SRP_Area::Float64 = 20., InertiaTensor::Matrix{Float64} = diagm([10000., 10000., 10000.]),
  InverseInertiaTensor::Matrix{Float64} = inv(InertiaTensor),
  vehicleAeroDatabase::T = VehicleAeroDataBase(),
    #Actuators::Vector{Type{<:AbstractActuator}} = Vector{AbstractActuator}(),
  missionSystem::S = MissionSystem(),
  guidanceSystem::K = GuidanceSystem(),
  controlSystem::L = ControlSystem(),
  navigationSystem::O = NavigationSystem(),
  InitialState::SimState = SimState(),
  Trajectory::Vector{SimState} = Vector{SimState}()
  ) where {T <: AbstractVehicleDataBase, S <: AbstractMissionSystem, K <: AbstractGuidanceSystem, L <: AbstractControlSystem, O <: AbstractNavigationSystem}

  #Create Vehicle
  RigidBodyVehicle(Name, Drymass, Fuel, ReferenceArea, ReferenceLengthLongitude, ReferenceLengthLatitude,
    ReflectionCoefficient, SRP_Area, InertiaTensor, InverseInertiaTensor,
    vehicleAeroDatabase, #Actuators, 
    missionSystem, guidanceSystem, controlSystem,
    navigationSystem, InitialState, Trajectory
    )
end #End Constructor