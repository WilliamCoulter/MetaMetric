function plotAlphaOpics
%% Plot Alpha Opic Action Spectra from CIE S 026:E2018 taken from their V1.049a toolbox



%% Load Data
persistent T_Alpha_Opic_Radiometric
if isempty(T_Alpha_Opic_Radiometric)
    load('Standards\CIES026_E2018\CIE_S026_AlphaOpic_v1049a.mat','T_Alpha_Opic_Radiometric');
end
% persistent vLambda1924
% if isempty(vLambda1924)
%     load('Project\Project_Data\Standards\ISOCIE_11664_1_2019\LuminousEfficiencyFunction.mat');
% end
% vLambda = vLambda1924(21:421,2); %vlambda cropped to 380:1:780

%% Assign Values and remove Nans
wlOpic = T_Alpha_Opic_Radiometric.nm;
sOpic = T_Alpha_Opic_Radiometric.sc;
mOpic = T_Alpha_Opic_Radiometric.mc; 
lOpic = T_Alpha_Opic_Radiometric.lc;
rOpic = T_Alpha_Opic_Radiometric.rh;
melOpic = T_Alpha_Opic_Radiometric.mel;

%remove nans if needed
sOpic(isnan(sOpic))     = 0;
mOpic(isnan(mOpic))     = 0;
lOpic(isnan(lOpic))     = 0;
melOpic(isnan(melOpic)) = 0;
rOpic(isnan(rOpic))     = 0;

%%
lineWidth = 3;
hold on
sPlot = plot(wlOpic, sOpic,'b','LineWidth',lineWidth);
mPlot = plot(wlOpic, mOpic,'g','LineWidth',lineWidth);
lPlot = plot(wlOpic, lOpic,'r', 'LineWidth', lineWidth);
melPlot = plot(wlOpic, melOpic, 'm', 'LineWidth', lineWidth);
rPlot = plot(wlOpic, rOpic, '-k', 'LineWidth', lineWidth);
xlabel('Wavelength (nm)');
ylabel('Units: 1/nm');
title('CIE S026 E2018 Alpha Opic Action Spectra');
hold off
%for now, it just overwrites the legend
% figHandle
% legend([sPlot, mPlot, lPlot, melPlot, rPlot],...
%     {'S-Opic Action Spectra','M-Opic Action Spectra', 'L-Opic Action Spectra', 'Melanopic Action Spectra', 'Rhodopic Action Spectra'});


end
