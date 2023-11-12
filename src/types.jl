mutable struct Experiment
    id::String
    timeseries::Vector{TimeArray}

    function Experiment(id::String, timeseries::Vector{TimeArray})
        new(id, timeseries)
    end
end

function Experiment(dfs::DataFrame...; name::String, timecol = :datetime)
    ts_vec = Vector{TimeArray}()
    for df in dfs
        for col in names(df)
            if Symbol(col) != Symbol(timecol)
                ts = timeseries(Symbol(col), df[!,timecol], df[!,col])
                push!(ts_vec, ts)
                #push!(timeseries, TimeSeries.TimeArray(df[!,timecol], df[!,col], [Symbol(col)]))
            end
        end
    end
    return Experiment(name, ts_vec)
end