mutable struct Experiment
    id::String
    timeseries::Vector{TimeArray}

    function Experiment(id::String, timeseries::Vector{TimeArray})
        new(id, timeseries)
    end
end

function Experiment(dfs::DataFrame...; name::String)
    timeseries = Vector{TimeArray}()
    for df in dfs
        for col in names(df)
            if col != "datetime"
                push!(timeseries, TimeSeries.TimeArray(df.datetime, df[!,col]))
            end
        end
    end
    return Experiment(name, timeseries)
end