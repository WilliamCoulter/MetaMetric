function [ SPDs ] = makeSpds( Peak_Wavelengths, FWHM_Widths, Peak_Heights, wv)
%% makeSPDs(peakWavelength, fwhm, wavelength vector) where peak = 1. It is recommended to scale it, as the default is arbitrary. takes in row vectors


%% 
if width(wv) > 1
    wv = wv';
elseif width(FWHM_Widths) >1
    FWHM_Widths = FWHM_Widths';
elseif width(Peak_Heights) > 1
    Peak_Heights = Peak_Heights';
elseif Peak_Wavelengths >1
    Peak_Wavelengths = Peak_Wavelengths';
end

sigmas = FWHM_Widths/(2*sqrt(2*log(2))); %gauss exponents as function of FWHM
SPDs = zeros( length(wv), length(Peak_Wavelengths) ); %preallocate matrix.

for i = 1:length(Peak_Wavelengths)
    SPDs(:,i) = Peak_Heights(i).*exp( - (wv - Peak_Wavelengths(i)).^2/ ( 2*sigmas(i)^2) ); %this could be vectorized, but I prefer a loop unless we run into speed issues
end

end