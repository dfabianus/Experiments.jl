using Experiments
using CSV 
using DataFrames
using TimeSeries
using Plots
using Dates

include("load_test_data.jl")
exp_offline_dataframe, exp_online_dataframe, exp_multiple_dataframes = create_experiments(repl=true)

# Dates and durations for a single timeseries
Experiments.starttime(exp_multiple_dataframes.timeseries[1])
Experiments.endtime(exp_multiple_dataframes.timeseries[1])
Experiments.duration(exp_multiple_dataframes.timeseries[1])

Experiments.starttime(exp_multiple_dataframes.timeseries[38])
Experiments.endtime(exp_multiple_dataframes.timeseries[38])
Experiments.duration(exp_multiple_dataframes.timeseries[38])

## Trying to implement the dataframes integration
exp_multiple_dataframes
ts1 = exp_multiple_dataframes.timeseries[3] # 20x1 DCW 
ts2 = exp_multiple_dataframes.timeseries[30] # 24600x1 Volume
ts3 = exp_multiple_dataframes.timeseries[24] # 24600x1 A
# now merge these two timeseries into a dataframe
df1 = DataFrame(ts1)
df2 = DataFrame(ts2)
df3 = DataFrame(ts3)

# not feasible because it just considers equal timestamps
innerjoin(df1, df2, on=:timestamp, makeunique=true) 

leftjoin(df1, df2, on=:timestamp, makeunique=true) # 24600x2
rightjoin(df1, df2, on=:timestamp, makeunique=true)# 20x2

df4 = outerjoin(df1, df2, df3, on=:timestamp, makeunique=true) # 24600x2
sort!(df4, :timestamp) # must be done after join
scatter(df4.timestamp, df4.A)
plot(df4.timestamp, df4.A_2)

df = DataFrame(exp_multiple_dataframes)
plot(df[!, :timestamp], df[!, :A_2])
scatter(df.timestamp, df.A_10)

Experiments.starttime()