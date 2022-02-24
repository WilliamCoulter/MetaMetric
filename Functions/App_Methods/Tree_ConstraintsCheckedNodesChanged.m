function Tree_ConstraintsCheckedNodesChanged(app,event)
%TREE_CONSTRAINTSCHECKEDNODESCHANGED Summary of this function goes here
checkedNodes = app.Tree_Constraints.CheckedNodes;
if ~isempty(checkedNodes) %we can't dot index the tag if it is empty
    % remove the parent nodes that are checked
    myCheckedCellArray = {checkedNodes.NodeData};
    isNodeStructTF = cellfun( @isstruct, myCheckedCellArray)
    nodesToUse = checkedNodes(~isNodeStructTF); %get all nodes that are not struct
    metricsToList = {nodesToUse.Tag}';
    %             app.MetricsEvaluated = {checkedNodes.Tag}';
    makeUIConstraintTable(app,metricsToList); %remake table
elseif isempty(checkedNodes)
    %for debug
    app.UITable_Constraints.Data = [];

end
end

