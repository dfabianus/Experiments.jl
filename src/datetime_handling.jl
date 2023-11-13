hours2duration(time::Real) = Dates.Second(1.0) .* Int64.(round.(3600 .* time, digits=0))

"""
    starttime(timeseries::TimeArray)

Get the start datetime of a timeseries.

# Examples
```julia-repl
julia> starttime(timeseries)
2019-01-01T00:00:00
```
"""
function starttime(timeseries::TimeArray)
    return minimum(timestamp(timeseries))
end

"""
    starttime(experiment::Experiment)

Get the start datetime of an experiment from the minimum of all included timeseries.

# Examples
```julia-repl
julia> starttime(experiment)
2019-01-01T00:00:00
```
"""
function starttime(experiment::Experiment)
    first_timepoints = [starttime(ts) for ts in experiment.timeseries]
    return minimum(first_timepoints)
end

"""
    endtime(timeseries::TimeArray)

Get the end datetime of a timeseries.

# Examples
```julia-repl
julia> endtime(timeseries)
2019-01-02T10:10:00
```
"""
function endtime(timeseries::TimeArray)
    return maximum(timestamp(timeseries))
end

"""
endtime(experiment::Experiment)

Get the end datetime of an experiment from the maximum of all included timeseries.

# Examples
```julia-repl
julia> endtime(experiment)
2019-01-02T10:10:00
```
"""
function endtime(experiment::Experiment)
    last_timepoints = [endtime(ts) for ts in experiment.timeseries]
    return maximum(last_timepoints)
end

"""
    duration(timeseries::TimeArray)

Get the duration of a timeseries.

# Examples
```julia-repl
julia> duration(timeseries)
1 day, 10 hours, 9 minutes, 55 seconds
```
"""
function duration(timeseries::TimeArray)
    return Dates.canonicalize(endtime(timeseries) - starttime(timeseries))
end

"""
    duration(experiment::Experiment)

Get the duration of an experiment from all included timeseries.

# Examples
```julia-repl
julia> duration(experiment)
1 day, 10 hours, 9 minutes, 55 seconds
```
"""
function duration(experiment::Experiment)
    return Dates.canonicalize(endtime(experiment) - starttime(experiment))
end

function timestamp2hours(timeseries::TimeArray)
    return (timestamp(timeseries) .- starttime(timeseries)) ./ Dates.Hour(1)
end