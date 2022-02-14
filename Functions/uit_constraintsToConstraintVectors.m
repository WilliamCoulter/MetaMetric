function [c,ceq] = uit_constraintsToConstraintVectors(SpdStruct,myUiConStruct, c,ceq)
%UIT_CONSTRAINTSTOCONSTRAINTVECTORS Summary of this function goes here

t = myUiConStruct;
for iMetric = 1:height(t) %go through each row (metric name)
    if t(iMetric).UseTF == 1
        currentVal = SpdStruct.(t(iMetric).Metric);
        %% go through each equality types
        if t(iMetric).EqualToTF == 1 %if we want to use equal to
            constraintVal = t(iMetric).EqualToVal; %value user set to be equal to
            ceq(end+1,1) = currentVal - constraintVal;
        end
%         if t.LessThanTF(iMetric) == 1 %if we want to use less than
        if t(iMetric).LessThanTF == 1 %if we want to use less than
            constraintVal = t(iMetric).LessThanVal;
            c(end+1,1) = currentVal - constraintVal;
        end
        if t(iMetric).GreaterThanTF == 1 %if we want to use greater than
            constraintVal = t(iMetric).GreaterThanVal;
            c(end+1,1) = -1* [ currentVal - constraintVal];
        end
    end
end

end

