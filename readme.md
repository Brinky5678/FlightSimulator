# An extensible spaceflight simulator in Julia

  The goal of this project is to create a foundation for trajectory and vehicle
  performance analysis based on detailed numerical simulations, modelling the numerous
  forces acting on a vehicle in the space environment. The vehicles can be equipped with
  feedback controllers for both translational and rotational motions.

## Features for V0.1

### Core Features
Features that will be included are;
 - Motion simulation of vehicles within solar system, taking into account the effects of;
    + Gravity of the sun and all planets, at any distance
    + Solar Pressure (if SRParea or SRCoeff != 0)
    + Atmosphere of Earth
    + Custom Atmosphere Models of Earth or other planets.

- Ability to define custom vehicles with custom properties through standardized API. By default,
  the following properties will be implemented;
    + Structure/type identical of custom vehicle (subtype of AbstractSpacecraft)
    + DryMass [kg]
    + FuelMass for OMS [kg]
    + FuelMass for RCS [kg]
    + Reference Area  [m^2 ]
    + Reference Length Longitudinal  [m]
    + Reference Length Lateral  [m]
    + Solar Reflection Coefficient [-]
    + Solar Reflection Area [m^2]
    + Moment of Inertia Tensor and its inverse (the inverse is computed automatically) [kg m^2]
    + Aerodynamic database [-]
      * Contains data about how the changing orientation of the vehicle w.r.t. the airflow
        Affects to aerodynamic forces on the vehicle. (control surfaces not included here)
      * Ability to load from CSV or JSON file (ToDo)
    + Mission Control Subsystem (ToDo)
      * Determines where to go
      * Discrete Time System Interface running at specified update frequency (event)
    + Navigation Subsystem (ToDo)
      * Determines where the vehicle is
      * Make use of noisy "sensor data" (e.g. simulated state + noise) with kalman filter
        (settings of which are included in the configuration file)
      * Discrete Time System Interface running at specified update frequency (event)
    + Guidance Subsystem (ToDo)
      * Determines Forces and Attitude required to go to where the vehicle needs to go
      * Discrete Time System Interface running at specified update frequency
    + Attitude Control Subsystem (ToDo)
      * Determines the moments on the system required for the command orientation by the
        Guidance Subsystem
      * Discrete Time System Interface running at specified update frequency (event)
      * Has an option to model the thrusters or simply take the moments commanded to the
        attitude thrusters as the final answer
    + Actuator Subsystem (ToDo)
      * Determines the amount of thrust for the RCS and the deflections of the aerodynamic
        affectors in an optimal sense.
      * Discrete Time System Interface running at specified update frequency (event)
    + Ability to load from JSON configuration file (ToDo)


- Ability to define custom thruster models (ToDo)
  + Thruster structure
    * Control variable is the thrust
    * Maximum Thrust
    * Orientation w.r.t. body-frame of vehicle
    * Location w.r.t. origin of body-frame of vehicle
    * Boolean Flag to indicate whether to use fuel
    * Specific impulse of thruster (only required when using fuel)
    * Boolean Flag to indicate whether to use pressure contribution
    * Exhaust Pressure (only required when using pressure contribution)
    * Exhaust Area (only required when using pressure contribution)
    * In practice the RCS thrusters are often fired in pulsating mode to provide a required
      change in orientation. This will not be modelled here, instead a commanded moment from
      the attitude control subsystem will be executed by the thrusters in combination with the
      the aerodynamic effectors, unless otherwise commanded, as if they were always on.

### Additional Features       
- Configuration file (JSON) (ToDo);
  + To determine which forces to include and from which sources
  + Visualization of trajectory data on Spice Enhanced Cosmographia
  + Which data to export to CSV file
  + Simulator Setup, including which integrator to use
- Ability to be called from command line, using a configuration file for the setup of the simulator,
  allowing for interfacing between external software. (ToDo)
- Trajectory data, or otherwise selected data in configuration file, will be made available in a CSV file for
  post-processing (ToDo)
- Documentation and examples of the API (ToDo)


## Planned Features for V0.2 (So far)
- Multiple spacecrafts simulations
- communications between the various spacecraft (events)
- Improvements to API (because there will always be improvements ;-) )
- Requested Features
