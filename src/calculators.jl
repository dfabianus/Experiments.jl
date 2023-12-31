"""
Calculator functions must take an experiment as the first input and can accept additional arguments.
They must return a tuple of timeseries.
"""
#todo: check if the timeseries are already in the experiment
function calc!(experiment::Experiment, calculator::Function, args...; kwargs...)
    ts_vec = calculator(experiment, args...; kwargs...)
    names = [colnames(ts)[1] for ts in ts_vec]
    for (name,ts) in zip(names, ts_vec)
        if name in colnames(Experiments.timeseries(experiment))
            println("Timeseries with the name $name already exists in the experiment.")
        else
            add_timeseries!(experiment, ts)
        end
    end
end 

function calc!(experiments::Vector{Experiment}, calculator::Function, args...; kwargs...)
    for exp in experiments
        calc!(exp, calculator, args...; kwargs...)
    end
end
