module Experiments
export Experiment, TimeVariable
using TimeSeries
using Dates
using DataFrames

#struct TimeVariable{T,N,D,A} <: AbstractTimeSeries{T,N,D}
#    timeArray::TimeArray{T,N,D,A}
#end

mutable struct Experiment
    id::String
    timeseries::Vector{TimeArray}

    function Experiment(id::String, timeseries::Vector{TimeArray})
        new(id, timeseries)
    end
end

function Experiment(id::String, df::DataFrame)
    timeseries = Vector{TimeArray}()
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

function starttime(timeseries::TimeArray)
    return minimum(timestamp(timeseries))
end
function starttime(experiment::Experiment)
    first_timepoints = [starttime(ts) for ts in experiment.timeseries]
    return minimum(first_timepoints)
end
function endtime(timeseries::TimeArray)
    return maximum(timestamp(timeseries))
end
function endtime(experiment::Experiment)
    last_timepoints = [endtime(ts) for ts in experiment.timeseries]
    return maximum(last_timepoints)
end

function duration(timeseries::TimeArray)
    return Dates.canonicalize(endtime(timeseries) - starttime(timeseries))
end
function duration(experiment::Experiment)
    return Dates.canonicalize(endtime(experiment) - starttime(experiment))
end

# 
end