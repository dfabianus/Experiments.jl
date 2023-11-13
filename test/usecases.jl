using Revise
using Experiments
using TimeSeries
using Plots
using Dates
using CSV 
using DataFrames
using Interpolations

# First, creating some measurements from fermentations
df_offline = CSV.read("data/offline.csv", DataFrame)
df_online = CSV.read("data/online.csv", DataFrame)

df_offline.datetime = DateTime(2018,1,1,0,0,0) .+ Experiments.hours2duration.(df_offline.time)
df_online.datetime = DateTime(2018,1,1,0,0,0) .+ Experiments.hours2duration.(df_online.time)

exp = Experiments.Experiment(df_offline, df_online; name="Fermentation 1")

# Getting some information about the experiment
println("Experiment name: ", exp.id)
println("Experiment start: ", Experiments.starttime(exp))
println("Experiment end: ", Experiments.endtime(exp))
OD = Experiments.timeseries(exp, :OD)
println("OD start: ", Experiments.starttime(OD))
println("OD end: ", Experiments.endtime(OD))
pO2 = Experiments.timeseries(exp, :p_O2)
OD_DCW_pO2 = Experiments.timeseries(exp, :OD, :DCW, :p_O2)

# Clone the first experiment to get another one 
df_offline.datetime = Experiments.starttime(exp) .+ Experiments.hours2duration.(df_offline.time) .+ Dates.Day(2)
df_online.datetime = Experiments.starttime(exp) .+ Experiments.hours2duration.(df_online.time) .+ Dates.Day(2)
exp2 = Experiments.Experiment(df_offline, df_online; name="Fermentation 2")

# stack both experiment in a vector
experiments = [exp, exp2]
df_both = Experiments.DataFrame(experiments)
scatter(df_both.time, df_both.OD, group=df_both.id, xlabel="Time", ylabel="OD", legend=:topleft, alpha = 0.8)
scatter(df_both.timestamp, df_both.OD, group=df_both.id, xlabel="Time", ylabel="OD", legend=:topleft, alpha = 0.8)
scatter(df_both.time, df_both.q_S_meas_DCW, group=df_both.id, xlabel="Time", ylabel="q_S", legend=:topleft, alpha = 0.8)
size(ts_both)

# Calculate some differences using the calculator functionalities
exp = Experiments.Experiment(df_offline, df_online; name="Fermentation 1")
OD_diff = Experiments.diff(exp, :OD)
OD_diff = Experiments.diff(exp, :OD, :DCW, :p_O2)
Experiments.calc!(exp, Experiments.diff, :OD, :DCW, :p_O2)
ts = Experiments.timeseries(exp, :p_O2_diff)
plot(ts)

# The same works for a vector of experiments
experiments
Experiments.calc!(experiments, Experiments.diff, :OD, :DCW, :p_O2)
experiments

# interpolation
ts = Experiments.timeseries(exp, :OD)
lin = linear_interpolation(Experiments.timestamp2hours(ts), vec(values(ts)), extrapolation_bc=Line())
plot([0:0.1:37], lin.([0:0.1:37]), label="interpolated")
scatter!(Experiments.timestamp2hours(ts), vec(values(ts)), label="original")
OD_2 = Experiments.interpolate(ts, pO2)
meta(OD_2)
plot(values(pO2),values(OD_2))
plot!(pO2)

# calculator std library
colnames(Experiments.timeseries(exp))
Experiments.calc!(exp, Experiments.x_OGin, :F_AIR, :F_O2; name = :x_OGin_newcalc)
xOGin = Experiments.x_OGin(exp, :F_AIR, :F_O2)
Experiments.calc!(exp, Experiments.x_CGin, :F_AIR, :F_O2; name = :x_CGin_newcalc)
Experiments.calc!(exp, Experiments.INERT, :x_OGin, :x_CGin, :x_O2, :x_CO2; name = :INERT)
Experiments.calc!(exp, Experiments.diff_kalman, :m_L, :m_B, :m_R)
Experiments.calc!(exp, Experiments.diff, :m_L, :m_B, :m_R)
plot(Experiments.timeseries(exp, :m_R_diff) ./ diff(Experiments.timeseries(exp, :time).time_1))
plot!(Experiments.timeseries(exp, :m_R_diff_kalman), linewidth=3)
Experiments.calc!(exp, Experiments.volume_flow, :m_R_diff_kalman) 
Experiments.volume_flow(exp, :m_R_diff_kalman)
plot(Experiments.timeseries(exp, :volume_flow))
Experiments.calc!(exp, Experiments.integral, :m_R_diff_kalman) 

plot(Experiments.timeseries(exp, :m_R_diff_kalman_integral))
plot!(Experiments.timeseries(exp, :m_R))

Experiments.calc!(exp, Experiments.calc_K2S1, :Q_S, :Q_CO2, :Q_O2, :V_L; x0 = [0.45,30.0,0.0,0.0]) 
plot(Experiments.timeseries(exp, :K2S1_mX))
plot!(Experiments.timeseries(exp, :K2S1_mS))
scatter!(Experiments.timeseries(exp, :c_S) .* Experiments.timeseries(exp, :V_L))
scatter!(Experiments.timeseries(exp, :DCW) .* Experiments.timeseries(exp, :V_L))