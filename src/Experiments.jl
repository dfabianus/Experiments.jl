module Experiments
export Experiment

using TimeSeries
using Dates

mutable struct Experiment
    id::String
    meta::Dict{String,Any}
    timeseries::Dict{String,TimeSeries.TimeArray}

    function Experiment(id::String, meta::Dict{String,Any}, timeseries::Vector{Float64})
        new(id, meta, timeseries)
    end
end

# Dependent properties
"""
    get_start_datetime(experiment::Experiment)

Get the start datetime of an experiment from the minimum of all included timeseries.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
function get_start_datetime(experiment::Experiment)
    first_timepoints = [timestamp(ts)[1] for ts in experiment.timeseries]
    return minimum(first_timepoints)
end

function get_end_datetime(experiment::Experiment)
    last_timepoints = [timestamp(ts)[end] for ts in experiment.timeseries]
    return maximum(last_timepoints)
end


end