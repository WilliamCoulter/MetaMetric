% function [BBxyt]= getBBxyt(observer)
% 
% % cmfs = readtable('MetaMetric\Standards\ISOCIE_11664_1_2019\ISOCIE_11664_1_2019_2deg10deg.xlsx',...
% %     'ReadVariableNames',false);
% fileName = 'ISOCIE_11664_1_2019_2deg10deg.xlsx';
% filePath = which(fileName);
% cmfs = readtable(filePath,'ReadVariableNames',false);
% 
% cmfs = table2array(cmfs);
% switch observer
%     case 2
%         xyzbar = cmfs(:,2:4);
%     case 10
%         xyzbar = cmfs(:,5:7);
% end
% wv = cmfs(:,1);
% wv_interval = 1;
% %%Developing the radiant spectral distribution for blackbody of
% %Temperature, T, in Kelvins. Units: Watts/m^2/nm
% h=6.626176*10^-34; k= 1.380662*10^-23;  c=2.9979*10^8; c1=2*pi*h*(c^2); c2=h*c/k;
% %plank constant J*s%; %Boltzmann constant J/K %speed of light m/s
% T = 1000:250:10000;
% lambda = wv.*10^-9;
% lambda = repmat(lambda, 1, numel(T) );
% M = c1.*(lambda.^-5)./ (exp( c2./( T.*lambda) )); % wl x nBB spectrum
% 
% 
% %%
% %Plotting Chromaticity of blackbody spectrum
% MXYZ = M'*xyzbar;
% kbb = 100./MXYZ(:,2);
% MScaled = M.*kbb'; %scale spectrum to Y = 100 via kbb
% % MXYZScaled = MXYZ.*kbb'
% BBXYZ = MScaled'*xyzbar;
% BBxyt = [BBXYZ(:,1:2)./sum(BBXYZ,2), T'];
% 
% end
