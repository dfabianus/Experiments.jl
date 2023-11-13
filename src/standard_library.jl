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
function Q_S(experiment::Experiment, F_R::Symbol; c_SR::AbstractFloat=400.0, M_S::AbstractFloat=30.0, name::Symbol=:Q_S)
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

function integral(experiment::Experiment, names::Symbol...)
    ts_vec = [Experiments.timeseries(experiment, name) for name in names]
    t_vec = timestamp2hours.(ts_vec)
    tdiff = Base.diff.(t_vec)
    z_vec = vec.(values.(ts_vec))
    d_vec = [cumsum(z) for z in z_vec]
    int_vec = [d[2:end] .* td for (d,td) in zip(d_vec, tdiff)]
    ts_diff = [Experiments.timeseries(Symbol(name, :_integral), t[2:end], d) for (name,t,d) in zip(names,timestamp.(ts_vec),int_vec)]
    return ts_diff
end

function K2S1(r, E, i_known, i_unknown)
    # Q is a vector of the supply rates and exhaust rates measured at the bioreactor
    # Units are mol/h
    sigma = Matrix{Float64}(LinearAlgebra.I, length(i_known), length(i_known))
    rm = r[i_known]
    Em = E[:,i_known]
    Ec = E[:,i_unknown]
    #Ec_star: Moore Penrose pseudo inverse of Ec
    Ec_star=(inv(Ec'*Ec))*Ec'
    # R: Redundancy matrix
    R=Em-Ec*Ec_star*Em
    # Rred: Reduced redundancy matrix (containing just the independent rows of R
    U,S,V=svd(R)
    Sconv=[1 0]
    C=Sconv*S
    K=C*S'*U'
    Rred=K*R
    # eps: residual vector
    eps = Rred * rm
    # P: Residual variance covariance matrix
    P = Rred * sigma *Rred'
    # Reconciliation of measured and calculated rates
    delta = (sigma*Rred'*inv(P) * Rred)* rm
    rm_best = rm-delta
    xc_best = -Ec_star*Em*rm_best
    # Sum of weighted squares of residuals
    h = eps' * inv(P) * eps
    # Calculate the function outputs
    return (r=vcat(xc_best, rm_best), h=h)
end

function K2S1m(x,p,t)
    i_known = [2,3,4]
    i_unknown = [1]
    M = [26.5, 30, 44, 32]
    E = [1 1 1 0;
         4.113 4 0 -4]
    c_S = x[2] ./ p.V_L(t)
    qS = p.qSmax(t) * c_S / (p.kS(t) + c_S)
    rS = -qS * x[1]
    # constructing Q and r in mol/h and g/h
    Q_mol = vcat(zeros(length(i_unknown)), [Q(t) for Q in p.Q_known])
    Q_g = Q_mol .* M
    r_g = vcat(zeros(length(i_unknown)), rS, Q_g[3:4])
    r_mol = r_g ./ M
    r_hat_mol, h = K2S1(r_mol, E, i_known, i_unknown)
    r_hat_g = r_hat_mol .* M
    # if x[1] < 7
    #     #r_hat[1] = -0.37 * r_hat[2]
    #     r_hat[1] = -0.45 * r_hat[2]
    # end
    
    #dx[:] = [Qᵢ+rᵢ for (Qᵢ,rᵢ) in zip(Q_g,r_hat_g)]
    return Q_g .+ r_hat_g, r_hat_g, h
end

function K2S1m_call!(dx,x,p,t)
    dx[:], _, _ = K2S1m(x,p,t)
end

function datafun(t,tx,x)
    x_int = Interpolations.linear_interpolation(tx, x, extrapolation_bc=Line())
    return x_int(t)
end

function calc_K2S1(tx, Q_S, Q_CO2, Q_O2, V_L, x0; tInd=24, qSmax_0=1.25, qSmax_1=0.24, kS_0=0.1)
    Q_known = [(t) -> datafun(t, tx, Q) for Q in [Q_S, Q_CO2, Q_O2]]
    V_Lf(t) = datafun(t, tx, V_L)
    tspan = (tx[1], tx[end])
    p = (Q_known = Q_known,
        V_L = V_Lf,
        qSmax = (t) -> t <= tInd ? qSmax_0 : qSmax_1,
        kS = (t) -> kS_0
        )
    prob = ODEProblem(K2S1m_call!,x0,tspan,p)
    sol = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)
    return sol
end

function calc_K2S1(experiment::Experiment, Q_S::Symbol, Q_CO2::Symbol, Q_O2::Symbol, V_L::Symbol; x0, tInd=24, qSmax_0=1.25, qSmax_1=0.24, kS_0=0.1)
    Q_S_ts = Experiments.timeseries(experiment, Q_S)
    Q_CO2_ts = Experiments.timeseries(experiment, Q_CO2)
    Q_O2_ts = Experiments.timeseries(experiment, Q_O2)
    V_L_ts = Experiments.timeseries(experiment, V_L)
    Q_vv = [vec(values(Q_S_ts)), vec(values(Q_CO2_ts)), vec(values(Q_O2_ts))]
    tx = timestamp2hours(Q_S_ts)
    Q_known = [(t) -> datafun(t, tx, Q) for Q in Q_vv]
    V_Lf(t) = datafun(t, tx, vec(values(V_L_ts)))
    tspan = (tx[1], tx[end])
    p = (Q_known = Q_known,
        V_L = V_Lf,
        qSmax = (t) -> t <= tInd ? qSmax_0 : qSmax_1,
        kS = (t) -> kS_0
        )
    prob = ODEProblem(K2S1m_call!,x0,tspan,p)
    sol = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)
    df = DataFrame(sol)
    ts_X = Experiments.timeseries(:K2S1_mX, Experiments.starttime(Q_S_ts) .+ Experiments.hours2duration.(df.timestamp), df.value1)
    ts_S = Experiments.timeseries(:K2S1_mS, Experiments.starttime(Q_S_ts) .+ Experiments.hours2duration.(df.timestamp), df.value2)
    ts_CO2 = Experiments.timeseries(:K2S1_mCO2, Experiments.starttime(Q_S_ts) .+ Experiments.hours2duration.(df.timestamp), df.value3)
    ts_O2 = Experiments.timeseries(:K2S1_mO2, Experiments.starttime(Q_S_ts) .+ Experiments.hours2duration.(df.timestamp), df.value4)
    return [ts_X, ts_S, ts_CO2, ts_O2]
end