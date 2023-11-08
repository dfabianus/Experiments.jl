using Revise
using Experiments

Experiments.Experiment("test", Dict("a" => 1, "b" => "c"), [1.1,2.4,3.1])
Experiments.f()


using TimeSeries
using Dates
dates = [DateTime(2018,1,1,10,0,0), DateTime(2018,1,1,11,0,0), DateTime(2018,1,1,12,0,0)]
timseries = TimeSeries.TimeArray(dates, [1.1,2.4,3.1])

using Plots
plot(timseries)