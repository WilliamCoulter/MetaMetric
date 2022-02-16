function metricResultsStructToTable(app)
%METRICRESULTSSTRUCTTOTABLE Summary of this function goes here
%   Detailed explanation goes here
% trim structure to get metrics in a column
% I practiced this in "practiceSaveResultsToFile.mlx"
% List out which metrics to delete.
metricDeleteList = {'sref','stest','s','rfBins','hsBins','csBins',...
    'gref','gtest','SpdPercents0','Solution','wl'};
% Create scalar struct (size 1) that will be output to file by
% deleting fields listed above
myStructForTable = rmfield(app.myOptimResults.metrics,metricDeleteList);

app.metricResultsTable = struct2table(myStructForTable,'AsArray',true);
app.metricResultsTable = rows2vars(app.metricResultsTable);
app.metricResultsTable.Properties.VariableNames = ["Metrics", "Value of Optimized SPD"];
end

