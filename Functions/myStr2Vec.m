function [dataOut] = myStr2Vec(dataString,listLength)
%%This is a replacement for str2num. I wanted to wrap the ui controls with
%%a short function, so, this is what I do.

%Code Credit from FannoFlow at Matalab's Discord
% if listLength >16
% elseif max(listLength) > listLength
%     error("There are only " + string(length(listLength)) + " of those")
% end

dataOut = dataString.erase(["[","]"]).split([",", " "]).double();
dataOut(isnan(dataOut)) = [];

if nargin > 1
    if max(dataOut) > listLength
        error("There are only " + string(length(listLength)) + " of those")
    end
    if min(dataOut) < 1
        error("You entered a negative value or 0 for list length")
    end
end
% if ~isempty(dataString)
%     dataOut = dataString.erase(["[","]"]).replace(","," ").split().double();
% else
%     dataOut = [];
% end

end

