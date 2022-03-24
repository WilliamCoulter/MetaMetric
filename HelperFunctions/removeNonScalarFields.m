function [ScalarOnlyStruct, nFieldsDeleted] = removeNonScalarFields(StructIn)
%% [ScalarOnlyStruct, nFieldsDeleted] = removeNonScalarFields(StructIn) 
% Input: Scalar Structure whose fieldnames may be scalar or non-scalar
% Output 1: Scalar Structure whose fieldnames are only scalar values
% Output 2: How many fields were deleted
    arguments
        StructIn (1,1) struct
    end
    % Because I don't want to have the output be the same name as the input,
    % even though there might not be an error if I did, I need to make a copy
    % of the original and then delete the fields each time, otherwise it just
    % redefines itself in the loop
    ScalarOnlyStruct = StructIn;
    %
    fn = fieldnames(ScalarOnlyStruct); %this is cell array of char vecs
    for nField = 1:numel(fn) %go through each field
        fieldToCheck = fn{nField}; %verbose but clearly specify field we check
        if ~isscalar(ScalarOnlyStruct.(fieldToCheck)) %if that field is nonscalar
            ScalarOnlyStruct = rmfield(ScalarOnlyStruct,fieldToCheck); %delete field and move on
        end
    end
    nFieldsDeleted = numel(fn) - numel(fieldnames(ScalarOnlyStruct));

end