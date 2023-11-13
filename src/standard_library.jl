# Some standard calculators
function diff(experiment::Experiment, names::Symbol...)
    ts_vec = [Experiments.timeseries(experiment, name) for name in names]
    ts_diff = [Experiments.timeseries(TimeSeries.diff(ts), Symbol(name, :_diff)) for (name,ts) in zip(names,ts_vec)]
    return ts_diff
end

"x_OGin(F_AIR,F_O2;x_OAIR=0.2094) = (F_AIR.*x_OAIR+F_O2)./(F_AIR+F_O2)"
function x_OGin(experiment::Experiment, F_AIR::Symbol, F_O2::Symbol; x_OAIR::AbstractFloat=0.2094, name::Symbol=:x_OGin)
    ts_F_AIR = Experiments.timeseries(experiment, F_AIR)
    ts_F_O2 = Experiments.timeseries(experiment, F_O2)
    ts_x_OGin = (ts_F_AIR .* x_OAIR .+ ts_F_O2) ./ (ts_F_AIR .+ ts_F_O2)
    return [Experiments.timeseries(ts_x_OGin, name)]
end

"x_CGin(F_AIR,F_O2;x_CAIR=0.0004) = (F_AIR.*x_CAIR)./(F_AIR+F_O2)"
function x_CGin(experiment::Experiment, F_AIR::Symbol, F_O2::Symbol; x_CAIR::AbstractFloat=0.0004, name::Symbol=:x_CGin)
    ts_F_AIR = Experiments.timeseries(experiment, F_AIR)
    ts_F_O2 = Experiments.timeseries(experiment, F_O2)
    ts_x_CGin = (ts_F_AIR .* x_CAIR) ./ (ts_F_AIR .+ ts_F_O2)
    return [Experiments.timeseries(ts_x_CGin, name)]
end

"INERT(x_OGin,x_CGin,x_O2,x_CO2;EXH2O=EXH2O()) = (1 .-x_OGin.-x_CGin)./(1 .-x_O2.-x_CO2.-EXH2O)"
function INERT(experiment::Experiment, x_OGin::Symbol, x_CGin::Symbol, x_O2::Symbol, x_CO2::Symbol; name::Symbol=:INERT)
    ts_x_OGin = Experiments.timeseries(experiment, x_OGin)
    ts_x_CGin = Experiments.timeseries(experiment, x_CGin)
    ts_x_O2 = Experiments.timeseries(experiment, x_O2)
    ts_x_CO2 = Experiments.timeseries(experiment, x_CO2)
    EXH2O(x_WET=0.2094;x_OAIR=0.2094)=1-(x_WET./x_OAIR)
    ts_INERT = (1 .-ts_x_OGin.-ts_x_CGin)./(1 .-ts_x_O2.-ts_x_CO2.-EXH2O())
    return [Experiments.timeseries(ts_INERT, name)]
end

"Q_CO2(F_AIR,F_O2,x_CO2,x_CGin,INERT;V_M=22.414) = (F_AIR+F_O2)./V_M.*(x_CO2.*INERT-x_CGin)" # mol/h
function Q_CO2(experiment::Experiment, F_AIR::Symbol, F_O2::Symbol, x_CO2::Symbol, x_CGin::Symbol, INERT::Symbol; V_M::AbstractFloat=22.414, name::Symbol=:Q_CO2)
    ts_F_AIR = Experiments.timeseries(experiment, F_AIR)
    ts_F_O2 = Experiments.timeseries(experiment, F_O2)
    ts_x_CO2 = Experiments.timeseries(experiment, x_CO2)
    ts_x_CGin = Experiments.timeseries(experiment, x_CGin)
    ts_INERT = Experiments.timeseries(experiment, INERT)
    ts_Q_CO2 = (ts_F_AIR .+ ts_F_O2) ./ V_M .* (ts_x_CO2 .* ts_INERT .- ts_x_CGin)
    return [Experiments.timeseries(ts_Q_CO2, name)]
end

"Q_O2(F_AIR,F_O2,x_O2,x_OGin,INERT;V_M=22.414) = (F_AIR+F_O2)./V_M.*(x_O2.*INERT-x_OGin)" # mol/h
function Q_O2(experiment::Experiment, F_AIR::Symbol, F_O2::Symbol, x_O2::Symbol, x_OGin::Symbol, INERT::Symbol; V_M::AbstractFloat=22.414, name::Symbol=:Q_O2)
    ts_F_AIR = Experiments.timeseries(experiment, F_AIR)
    ts_F_O2 = Experiments.timeseries(experiment, F_O2)
    ts_x_O2 = Experiments.timeseries(experiment, x_O2)
    ts_x_OGin = Experiments.timeseries(experiment, x_OGin)
    ts_INERT = Experiments.timeseries(experiment, INERT)
    ts_Q_O2 = (ts_F_AIR .+ ts_F_O2) ./ V_M .* (ts_x_O2 .* ts_INERT .- ts_x_OGin)
    return [Experiments.timeseries(ts_Q_O2, name)]
