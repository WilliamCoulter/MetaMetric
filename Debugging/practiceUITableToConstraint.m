clc
clear
load('C:\Users\Will\OneDrive\MyMatlab\MetaMetric\Debugging\dummyUITable.mat')

%% Ok, so I have myUiCon as a struct array with each index being a metric
% where the fields are the values and names and types of constraints. I now
% have a uiTable that I can pull from to make the constraint vectors c, ceq
uit = t;

t = uit.Data

%% Think through how to pull data from table
% How many rows in the constraint vectors c, ceq?
% Metric is used only if UseTF == true, and when it is true, there are at
% most 3 per metric for each of the three equality types.