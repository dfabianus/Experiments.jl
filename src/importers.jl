using Measurements
using DataFrames
using TimeSeries
using Dates

# Wrappers around the TimeArray constructor
function timeseries(name::Symbol, datetimes::AbstractVector{<:TimeType}, values::AbstractVector...)
    names = [name for i in 1:length(values)]
    return TimeArray(datetimes, hcat(values...), names)
end
