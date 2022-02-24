function wrapper_UIFigureCloseRequest(app,event)
%WRAPPER_UIFIGURECLOSEREQUEST Summary of this function goes here
saveMyDefaults(app,event);
delete(app,event)
end

