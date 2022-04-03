function [BinFig] = TmStruct2BinFig(TmStruct)

BinFig = figure;

sp1 = subplot(3,1,1);
ChromaShiftPlot   = bar([1:16],TmStruct.csBins);
xTip1 = ChromaShiftPlot(1).XEndPoints;
yTip1 = ChromaShiftPlot(1).YEndPoints;
labels1 = string( round(ChromaShiftPlot(1).YData,2,'significant') );
text(xTip1,yTip1,labels1, 'HorizontalAlignment','center','VerticalAlignment','bottom');
ylabel("Chroma Shift");
sp1.XTick = [1:16];
axis padded

sp2 = subplot(3,1,2);
HueShiftPlot      = bar(TmStruct.hsBins);
xTip2 = HueShiftPlot(1).XEndPoints;
yTip2 = HueShiftPlot(1).YEndPoints;
labels2 = string( round( HueShiftPlot(1).YData,2,'significant' ) );
text(xTip2,yTip2,labels2, 'HorizontalAlignment','center','VerticalAlignment','bottom');
ylabel("Hue Shift");
sp2.XTick = [1:16];
axis padded

sp3 = subplot(3,1,3);
FidelityBins = bar(TmStruct.rfBins);
xTip3 = FidelityBins(1).XEndPoints;
yTip3 = FidelityBins(1).YEndPoints;
labels3 = string(round(FidelityBins(1).YData,2,'significant') );
text(xTip3,yTip3,labels3, 'HorizontalAlignment','center','VerticalAlignment','bottom');
ylabel("Rf Shift");
sp3.XTick = [1:16];
axis padded

end

