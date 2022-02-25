function loadMyDefaults(app)
%Loads a myDefaults structure that was stored at app shutdown to reload the
%properties into the app of the previous session
% Willingo#3404 2/24/2022

if isfile('MyAppDefaults.mat') % Check it exists.
    load('MyAppDefaults.mat','myDefaults') %load structure from file

    %each field of myDefaults corresponds to a property or ui component in
    %the app. Loop through them
    fnDef = fieldnames(myDefaults);  %fieldnames of the default
    for fnDefIdx = 1:numel(fnDef)
        %                 app.UITable.Data = myDefaults.UITable.Data;
        mc = metaclass(app.(fnDef{fnDefIdx}));
        %
        %metadata of properties of obj.
        pList = mc.PropertyList; %array of properties and their metaproperties
        %writability for each prop
        pListSetAccess = {pList.SetAccess}; % cell array char vecs
        % Create logical list for properties that are writable
        setAccessPublicTF = strcmp(pListSetAccess,'public');
        % Don't include properties relating to parents (maybe
        % children, too?)
        propIsParentTF = contains( {pList.Name},'Parent');
        % Logically combine. Public access and not Parent
        idxUse = setAccessPublicTF & ~propIsParentTF;
        % Get the names of all the properties
        pListUse = {pList(idxUse).Name} %list of all properties
        %% Loop through the list of properties we want
        % Assign each property that was filtered above from the
        % myDefault structure into the app
        % note that (fnDef{fnDefIDx}) basically is like
        % "UITable" or "myPersonalAppProp".
        for nProp = 1:numel(pListUse)
            app.(fnDef{fnDefIdx}).(pListUse{nProp}) = myDefaults.(fnDef{fnDefIdx}).(pListUse{nProp});
        end

    end
end
end