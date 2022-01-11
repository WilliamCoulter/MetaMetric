function [ SPD_gauss ] = makeSpd( peak, width, wv, shape)
%% makeSPD(peakWavelength, fwhm, wavelength vector, shape) where peak = 1. It is recommended to scale it, as the default is arbitrary.

if ~exist('shape','var')
    % if shape is not input
    shape = 'Gauss';
end

%% 
% y = gaussmf(x,[sigma center]) 
% SPD_gauss = gaussmf(wv,[width peak])'; 
sigma = width/2.355;
SPD_gauss(:,1) = exp( - (wv-peak).^2/ ( 2*sigma^2));
% SPD_gauss = SPD_gauss./max(SPD_gauss)
% SPD_gauss = exp( -(wv-peak).^2./(2*width^2) )'; 

end
