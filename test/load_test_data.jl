using Experiments

using CSV 
using DataFrames
using TimeSeries
using Dates

function load_example_data(;repl=false)
    if repl
        df_offline = CSV.read("data/offline.csv", DataFrame)
        df_online = CSV.read("data/online.csv", DataFrame)
    else
        df_offline = CSV.read("../data/offline.csv", DataFrame)
        df_online = CSV.read("../data/online.csv", DataFrame)
    end
    start_time = DateTime(2018,1,1,0,0,0)
    df_offline.datetime = start_time .+ Dates.Second(1.0) .* Int64.(round.(3600 .* df_offline.time, digits=0))
    df_online.datetime = start_time .+ Dates.Second(1.0) .* Int64.(round.(3600 .* df_online.time, digits=0))
    return df_offline, df_online
end

function create_experiments(;repl=false)
    df_offline, df_online = load_example_data(repl=repl)
    exp_offline_dataframe = Experiments.Experiment(df_offline; name="test_1")
    exp_online_dataframe = Experiments.Experiment(df_online; name="test_2")
    exp_multiple_dataframes = Experiments.Experiment(df_offline, df_online; name="test_3")
    return exp_offline_dataframe, exp_online_dataframe, exp_multiple_dataframes
end