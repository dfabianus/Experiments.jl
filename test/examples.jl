using Experiments
using CSV 
using DataFrames
using TimeSeries
using Plots
using Dates

# Load test data
include("load_test_data.jl")

# Create experiments
exp_offline_dataframe, exp_online_dataframe, exp_multiple_dataframes = create_experiments(repl=true)

# Dates and durations for a single timeseries
Experiments.starttime(exp_multiple_dataframes.timeseries[1])
Experiments.endtime(exp_multiple_dataframes.timeseries[1])
Experiments.duration(exp_multiple_dataframes.timeseries[1])

Experiments.starttime(exp_multiple_dataframes.timeseries[38])
Experiments.endtime(exp_multiple_dataframes.timeseries[38])
Experiments.duration(exp_multiple_dataframes.timeseries[38])

# Plotting
df = DataFrame(exp_multiple_dataframes)
# Unfortunately, with missing values, the plot is not correct, scatter works
plot(df[!, :timestamp], df[!, :A_1])
scatter(df.timestamp, df.A_1)
# compare to timeseries plotting, its working
plot(exp_multiple_dataframes.timeseries[2])
scatter(exp_multiple_dataframes.timeseries[2])

# Writing and reading experiments
df
Experiments.save(exp_multiple_dataframes, "data/test_export.csv")
df == df2 # Doesnt work because of missing data 
## maybe implement: exp2_multiple_dataframes = Experiments.load("data/test_export.csv")
exp2_multiple_dataframes = Experiments.Experiment(df2; name = "test_experiment_from_csv", timecol = :timestamp)
df3 = DataFrame(exp2_multiple_dataframes) # true
df3 == df2 # This should in principle be also true

# Nice Timeseries
ts = exp_multiple_dataframes.timeseries[11]
colnames(ts)
meta(ts)

# addressing values based on conditions
exp_multiple_dataframes.timeseries[14][exp_multiple_dataframes.timeseries[14].>0.0]
[exp_multiple_dataframes.timeseries[14].>0.0]

scatter(ts)
scatter(diff(ts))

timestamp(ts)

# maybe a function for adding differentials to a timeseries?
merge(ts, diff(ts), method = :outer, colnames = [colnames(ts)[1], :diff])

using Measurements
# This works also for TimeSeries
ts2 = TimeArray(timestamp(ts), values(ts) .± 0.1, colnames(ts))
merge(ts2, diff(ts2), method = :outer, colnames = [colnames(ts2)[1], :diff])

datetimes = [DateTime(1,1,1,1,1,1), DateTime(1,1,1,1,1,2), DateTime(1,1,1,1,1,3)]
data = [1.0, 2.0, 3.0].±0.1
test_constr = Experiments.timeseries(:test, datetimes, data, data.+1, data.-1)
scatter(test_constr)

exp_multiple_dataframes
ts_all = Experiments.timeseries(exp_multiple_dataframes)
df_all = DataFrame(exp_multiple_dataframes)
scatter(df_all.timestamp, df_all.OD)
scatter(ts_all.OD)
colnames(ts_all)

df_all[!,1] == timestamp(ts_all)