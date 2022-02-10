function [c,ceq] = uit_constraintsToConstraintVectors(SpdStruct, c,ceq,myUITableConstraints)
%UIT_CONSTRAINTSTOCONSTRAINTVECTORS Summary of this function goes here

t = myUITableConstraints;
% % colNames = uit_constraints.ColumnNames
% for i = 1:84
%     SpdStruct.(t{:,1}{i})
% end


for iMetric = 1:height(t) %go through each row (metric name)
    %     if t.UseTF(iMetric) == 1 %if the metric is used AT ALL
    if t{:,2}(iMetric)==1 %pull out via index

%         currentVal = SpdStruct.(t.Metrics{iMetric}); %Current spd value
        currentVal = SpdStruct.(t{:,1}{iMetric}); %Current spd value

        %% go through each equality types
        if t{:,3}(iMetric) == 1 %if we want to use less than
            constraintVal = t{:,4}(iMetric);
            c(end+1,1) = currentVal - constraintVal;
        end
        if t{:,5}(iMetric) == 1 %if we want to use equal to
            constraintVal = t{:,6}(iMetric); %value user set to be equal to
            ceq(end+1,1) = currentVal - constraintVal;
        end

        if t{:,7}(iMetric) == 1 %if we want to use greater than
            constraintVal = t{:,8}(iMetric);
            c(end+1,1) = -1* [ currentVal - constraintVal];
        end
    end
end

end

