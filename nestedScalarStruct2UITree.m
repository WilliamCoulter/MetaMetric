function nestedScalarStruct2UITree(StructureLayer,parentNodeTag,uiTreeObj)

%% Given a nested scalar structure, create a uitree.
% This function recursivley adds new braches to the uitree as it finds
% more nested structures. Each node has a tag and text that are
% equivalent and defined by the fieldname. Structure nodes have no data
% assigned, but non-structure nodes assign the value of that field to
% the node

% Example: (Capital when field is a structure, non-capital is a field with values)
% S.A.a = 'SAa';
% S.A.B.a = 'SABa';
% S.C.B = 'SCb'; %we can have structs with same name (B) in same layer
% S.C.A.B.a = 'SCABa'; %we cannot have same name of structure in DIFFERENT layer
%
% myUiFigure = uifigure;
% myTree = uitree(myUiFigure, 'tag','myTreeTag')
%
% fieldNamesToNodes(S, 'myTreeTag', myTree)
arguments
    StructureLayer (1,1) {isstruct}
    parentNodeTag
    uiTreeObj
end
% get all the fieldnames of the layer
fn = fieldnames(StructureLayer);
% Find the parentnode of this layer
parentNode = findobj(uiTreeObj,'tag',parentNodeTag);

%Fixes  issue where multiple are returned. I believe this goes for the
%deepest level.
if numel(parentNode) >1
    error("I'm not entirely sure why this fails,..." + ...
        " but it will always work if every field in every layer is a unique name");
end
% for each fieldname, add a node in this layer
for fnIdx = 1:numel(fn)
    uitreenode(parentNode, 'Text', fn{fnIdx},...
        'tag', fn{fnIdx},...
        'NodeData', StructureLayer.(fn{fnIdx}));
end

%% if it is structure, we need to do it again!Function RECURSION!
isStructArray    = structfun(@isstruct,StructureLayer);%get logical array of whether fields are structs
structFieldNames = fn(isStructArray);
for idx = 1:numel(structFieldNames)
    % The parent node needs to be this fieldname
    %         tagName = strcat( structFieldNames{idx})
    nestedScalarStruct2UITree(StructureLayer.(structFieldNames{idx}),...
        structFieldNames{idx}, uiTreeObj);
end
%%
end

