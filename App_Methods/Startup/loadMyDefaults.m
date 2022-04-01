function loadMyDefaults(app)
%% Loads a myDefaults structure that was stored at app shutdown to reload
% select app properties from previous session to current session 3/21/2022
% Find me on Matlab's Discord via Willingo#3404 Feel free to DM
% Basic inspiration via https://www.mathworks.com/matlabcentral/answers/467573-how-to-save-and-load-app-designer-app-state-in-between-sessions
%% How to use?
% This entire function should not need to be changed, unlike the
% "saveMyDefaults". If you encounter issues, you may want to debug to add
% to the list of metaproperties that are ignored.

% 1) Stick this in your app's startupfcn callback.
% 2) Ensure that you read "saveMyDefaults.m" companion function.
% 3) If you encounter errors, set a debug line in the "j" loop and step
% through until you encounter the error. This is how I found that setting
% the "Parent" property will just break that component entirely for the
% entire app session. Add the property name into the list of properties to
% ignore in "propsNotToLoad"
%% Notes
% 1) I originally was going to make a metaclass and check for metaproperty
% attributes such as "SetAccess", but using a try catch seems more elegant
% 2) Apps have built in properties (components) like UITable or buttons.
% They can also user-set custom properties. For an app property like
% "UITable", it has "metaproperties" such as ".Data", "BackgroundColor",
% "Position". 

%% Setup arbitrary things
defaultFileName = 'MyAppDefaults.mat'; %If you change here, make sure you change in "saveMyDefaults.m"
catchList = {}; %Useful for debugging
metaPropsNotToLoad = {'Parent','Children','Fcn','Callback'}; 
%% Main loop. 
% if file detected --> get list of app properties that are saved --> go
% through all metaproperties --> Erase metaproperties that cause problems
% --> set app's properties' metaproprties to previous value.
if isfile(defaultFileName) %check file exists
    %% Load file
    S = load(defaultFileName); %load properly
    myDefaults = S.myDefaults; %rename
    appPropsSavedList = fieldnames(myDefaults); %get list of all components/app properties saved
    %% Go through each app property/component that was saved
    for i = 1:numel(appPropsSavedList) 
        metaPropsList = fieldnames(myDefaults.(appPropsSavedList{i}) );
        %% Important! Remove Parent property, as it seems setting this poofs tables away and are no longer accesible
        %Parent is known to cause big errors, but the rest seem like bad practice to set
        metaPropsList(contains(metaPropsList,metaPropsNotToLoad) ) =[];
        %% Go through jth metaproperty for the ith "thing" that was saved
        for j = 1:numel(metaPropsList)
            %% Try to set jth metaproperty of ith "thing" for current app.
            try
%                 metaPropsList{j}; %For debugging
                app.(appPropsSavedList{i}).(metaPropsList{j}) = myDefaults.(appPropsSavedList{i}).(metaPropsList{j});
            catch
                % Some potentially-useful debugging lines
%                 disp("Caught error for" + string(metaPropsList{j}) ); %kep
                %catchList{end+1} = metaPropsList{j};
                continue %if error, that means the metaproperty does not have set access, just keep going!
            end
        end
    end
end

end