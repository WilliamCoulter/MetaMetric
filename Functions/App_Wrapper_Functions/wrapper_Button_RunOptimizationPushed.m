function wrapper_Button_RunOptimizationPushed(app,event)
try
    %% On button push, access certain components' values
    app.HonorBoundsTF = app.CheckBox_HonorBounds.Value;
    % Make myUiFun structure
    app.myUiFun.myOptIterations = app.EditField_MaxIterations.Value; %Query edit field
    app.myUiFun.metric = string(app.DropDown_MetricGoal.Value); %Query dropdown selection
    switch app.DropDown_MaxOrMinGoal.Value %Convert from words to math. Minimizing the negative is maximizing
        case 'Maximize'
            app.myUiFun.minOrMax = -1;
        case 'Minimize'
            app.myUiFun.minOrMax = 1;
    end
    %% Make myUiCon struct from table
    app.myUiCon = table2struct(app.UITable_Constraints.Data);
    app.myUiCon = cell2struct(struct2cell(app.myUiCon),...
        {'Metric','UseTF',...
        'LessThanTF','LessThanVal',...
        'EqualToTF','EqualToVal',...
        'GreaterThanTF','GreaterThanVal'});
    %% Go through nRuns
    bestFVal = inf; %best fval is infinity, so anything is better
    app.myBestOptimResult = []; %initialize to empty
    for idxRun = 1:app.EditField_NRuns.Value
        %% Make a random guess
        app.InitialGuessChannelPercents_Prop = 25+75*rand(sum(app.channelSelectedTF),1);
        %% Run optimization
        [SpdMixOut, myOptimOptions,iterationStop,fVal(idxRun), optimizerOutput(idxRun)] = runOptimization(app);
        %% If it is negative, then go to next attempt
        %                     if min(SpdMixOut.Solution) < 0
        %                         message = {'SPD Result Is Not All-Positive', 'No Data Will Be Saved Or Plotted', 'Try again'};
        %                         uialert(app.UIFigure,message,'Error','Icon','Error');
        % %                         app.myOptimResults(1) = []; %set to empty
        %                         continue %if min is negative, then skip storing results and go to next idxRun
        %                     end
        %% Store results into one structure array
        app.myOptimResults(idxRun).metrics = SpdMixOut;
        app.myOptimResults(idxRun).spdPercents0 = app.InitialGuessChannelPercents_Prop;
        app.myOptimResults(idxRun).myUiFun = app.myUiFun;
        app.myOptimResults(idxRun).myOptimOptions = myOptimOptions;
        app.myOptimResults(idxRun).myConstraintsTable = app.UITable_Constraints.Data;
        app.myOptimResults(idxRun).spdFileImportPath =  app.importedFileName_Prop;
        app.myOptimResults(idxRun).iterationStop = iterationStop;


        isValid = ...
            min( SpdMixOut.Solution >=0) && optimizerOutput(idxRun).constrviolation < 1e-2;

        %% Update best result
        % if the run is valid AND the optimized value is the
        % minimum of all. note that fVal is always negative,
        % since program always seeks negative. for maximum
        % goals we find the minimum of the negative value.
        if isValid ==1 && fVal(idxRun) < bestFVal
            bestFVal = fVal(idxRun);
            app.myBestOptimResult = app.myOptimResults(idxRun);
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
    app.UITable_OptimizationResults.Data = app.metricResultsTable;
    %% Write spd to uiaxes
    cla(app.UIAxes_OptimSPD);
    hold(app.UIAxes_OptimSPD,'on');
    plot(app.UIAxes_OptimSPD ,...
        app.myBestOptimResult.metrics.wl, app.myBestOptimResult.metrics.s);

    plot(app.UIAxes_OptimSPD,...
        app.myBestOptimResult.metrics.wl,...
        app.userSPDLibrary(:,app.channelSelectedTF).*app.myBestOptimResult.metrics.Solution',...
        LineStyle="--");

    app.UIAxes_OptimSPD.XLim = [380,780];

    %%
catch ME
    report = getReport(ME);
    uialert(app.UIFigure, report, 'Error Message', 'Interpreter','html')
end


end

