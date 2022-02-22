function [MetricsEvaluated]= makeUIConstraintTable(app)

%% Replicate metric generation done in optimziation function
dummyStruct = channelPercentsToSPDStruct(ones(401,1));
%% Clumsily shuffle the bin fields to the end
% The 48 bin fields are assigned programmatically using a
% clever trick, but it can only be done to create a structure,
% not add to an existing one. A workaround could make spdToTM30
% run significantly more slowly.
dummyStruct = shuffleStructFields(dummyStruct,51);
dummyStruct = shuffleStructFields(dummyStruct,19);
%%
[dummyStruct] = removeNonScalarFields(dummyStruct);

%% Get the fieldnames, which are the metrics. These are stored in app properties
allMetrics = fieldnames(dummyStruct);
MetricsEvaluated = 
%% Create columns based on the number of elements
% Set default constraints to none being used
UseTF         = false( numel(MetricsEvaluated),1);
LessThanTF    = false(numel(MetricsEvaluated),1);
EqualToTF     = true(numel(MetricsEvaluated),1); %default
GreaterThanTF = false(numel(MetricsEvaluated),1 );

% Min > -inf, max < +inf, and equal is default to 0.
LessThanVal    = 1*inf*ones( numel(MetricsEvaluated), 1);
EqualToVal     = zeros(numel(MetricsEvaluated),1);
GreaterThanVal = -1*inf*ones( numel(MetricsEvaluated),1);

%% Create a standard table
% use comma-separated variables as variablenames
myConstraintTableNames = ["Metric.","Use This Metric At All?",...
    "Use < Constraint?", "Less than what?",...
    "Use = Constraint?", "Equal to what?",...
    "Use > Constraint?", "Greater than what?"];

constraints_Table = table(MetricsEvaluated, UseTF,...
    LessThanTF,LessThanVal,...
    EqualToTF, EqualToVal,...
    GreaterThanTF,GreaterThanVal,...
    VariableNames=myConstraintTableNames);


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

