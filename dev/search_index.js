var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = Experiments","category":"page"},{"location":"#Experiments","page":"Home","title":"Experiments","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for Experiments.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Experiments]","category":"page"},{"location":"#Experiments.INERT-Tuple{Experiment, Vararg{Symbol, 4}}","page":"Home","title":"Experiments.INERT","text":"INERT(xOGin,xCGin,xO2,xCO2;EXH2O=EXH2O()) = (1 .-xOGin.-xCGin)./(1 .-xO2.-xCO2.-EXH2O)\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.Q_CO2-Tuple{Experiment, Vararg{Symbol, 5}}","page":"Home","title":"Experiments.Q_CO2","text":"QCO2(FAIR,FO2,xCO2,xCGin,INERT;VM=22.414) = (FAIR+FO2)./VM.*(xCO2.*INERT-x_CGin)\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.Q_O2-Tuple{Experiment, Vararg{Symbol, 5}}","page":"Home","title":"Experiments.Q_O2","text":"QO2(FAIR,FO2,xO2,xOGin,INERT;VM=22.414) = (FAIR+FO2)./VM.*(xO2.*INERT-x_OGin)\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.Q_S-Tuple{Experiment, Symbol}","page":"Home","title":"Experiments.Q_S","text":"QS(FR;cSR=400,MS=30) = -FR .* cSR ./ M_S\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.RQ-Tuple{Experiment, Symbol, Symbol}","page":"Home","title":"Experiments.RQ","text":"RQ(QCO2,QO2) = -QO2 ./ QCO2\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.duration-Tuple{Experiment}","page":"Home","title":"Experiments.duration","text":"duration(experiment::Experiment)\n\nGet the duration of an experiment from all included timeseries.\n\nExamples\n\njulia> duration(experiment)\n1 day, 10 hours, 9 minutes, 55 seconds\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.duration-Tuple{TimeSeries.TimeArray}","page":"Home","title":"Experiments.duration","text":"duration(timeseries::TimeArray)\n\nGet the duration of a timeseries.\n\nExamples\n\njulia> duration(timeseries)\n1 day, 10 hours, 9 minutes, 55 seconds\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.endtime-Tuple{Experiment}","page":"Home","title":"Experiments.endtime","text":"endtime(experiment::Experiment)\n\nGet the end datetime of an experiment from the maximum of all included timeseries.\n\nExamples\n\njulia> endtime(experiment)\n2019-01-02T10:10:00\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.endtime-Tuple{TimeSeries.TimeArray}","page":"Home","title":"Experiments.endtime","text":"endtime(timeseries::TimeArray)\n\nGet the end datetime of a timeseries.\n\nExamples\n\njulia> endtime(timeseries)\n2019-01-02T10:10:00\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.starttime-Tuple{Experiment}","page":"Home","title":"Experiments.starttime","text":"starttime(experiment::Experiment)\n\nGet the start datetime of an experiment from the minimum of all included timeseries.\n\nExamples\n\njulia> starttime(experiment)\n2019-01-01T00:00:00\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.starttime-Tuple{TimeSeries.TimeArray}","page":"Home","title":"Experiments.starttime","text":"starttime(timeseries::TimeArray)\n\nGet the start datetime of a timeseries.\n\nExamples\n\njulia> starttime(timeseries)\n2019-01-01T00:00:00\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.x_CGin-Tuple{Experiment, Symbol, Symbol}","page":"Home","title":"Experiments.x_CGin","text":"xCGin(FAIR,FO2;xCAIR=0.0004) = (FAIR.*xCAIR)./(FAIR+FO2)\n\n\n\n\n\n","category":"method"},{"location":"#Experiments.x_OGin-Tuple{Experiment, Symbol, Symbol}","page":"Home","title":"Experiments.x_OGin","text":"xOGin(FAIR,FO2;xOAIR=0.2094) = (FAIR.*xOAIR+FO2)./(FAIR+F_O2)\n\n\n\n\n\n","category":"method"}]
}