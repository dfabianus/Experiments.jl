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

#TV_DCW = Experiments.TimeVariable(TimeSeries.TimeArray(df_offline.datetime, df_offline.DCW))
#scatter(TV_DCW)
#plot(TimeSeries.TimeArray(df_offline.datetime, df_offline.DCW))

# #create start time 
start_time = DateTime(2018,1,1,0,0,0)
df_offline.datetime = start_time .+ Dates.Second(1.0) .* Int64.(round.(3600 .* df_offline.time, digits=0))
df_online.datetime = start_time .+ Dates.Second(1.0) .* Int64.(round.(3600 .* df_online.time, digits=0))

# Create a new experiment
test_from_dataframe = Experiments.Experiment(df_offline; name="test")
plot(test_from_dataframe.timeseries[1])
scatter(test_from_dataframe.timeseries[7])

# Dates and durations for the whole experiment
Experiments.starttime(test_from_dataframe)
Experiments.endtime(test_from_dataframe)
Experiments.duration(test_from_dataframe)

# Dates and durations for a single timeseries
Experiments.starttime(test_from_dataframe.timeseries[1])
Experiments.endtime(test_from_dataframe.timeseries[1])
Experiments.duration(test_from_dataframe.timeseries[1])
#In this case both are equal because timeseries are all the same length

