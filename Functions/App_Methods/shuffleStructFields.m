function [structOut] = shuffleStructFields(StructIn,cutNum)
%Shuffles the order of a scalar structure's fields similar to cut
%shufflling a deck of cards. Cuts the first 1:cutNum, inclusive, and
%shuffles to back

    myStartToCut = 1:1:cutNum; %index of fields to shuffle
    
    nFields = numel(fieldnames(StructIn) ); %get names
    if nFields <= cutNum
        error("Your structure does not have that many fields to shuffle")
    end

    myCutToEnd =  cutNum+1:nFields; %index of cards that are not cut
    myPermOrder = [myCutToEnd, myStartToCut]; %reorder indexes
    
    structOut = orderfields(StructIn, myPermOrder); %remake a struct
end

