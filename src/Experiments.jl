module Experiments

export Experiment, TimeVariable

using TimeSeries
using Dates
using DataFrames

include("types.jl")
include("datetime_handling.jl")

Base.show(io::IO, z::Experiment) = print(io, z.id, " experiment with ", length(z.timeseries), " timeseries")

function DataFrame(experiment::Experiment)
    dfs = Vector{DataFrame}()
    for ts in experiment.timeseries
        push!(dfs, DataFrame(ts))
    end
    df_total = outerjoin(dfs..., on=:timestamp, makeunique=true)
    sort!(df_total, :timestamp) # must be done after join
    return df_total
end

end