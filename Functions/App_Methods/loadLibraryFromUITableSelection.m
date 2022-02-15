function [subTableArray] = loadLibraryFromUITableSelection(app)
%LOADLIBRARYFROMUITABLESELECTION Summary of this function goes here
%% Select SPDs from selection
% the .Selection queries the highlighted cells and returns an
% n x 2 array of indices: [rows, cols]. Use this to create a
% subtable and then convert that to an array
cellSelection = app.UITable_ImportedFile.Selection;
uniqueRow = unique(cellSelection(:,1) ); %note that unique automatically sorts in ascending order
uniqueCol = unique(cellSelection(:,2) );
% Assign property
app.ImportTableColNumSelected = uniqueCol;

subTableSelected = app.UITable_ImportedFile.Data(uniqueRow,uniqueCol); %selected set of SPDs
subTableArray = table2array( subTableSelected ); %my functiosn expect arrays

app.wlIntUserImported_Prop = (780-380)/(height(subTableArray)-1);
app.wlUserImported(:,1) = 380:app.wlIntUserImported_Prop:780;
if round( app.wlIntUserImported_Prop) ~= app.wlIntUserImported_Prop
    msgbox( "When guessing wavelength interval, a non-integer was determined. "+...
        "Are you sure the wavelengths are from 380 to 780 and that you selected the entire column?", 'Error','error')
end
% This Ensure they chose a square selection (not necessarily
% contiguous).
if numel(subTableArray) ~= size(cellSelection,1)
    msgbox("Please Ensure each SPD has the same amount of rows selected", 'Error','error');
end

end

