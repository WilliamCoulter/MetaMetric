function [fieldNamePath] = getStructPathFromNode(tree,tagToSearch)
%GETNODEPATHFORSTRUCT Summary of this function goes here
% Given a tree representing a nested scalar structure whose nodes' tags are
% the scalar structure's fieldnames, create a cell array of fieldname
% search paths to get to a field in the structure.

% We have a uitree that has the format of our structure in it inherently.
% each node represents a field and each node has a tag of the fieldname
% We can make a searchpath to get a field from somewhere inside our nested
% struct


targetNode = findobj(tree,'tag', tagToSearch);
parentHierarchy = {};
nodeSearch = targetNode;
% t0=tic;
while class(nodeSearch.Parent) ~= "matlab.ui.container.CheckBoxTree"
%     if toc-t0 >15 %while loops scare me
%         error("Finding structure path to metric goal took too long")
%     end
    parentHierarchy{end+1} = nodeSearch.Parent.Tag; %get & store tag of parent
    nodeSearch = nodeSearch.Parent; %go up one level
end
childrenHierarchy = flip(parentHierarchy); %children is reverse of parents
fieldNamePath = [childrenHierarchy, targetNode.Tag];

end

