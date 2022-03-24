function wrapper_UIFigureCloseRequest(app,event)
%WRAPPER_UIFIGURECLOSEREQUEST Summary of this function goes here
if isdeployed == 0
    saveMyDefaults(app,event);

end
end

