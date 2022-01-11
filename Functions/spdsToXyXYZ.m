function [xy, XYZ]= spdsToXyXYZ(mySpectrum,obs)
%% Takes M wavelengths x N channel spectra and a cmf at M wavelengths x 3 Cmfs to output N x 2 xy and N x3 XYZ. Assumes SPD is in 1 nm increment from 380 to 780
%% Set A_CMF to persistent, so that it only needs to be loaded once, on first call to function
persistent A_CMF
%% If it does not exist (first call to function), then load A_CMF
% A_CMF is a matrix of columns [wavelength, x2,y2,z2,x10,y10,z10] for
% wavelength 380 to 780 in 1 nm increments. Note that A means "Array"
% instead of "T" which means table in my program
if isempty(A_CMF)
    load('Standards\TM-30-18_tools_etc\TM30_V204.mat', 'A_CMF');
end

%% Detect wavelength interval, assuming that nWavelength > nChannels (otherwise using length fcn will be an issue)
wlInt = 400/(length(mySpectrum) - 1);
if mod(400,wlInt) ~= 0
    error("Your wavelength interval step size does not make sense."+newline()+...
        "Make sure it starts at 380, has a uniform step size, and ends at 780");
end
%% Based on observer input, use 2 deg or 10 deg.

switch obs
    case 2
%         cmfs = A_CMF(:,)
        [XYZ] = 683*mySpectrum'*A_CMF(1:wlInt:end,[2,3,4]); %XYZ is an Nx3 with columns being X,Y,Z
        xy = [XYZ(:,1), XYZ(:,2)] ./ sum(XYZ,2);
    case 10
        [XYZ] = 683*mySpectrum'*A_CMF(1:wlInt:end,[5,6,7]); %XYZ is an Nx3 with columns being X,Y,Z
        xy = [XYZ(:,1), XYZ(:,2)] ./ sum(XYZ,2);
end

%% old code. Delete if encounter issues
% if width(cmfs) ~= 3
%     error(" spdsToXyXYZ currently does not support more than 3cmfs. ")
% end

% if size(spectrum,2) == 1
%     spectrum = [ (360:830)' spectrum ];
% end

% K_b = 683;

% for i = 1:size(spectrum,2)
% %     [XYZ(i,:)] = K_b*spectrum(:,i)'*cmfs(:,1:3);
%     [XYZ(i,:)] = K_b*spectrum'*cmfs;
%     
%     x     = XYZ(1)/sum(XYZ);
%     y     = XYZ(2)/sum(XYZ);
% 
%     xy(i,:)= [x, y];    
% end
%
% go from Mwave X Nchann to Nchann x Mwavel
% spectrum = spectrum';
% % make Nchan X 3 = Nchann xMwave * Mwave x 3
% [XYZ] = K_b*spectrum*cmfs;
% xy = [XYZ(:,1), XYZ(:,2)] ./ sum(XYZ,2);


end
