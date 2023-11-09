using Experiments
using Test
using CSV 
using DataFrames
using TimeSeries
using Dates

include("load_test_data.jl")
exp_offline_dataframe, exp_online_dataframe, exp_multiple_dataframes = create_experiments()

# For construction of tests from two dataframes. Are the timeseries correctly created?
@test (length(exp_offline_dataframe.timeseries) + length(exp_online_dataframe.timeseries) 
    == length(exp_multiple_dataframes.timeseries))

@test_broken (length(exp_offline_dataframe.timeseries) == 1) # just an example for a broken test, not important