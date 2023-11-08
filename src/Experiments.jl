module Experiments
export Experiment
using TimeSeries
using Dates
using DataFrames

struct TimeVariable{T,N,D,A} <: AbstractTimeSeries{T,N,D}
    timeArray::TimeArray{T,N,D,A}
end

mutable struct Experiment
    id::String
    #meta::Dict{String,Any}
    timeseries::Vector{TimeVariable}

    function Experiment(id::String, timeseries::Vector{TimeVariable})
        new(id, timeseries)
    end
end

function Experiment(id::String, df::DataFrame)
    timeseries = Vector{TimeVariable}()
    for col in names(df)
        if col != "datetime"
            push!(timeseries, TimeSeries.TimeArray(df.datetime, df[!,col]))
        end
    end
    return Experiment(id, timeseries)
end

# Dependent properties
"""
    get_start_datetime(experiment::Experiment)

Get the start datetime of an experiment from the minimum of all included timeseries.

# Examples
```julia-repl
julia> get_start_datetime(experiment)
2019-01-01T00:00:00
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

function get_experiment_duration(experiment::Experiment)
    return get_end_datetime(experiment) - get_start_datetime(experiment)
end

function get_signal_absolute_hours(experiment::Experiment, signal::String)
    return get_end_datetime(experiment) - get_start_datetime(experiment)
end

# 
end