clear;clc;

x = (340:3: 860)';
nLed = 20;
% clumsily make a somewhat random distributed set of peaks
% pkList = [randi([420, 520],1,nLed/3), randi([520, 620], 1,nLed/3), randi([620,750],1,nLed/3)]
widthList = randi([15, 30], 1, nLed)

minPk = floor( min(x) + max(widthList).*1.5 );
maxPk = floor( max(x) - max(widthList).*1.5 );
pkList = randi([minPk,maxPk],1,nLed);

for i = 1:numel(pkList)
    y(:,i) = makeSpd(pkList(i), widthList(i), x);

end
figure
plot(x,y)
%% Make messed up wavelength spaced data
x = 380:1:780;
xInterp(:,1) = x(13:2:end-8); %weird start and end
xInterp(:,1) = xInterp + 0.7*rand(size(xInterp)); %add 0 to 0.7 to wavelengths
for i = 1:width(y)
    yInt(:,i) = interp1( x,y(:,i), xInterp,'spline', 0);
end
% yint(:,i) = interp1(x,y(:,i), )
figure(2);
plot(xInterp, yInt,'-o')

% badlySpacedSPDs = array2table( [xInterp, yInt],'VariableNames',["Wavelength", "SPDs" + string(1:width(yInt)) ])
% badStartEndSPDs
%%
% spdTable = [x,y]
% spdTable = array2table( [x,y],'VariableNames',["Wavelength", "SPDs" + string(1:width(y)) ])

% writetable(spdTable,'debugSheet_WL_340_3_860.xls')

% save('badWlIntervalDebugSPDWorkspace')