function makeUITree_Constraints(app)

%% Create uitree
% I added the tag at default as "myUITree"
nestedScalarStruct2UITree(app.dummyStruct,'myUITree',app.Tree_Constraints);
app.Tree_Constraints.CheckedNodes = app.Tree_Constraints.Children(:); %intially check all

end