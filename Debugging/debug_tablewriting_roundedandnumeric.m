clc;clear;
load('debugTableWriting.mat')

% myTableOneCol = [iterationUsedTable, myUiFunTable, solutionTable,...
%     initialGuessTable, spdTable]
% myTable = [iterationUsedTable, myUiFunTable, solutionTable,...
%     initialGuessTable, spdTable];
% myCellOneCol = table2cell(myTable)'
% array2table(myCellOneCol,'RowNames',myTable.Properties.VariableNames)

myOptimTable_proper = [iterationUsedTable, myUiFunTable, solutionTable,...
    initialGuessTable, spdTable];
myOptimTable_proper{:,vartype('numeric') } = round(myOptimTable_proper{:,vartype('numeric')},3,'significant')
%% Make each run correspond to column instead of a row
% SPDs are usually written column-wise
myOptimResultsCellArray = table2cell(myOptimTable_proper)'; %make it cell array column vec
myOptimResultsTable = array2table(myOptimResultsCellArray,...
    'RowNames',myOptimTable_proper.Properties.VariableNames)

writetable(myOptimResultsTable, 'test123.xls','WriteRowNames',true)

%%
% t = myOptimTable_proper
% t(:,vartype('numeric')) = round(t(:,vartype('numeric'),3, 'significant') )


