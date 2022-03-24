function saveMyDefaults(app,event)
%% Saves a list of app components / custom properties to a file to be loaded on a new app session
% via "loadMyDefaults.m"
% Find me at #Willingo3404 on Discord at the Matlab's discord. Feel free to
% DM
%% How to use?
% 1) Stick this in the app's "app.UIFigureCloseRequest" callback (right
% click app in design view to create the callback), preferably inside a try
% block, with "delete(app)" outside the try catch block to always ensure
% the app closes
% 2) Using design view, add the name of a component into the
% "listOfPropsToSave". 
% 3) You may want to place the file into a more absolute path
%% Limitations
% Currently it can't save user-defined properties, as they may not be .
% accessible. If your user-defined property is a structure, then it should
% work. You can always force your property to be a structure.
% Example of forcing a user-property into a structure:
% Original: app.myProperty = [1,3,5];
% Forced structure: app.myProperty.Value = [1,3,5];
%% Create list of UI components / User Properties (structures only)
listOfPropsToSave = {'UITable_ImportedFile'};
%% 
myDefaults = struct();
defaultFileName = 'MyAppDefaults.mat'; %If you change here, change in "loadMyDefaults.mat"
%% Loop logic:
% Go through "ith" app component / property specified in "listOfPropsToSave" --> 
% get list of metaproperties --> Go through "jth" metaproperty --> 
% store jth metaproperty of app's "ith" property into a scalar structure
% "myDefaults".

for i = 1:numel(listOfPropsToSave)
    metaPropsList = properties(app.(listOfPropsToSave{i}) );
    for j = 1:numel(metaPropsList)
        try
            myDefaults.(listOfPropsToSave{i}).(metaPropsList{j}) = app.(listOfPropsToSave{i}).(metaPropsList{j});
        catch
            disp("caught");
        end
    end
end

%% Save scalar structure into file name
try
    save(defaultFileName,'myDefaults');
catch ME
    report = getReport(ME);
    uialert(app.UIFigure, report, 'Error Message', 'Interpreter','html')
end

end

