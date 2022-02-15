function [SpdMixStruct] = channelPercentsToSPDStruct(spdChannels,spdPercents)
    %% Create an SPD that is a mix of spdChannels and spdPercents
        %Percents are from 0 to 100 in the program, not 0 to 1.0, although
        %it might not matter for some applications
        
    % Note that spdMix is not capitalized while SpdMixStruct is. This is in
    % keeping with the standard that only structures are capitalized.
    spdMix.s         = spdChannels*spdPercents;
    %% Metrics From the SPD
        %function take in 2 double arrays and makes the spdMix as a double
        %array. The TM30 function converts it to a structure, adding new
        %fields. If new user function takes an spd as a double array then
        %use "SpdMixStruct.s" as the input.
    %% TM30-20 
        %Verification: "IES TM-30-20 Advanced CalculationTool v2.04 (not released).xlsm"
        %Excel file under "/Standards/TM-30-18_tools_etc"
        
    [SpdMixStruct] = spdToTM30(spdMix);
    %% CIE S026:E2018 Alpha Opic LER
        %Verification:  "CIE_S026_Alpha_Opic_Toolbox_V1_049a_2020_Nov.xlsx"   
        %Excel file under "/Standards/CIES026_E2018"
        
    [SpdMixStruct] = spdToAlphaOpics(SpdMixStruct); %add fields
    %% Future Metrics 1
    
    %SpdMixStruct = FUTUREFUNCTION(SpdMixStruct);
        % % % OR if your function cannot handle a struct:
    %SpdMixStruct = FUTUREFUNCTION(SpdMixStruct.s);
    %% Future Metrics 2
        
    %SpdMix = FUTUREFUNCTION(SpdMixStruct);
        % % % OR if your function cannot handle a struct:
    %SpdMix = FUTUREFUNCTION(SpdMixStruct.s);

end

