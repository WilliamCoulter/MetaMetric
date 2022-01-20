function [spectrumOut] = scaleSpdToOneCmf(spectrum,cmfUse,valOut, kBar)
%%takes in one spd and a cmf (like ybar) and  desired value of that
%%tristimulus value you want to come out. 4th argument is kBar and it is
%%presumed to be 683 if you do not input anything

spectrumIn(:,1) = spectrum;
cmfIn(1,:) = cmfUse;

if ~exist('kBar')
    kBar = 683;
end

valIn = kBar.* dot( spectrumIn, cmfIn); %say you feed in a spectrum and it is ybar, this just is the tristim value

spectrumOut = spectrumIn.*valOut/valIn;


end
