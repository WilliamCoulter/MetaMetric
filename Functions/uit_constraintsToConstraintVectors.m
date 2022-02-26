function [c,ceq] = uit_constraintsToConstraintVectors(SpdStruct,myUiConStruct, c,ceq)
%UIT_CONSTRAINTSTOCONSTRAINTVECTORS Summary of this function goes here

%  = myUiConStruct;
S_con = myUiConStruct; %rename for shorter code
% Recall that S_con is a structure array whose fields are the following.
% targetPath was obtained when the run optimization button was pressed, and
% it is a cell array of field names that acquire the value form SpdStruct
% %    Metric
%     LessThanTF
%     LessThanVal
%     EqualToTF
%     EqualToVal
%     GreaterThanTF
%     GreaterThanVal
%     targetPath


for conIdx = 1:numel(S_con)
    % Get the field value by using cell array argument chaining
%     disp("Current Constraint Metric is " + S_con(conIdx).Metric)

    currentVal = getfield(SpdStruct,S_con(conIdx).targetPath{:});

%     disp("Current Value Of Con Metric is " + string(currentVal) )

    % Add < constraint violation
    if S_con(conIdx).LessThanTF ==1
        constraintVal = S_con(conIdx).LessThanVal;
        c(end+1,1) = currentVal - constraintVal;
%         disp("Needs to be less than " + string(constraintVal) )
%         disp("Violation is " + string(c(end,1) ) )
    end
    % Add > constraint violation
    if S_con(conIdx).GreaterThanTF ==1
        constraintVal = S_con(conIdx).GreaterThanVal;
        c(end+1,1) = -1* [ currentVal - constraintVal];
%         disp("Needs to be greater than " + string(constraintVal) )
%         disp("Violation is " + string(c(end,1) ) )
    end
    % Add == constraint violation
    if S_con(conIdx).EqualToTF == 1
        constraintVal = S_con(conIdx).EqualToVal;
        ceq(end+1,1) = currentVal - constraintVal;
%         disp("Needs to be equal to " + string(constraintVal) )
%         disp("Violation is " + string(ceq(end,1) ) )
    end



end
% % for iMetric = 1:height(t) %go through each row (metric name)
%     if t(iMetric).UseTF == 1
%         currentVal = SpdStruct.(t(iMetric).Metric);
%         %% go through each equality types
%         if t(iMetric).EqualToTF == 1 %if we want to use equal to
%             constraintVal = t(iMetric).EqualToVal; %value user set to be equal to
%             ceq(end+1,1) = currentVal - constraintVal;
%         end
% %         if t.LessThanTF(iMetric) == 1 %if we want to use less than
%         if t(iMetric).LessThanTF == 1 %if we want to use less than
%             constraintVal = t(iMetric).LessThanVal;
%             c(end+1,1) = currentVal - constraintVal;
%         end
%         if t(iMetric).GreaterThanTF == 1 %if we want to use greater than
%             constraintVal = t(iMetric).GreaterThanVal;
%             c(end+1,1) = -1* [ currentVal - constraintVal];
%         end
%     end
% end

end

