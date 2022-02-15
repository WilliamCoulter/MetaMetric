function [SpdMixOut, myOptimOptions,iterationStop,myUiFun] = runOptimization(app)
%% Options and edit fields are called only on this button press

% Get table from uitable
%                 metricConstraints_table = app.UITable_Constraints.Data; %what is diff between Data & DisplayData field?
% %% Make myUiCon struct from table
% app.myUiCon = table2struct(app.UITable_Constraints.Data);
% app.myUiCon = cell2struct(struct2cell(app.myUiCon),...
%     {'Metric','UseTF',...
%     'LessThanTF','LessThanVal',...
%     'EqualToTF','EqualToVal',...
%     'GreaterThanTF','GreaterThanVal'});
% 
% %% Run Optimization
% 
% % Make a random guess
% app.InitialGuessChannelPercents_Prop = 25+75*rand(width(app.SPDsScaled_Prop),1);
% %                 spdPercents0 = app.InitialGuessChannelPercents_Prop;
% 
% %
% %                 spdChannels = app.SPDsScaled_Prop;
% % Make myUiFun structure
% myUiFun.myOptIterations = app.EditField_MaxIterations.Value; %Query edit field
% myUiFun.metric = string(app.DropDown_MetricGoal.Value); %Query dropdown selection
% switch app.DropDown_MaxOrMinGoal.Value %Convert from words to math. Minimizing the negative is maximizing
%     case 'Maximize'
%         myUiFun.minOrMax = -1;
%     case 'Minimize'
%         myUiFun.minOrMax = 1;
% end
%% Run optimizer

appStopFlag = false;
[SpdMixOut, myOptimOptions,iterationStop] = Main_Optimizer_Function_App_mfile(app.InitialGuessChannelPercents_Prop,...
    app.userSPDLibrary(:,app.channelSelectedTF),...
    app.myUiCon,myUiFun);
end

