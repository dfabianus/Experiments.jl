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
test_from_offline_dataframe = Experiments.Experiment(df_offline; name="test_1")
test_from_online_dataframe = Experiments.Experiment(df_online; name="test_2")
test_from_multiple_dataframes = Experiments.Experiment(df_offline, df_online; name="test_3")

# Dates and durations for the whole experiment
Experiments.starttime(test_from_multiple_dataframes)
Experiments.endtime(test_from_multiple_dataframes)
Experiments.duration(test_from_multiple_dataframes)

# Dates and durations for a single timeseries
Experiments.starttime(test_from_multiple_dataframes.timeseries[1])
Experiments.endtime(test_from_multiple_dataframes.timeseries[1])
Experiments.duration(test_from_multiple_dataframes.timeseries[1])

Experiments.starttime(test_from_multiple_dataframes.timeseries[38])
Experiments.endtime(test_from_multiple_dataframes.timeseries[38])
Experiments.duration(test_from_multiple_dataframes.timeseries[38])

# The duration of the experiment is always the longest 
# The duration of the timeseries can be all different



