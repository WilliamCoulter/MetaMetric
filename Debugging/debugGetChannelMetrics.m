%% I used debugger to take out the values at the end of the for loop. 
% I should be able to recreate what is resulting in wrong peak values

%% Load data
clear;clc;
load('C:\Users\Will\OneDrive\MyMatlab\MetaMetric\Debugging\debugGetChannelMetrics.mat')
%% Plot the SPDs
figure(1);clf;
myP = plot(myWL, mySPDs);
% color = reshape([myP.Color]',[],3)
hold on;
grid on;
set(gca,XTick = [350:25:700])
%% go through cell array
for i = 3
     xline( [ str2double(chPkLocs{i}.split() )],Color=[myP(i).Color])
%     xline([chPkLocs{i}]);
end
%% copy paste the for loop that creates the outputs

tMetrics = cell2table([chPkLocs,chPkFwhm,chCentroid])

% 
% 
% for nChannel = 1: width(app.userSPDLibrary)
%     [~,chPkLocs_temp,chPkFwhm_temp] =...
%         findpeaks(app.userSPDLibrary(:,nChannel),...
%         app.wlUserImported,...
%         'WidthReference','halfheight','MinPeakDistance',20,'MinPeakWidth',10);
%     chPkLocs{nChannel,1}(1,:) = string( round(chPkLocs_temp,1,"decimals") ).join(', ');
%     chPkFwhm{nChannel,1}(1,:) = string( round(chPkFwhm_temp,1,"decimals") ).join(', ');
%     clear chPkLocs_temp chPkFwhm_temp
% % end
% %% Get wavelength centroid;
% % for nChannel = 1:width(app.userSPDLibrary)
%     % https://mathworld.wolfram.com/FunctionCentroid.html
%     x = app.wlUserImported;
%     y = app.userSPDLibrary(:,nChannel);
%     chCentroid_temp =trapz( x,x.*y)./ trapz(x,y);
%     chCentroid{nChannel,1}(1,:) = string( round(chCentroid_temp,1,"decimals") ); %not needed, but for consistency
%     clear chCentroid_temp
% end

max( reshape([app.UIAxes_ImportedSPDs.Children.YData],401,[]) )