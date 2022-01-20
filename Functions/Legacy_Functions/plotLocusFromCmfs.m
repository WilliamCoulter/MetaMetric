function  [x_Locus,y_Locus, xy_Locus] = plotLocusFromCmfs(cmf, wl, Interval)
%[x_Locus,y_Locus, xy_Locus, wl] = plotLocusFromCmfs(wl,cmf, Interval)
% Plots chrom diagram from CMFs. Labels wavlengths on locus on interval
% (not yet implemented). Can return column vector of x, y, or xy as an Nx2

x_Locus(:,1) = cmf(:,1)./ sum(cmf,2);
y_Locus(:,1) = cmf(:,2)./ sum(cmf,2);
xy_Locus = [x_Locus, y_Locus];

plot(x_Locus,y_Locus);
hold on
% text( x_Locus(1:Interval:end), y_Locus(1:Interval:end), num2str(wl(1:Interval:end)))


end

