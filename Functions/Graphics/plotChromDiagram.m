function [xyLocus, BBxyt]=plotChromDiagram(observer, axHandle)
%%just plots 2 deg. Using function for cleaner code.

% the ReadvariableNames False just stops it from reading the headers of the
% table, which don't matter if we immediately are converting to an array. 
% https://www.mathworks.com/matlabcentral/answers/360431-how-to-avoid-variable-name-warnings-when-using-filenames-as-variable-names
% cmfs = readtable('MetaMetric\Standards\ISOCIE_11664_1_2019\ISOCIE_11664_1_2019_2deg10deg.xlsx','ReadVariableNames',false) ;
fileName = 'ISOCIE_11664_1_2019_2deg10deg.xlsx';
filePath = which(fileName);
cmfs = readtable(filePath, 'ReadVariableNames',false);
cmfs = table2array(cmfs);
cmfs = cmfs(cmfs(:,1) >=380 & cmfs(:,1) <=780,:);
% hold(axHandle,'on');
% figHandle = figure;
switch observer
    case 2  

        xyLocus = cmfs(:,2:3)./sum(cmfs(:,2:4),2);
        BBxyt   = getBBxyt(2);

        if nargin ==2
            xlabel(axHandle,'x Chromaticity (2deg)');
            ylabel(axHandle,'y Chromaticity (2deg)');
            title(axHandle,'2 Deg Chromaticity Diagram');
            xlim(axHandle,[0, 0.75]);
            ylim(axHandle,[0,0.85]);
            
            xyLocusPlot       = plot(axHandle,xyLocus(:,1),xyLocus(:,2),'k','linewidth',3 );
            lineOfPurplesPlot = plot(axHandle,xyLocus([end,1],1), xyLocus([end,1],2),'m' );
            BBPlot            = plot(axHandle, BBxyt(:,1),BBxyt(:,2),'-*k','MarkerSize',2);
%     
%             axis square;
%             grid on;
        end
    case 10
        error("Not made yet");
%         xyLocus = cmfs(:,5:6)./sum(cmfs(:,5:7),2);
%         BBxy = getBBxyt(cmfs(:,5:7),cmfs(:,1) );
% 
%         xyLocusPlot = scatter(xyLocus,xyLocus);
%         BBPlot = scatter(BBxyt(:,1),BBxyt(:,2));
end
%% Add stuff that does not depend on observer input


%%

% if nargin ==1
%     xyLocusPlot       = plot(xyLocus(:,1),xyLocus(:,2),'k','linewidth',3 );
%     lineOfPurplesPlot = plot(xyLocus([end,1],1), xyLocus([end,1],2),'m' );
%     BBPlot            = plot(BBxyt(:,1),BBxyt(:,2),'-*k','MarkerSize',2);
% elseif nargin ==2 %if we told it which axis to plot to, put it there
%     xyLocusPlot       = plot(axHandle,xyLocus(:,1),xyLocus(:,2),'k','linewidth',3 );
%     lineOfPurplesPlot = plot(axHandle,xyLocus([end,1],1), xyLocus([end,1],2),'m' );
%     BBPlot            = plot(axHandle, BBxyt(:,1),BBxyt(:,2),'-*k','MarkerSize',2);
% end

function [BBxyt]= getBBxyt(observer)

% cmfs = readtable('MetaMetric\Standards\ISOCIE_11664_1_2019\ISOCIE_11664_1_2019_2deg10deg.xlsx',...
%     'ReadVariableNames',false);
fileName = 'ISOCIE_11664_1_2019_2deg10deg.xlsx';
filePath = which(fileName);
cmfs = readtable(filePath,'ReadVariableNames',false);

cmfs = table2array(cmfs);
switch observer
    case 2
        xyzbar = cmfs(:,2:4);
    case 10
        xyzbar = cmfs(:,5:7);
end
wv = cmfs(:,1);
wv_interval = 1;
%%Developing the radiant spectral distribution for blackbody of
%Temperature, T, in Kelvins. Units: Watts/m^2/nm
h=6.626176*10^-34; k= 1.380662*10^-23;  c=2.9979*10^8; c1=2*pi*h*(c^2); c2=h*c/k;
%plank constant J*s%; %Boltzmann constant J/K %speed of light m/s
T = 1000:250:10000;
lambda = wv.*10^-9;
lambda = repmat(lambda, 1, numel(T) );
M = c1.*(lambda.^-5)./ (exp( c2./( T.*lambda) )); % wl x nBB spectrum


%%
%Plotting Chromaticity of blackbody spectrum
MXYZ = M'*xyzbar;
kbb = 100./MXYZ(:,2);
MScaled = M.*kbb'; %scale spectrum to Y = 100 via kbb
% MXYZScaled = MXYZ.*kbb'
BBXYZ = MScaled'*xyzbar;
BBxyt = [BBXYZ(:,1:2)./sum(BBXYZ,2), T'];

end

end

