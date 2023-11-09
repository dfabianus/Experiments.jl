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

# The duration of the experiment is always the longest 
# The duration of the timeseries can be all different
