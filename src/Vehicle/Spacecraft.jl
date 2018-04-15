#To Do: Make it possible to load from file

#Create AbstractSpacecraft type
abstract type AbstractSpacecraft end

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
  VehicleAeroDataBase::Type{<:AbstractVehicleDataBase}
  Actuators::Vector{Type{<:AbstractActuator}}
  MissionSystem::Type{<:AbstractMissionSystem}
  GuidanceSystem::Type{<:AbstractGuidanceSystem}
  ControlSystem::Type{<:AbstractControlSystem}
  NavigationSystem::Type{<:AbstractNavigationSystem}
  InitialState::SimState
  Trajectory::Vector{SimState}

  #Constructor for vehicle type
  function RigidBodyVehicle(;Name::String = "MySpacecraft", Drymass::Float64 = 1000.,
      Fuel::Float64 = 0., ReferenceArea::Float64 = 100., ReferenceLengthLongitude::Float64 = 23.,
      ReferenceLengthLatitude::Float64 = 12., ReflectionCoefficient::Float64 = 0.5,
      SRP_Area::Float64 = 20., InertiaTensor::Matrix{Float64} = diagm([10000., 10000., 10000.]),
      InverseInertiaTensor::Matrix{Float64} = inv(InertiaTensor),
      VehicleAeroDatabase::Type{<:AbstractVehicleDataBase} = VehicleAeroDataBase(),
      Actuators::Vector{Type{<:AbstractActuator}} = Vector{AbstractActuator}(),
      MissionSystem::Type{<:AbstractMissionSystem} = MissionSystem(),
      GuidanceSystem::Type{<:AbstractGuidanceSystem} = GuidanceSystem(),
      ControlSystem::Type{<:AbstractControlSystem} = ControlSystem(),
      NavigationSystem::Type{<:AbstractNavigationSystem} = NavigationSystem(),
      InitialState::SimState = SimState(Vector{Float64}(6), Vector{Float64}(3)),
      Trajectory::Vector{SimState} = Vector{SimState}())

      #Create Vehicle
      new(Name, Drymass, Fuel, ReferenceArea, ReferenceLengthLongitude, ReferenceLengthLatitude,
            ReflectionCoefficient, SRP_Area, InertiaTensor, InverseInertiaTensor,
            VehicleAeroDataBase, Actuators, MissionSystem, GuidanceSystem, ControlSystem,
            NavigationSystem, InitialState, Trajectory)
  end #End Constructor
end
