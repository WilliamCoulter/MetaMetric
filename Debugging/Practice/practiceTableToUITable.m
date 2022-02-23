clear;clc;
myF = uifigure;
% t =
uit = uitable(myF)
% uit.ColumnName = [];
%%
dummyStruct.field1 = 2;
dummyStruct.field2 = 3;
%% Get the fieldnames, which are the metrics. These are stored in app properties
MetricsEvaluated = fieldnames(dummyStruct);
%% Create columns based on the number of elements
% Set default constraints to none being used
UseTF         = false( numel(MetricsEvaluated),1);

%% Create a standard table
% use comma-separated variables as variablenames
myConstraintTableNames = ["Metric To Constrain.","Use This Metric At All?"];

constraints_Table = table(MetricsEvaluated, UseTF,...
    VariableNames=myConstraintTableNames);

uit.Data = constraints_Table

%%


myF = uifigure;
myT = uitable(myF);
% myT.ColumnName = [];
t = table(ones(5,1), VariableNames = "Variable 1");
myT.Data = t;
