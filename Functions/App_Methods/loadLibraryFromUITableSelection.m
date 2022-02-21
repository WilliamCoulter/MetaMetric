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



subTableSelected = app.UITable_ImportedFile.Data(uniqueRow,uniqueCol); %selected set of SPDs
importHeaders =  subTableSelected.Properties.VariableNames;


%% Step 2: Create array from the subtable selected
% This isn't strictly necessary, but I'd rather deal with an array
rawSubTableArray = table2array( subTableSelected ); 
%% Step 3: Ensure the selection is rectangular
% This Ensure they chose a square selection (not necessarily
% contiguous).
if numel(rawSubTableArray) ~= size(cellSelection,1)
    msgbox("Please Ensure each SPD has the same amount of rows selected", 'Error','error');
end
%% Step 4: Preprocess imported data
% For simplicity, the program uses wavelengths of 380:5:780 at all points 
% Step 4 here will consider if app.CheckBox_IsLeftColumnSelectedWavelength is true
% If it is true, we need to interpolate and pad to 380:780. If it isn't
% true, still interpolate.
% Note that if data is 380:1:780, then interpolation is not doing any math
% but just pulling out every 5th value. The same is true if it is
% 360:1:830, except it only pulls out values between 380 to 780.


% Consider if the left checkbox is checked. 
switch app.CheckBox_IsLeftColumnSelectedWavelength.Value
    case true
        % Assign property to use in later functions. leftmost is the
        % minimum of column
        app.ImportTableColNumSelected = uniqueCol(uniqueCol ~= min(uniqueCol) ); %take all values that aren't minimum

        app.ImportTableHeaders = importHeaders(2:end); %ignore first, since it is wavelength
        %subTableArray is spds, so split the array into spds and
        %wavelengths
        rawUserWavelength = rawSubTableArray(:,1);%all rows, first column
        spdChannelArray   = rawSubTableArray(:,2:end); %all rows, all columns but first

    case false
        % Assign property to use in later functions. All columns are spds
        app.ImportTableColNumSelected = uniqueCol;
        app.ImportTableHeaders = importHeaders;

        %the subtable is all spds. rename to be consistent with the true case condition
        spdChannelArray = rawSubTableArray; 

        % create wavelength vector based on height of table and min and max
        % that the user inputs
        minWl = app.EditField_ImportedSPDWavelengthMin.Value;
        maxWl = app.EditField_ImportedSPDWavelengthMax.Value;
        numEntries = height(spdChannelArray);
        % Example of logic:
        % For 2,3,4,5,6 the min is 2 and max is 6. There are 5 entries.
        % Interval = (max +1 - min) / entries = (7 - 2)/5 = 1
        wlInterval = (maxWl +1 - minWl)/numEntries; 

        rawUserWavelength = [minWl:wlInterval:maxWl]'; %make column vec
    otherwise
        error("Somehow the checkbox for whether the left column " + ...
            "of uitable is neither checked nor unchecked")
end
% We now have the wavelength vector and spds
%% Step 5: Inteprolate user data to universal 380:5:780 of program.
% use for loop to make code easier to understand
% app.wlVecProgram = [380:5:780]'; %this is 380:5:780 and assigned on
% startup
extrapVal = 0; %set values that need to be extrapolated to 0
userMethod = app.DropDown_InterpolationType.Value;
xInterp = app.wlVecProgram;
for spdCol = 1:width(spdChannelArray)
    subTableArray(:,spdCol) = interp1( rawUserWavelength, spdChannelArray(:,spdCol),...
        xInterp, userMethod,...
        extrapVal); %set value for data outside of xInterp
end
%% Step 6: If over 99% of power is outside of 380-780, notify and set all to 0

% for i = 1:width(spdChannelArray)
%     powInRange(i) = trapz(app.wlVecProgram, subTableArray(:,i) ) %use interpolated value to check inside 380 to 780
%     powTotal(i)   = trapz(rawUserWavelength, spdChannelArray(:,i))
% 
% end
% idOver99OfPowOutside = powInRange./PowTotal < 0.01
% if idOver99OfPowOutside >0 %if there is at least one that has too little power
%     message = ["The following SPD channel column numbers (in order of selection) were set to 0";
%         "They had over 99% of their power outside the range 380:780nm";
%         ]
%     uialert(app.UIFigure, message,'Warning','Icon','warning');
% 
% %     uialert('')
% a


%% Make sure that the selected array is rectangular
% Load the min and max wavelength

% app.wlIntUserImported_Prop = (780-380)/(height(subTableArray)-1);
% app.wlUserImported = [380:app.wlIntUserImported_Prop:780]';


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
    linInd = sub2ind(size(subTableArray), rowIdx,colIdx);
    subTableArray(linInd) = 0; %set the negative values to 0
end



end

