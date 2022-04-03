function [XYZ] = xyToXYZ(xy, lumen)
%% [XYZ] = xy2XYZ( xy, lumen) where xy is a 2 length vector

%% asume xy is nx2 vector
z = ones(length(xy(:,1)),1)- xy(:,1) -xy(:,2)
xyz =  [ xy(:,1), xy(:,2), z]
for i=1:size(xyz,1)
    XYZ(:,i) = (lumen./xyz(i,2)).*[ xyz(i,:)]
end
