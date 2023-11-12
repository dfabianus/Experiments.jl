using Experiments
using Test
using CSV 
using DataFrames
using TimeSeries
using Dates
using Measurements

include("load_test_data.jl")

exp_offline_dataframe, exp_online_dataframe, exp_multiple_dataframes = create_experiments()

# For construction of tests from two dataframes. Are the timeseries correctly created?
@test (length(exp_offline_dataframe.timeseries) + length(exp_online_dataframe.timeseries) 
    == length(exp_multiple_dataframes.timeseries))

# This tests will check the correct construction of a DataFrame from an Experiment
df_all = DataFrame(exp_multiple_dataframes)
@test size(df_all, 2) == length(exp_multiple_dataframes.timeseries) + 1

# This tests will check the timeseries constructors from Experiments.jl
# with Measurements.jl type and replicates measurements.
datetimes = [DateTime(1,1,1,1,1,1), DateTime(1,1,1,1,1,2), DateTime(1,1,1,1,1,3)]
data = [1.0, 2.0, 3.0].±0.1
test_constr = Experiments.timeseries(:test, datetimes, data, data.+1, data.-1)
@test size(test_constr, 2) == length((data, data.+1, data.-1))
# We can also get a big TimeArray object from an Experiment
# this should be somewhat similar to the DataFrame from above
ts_all = Experiments.timeseries(exp_multiple_dataframes)
@test timestamp(ts_all) == df_all[!, :timestamp]
@test timestamp(ts_all) == df_all.timestamp
@test timestamp(ts_all) == df_all[!, 1]

# TEST DRIVEN DEVELOPMENT - Broken Tests
@test_broken (length(exp_offline_dataframe.timeseries) == 1) 
@test (length(exp_offline_dataframe.timeseries) == 1) skip=true
# just an example for a broken test, not importants