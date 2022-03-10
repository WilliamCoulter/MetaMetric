function wrapper_startupFcn(app)
%% This is called at startup.
% Roles
% 1) Setup initial display of axes and plots, like their limits
% 2) Assign default values to parameters like the wavelength we interpolate
% to
% 3) Generate UIConstraint Table
%% Load previous session's output folder
% try
%     loadMyDefaults(app);
% catch ME
%     report = getReport(ME);
%     uialert(app.UIFigure, report, 'Error Message', 'Interpreter','html')
% end

%% Specify wavelength vector the program works with
app.wlVecProgram = [];
% app.wlIntProgram = 
app.wlVecProgram(:,1) = 380:5:780;

%% Create dummy struct
dummyStruct = channelPercentsToSPDNestedStruct(ones(401,1));
fn = fieldnames(dummyStruct);

for fnIdx = 1:numel(fn)
    if ~isstruct(dummyStruct.(fn{fnIdx})) %check that first layer is all struct
        error("You need to have the first layer of the spd structure that..." + ...
            "has all of the metrics to be structures themselves");
    end
    [dummyStruct.(fn{fnIdx})] = removeNonScalarFields(dummyStruct.(fn{fnIdx}) );
end
app.dummyStruct = dummyStruct;
%% Get list of all possible metrics to consider
% These are all the scalar, non-struct fields returned via channelPercentsToSPDNestedStruct
app.allPossibleMetrics = getAllPossibleMetrics(app);
%% Make empty ui constriant table
makeUIConstraintTable(app,app.allPossibleMetrics);
% Make a table of ALL the constraints. When a checked node changes, the 
app.UITable_Constraints_History = app.UITable_Constraints.Data; 
app.UITable_Constraints_History.Properties.RowNames = app.UITable_Constraints_History.Metric; %give it row names to make indexing easier
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

%% Create The UITree
makeUITree_Constraints(app);
%% Set options for Optimization Goal Drop Downs
app.DropDown_MetricGoal.Items = app.allPossibleMetrics;
app.DropDown_MaxOrMinGoal.Items = {'Maximize','Minimize'};
%% Set default max iterations
app.EditField_MaxIterations.Value = 500;

%%
end

