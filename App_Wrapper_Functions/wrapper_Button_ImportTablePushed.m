function wrapper_Button_ImportTablePushed(app,event)
%% Prompt user for CSV/Excel file and convert to table
promptReadAssignPropImportedTable(app,event);
%% Store entire table into the uitable
t = app.userImportedTable;
app.UITable_ImportedFile.Data = t;
app.UITable_ImportedFile.ColumnName = t.Properties.VariableNames;
app.EditField_ImportedFileName.Value = "Data Loaded From "  + string(app.importedFileName_Prop);
%% Force app back to front
%https://www.mathworks.com/matlabcentral/answers/296305-appdesigner-window-ends-up-in-background-after-uigetfile
figure(app.UIFigure);
end

