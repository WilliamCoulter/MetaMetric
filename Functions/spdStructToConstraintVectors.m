function [c,ceq] = spdStructToConstraintVectors(SpdStruct, uiStruct,c,ceq)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% if abs(SpdStruct.duv) > 0.05
%     ind1 = find([uiStruct.metric] == "rf");
%     ind2 =find([uiStruct.metric] == "rfBins");% | ...
% %     uiStruct(ind1).tf = 0;
% %     uiStruct(ind2).tf = 0;
% %     SpdStruct.rf
% %        [uiStruct.metric] == "csBins" | ...
% %        [uiStruct.metric] == "hsBins" );
% %    uiStruct(inds).tf = 0;
%     
% end
t = uiStruct;
for i = 1:length([t]) %go through each metric
    if t(i).tf ==1 % if they clicked true on tf checkbox go on
        for j = 1:length( [t(i).eq] ) %for each equality value, go through each. This is for bins

            if isempty(t(i).list) %if the list is empty (because it is not a bin), then say it is 1
                t(i).list(j) = 1;
            end

            switch t(i).eq(j) %ith metric used and jth equality input

                case 1 %greater than
                        c(end+1,1)    = -1*[ SpdStruct.( t(i).metric)( t(i).list(j) )  - t(i).val(j)];

                case -1 %less than
                        c(end+1,1)    = ( SpdStruct.( t(i).metric)( t(i).list(j) )  - t(i).val(j) ); 
                case 0 %equal to
                       ceq(end+1,1)  = ( SpdStruct.( t(i).metric)( t(i).list(j) )  - t(i).val(j) ); 

                otherwise
                    error("Equality Constraint Input Error Need 0, -1, or 1")
            end

        end
    end
end
    
end

