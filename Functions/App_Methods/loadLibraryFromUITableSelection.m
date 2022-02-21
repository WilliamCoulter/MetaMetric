function [subTableArray] = loadLibraryFromUITableSelection(app)
%% Description: Load SPD Channels Into Program
% After the user selects the cells of data in the uitable on tab 1, and
% specifying the min and max range, read in the subtable from the uitable
% and interpolate / pad / trim the data into the program's universal
% 380:5:780 nm range

%% Step 1: Create numeric array of spds from the subtable selected in uitable

% the .Selection queries the highlighted cells and returns an
% n x 2 array of indices: [rows, cols]. Use this to create a
% subtable and then convert that to an array
cellSelection = app.UITable_ImportedFile.Selection;

uniqueRow = unique(cellSelection(:,1) ); %note that unique automatically sorts in ascending order
uniqueCol = unique(cellSelection(:,2) );

% Assign property to use in later functions
app.ImportTableColNumSelected = uniqueCol;

subTableSelected = app.UITable_ImportedFile.Data(uniqueRow,uniqueCol); %selected set of SPDs
%% Step 2: Create array from the subtable selected
% This isn't strictly necessary, but I'd rather deal with an array
subTableArray = table2array( subTableSelected ); 

%% Step 3: Consider user inputs in panel 2 and 3 in tab 1

% Load the min and max wavelength
minWavelength = app.EditField_ImportedSPDWavelengthMin.Value;
maxWavelength = app.EditField_ImportedSPDWavelengthMax.Value;


app.wlIntUserImported_Prop = (780-380)/(height(subTableArray)-1);
app.wlUserImported = [380:app.wlIntUserImported_Prop:780]';
if round( app.wlIntUserImported_Prop) ~= app.wlIntUserImported_Prop
    msgbox( "When guessing wavelength interval, a non-integer was determined. "+...
        "Are you sure the wavelengths are from 380 to 780 and that you selected the entire column?", 'Error','error')
end
% This Ensure they chose a square selection (not necessarily
% contiguous).
if numel(subTableArray) ~= size(cellSelection,1)
    msgbox("Please Ensure each SPD has the same amount of rows selected", 'Error','error');
end
%% Check they are all positive
if any(subTableArray(:,:)< 0,'all') % check 'all' values to see if any are < 0
    % https://www.mathworks.com/help/matlab/ref/uialert.html
    [rowIdx, colIdx] = find(  subTableArray < 0 ); %get row and column indices that are negative
    colList = unique(colIdx); %get the unique list of columns that had a negative
    message = [(string(numel(colIdx)) + " Entries were found to be negative");...
        "The following columns (SPDs) had negatives: " + strjoin( string(colList), ',');... %this just makes a list like colList = [1,3,4] ---> "1, 3, 4"
        "This/these value(s) will be set to 0 in the app";...
        "(The file used to import data will not be changed)"];
    uialert(app.UIFigure, message,'Warning','Icon','warning');
    subTableArray(rowIdx,colIdx) = 0; %set the negative values to 0
end



end

