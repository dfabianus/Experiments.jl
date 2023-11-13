# Experiments

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://dfabianus.github.io/Experiments.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://dfabianus.github.io/Experiments.jl/dev/)
[![Build Status](https://github.com/dfabianus/Experiments.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/dfabianus/Experiments.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Build Status](https://app.travis-ci.com/dfabianus/Experiments.jl.svg?branch=master)](https://app.travis-ci.com/dfabianus/Experiments.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/hfqbg7qfmx0edwip?svg=true)](https://ci.appveyor.com/project/dfabianus/experiments-jl)
[![Coverage](https://codecov.io/gh/dfabianus/Experiments.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/dfabianus/Experiments.jl)

-- Still in early development --

When collecting time series experimental data, the frequency and completeness of the single measurements often differs a lot. Different measurements are usually not all taken at exactly the same time and in the same frequence making it complicated to handle them in one single DataFrame. Subsequent data analysis and calculation of additional variables then requires to handle the varying quality and quantity of the data through interpolation and other measures.

This package builts on top of [TimeSeries.jl](https://github.com/JuliaStats/TimeSeries.jl) and [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) .