end

"Q_S(F_R;c_SR=400,M_S=30) = -F_R .* c_SR ./ M_S"
function Q_S(experiment::Experiment, F_R::Symbol; c_SR::AbstractFloat=400, M_S::AbstractFloat=30, name::Symbol=:Q_S)
    ts_F_R = Experiments.timeseries(experiment, F_R)
    ts_Q_S = -ts_F_R .* c_SR ./ M_S
    return [Experiments.timeseries(ts_Q_S, name)]
end

"RQ(Q_CO2,Q_O2) = -Q_O2 ./ Q_CO2"
function RQ(experiment::Experiment, Q_CO2::Symbol, Q_O2::Symbol; name::Symbol=:RQ)
    ts_Q_CO2 = Experiments.timeseries(experiment, Q_CO2)
    ts_Q_O2 = Experiments.timeseries(experiment, Q_O2)
    ts_RQ = -ts_Q_O2 ./ ts_Q_CO2
    return [Experiments.timeseries(ts_RQ, name)]
end

function kalman(zₖ, xₖ = [0.0 0.0]', Pₖ = [10 0; 0 10]; Δt = 1.0, Q = [0 0; 0 0.01], R = 0.04)
    A = [1.0 Δt; 0.0 1.0]
    C = [1.0 0.0]
    # State prediction
    xₖ = A * xₖ
    Pₖ = A * Pₖ * A' + Q
    # Kalman Gain
    K = Pₖ * C'* inv(C * Pₖ * C' .+ R)
    # Output / estimate
    x_hat = xₖ .+ K * (zₖ .- C * xₖ)
    # Covariance error
    P_hat = Pₖ .- K * C * Pₖ
    return x_hat, P_hat
end
function kalman_vec(t, z, xₖ = [0 0]', Pₖ = [10 0; 0 10]; Q = [0 0; 0 0.01], R = 0.04) 
    if length(z) < 2
        return kalman(z, xₖ, Pₖ; Δt=t, Q=Q, R=R)
    else
        x = xₖ
        P = vec(Pₖ)
        Δt = Base.diff(t,dims=1)
        for (Δtₖ,zₖ) in zip(Δt, z[2:end])
            xₖ, Pₖ = kalman(zₖ, xₖ, Pₖ; Δt=Δtₖ, Q=Q, R=R)
            x = [x xₖ]
            P = [P vec(Pₖ)]
        end
        return x,P
    end
end
function kalman_state_derivative(t, z, xₖ = [0 0]', Pₖ = [10 0; 0 10]; Q = [0 0; 0 0.01], R = 0.04) 
    x,P = kalman_vec(t, z, xₖ, Pₖ; Q = Q, R = R) 
    state = x[1,:]
    derivative = x[2,:]
    return state, derivative, x, P
end
function kalman_flow_rate(t, z, density = 1000, init_vol = 1.5, xₖ = [0 0]', Pₖ = [10 0; 0 10]; Q = [0 0; 0 0.01], R = 0.04) 
    state, derivative, x, P = kalman_state_derivative(t, z, xₖ, Pₖ; Q = Q, R = R) 
    return (
        volume = state ./ density .+ init_vol, 
        flow_rate = -derivative ./ density,
        x = x,
        P = P) 
end

function diff_kalman(experiment::Experiment, names::Symbol...; xₖ = [0 0]', Pₖ = [10 0; 0 10], Q = [0 0; 0 0.01], R = 0.04)
    ts_vec = [Experiments.timeseries(experiment, name) for name in names]
    t_vec = timestamp2hours.(ts_vec)
    z_vec = vec.(values.(ts_vec))
    d_vec = [kalman_state_derivative(t, z, xₖ, Pₖ; Q = Q, R = R)[2] for (t,z) in zip(t_vec, z_vec)]
    ts_diff = [Experiments.timeseries(Symbol(name, :_diff_kalman), t, d) for (name,t,d) in zip(names,timestamp.(ts_vec),d_vec)]
    return ts_diff
end

function volume_flow(experiment::Experiment, massflow::Symbol ; density::Real=1000, name::Symbol=:volume_flow)
    ts_massflow = Experiments.timeseries(experiment, massflow)
    ts_volume_flow = -ts_massflow ./ density
    return [Experiments.timeseries(ts_volume_flow, name)]
end