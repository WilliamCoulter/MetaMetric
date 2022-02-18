function wrapper_Button_UseSelectedSPDsPushed(app,event)
%% Based on selected cells in the UITable_ImportedFile, create the userSPDLibrary ARRAY
[app.userSPDLibrary] = loadLibraryFromUITableSelection(app);

%% Get xy and XYZ of all spds
observerChoice = 2;
[app.xyuserSPDLibrary,app.XYZuserSPDLibrary] = ...
    spdsToXyXYZ(app.userSPDLibrary(:,1:end), observerChoice );%get xy chromaticities for the imported spds
%% Scale data Y10 = 100 for each channel
% Find amount needed to scale each channel
%             app.ScalePerSPD = 100./app.XYZuserSPDLibrary(:,2);
% Create new set of SPDs that are scaled to Y10 = 100;
%             app.SPDsScaled_Prop         = app.ScalePerSPD'.*app.userSPDLibrary;
% Create new set of XYZ for them scaled. xy should not change
% via scaling
%             [app.xySPDsScaled_Prop,app.XYZSPDsScaled_Prop] = ...
%                 spdsToXyXYZ(app.SPDsScaled_Prop(:,1:end) , 2 );%get xy chromaticities for the imported spds
%% Set edit value text box to show file name and number of channels
app.EditField_ImportedFileName.Value = ...
    num2str(width(app.userSPDLibrary)) + " channels were loaded from: "  + string(app.importedFileName_Prop);
%% Plot the chrom diagram
% clear it first
cla(app.UIAxes_ChromDiagram);
cla(app.UIAxes_ImportedSPDs);
plotSPDLibraryToChromDiagramAndSPDPlot(app)

%% Process spds and put into the selection table
getChannelMetrics(app);
end

