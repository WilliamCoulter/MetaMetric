clear;clc;
%% Set file types to look for
% https://www.mathworks.com/help/matlab/ref/uigetfile.html#mw_fbfe34a8-3ccf-49de-b27f-ff95c81b212e
importFileTypes = {'*.xls;*.xlsx;*.xlsb;*.xlsm',...
    'SPD Files (*.xls,*.xlsx,*.xlsb,*.xlsm)'};
%% User chooses file and returns file path
[myFileName, myFolderPath] = uigetfile(importFileTypes);
myFileFullPath =  fullfile(myFolderPath,myFileName);
%% Get the file name that hopefully does not get changed via uiimport
[~,myFile,~] = fileparts(myFileFullPath)
%% Guess what the file will be changed, if at all, to
myFileDataVar = strrep(myFile,' ','');
myFileDataVar = strrep(myFileDataVar,'_', '');
%% open up ui tool and pause program until file is imported
uiimport(myFileFullPath);

tic
while exist(myFileDataVar,'var') == 0
    pause(1);
    if toc >25
        error("File Name Not Found")
    end
end
%% Save workspace then load variable
save testVars
N= who;
V = load('testVars');
mySPD = getfield(V,myFileDataVar);
delete testVars.mat
clear N V
%%
%% Nothing here is shared outside of this function unless it is added to a property in the block below
%%Deal with ui callback
%https://www.youtube.com/watch?v=7_IC8Xcjp4w
% https://www.mathworks.com/help/matlab/ref/uigetfile.html#mw_fbfe34a8-3ccf-49de-b27f-ff95c81b212e
% 
% importFileTypes = {'*.xls;*.xlsx;*.xlsb;*.xlsm',...
%  'SPD Files (*.xls,*.xlsx,*.xlsb,*.xlsm)'};
% [spdFileName,spdFolderPath] = uigetfile(importFileTypes); %have user select csv file
% %% Get full path of file
% spdFileFullPath =  fullfile(spdFolderPath,spdFileName);
% app.importedFileName_Prop = spdFileName;
% %% Import data
% uiimport(spdFileFullPath);
% [~,rawImport,~] = fileparts(spdFileName);



% % % % % 
% % % % % 
% % % % % clear;clc;
% % % % % %% Set file types to look for
% % % % % % https://www.mathworks.com/help/matlab/ref/uigetfile.html#mw_fbfe34a8-3ccf-49de-b27f-ff95c81b212e
% % % % % importFileTypes = {'*.xls;*.xlsx;*.xlsb;*.xlsm',...
% % % % %     'SPD Files (*.xls,*.xlsx,*.xlsb,*.xlsm)'};
% % % % % %% User chooses file and returns file path
% % % % % [myFileName, myFolderPath] = uigetfile(importFileTypes);
% % % % % myFileFullPath =  fullfile(myFolderPath,myFileName);
% % % % % %% Get the file name that hopefully does not get changed via uiimport
% % % % % [~,rawImportName,~] = fileparts(myFileName);
% % % % % %% Guess at how uiimport formats filename into data variable
% % % % % rawImportName = strrep(rawImportName, ' ', ''); %remove whitespace
% % % % % rawImportName = strrep(rawImportName, '_', ''); %remove underscore
% % % % % %% open up ui tool and pause program until file is imported
% % % % % uiimport(myFileFullPath);
% % % % % 
% % % % % tic
% % % % % while exist(rawImportName,'var') == 0
% % % % %     pause(1);
% % % % %     if toc >20 % Code fuse in case imported var ~= filename
% % % % %         error("File Name Not Found")
% % % % %     end
% % % % % end
% % % % % %% Save workspace then load variable
% % % % % save testVars
% % % % % N= who;
% % % % % V = load('testVars');
% % % % % mySPD = getfield(V,rawImportName);
% % % % % delete testVars.mat
% % % % % clear V N
% % % % % 
% % % % % % com.mathworks.mlwidgets.importtool.SpreadsheetImportClient.close(myFileName);
% % % % % % com.mathworks.mlwidgets.importtool.SpreadsheetImportClient.open(fileAbsolutePath);
% % % % % % com.mathworks.mlwidgets.importtool.SpreadsheetImportClient.open(myFileFullPath);
