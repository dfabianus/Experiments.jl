using Measurements
using DataFrames
using TimeSeries
using Dates

# Wrappers around the TimeArray constructor
function timeseries(name::Symbol, datetimes::AbstractVector{<:TimeType}, values::AbstractVector...)
    names = [name for i in 1:length(values)]
    return TimeArray(datetimes, hcat(values...), names, name)
end

function timeseries(experiment::Experiments.Experiment)
    return merge(experiment.timeseries..., method = :outer)
end

function timeseries(experiment::Experiments.Experiment, names::Symbol...)
    ts_vec = Vector{TimeArray}()
    for ts in experiment.timeseries
        if Symbol(meta(ts)) in names
            push!(ts_vec, ts)
        end
    end
    if length(ts_vec) == 0
        error("No timeseries with the given names found.")
    end
    if length(ts_vec) == 1
        return ts_vec[1]
    end
    return merge(ts_vec..., method = :outer)
end