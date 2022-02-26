function metricResultsStructToTable(app)
%METRICRESULTSSTRUCTTOTABLE Summary of this function goes here
%   Detailed explanation goes here
% trim structure to get metrics in a column
% I practiced this in "practiceSaveResultsToFile.mlx"
% List out which metrics to delete.
% metricDeleteList = {'sref','stest','s','rfBins','hsBins','csBins',...
% %     'gref','gtest','SpdPercents0','Solution','wl'};
% Create scalar struct (size 1) that will be output to file by
% deleting fields listed above
% categoryStruct=cell(1);
for idx = 1:numel(app.allPossibleMetrics)
%     idx;
    [fieldNamePath] = getStructPathFromNode(app.Tree_Constraints,app.allPossibleMetrics{idx} );
    metricVal{idx,1} = getfield(app.myBestSpdMix, fieldNamePath{:});

%     if idx~= 1 && numel(fieldNamePath) > width(categoryStruct)
%         nPad = abs(numel(fieldNamePath) - width(categoryStruct))
% 
%         categoryStruct = [categoryStruct, cell(height(categoryStruct), nPad)];
%     elseif idx~=1 && numel(fieldNamePath) < width(categoryStruct)
%         nPad = abs(numel(fieldNamePath) - width(categoryStruct))
% 
%         fieldNamePath = [fieldNamePath, cell(1,nPad)]
%     end
%     categoryStruct(idx,:) = [fieldNamePath]
%     if numel(fieldNamePath) < 3 %this is not general but it works for now
%         categoryStruct{idx,1} = fieldNamePath, []
end

t = array2table([app.allPossibleMetrics, metricVal]);
t.Properties.VariableNames = ["Metrics", "Value of Optimized SPD"];
metricsOfInterest = cellstr( [app.myUiFun.metric, {app.myUiCon.Metric} ]' );
moiRowId = find(ismember(t.Metrics, metricsOfInterest));
tmoi = [t(moiRowId,:)];
t(moiRowId,:) = [];
t = [tmoi; t];
% subTable
% sort them



%% Reorder to put optim at top and constraitns then rest

app.metricResultsTable = t;

end

