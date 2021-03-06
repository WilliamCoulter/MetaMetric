function [allMetrics] = getAllPossibleMetrics(app)

%% Go through the structure and parse out all scalar fieldnames to get a list of all
% potential metrics

nestStructNames = fieldnames(app.dummyStruct); %these are the nested structure
allMetrics = {};
for nestStructIdx = 1:numel(nestStructNames) %first fields are always structs. go through each
    
    nestStruct = app.dummyStruct.(nestStructNames{nestStructIdx}); %first layer always struct. temporarily assign
    if ~isstruct(nestStruct) %Like above, ensure they are all struct
        error("Fieldnames of struct must all be structures for program - Will C")
    end
    % Go through each nested struct. Remember each nested struct is a
    % category like TM30, Power, AOpics
    fn = fieldnames(nestStruct); %get field names of each nestStruct

    for fnIdx = 1:numel(fn) %go through the fields of the nested struct

        if isstruct( nestStruct.(fn{fnIdx}) )
            %% Ensure that these are all scalar and nonstructs
            anyStructTF = all(structfun(@isstruct,nestStruct.(fn{fnIdx}) ) );
            anyNonScalarTF = ~all(structfun(@isscalar,nestStruct.(fn{fnIdx}) ) );
            if anyStructTF || anyNonScalarTF %if a structure is found or they are not all scalar
                error("Third layer of your nested structure can contain not structures..." + ...
                    "Why would you want to make this even more complicated :D -Will C")
            end
            %% 
            allMetrics = [allMetrics; fieldnames(nestStruct.(fn{fnIdx}) )];
        elseif ~isstruct(nestStruct.(fn{fnIdx})) && isscalar(nestStruct.(fn{fnIdx}))
            allMetrics = [allMetrics;  fn{fnIdx}]; %if fieldname is not a struct and is scalar, add it

        elseif ~isscalar(nestStruct.(fn{fnIdx})) % if it is not scalar, like a matrix, then error
            error("The fields need to be nonscalar for the program. ..." + ...
                "They should have been removed via my removeNonScalarFields function -Will C")
        end
    end
end

end

