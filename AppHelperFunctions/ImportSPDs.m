%% Note that this is not a function. It just wraps a lot of commands into one name
% %%Deal with ui callback
% %https://www.youtube.com/watch?v=7_IC8Xcjp4w
% [spdFileName,spdFolderPath] = uigetfile('*.xlsx'); %have user select csv file
% spdFileFullPath = strcat(spdFolderPath,'\',spdFileName); %will addresses always be \ or sometimes \\ or / or // ?
% %             app.EditField.Value = spdFileName;
% excelSheetName = "UserSPDs";
% 
% %% Import the data
% [userSPDs, wlInt_user] = importUserSPDs(spdFileFullPath,excelSheetName);
% [xyUserSPDs,XYZUserSPDs] = spdsToXyXYZ(userSPDs(:,1:end), 2 );%get xy chromaticities for the imported spds
% 
