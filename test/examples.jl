using Revise
using Experiments
using CSV 
using DataFrames
using TimeSeries
using Plots
using Dates

df_offline = CSV.read("data/offline.csv", DataFrame)
df_online = CSV.read("data/online.csv", DataFrame)
t = df_offline.time
DCW = df_offline.DCW
scatter(t,DCW)

Experiments.TimeVariable("DCW", TimeSeries.TimeArray(df_offline.datetime, df_offline.DCW))

## create start time 
start_time = DateTime(2019,1,1,0,0,0)
df_offline.datetime = start_time .+ Dates.Second(1.0) .* Int64.(round.(3600 .* df_offline.time, digits=0))
df_online.datetime = start_time .+ Dates.Second(1.0) .* Int64.(round.(3600 .* df_online.time, digits=0))

# Create a new experiment
test_from_dataframe = Experiments.Experiment("test_from_dataframe", df_offline)
duration_test = timestamp(test_from_dataframe.timeseries["time"][5])-timestamp(test_from_dataframe.timeseries["time"][1])
Dates.canonicalize(Dates.CompoundPeriod(duration_test))

Experiments.Experiment("test", Dict("a" => 1, "b" => "c"), [1.1,2.4,3.1])
Experiments.f()

dates = [DateTime(2018,1,1,10,0,0), DateTime(2018,1,1,11,0,0), DateTime(2018,1,1,12,0,0)]
YES = [1.1,2.4,3.1]
timseries = TimeSeries.TimeArray(dates, YES)

plot(timseries)

