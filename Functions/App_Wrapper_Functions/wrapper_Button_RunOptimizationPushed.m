function wrapper_Button_RunOptimizationPushed(app,event)
try
    %% On button push, access certain components' values
    app.HonorBoundsTF = app.CheckBox_HonorBounds.Value;
    % Make myUiFun structure
    app.myUiFun.myOptIterations = app.EditField_MaxIterations.Value; %Query edit field
    app.myUiFun.metric = string(app.DropDown_MetricGoal.Value); %Query dropdown selection
    %% Store search path of structure to get to the metric
    app.myUiFun.targetPath = getStructPathFromNode(app.Tree_Constraints,app.myUiFun.metric);
    % find which nested struct it is under
    
    %%
    switch app.DropDown_MaxOrMinGoal.Value %Convert from words to math. Minimizing the negative is maximizing
        case 'Maximize'
            app.myUiFun.minOrMax = -1;
        case 'Minimize'
            app.myUiFun.minOrMax = 1;
    end
    %% Make myUiCon struct from table
    checkedConstraintNodes = app.Tree_Constraints.CheckedNodes;
    constraintTags = {checkedConstraintNodes.Tag};
    app.myUiCon = table2struct(app.UITable_Constraints.Data);
    app.myUiCon = cell2struct(struct2cell(app.myUiCon),...
        {'Metric',...
        'LessThanTF','LessThanVal',...
        'EqualToTF','EqualToVal',...
        'GreaterThanTF','GreaterThanVal'});
    for idx = 1:numel(app.myUiCon)
        app.myUiCon(idx).targetPath = getStructPathFromNode(app.Tree_Constraints,app.myUiCon(idx).Metric);
    end
    %% Go through nRuns
    bestFVal = inf; %best fval is infinity, so anything is better
    app.myBestOptimResult = []; %initialize to empty
    for idxRun = 1:app.EditField_NRuns.Value
        %% Make a random guess
        app.InitialGuessChannelPercents_Prop = 25+75*rand(sum(app.channelSelectedTF),1);
        %% Run optimization
        [SpdMixOut(idxRun), myOptimOptions,fVal(idxRun), optimizerOutput(idxRun),channelSolution] = runOptimization(app);
        %% Store results into one structure array
        app.myOptimResults(idxRun).Solution = channelSolution;
        app.myOptimResults(idxRun).spdPercents0 = app.InitialGuessChannelPercents_Prop;
        app.myOptimResults(idxRun).myUiFun = app.myUiFun; %never changed so not really needed
%         not needed
        app.myOptimResults(idxRun).myOptimOptions = myOptimOptions;
        app.myOptimResults(idxRun).myConstraintsTable = app.UITable_Constraints.Data;
        app.myOptimResults(idxRun).spdFileImportPath =  app.importedFileName_Prop;
%         app.myOptimResults(idxRun).iterationStop = iterationStop;


        isValid = ...
            min( app.myOptimResults(idxRun).Solution >=0) && optimizerOutput(idxRun).constrviolation < 1e-2;

        %% Update best result
        % if the run is valid AND the optimized value is the
        % minimum of all. note that fVal is always negative,
        % since program always seeks negative. for maximum
        % goals we find the minimum of the negative value.
        if isValid ==1 && fVal(idxRun) < bestFVal
            bestFVal = fVal(idxRun);
            app.myBestOptimResult = app.myOptimResults(idxRun);
            app.myBestSpdMix      = SpdMixOut(idxRun);
        end

    end
    % clear it to debug to check it isn't used elsewhere
    app.myOptimResults = [];
    % if app.myBestOptimResult is empty, that means the if loop
    % was never entered because it was never valid
    if isempty(app.myBestOptimResult)
        message = {'All SPD Results Violated The Constraints',...
            'No Data Will Be Saved Or Plotted',...
            'Try Again With HonorBounds Checked On'};
        uialert(app.UIFigure,message,'Error','Icon','Error');
        %                         app.myOptimResults(1) = []; %set to empty
    end

    %% write to uitable results
    metricResultsStructToTable(app);
    app.UITable_OptimizationResults.Data = app.metricResultsTable; %keep table instead of uitable so I can use this for writing to excel
    %% Write spd to uiaxes
    cla(app.UIAxes_OptimSPD);
    hold(app.UIAxes_OptimSPD,'on');
    plot(app.UIAxes_OptimSPD ,...
        app.wlVecProgram, app.myBestSpdMix.Power.s);

    plot(app.UIAxes_OptimSPD,...
        app.wlVecProgram,...
        app.userSPDLibrary(:,app.channelSelectedTF).*app.myBestOptimResult.Solution',...
        LineStyle="--");

    app.UIAxes_OptimSPD.XLim = [380,780];

    %%
catch ME
    report = getReport(ME);
    uialert(app.UIFigure, report, 'Error Message', 'Interpreter','html')
end


end

