function wrapper_Tree_ConstraintsCheckedNodesChanged(app,event)
%WRAPPER_TREE_CONSTRAINTSCECKEDNODESCHANGED Summary of this function goes here

%% Go through all checked nodes by their NodeData, which has their metric name
%

checkedNodes = app.Tree_Constraints.CheckedNodes;
if ~isempty(checkedNodes) %we can't dot index the tag if it is empty
    % remove the parent nodes that are checked
    myCheckedCellArray = {checkedNodes.NodeData};
    isNodeStructTF = cellfun( @isstruct, myCheckedCellArray);
    nodesToUse = checkedNodes(~isNodeStructTF); %get all nodes that are not struct
    metricsChecked = {nodesToUse.Tag}';
    %             app.MetricsEvaluated = {checkedNodes.Tag}';
elseif isempty(checkedNodes)
    metricsChecked = {};

end
updateUIConstraintTable(app,metricsChecked); %remake table

end

