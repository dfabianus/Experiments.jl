module Experiments

export Experiment, TimeVariable

using TimeSeries
using Dates
using DataFrames
using CSV

include("types.jl")
include("datetime_handling.jl")
include("importers.jl")

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

function DataFrame(experiments::Vector{Experiment})
    dfs = Vector{DataFrame}()
    for exp in experiments
        df = DataFrame(exp)
        df.id = [exp.id for i in 1:size(df,1)]
        push!(dfs, df)
    end
    df_total = vcat(dfs...)
    sort!(df_total, :timestamp) # must be done after join
    return df_total
end

function save(experiment::Experiment, filename::String)
    df = DataFrame(experiment)
    CSV.write(filename, df)
end

end