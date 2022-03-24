function [SpdStruct] = spdToNewMetric(SpdStruct)
%This is a template for adding new metric to the program
% SpdStruct MUST be input argument AND output argument.


%% What do your metrics depend on? Create temporary variables
% Thus far, each metric can be determined solely from the spd power. Create
% a variable, spd, that exists only in this function so that the user does
% not need to type out "SpdStruct.Power.s" every time.
spd = SpdStruct.Power.s; %this is the current place the spd power is stored
wl = SpdStruct.Power.wl; 
%% Create new metrics, whose output must be scalar (size of 1x1)
% Create temporary metric variables. Note that these names are forgotten
% and not used anywhere else.

% Peak Wavelength
spdPeakWavelength = wl(  spd == max(spd) ); %get max wavelength number

% Let's be a little creative and measure coefficient of variation
spdCOV = std(spd)./ mean(spd);

% Maybe weighted mean?
spdMeanPerMax = mean(spd)./max(spd);

%% Ok, so now that all the metrics you wish to group under this new category,
% "nested structure" . "category" . "metric name"
% You only have control over the category name and the metric names.

SpdStruct.ExampleCategory.PeakWavelength = spdPeakWavelength;
SpdStruct.ExampleCategory.COV = spdCOV;
SpdStruct.ExampleCategory.MeanPerSum = spdMeanPerMax;

%Note that the SpdStruct.ExampleCategory.___ can have a name different than
%the one used to make the variables above. In fact, you could just directly
%assign it, but I feel that splitting it into multiple steps makes it
%easier for beginners.

end

