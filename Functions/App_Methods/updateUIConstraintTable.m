function updateUIConstraintTable(app,metricsChecked)

%% 1) Update the table that stores the history
% we either are adding a node or removing a node
uit = app.UITable_Constraints.Data; %get the TABLE from the UITABLE
metricsExistingInTable = uit.Properties.RowNames;
%take existing table metrics and store
app.UITable_Constraints_History( metricsExistingInTable,:) = uit(metricsExistingInTable,:);
%% Now that we saved the data in the table to our history, remake/overwrite
uit = app.UITable_Constraints_History(metricsChecked,:);
%% Now recreate uitable with the table
app.UITable_Constraints.Data = uit;
%% Repopulate uitable with only metrics selected
app.UITable_Constraints.Data = app.UITable_Constraints_History(metricsChecked,:);
%% Set utable properties
app.UITable_Constraints.ColumnEditable = true;
app.UITable_Constraints.Multiselect = true;
%             app.UITable_Constraints.ColumnWidth = 'fit';
app.UITable_Constraints.FontSize = 18;
app.UITable_Constraints.RowStriping ='on';
%% Add style
styleCentered = uistyle('HorizontalAlignment','center');
addStyle(app.UITable_Constraints, styleCentered, 'column', [2:width(app.UITable_Constraints.Data)] );

end

