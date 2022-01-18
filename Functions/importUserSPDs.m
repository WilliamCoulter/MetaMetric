function [userSPDs, wlInt] = importUserSPDs(fileName,sheetName)
%give the filename and the sheet and it will import the spds, assuming the
%power starts on line 10 and on column 2

%% Load Filenam
T_User = readtable(fileName,"Sheet", sheetName);
% T_User = readtable(fileName,"Sheet", sheetName,ReadVariableNames=false);
%% Pull the table of powers, assuming 380 to 780
T_Pow    = (T_User(10:end, 2:end) );

A_Pow = table2array(T_Pow); %convert to array, empty values become NaN

colIndEmpty = all(isnan(A_Pow)); %define an empty column as one where all powers are 0

A_Pow(:,colIndEmpty) = []; %cut out the array and only take inputted values

%%Detect the interval for input based on length
for i = 1:width(A_Pow) %now that A_Pow is all input vals, go throug each
   
    nonNanInd = ~isnan(A_Pow(:,i) ); %need to remove NaN to figure out real length
    Length_Pow = length(A_Pow(nonNanInd,i));
    
    if Length_Pow == 81
        int_Pow(i) = 5;
    elseif Length_Pow == 401
        int_Pow(i) = 1;
    elseif Length_Pow == 201
        int_Pow(i) =2;
    else
        errorStr = "Channel Number " + string(i) +" must be 380 to 780nm in 1nm,2nm, or 5nm steps";
        error(errorStr)
    end
    
end
% just double check
if width(int_Pow) ~= width(A_Pow)
    error("messed up")
end

%% Define the wlInt, that I pass out to optimizer, as the widest interval and interpolate from there
wlInt = max(int_Pow);
wl(:,1) = 380:wlInt:780; %because min and max range are same, we can make up the wl

%% Now go through each channel and interpolate to the wlInt
allSameInt = 1; %assume all are same interval

for i = 1:width(A_Pow)
    nanInd = isnan(A_Pow(:,i) ); %find nans
    s = A_Pow(:,i); %temp vec.
    s(nanInd) = []; %delete nans
    if length(s) ~=length(A_Pow(:,i))
        allSameInt = 0; % if s, which was A_Pow with no NaNs, is diff than A_Pow, then they weren't all same interval
    end
    if length(s) ~= length(wl) %the length should be the length of the wl we want everything to be in
        error("")
    end
    x = (380:int_Pow(i):780)'; %This is the data's wavelength entry, needed for interp1
    A_SPDs(:,i) = interp1(x, s, wl); %interp the spectrum s that is originally at wavelengths x to new wavelength wl
end
userSPDs = A_SPDs;
if sum(any(userSPDs<0)) >0
    userSPDs(userSPDs<0) = 0;
    disp("Changed negative vals to 0")
else
    disp("No negative values found")
end

if allSameInt ==1
    disp("All the intervals were the same:" +  string(wlInt) + " nm")
elseif allSameInt == 0
    disp("The intervals were not the same, so" + ...
        " they were interpolated to the widest, which was " + string(wlInt) + "nm")
else
    error("logical error")
end
%% handle negatives
% idList = 1:width(A_Pow);
% if all(userSPDs>=0)
%     disp("All channels loaded had all positive values")
%     if allSameInt ==1
%         disp("All the intervals were the same:" +  string(wlInt) + " nm")
%     elseif allSameInt == 0
%         disp("The intervals were not the same, so" + ...
%             " they were interpolated to the widest, which was " + string(wlInt) + "nm")
%     end
% end
% 
% if any(userSPDs<0)
%     disp("Channels" + string( idList(any(A_SPDs<0) ) ) +" Have at least one negative Value. I assumed" + ...
%         " they were small, so I set them to 0")
%     userSPDs(userSPDs<0) = 0;
% 
% end
% % userSPDs = A_SPDs;


end

