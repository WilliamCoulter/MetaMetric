function makeUIConstraintTable(app,metricsToList)
% metricsToList = [];
%% Create columns based on the number of elements
% Set default constraints to none being used
% UseTF         = false( numel(metricsToList),1);
LessThanTF    = false(numel(metricsToList),1);
EqualToTF     = false(numel(metricsToList),1); %default
GreaterThanTF = false(numel(metricsToList),1 );

% Min > -inf, max < +inf, and equal is default to 0.
LessThanVal    = 1*inf*ones( numel(metricsToList), 1);
EqualToVal     = zeros(numel(metricsToList),1);
GreaterThanVal = -1*inf*ones( numel(metricsToList),1);

%% Create a standard table
% use comma-separated variables as variablenames
myConstraintTableNames = ["Metric",...
    "Use < Constraint?", "Less than what?",...
    "Use = Constraint?", "Equal to what?",...
    "Use > Constraint?", "Greater than what?"];

constraints_Table = table(metricsToList,...
    LessThanTF,LessThanVal,...
    EqualToTF, EqualToVal,...
    GreaterThanTF,GreaterThanVal,...
    VariableNames=myConstraintTableNames);

%Add row names to make indexin easier. It won't appear anyway
constraints_Table.Properties.RowNames = constraints_Table.Metric;
%% Fill in the uitable
app.UITable_Constraints.Data = constraints_Table;
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

