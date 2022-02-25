function [allMetrics] = getAllPossibleMetrics
%% This calls the channelPercentsToSPDNestedStruct and removeNonScalarFields 
% and parses it to find all metrics that are scalar

%% Create the dummyStruct.
% Note that some fields are not used for constraints but for other things
% like plotting, so we need to remove the nonscalar fields.
% 
dummyStruct = channelPercentsToSPDNestedStruct(ones(401,1));
%
fn = fieldnames(dummyStruct);
for fnIdx = 1:numel(fn)
    if ~isstruct(dummyStruct.(fn{fnIdx})) %check that first layer is all struct
        error("You need to have the first layer of the spd structure that..." + ...
            "has all of the metrics to be structures themselves");
    end
    [dummyStruct.(fn{fnIdx})] = removeNonScalarFields(dummyStruct.(fn{fnIdx}) );
end

%% Go through the structure and parse out all scalar fieldnames to get a list of all
% potential metrics

nestStructNames = fieldnames(dummyStruct); %these are the nested structure
allMetrics = {};
for nestStructIdx = 1:numel(nestStructNames) %first fields are always structs. go through each
    
    nestStruct = dummyStruct.(nestStructNames{nestStructIdx}); %first layer always struct. temporarily assign
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

