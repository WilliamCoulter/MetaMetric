clc
clear
load('C:\Users\Will\OneDrive\MyMatlab\MetaMetric\Debugging\dummyUITable.mat')

%% Ok, so I have myUiCon as a struct array with each index being a metric
% where the fields are the values and names and types of constraints. I now
% have a uiTable that I can pull from to make the constraint vectors c, ceq
uit = t;

t = uit.Data
t.UseTF
%% Think through how to pull data from table
% How many rows in the constraint vectors c, ceq?
% Metric is used only if UseTF == true, and when it is true, there are at
% most 3 per metric for each of the three equality types.

%% Let's just use a loop to make it easier to read
% Loop each row (metric) and proceed to next loop if it is used (UseTF)
% Then go through each equality type and output to c, ceq
c=[];
ceq=[];
SpdStruct = spdToTM30(ones(401,1));
SpdStruct = spdToAlphaOpics(SpdStruct)
for iMetric = 1:height(t) %go through each row (metric name)
    if t.UseTF(iMetric) == 1 %if the metric is used AT ALL

        currentVal = SpdStruct.(t.Metrics{iMetric}); %Current spd value
        
        %% go through each equality types
        if t.EqualToTF(iMetric) == 1 %if we want to use equal to
            constraintVal = t.EqualToVal(iMetric); %value user set to be equal to
            ceq(end+1,1) = currentVal - constraintVal;
        end
        if t.LessThanTF(iMetric) == 1 %if we want to use less than
            constraintVal = t.LessThanVal(iMetric);
            c(end+1,1) = currentVal - constraintVal;
        end
        if t.GreaterThanTF(iMetric) == 1 %if we want to use greater than
            constraintVal = t.GreaterThanVal(iMetric);
            c(end+1,1) = -1* [ currentVal - constraintVal];
        end
    end
end




