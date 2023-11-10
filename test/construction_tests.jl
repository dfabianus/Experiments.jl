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

# This tests will check the correct construction of a DataFrame from an Experiment
df = DataFrame(exp_multiple_dataframes)
@test size(df, 2) == length(exp_multiple_dataframes.timeseries) + 1

# TEST DRIVEN DEVELOPMENT - Broken Tests
@test_broken (length(exp_offline_dataframe.timeseries) == 1) 
@test (length(exp_offline_dataframe.timeseries) == 1) skip=true
# just an example for a broken test, not importants