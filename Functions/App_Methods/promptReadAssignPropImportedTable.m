function promptReadAssignPropImportedTable(app,event)
%% Prompt user for spreadsheet to import
%https://www.youtube.com/watch?v=7_IC8Xcjp4w
% https://www.mathworks.com/help/matlab/ref/uigetfile.html#mw_fbfe34a8-3ccf-49de-b27f-ff95c81b212e
importFileTypes = {'*.xls;*.xlsx;*.xlsb;*.xlsm;*.csv',...
    'SPD Files (*.xls,*.xlsx,*.xlsb,*.xlsm,*.csv)'};
[spdFileName,spdFolderPath] = uigetfile(importFileTypes); %have user select csv file
%% Get full path of file
spdFileFullPath           =  fullfile(spdFolderPath,spdFileName);
app.importedFileName_Prop = spdFileName;
%% Import spreadsheet into table.

try sheetnames(spdFileFullPath); %Put in try catch because it will return error if no sheetnames
    
    fileSheetNames = sheetnames(spdFileFullPath); %since sheetnames can be done, get the file list
    if numel(fileSheetNames) >1 %only ask them to select if there's more than one
        msg = "Multiple Sheets Detected. Select Sheet With SPDs"; myTitle = "Choose Sheet To Load";
        sel = uiconfirm(app.UIFigure, msg, myTitle,...
            Options = cellstr(fileSheetNames) );
        t = readtable(spdFileFullPath,...
            ReadVariableNames= true, VariableNamingRule= 'preserve', Sheet=sel);
        % Force app back to front
        %https://www.mathworks.com/matlabcentral/answers/296305-appdesigner-window-ends-up-in-background-after-uigetfile
        figure(app.UIFigure);
    elseif numel(fileSheetNames) ==1
        t = readtable(spdFileFullPath,...
            ReadVariableNames= true, VariableNamingRule= 'preserve');
    else
        error("Somehow there are 0 sheetnames in promptAndReadSPDTable function");
    end
catch
    t = readtable(spdFileFullPath,...
        ReadVariableNames= true, VariableNamingRule= 'preserve');
end
%% Assign the table to a property
app.userImportedTable = t;
end

