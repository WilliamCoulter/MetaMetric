function [SpdStruct] = spdToNewMetric(SpdStruct)
%This is a template for adding new metric to the program
% SpdStruct MUST be input argument AND output argument.


%% What do your metrics depend on?
% Thus far, each metric can be determined solely from the spd power
spd = SpdStruct.Power.s; %this is the current place the spd power is stored
wl = SpdStruct.Power.wl;
%% Create new metrics, whose output must be scalar (size of 1x1)

% Weighted Mean
spdWeightedRange = ( max(spd) - min(spd) )./max(spd);

% Let's be a little creative and measure coefficient of variation
spdCOV = std(spd)./ mean(spd);

% Maybe weighted mean
spdMeanPerSum = mean(spd)./sum(spd);

%% Ok, so now that all the metrics you wish to group under this new category,
% "nested structure" . "category" . "metric name"


SpdStruct.ExampleCategory.wRange = spdWeightedRange;
SpdStruct.ExampleCategory.COV = spdCOV;
SpdStruct.ExampleCategory.MeanPerSum = spdMeanPerSum;

%Note that the SpdStruct.ExampleCategory.___ can have a name different than
%the one used to make the variables above. In fact, you could just directly
%assign it, but I feel that splitting it into multiple steps makes it
%easier for beginners.

end

