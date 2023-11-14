# Experiments

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://dfabianus.github.io/Experiments.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://dfabianus.github.io/Experiments.jl/dev/)
[![Build Status](https://github.com/dfabianus/Experiments.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/dfabianus/Experiments.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Build Status](https://app.travis-ci.com/dfabianus/Experiments.jl.svg?branch=master)](https://app.travis-ci.com/dfabianus/Experiments.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/hfqbg7qfmx0edwip?svg=true)](https://ci.appveyor.com/project/dfabianus/experiments-jl)
[![Coverage](https://codecov.io/gh/dfabianus/Experiments.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/dfabianus/Experiments.jl)

-- **Still in early development** --

When collecting time series experimental data, the frequency and completeness of the single measurements often differs a lot. Different measurements are usually not all taken at exactly the same time and in the same frequence making it complicated to handle them in one single DataFrame. Subsequent data analysis and calculation of additional variables then requires to handle the varying quality and quantity of the data through interpolation and other measures.

This package builts on top of [TimeSeries.jl](https://github.com/JuliaStats/TimeSeries.jl) and [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) and should provide following features.
- Stroing of multiple `TimeSeries` with different timestamps in an `Experiment` object.
- Apply calculation functions to infer new `TimeSeries` based on the available ones.
- The package handles interpolation between the measurement `TimeSeries` automatically.
- Process parameters are also stored as `TimeSeries` of length 2, which are the start and end timepoints of the experiment.
- You can combine several `Experiment` objects into an array of Experiments allowing for calculations based on multiple experiments.
- An interface for `DataFrames.jl` enables DataFrame based operations on the data.

## Quckstart tutorial
```julia
using Experiments
using Dates

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
```
We created two isntances of type `TimeArray` from `TimeSeries.jl` by using the `timeseries` function.
