function writeChannelMetricsToUITableSelection(app)
%GETCHANNELMETRICS Summary of this function goes here
%% Clear table in case they choose new selection
app.UITable_ChannelSelection.Data = [];
app.UITable_ChannelSelection.ColumnName = [];
app.UITable_ChannelSelection.RowName = [];
%%
%% At this point the user has selected the library of spds and the spds are loaded as a property.
% Let's make metrics and plot them into the table. This is very
% similar to the UITable_Constraints
%% Get the peaks and full width half max of each channel
% We cannot have uitable display cells in a column that have
% different length, so we need to use strings instead. This is
% not a big deal since we do not need to use this data in the
% program, only display it.

for nChannel = 1: width(app.userSPDLibrary)
    [chPkVals_temp,chPkLocs_temp,chPkFwhm_temp] =...
        findpeaks(app.userSPDLibrary(:,nChannel),...
        app.wlVecProgram,...
        'WidthReference','halfheight','MinPeakDistance',20,'MinPeakWidth',10);
    %% only accept peaks if they are 10% or greater to max prom
%     maxProm = max(chPkProm_temp);
    scaledPkVals = chPkVals_temp./max(chPkVals_temp);
    overTenPercTF = scaledPkVals > 0.10*max(scaledPkVals) ;

    chPkLocs_temp = chPkLocs_temp(overTenPercTF);
    chPkFwhm_temp = chPkFwhm_temp(overTenPercTF);
    %%
    %%
    chPkLocs{nChannel,1}(1,:) = string( round(chPkLocs_temp,1,"decimals") ).join(', ');
    chPkFwhm{nChannel,1}(1,:) = string( round(chPkFwhm_temp,1,"decimals") ).join(', ');
    clear chPkLocs_temp chPkFwhm_temp chPkVals_temp
% end
%% Get wavelength centroid;
% for nChannel = 1:width(app.userSPDLibrary)
    % https://mathworld.wolfram.com/FunctionCentroid.html
    x = app.wlVecProgram;
    y = app.userSPDLibrary(:,nChannel);
    chCentroid_temp =trapz( x,x.*y)./ trapz(x,y);
    chCentroid{nChannel,1}(1,:) = string( round(chCentroid_temp,1,"decimals") ); %not needed, but for consistency
    clear chCentroid_temp
end
channelMetricNames = ["Peak";"FWHM";"Centroid"];
channelNames = app.UITable_ImportedFile.ColumnName(app.ImportTableColNumSelected); %logically index from all selected which are checkbox marked
tMetrics = cell2table([chPkLocs,chPkFwhm,chCentroid] ,...
    RowNames = channelNames,...
    VariableNames= channelMetricNames);
%             tUseNoUse = table( false(numel()))
tUseNoUse = array2table(true( size(app.userSPDLibrary,2) ,1 ),...
    RowNames = channelNames,...
    VariableNames= "Use For Optimization?" );

selectionTable = [tUseNoUse,tMetrics];
%             app.ChannelMetricTable = selectionTable;
app.UITable_ChannelSelection.Data = selectionTable;
app.UITable_ChannelSelection.RowName = selectionTable.Properties.RowNames;%["Use For Optimization?";channelMetricNames];
app.UITable_ChannelSelection.ColumnName = selectionTable.Properties.VariableNames; %Not sure why this isn't inherited via .Data assignment
app.UITable_ChannelSelection.ColumnEditable = [true, false(1,width( app.UITable_ChannelSelection.Data )-1 ) ];
% Stylize
horizAlignStyle = uistyle("HorizontalAlignment","center");
addStyle(app.UITable_ChannelSelection,horizAlignStyle);

%%
app.channelSelectedTF= app.UITable_ChannelSelection.Data{:,1};
%%
end

