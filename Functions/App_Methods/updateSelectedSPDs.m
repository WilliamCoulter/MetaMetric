function updateSelectedSPDs(app,event)
%% The only editable parts of the table should be the first column
% Therefore, no indexing is needed. Just query the selected
app.channelSelectedTF= app.UITable_ChannelSelection.Data{:,1};
%% Update spd plots
% Flip is needed because for whatever reason mathworks decided
% to have the order of children FLIPPED so that (1) calls the
% last one.
% https://www.mathworks.com/matlabcentral/answers/94662-why-is-the-order-of-child-handles-reversed-when-an-object-is-queried-for-the-children-property
[app.UIAxes_ImportedSPDs.Children(flip(~app.channelSelectedTF)).LineStyle] = deal('--');
[app.UIAxes_ImportedSPDs.Children(flip(~app.channelSelectedTF)).LineWidth] = deal(.5);

[app.UIAxes_ImportedSPDs.Children(flip(app.channelSelectedTF) ).LineStyle] = deal('-');
[app.UIAxes_ImportedSPDs.Children(flip(app.channelSelectedTF)).LineWidth] = deal(2);
%% Update cie diagram
% Flip is not needed because we are not calling children.
% THis method of updating is probably the smarter one
% considering the children flipping
currentFilledxy = findobj(app.UIAxes_ChromDiagram,...
    tag= "filledxySPDs");
currentFilledxy.XData = app.xyuserSPDLibrary( (app.channelSelectedTF),1);
currentFilledxy.YData = app.xyuserSPDLibrary((app.channelSelectedTF),2);
currentFilledxy.MarkerFaceColor = [0 0.8 0]; %green
%             currentFilledxy.
currentFilledxy.MarkerFaceAlpha = 0.25;
currentFilledxy.SizeData = 100;
end

