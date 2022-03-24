function figHandle = plot2degChromDiagram()
%%just plots 2 deg. Using function for cleaner code.


load('Standards\TM-30-18_tools_etc\TM30_18_Excel_Data_7sf.mat',...
'CIE_1931_Locus_380_5_780_7sf');
load('Standards\TM-30-18_tools_etc\TM30_18_Excel_Data_7sf.mat',...
'CIE_1931_BB_Txy_7sf');

figHandle = figure;
hold on;
xyBBPlot    = plot(CIE_1931_BB_Txy_7sf(:,2), CIE_1931_BB_Txy_7sf(:,3) );
xyBBScat    = scatter(CIE_1931_BB_Txy_7sf(:,2), CIE_1931_BB_Txy_7sf(:,3),'SizeData', 75, 'Marker','|');
xyPurePlot  = plot(CIE_1931_Locus_380_5_780_7sf(:,2), CIE_1931_Locus_380_5_780_7sf(:,3),'linewidth',3 ,'color',[0.7 0 0.7]);
xyBBTest    = text(CIE_1931_BB_Txy_7sf(1:8,2)-.02, CIE_1931_BB_Txy_7sf(1:8,3)+0.03,  string( CIE_1931_BB_Txy_7sf(1:8,1)./1000) );
title('CIE 1931 2deg Chromaticity Diagram');
xlabel('x2 Chromaticity');
ylabel('y2 Chromaticity');
grid on;
axis square;

end
