function makeUITree_Constraints(app)
%% The uitree is to check metrics to evaluate, and these metrics need to be scalar
% % Since the struct is made with all first layer fields being structs
% % themselves, we need to apply the removeNonScalarFields to each structure
dummyStruct = channelPercentsToSPDNestedStruct(ones(401,1));
fn = fieldnames(dummyStruct);
for fnIdx = 1:numel(fn)
    [dummyStruct.(fn{fnIdx})] = removeNonScalarFields(dummyStruct.(fn{fnIdx}) );
end
%% For debugging, this practices
% f = uifigure;
% cbt = uitree(f,'checkbox','tag','cbt')
% 
% 
% nestedScalarStruct2UITree(dummyStruct,'cbt',cbt)

%% Create uitree
% I added the tag at default as "myUITree"
nestedScalarStruct2UITree(dummyStruct,'myUITree',app.Tree_Constraints);