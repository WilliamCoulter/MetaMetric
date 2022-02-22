function [SpdStruct] = channelPercentsToSPDStruct(spdArray,spdPercents)
%% Function summary: If spdArray is a vector, then metrics are assigned to a structure
% If spdArray is an array, then spdPercents must be passed in, and it mixed
% them as spdArray*spdPercents

%% Create the structure with initial field s being the spd

switch nargin
    case 1
        SpdStruct.s = spdArray; 
    case 2
        SpdStruct.s = spdArray*spdPercents;
    otherwise
        error("Invalid amount of arguments into function")
end
%% Function Chaining Of SPD structure to metrics
%Each function takes in a structure, assumes spd is in the field s, then
%appends fields to the structure
%% TM30-20
%Verification: "IES TM-30-20 Advanced CalculationTool v2.04 (not released).xlsm"
%Excel file under "/Standards/TM-30-18_tools_etc"

[SpdStruct] = spdToTM30(SpdStruct);
%% CIE S026:E2018 Alpha Opic LER
%Verification:  "CIE_S026_Alpha_Opic_Toolbox_V1_049a_2020_Nov.xlsx"
%Excel file under "/Standards/CIES026_E2018"

[SpdStruct] = spdToAlphaOpics(SpdStruct); %add fields
%% Future Metrics 1
%     [SpdMixStruct] = spdToMetamericIndex(SpdMixStruct);
%SpdMixStruct = FUTUREFUNCTION(SpdMixStruct);
% % % OR if your function cannot handle a struct:
%SpdMixStruct = FUTUREFUNCTION(SpdMixStruct.s);
%% Future Metrics 2

%SpdMix = FUTUREFUNCTION(SpdMixStruct);
% % % OR if your function cannot handle a struct:
%SpdMix = FUTUREFUNCTION(SpdMixStruct.s);

end

