clc;clear; close all force;
f = uifigure;

cbt = uitree(f,'checkbox','tag','cbt')
% S.A1.a2 = 'SAa'
% S.A1.B2.a3 = 'SAAa'
% S.A1.A2.a3 = 'SAAa';
% S.A1.A2.b3 = 'SAAb';
% S.A1.B2.a3 = 'SABa'
% S.B1.a3 = 'SBa'
% S.B1.b3 = 'SBb'
% S.B1.A2 = 'SBAa'
% S.B1.A2.b3 = 'SBAb'
% % S.c = 'Sc'
% S.D.a = 'SDa'
% S.D.b = 'SDb'
% S.D.c = 'SDc'
% S.D.A.a = 'SDAa'
% S.D.A.b = 'SDAb'
% S.D.A.A.a = 'SDAAa'

% 
% S.A.a = 'SAa';
% S.A.B.a = 'SABa';
% S.C.B = 'SBa'; %we can have structs with same name (B) in same layer
% S.C.A.B = 'SCAB'; %we cannot have same name of structure in DIFFERENT layer
% % we can have two structures with same name
% S = channelPercentsToSPDNestedStruct(ones(401,1))
S.A1.B2.a3 = 1;
S.A1.B2.b3 = 2;
S.B1.A2.a3 = 2;
S.B1.A2.b3 = {1,2};
% S.B1.A2 = 2


fieldNamesToNodes(S,'cbt',cbt) 

function fieldNamesToNodes(StructureLayer,parentNodeTag,uiTreeObj)
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
        error("Please have all field names unique"); 
    end
    % for each fieldname, add a node in this layer
    for fnIdx = 1:numel(fn)
        uitreenode(parentNode, 'Text', fn{fnIdx},...
            'tag', fn{fnIdx},...
            'NodeData', StructureLayer.(fn{fnIdx}) );
    end

    %% if it is structure, we need to do it again!Function RECURSION!
    isStructArray    = structfun(@isstruct,StructureLayer);%get logical array of whether fields are structs
    structFieldNames = fn(isStructArray);
    for idx = 1:numel(structFieldNames)
        % The parent node needs to be this fieldname
%         tagName = strcat( structFieldNames{idx})
        fieldNamesToNodes(StructureLayer.(structFieldNames{idx}),...
            structFieldNames{idx}, uiTreeObj);
    end
    %%
end
