function [xyY_m]= xyYmix(xyY1,xyY2)

%verbose for sake of readability
x1=xyY1(1) %coordinate 1
y1=xyY1(2)
Y1=xyY1(3)

x2=xyY2(1) %coordinate 2
y2=xyY2(2)
Y2=xyY2(3)

xm= ( x1*Y1/y1 + x2*Y2/y2)/ ( Y1/y1 + Y2/y2)
ym= ( Y1 + Y2            )/ (Y1/y1+ Y2/y2)
Ym= Y1+Y2
xyY_m= [xm ym Ym];