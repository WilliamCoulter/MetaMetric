function [tableOut] = promptAndReadSPDTable(app)
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

try sheetnames(spdFileFullPath) %Put in try catch because it will return error if no sheetnames
    
    fileSheetNames = sheetnames(spdFileFullPath); %since sheetnames can be done, get the file list
    if numel(fileSheetNames) >1 %only ask them to select if there's more than one
        msg = "Multiple Sheets Detected. Select Sheet With SPDs"; myTitle = "Choose Sheet To Load";
        sel = uiconfirm(app.UIFigure, msg, myTitle,...
            Options = cellstr(fileSheetNames) );
        t = readtable(spdFileFullPath,...
            ReadVariableNames= true, VariableNamingRule= 'preserve', Sheet=sel);
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
%% Check that all values are positive, if not, warn and set to 0
% if any(t{:,:} < 0,'all') % check 'all' values to see if any are < 0
%     % https://www.mathworks.com/help/matlab/ref/uialert.html
%     [rowIdx, colIdx] = find(  t{:,:} < 0 ); %get row and column indices that are negative
%     colList = unique(colIdx); %get the unique list of columns that had a negative
%     message = [(string(numel(colIdx)) + " Entries were found to be negative");...
%         "The following columns (SPDs) had negatives: " + strjoin( string(colList), ',');... %this just makes a list like colList = [1,3,4] ---> "1, 3, 4"
%         "This/these value(s) will be set to 0 in the app";...
%         "(The file used to import data will not be changed)"];
%     uialert(app.UIFigure, message,'Warning','Icon','warning');
%     t{rowIdx,colIdx} = 0; %set the negative values to 0
% end
tableOut = t;
end

