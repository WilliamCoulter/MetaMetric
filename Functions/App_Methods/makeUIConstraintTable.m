function [MetricsEvaluated]= makeUIConstraintTable(app)

%% Replicate metric generation done in optimziation function
dummyStruct = channelPercentsToSPDNestedStruct(ones(401,1));
%
fn = fieldnames(dummyStruct);
for fnIdx = 1:numel(fn)
    [dummyStruct.(fn{fnIdx})] = removeNonScalarFields(dummyStruct.(fn{fnIdx}) );
end

nestStructNames = fieldnames(dummyStruct); %these are the nested structure
allMetrics = {};
for nestStructIdx = 1:numel(nestStructNames) %first fields are always structs. go through each
    
    nestStruct = dummyStruct.(nestStructNames{nestStructIdx}); %first layer always struct. temporarily assign
    if ~isstruct(nestStruct)
        error("Fieldnames of struct must all be structures for program - Will C")
    end
    % Go through each nested struct. Remember each nested struct is a
    % category like TM30, Power, AOpics
    fn = fieldnames(nestStruct);
    for fnIdx = 1:numel(fn) %go through the fields of the nested struct
        if isstruct( nestStruct.(fn{fnIdx}) )
            anyStructTF = all(structfun(@isstruct,nestStruct.(fn{fnIdx}) ) );
            anyNonScalarTF = ~all(structfun(@isscalar,nestStruct.(fn{fnIdx}) ) );
            if anyStructTF || anyNonScalarTF %if a structure is found or they are not all scalar
                error("Third layer of your nested structure can contain not structures..." + ...
                    "Why would you want to make this even more complicated :D -Will C")
            end
            allMetrics = [allMetrics; fieldnames(nestStruct.(fn{fnIdx}) )];
        elseif ~isstruct(nestStruct.(fn{fnIdx})) && isscalar(nestStruct.(fn{fnIdx}))
            allMetrics = [allMetrics;  fn{fnIdx}] %if fieldname is not a struct and is scalar, add it
        elseif ~isscalar(nestStruct.(fn{fnIdx}))
            error("The fields need to be nonscalar for the program. ..." + ...
                "They should have been removed via my removeNonScalarFields function -Will C")
        end
    end
end
% allMetrics = fieldnames(dummyStruct);
MetricsEvaluated = allMetrics;
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

