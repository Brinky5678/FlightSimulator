#Global Dictionaries for the Simulation Options
ODEALG = Dict{String, Any}(
    "bs3" => BS3(),
    "tsit5" => Tsit5(),
    "vern7" => Vern7(),
    "rodas4" => Rodas4());

ODETYPES = Dict{String, Integer}(
    "bs3" => 1,
    "tsit5" => 2,
    "vern7" => 3,
    "rodas4" => 4);

DOFSIMTYPES = Dict{String, Integer}(
    "trans" => 1,
    "rot" => 2,
    "5dof" => 3, #Allows the user to give an anle-of-attack and a bank-angle that the vehicle will instantly have (sideslip always zero) 
    "transrot" => 4);

#Add function to allow for custom ode solvers
function NewODEType(odetype::String, odealg)
    ODETYPES[odetype] = length(ODETYPES) + 1
    ODEALG[odetype] = odealg
end #NewODEType
