function [c,ceq] = uit_constraintsToConstraintVectors(SpdStruct,uit_constraints, c,ceq)
%UIT_CONSTRAINTSTOCONSTRAINTVECTORS Summary of this function goes here

t = uit_constraints;

for iMetric = 1:height(t) %go through each row (metric name)
%     if t.UseTF(iMetric) == 1 %if the metric is used AT ALL
    if t(iMetric).UseTF == 1

%         currentVal = SpdStruct.(t.Metrics{iMetric}); %Current spd value
        currentVal = SpdStruct.(t(iMetric).Metric);
        %% go through each equality types
%         if t.EqualToTF(iMetric) == 1 %if we want to use equal to
        if t(iMetric).EqualToTF == 1 %if we want to use equal to

%             constraintVal = t.EqualToVal(iMetric); %value user set to be equal to
            constraintVal = t(iMetric).EqualToVal; %value user set to be equal to

            ceq(end+1,1) = currentVal - constraintVal;
        end
%         if t.LessThanTF(iMetric) == 1 %if we want to use less than
        if t(iMetric).LessThanTF == 1 %if we want to use less than

            constraintVal = t(iMetric).LessThanVal;

%             constraintVal = t.LessThanVal(iMetric);
            c(end+1,1) = currentVal - constraintVal;
        end
%         if t.GreaterThanTF(iMetric) == 1 %if we want to use greater than
        if t(iMetric).GreaterThanTF == 1 %if we want to use greater than

%             constraintVal = t.GreaterThanVal(iMetric);
            constraintVal = t(iMetric).GreaterThanVal;

            c(end+1,1) = -1* [ currentVal - constraintVal];
        end
    end
end

end

