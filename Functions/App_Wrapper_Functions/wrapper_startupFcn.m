function wrapper_startupFcn(app)
%% debug
%% Load previous session's output folder
try
    app.loadMyDefaults;
catch
end
%% Specify wavelength vector the program works with
app.wlVecProgram = [];
app.wlVecProgram(:,1) = 380:1:780;
%%
hold(app.UIAxes_OptimSPD,'on');
title(app.UIAxes_OptimSPD, "Most Recent SPD");
xlabel(app.UIAxes_OptimSPD, "Wavelength (nm)");
ylabel(app.UIAxes_OptimSPD, "Rad Watt / nm");
%% UIAxes_ImportedSPDs defaults
hold(app.UIAxes_ImportedSPDs,'on');
app.UIAxes_ImportedSPDs.XLim = [380,780];
defXTick = app.UIAxes_ImportedSPDs.XTick;
app.UIAxes_ImportedSPDs.XTick = linspace(defXTick(1), defXTick(end), 2*numel(defXTick)-1 );%double ticks
% app.UIAxes_ImportedSPDs.XTick = (380:25:780);
grid(app.UIAxes_ImportedSPDs,'on')
%% Make Chromaticity Diagram
%This is just for the startup. In reality, it is deleted and
%remade each time the library is selected from import table
hold(app.UIAxes_ChromDiagram,'on');
plotChromDiagram(2,app.UIAxes_ChromDiagram); %add a 2 deg chrom diagram to the axis handle
pbaspect(app.UIAxes_ChromDiagram,[1 1 1]);
%% Create Default Optimization Constraint Table
[app.MetricsEvaluated] = makeUIConstraintTable(app); %helper function. It also assigns app.MetricsEvaluated property
%% Set options for Optimization Goal Drop Downs
app.DropDown_MetricGoal.Items = app.MetricsEvaluated;
app.DropDown_MaxOrMinGoal.Items = {'Maximize','Minimize'};
%% Set default max iterations
app.EditField_MaxIterations.Value = 500;

%%
end

