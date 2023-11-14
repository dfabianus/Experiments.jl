using Experiments
using Dates
using DataFrames

# Define the first example timeseries
t1 = DateTime(2018,1,1,0,0,0) .+ Experiments.hours2duration.(0:0.1:15)
v1 = sin.(0:0.1:15)
ts1 = timeseries(:measurement1, t1, v1)
# 151×1 TimeSeries.TimeArray{Float64, 2, DateTime, Matrix{Float64}} 2018-01-01T00:00:00 to 2018-01-01T15:00:00

# Define a second example timeseries
t2 = DateTime(2018,1,1,1,0,0) .+ Experiments.hours2duration.(0:0.25:15)
v2 = cos.(0:0.25:15)
ts2 = timeseries(:measurement2, t2, v2)
# 61×1 TimeSeries.TimeArray{Float64, 2, DateTime, Matrix{Float64}} 2018-01-01T01:00:00 to 2018-01-01T16:00:00


using Plots
p = scatter(ts1)
scatter!(ts2)
savefig(p, "docs/assets/quickstart_1.svg")

# Create an experiment with both timeseries

exp1 = Experiments.Experiment(DataFrame(ts1), DataFrame(ts2); name="Experiment1", timecol = :timestamp)
exp1 = Experiment("Experiment1", ts1, ts2)

timeseries(exp1)
DataFrame(timeseries(exp1))
DataFrame(exp1)

timeseries(exp1, :measurement1)
timeseries(exp1, :measurement2)