function wrapper_Button_RunOptimizationPushed(app,event)
try
    %% On button push, access certain components' values
%     app.HonorBoundsTF = app.CheckBox_HonorBounds.Value;
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
    % Only if at least one TF is checked so we don't search and waste time
    % in optimizer
        lessThanTF = [app.myUiCon.LessThanTF];
        equalToTF  = [app.myUiCon.EqualToTF];
        greaterThanTF = [app.myUiCon.GreaterThanTF];
        useAnyTF = [lessThanTF; equalToTF; greaterThanTF]; %only pass in rows with ANY checks
        %check that if equal is chosen for row that no other is chosen
        idxEqualToTrue = equalToTF ==1;
        %create a logical array of all metrics specifically with equal to
        %being chosen. 
        logicArrayMetricsEqual = useAnyTF(:,idxEqualToTrue);
        % Of the metrics with equal chosen, if the sum of all chosen is
        % greater than 1, then there is a logical violation. can't set =
        % and >
        anyImpossibleConTF = any( sum(logicArrayMetricsEqual) >1); 
        if anyImpossibleConTF == 1
              message = {'Impossible set of constraints.', ...
                  'At least one metric has = constraint AND > or < constraint.',...
            'Optimization will not run.',...
            'Please fix your constraint table and press run again'};
            uialert(app.UIFigure,message,'Error','Icon','Error');
            return
        end
        app.myUiCon(~any(useAnyTF) ) = [];

    for idx = 1:numel(app.myUiCon)
        app.myUiCon(idx).targetPath = getStructPathFromNode(app.Tree_Constraints,app.myUiCon(idx).Metric);
    end
    %% Go through nRuns
    bestFVal = inf; %best fval is infinity, so anything is better
    app.myBestOptimResult = []; %initialize to empty
    for idxRun = 1:app.EditField_NRuns.Value
        %% Setup output plot
        f = figure(1);clf;
        % Create 2x1 tile layout and preallocate NaN
        tl = tiledlayout(f,3,1);
        plotAx(1) = nexttile(tl,1);
        hold(plotAx(1),'on');
        ylabel(plotAx(1),'Obj. Value');xlabel(plotAx(1),'Iteration');
        optimPlots(1) = plot(plotAx(1), NaN(app.EditField_NRuns.Value,1), NaN(app.EditField_NRuns.Value,1),'-ok','MarkerFaceColor','k' );
    
        plotAx(2) = nexttile(tl,2);
        hold(plotAx(2),'on');
        ylabel(plotAx(2),'Constr. Violation');xlabel(plotAx(2),'Iteration');
        optimPlots(2) = plot(plotAx(2), NaN(app.EditField_NRuns.Value,1), NaN(app.EditField_NRuns.Value,1),'-ok','MarkerFaceColor','k' );
        
        plotAx(3) = nexttile(tl,3);
        hold(plotAx(3),'on');
        ylabel(plotAx(3),'Current SPD');xlabel(plotAx(3),'Wavelength (nm)');
        optimPlots(1).XData = NaN(app.EditField_NRuns.Value,1);
        optimPlots(1).YData = NaN(app.EditField_NRuns.Value,1);
        optimPlots(2).XData = NaN(app.EditField_NRuns.Value,1);
        optimPlots(2).YData = NaN(app.EditField_NRuns.Value,1);
        optimPlots(3) = plot(plotAx(3),app.wlVecProgram, [sum(app.userSPDLibrary,2)]);
        optimPlots(3).Parent.XLim = [400,700];

        %% Make a random guess
        app.InitialGuessChannelPercents_Prop = 25+75*rand(sum(app.channelSelectedTF),1);

        %% Run optimization
        [SpdMixOut(idxRun), myOptimOptions,fVal(idxRun), optimizerOutput(idxRun),channelSolution ]= runOptimization(app,optimPlots);
        %% Store results into one structure array
        app.myOptimResults(idxRun).Solution = channelSolution;
        app.myOptimResults(idxRun).spdPercents0 = app.InitialGuessChannelPercents_Prop;
        app.myOptimResults(idxRun).myUiFun = app.myUiFun; %never changed so not really needed
        %         not needed
        app.myOptimResults(idxRun).myOptimOptions = myOptimOptions;
        app.myOptimResults(idxRun).myConstraintsTable = app.UITable_Constraints.Data;
        app.myOptimResults(idxRun).spdFileImportPath =  app.importedFileName_Prop;
        app.myOptimResults(idxRun).optimizerOutput = optimizerOutput(idxRun);

        isValid = min( app.myOptimResults(idxRun).Solution >=-eps);

        %% Update best result
        % if the run is valid AND the optimized value is the
        % minimum of all. note that fVal is always negative,
        % since program always seeks negative. for maximum
        % goals we find the minimum of the negative value.
        if isValid ==1 && fVal(idxRun) < bestFVal
            bestFVal = fVal(idxRun);
            app.myBestOptimResult = app.myOptimResults(idxRun);
            app.myBestSpdMix      = SpdMixOut(idxRun);
            % set a flag to check if constraints were violated
            badConstraintViolationFlag = optimizerOutput(idxRun).constrviolation >1e-2;
        end

    end
    % clear it to debug to check it isn't used elsewhere
    app.myOptimResults = [];
    % if app.myBestOptimResult is empty, that means the if loop
    % was never entered because it was never valid
    if isempty(app.myBestOptimResult)
        message = {'All SPD Results Violated The Constraints',...
            'No Data Will Be Saved Or Plotted',...
            'Are you sure your constraints can be satisfied',...
            'Perhaps you selected > and = for the same metric?'};
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
    uialert(app.UIFigure,"Go to Next Pane",'Optimization Complete','icon','info')

    if badConstraintViolationFlag
        msg = {'Constraint violation > 0.01.',...
            'Your constraints may be impossible, too difficult, or more runs should be attempted',...
            'It is also possible that you chose a > and < for a metric in which case ignore this message'};
        uialert(app.UIFigure,msg,...
            "Constraints Violated",'Icon','warning');
    end

catch ME
    report = getReport(ME);
    uialert(app.UIFigure, report, 'Error Message', 'Interpreter','html')
end


end

