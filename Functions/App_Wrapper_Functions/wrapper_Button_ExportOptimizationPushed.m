function wrapper_Button_ExportOptimizationPushed(app,event)
%% Create set of tables


myUiFunTable = struct2table(app.myBestOptimResult.myUiFun,'AsArray',true);
if myUiFunTable.minOrMax == -1
    myUiFunTable.minOrMax = "Maximize";
elseif myUiFunTable.minOrMax == 1
    myUiFunTable.minOrMax = "Minimize";
else
    msgbox("Unknown goal type (min or max) when writing myUiFun to table",'Error','error');
end
myUiFunTable = splitvars(myUiFunTable);


% SPD Watts/nm
spdTable = splitvars(table(app.myBestSpdMix.Power.s'));
spdTable.Properties.VariableNames = cellstr("Wavelength(nm): " +...
    string(app.wlVecProgram) );
% The mixture of channels used for solution
solutionTable = splitvars(table( round(app.myBestOptimResult.Solution,2,'decimals')' ));
%             solutionTable.Properties.VariableNames = cellstr( "Channel "...
%                 + string( 1:numel(app.myBestOptimResult.metrics.Solution) ) + " %" );
solutionTable.Properties.VariableNames = app.UITable_ImportedFile.ColumnName(app.channelSelectedTF);
% The initial guess percent for each channel
initialGuessTable = splitvars(table(app.myBestOptimResult.spdPercents0') );
%             initialGuessTable.Properties.VariableNames = cellstr( "Channel " +...
%                 string( 1:numel(app.myBestOptimResult.metrics.SpdPercents0)) + " Initial Guess %") ;
initialGuessTable.Properties.VariableNames = app.UITable_ImportedFile.ColumnName(app.channelSelectedTF) + " Initial Guess %";
% How many iterations were used for optimization run
iterationUsedTable = table(app.myBestOptimResult.optimizerOutput.iterations);
iterationUsedTable.Properties.VariableNames = "Iterations Used";
%% We have all of our tables as 1 row and many variables. Merge them
myTableOneCol = [iterationUsedTable, myUiFunTable, solutionTable,...
    initialGuessTable, spdTable];
%% Make each run correspond to column instead of a row
% SPDs are usually written column-wise
myTableOneCol = rows2vars(myTableOneCol);
% By default it make variable names a column on its own. Make
% and assign rownames of table to the variable names then
% delete the unused column of variable names now that they are
% row namesmyTableOneCol
myTableOneCol.Properties.RowNames= myTableOneCol.OriginalVariableNames;
myTableOneCol.OriginalVariableNames = [];
%% Get optimization settings to put into a third sheet
myProps = properties(app.myBestOptimResult.myOptimOptions);
for prop = 1:numel(myProps)
    optionStruct.(myProps{prop}) = app.myBestOptimResult.myOptimOptions.(myProps{prop});
end
optionTable = splitvars( struct2table(optionStruct,'asarray',true))  ;
optionTable.TypicalX = [];
typicalXTable= splitvars(table(app.myBestOptimResult.myOptimOptions.TypicalX') );
typicalXTable.Properties.VariableNames = "Typical X, CH " + string(1:numel(app.myBestOptimResult.myOptimOptions.TypicalX) );

optionTable = rows2vars( [optionTable, typicalXTable] ) ;
%% Ask user where to save
% This code is very similar to the one used to import the data
exportFileTypes = {'*.xls;*.xlsx;*.xlsb;*.xlsm;*.csv',...
    'SPD Files (*.xls,*.xlsx,*.xlsb,*.xlsm,*.csv)'};
[outputFileName, outputPathName] = uiputfile(exportFileTypes);
app.outputSavePath = fullfile(outputPathName,outputFileName);
%% refocus back to app
%https://www.mathworks.com/matlabcentral/answers/296305-appdesigner-window-ends-up-in-background-after-uigetfile
figure(app.UIFigure);
%% If file exists, load existing runs as table and append this run to it and resave
% Note that we output multiple sheets.

%write out merged table
writetable(app.metricResultsTable,...
    app.outputSavePath, 'Sheet',1);
myTableOneCol.Properties.VariableNames = "Best SPD";
writetable(myTableOneCol,...
    app.outputSavePath, 'Sheet',2,'WriteRowNames',true,...
    'WriteVariableNames',true);

writetable(app.myBestOptimResult.myConstraintsTable,...
    app.outputSavePath, 'Sheet',3);

writetable(optionTable,...
    app.outputSavePath, 'Sheet',4);


end

