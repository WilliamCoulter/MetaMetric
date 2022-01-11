%% Note that this is not a function. It just wraps a lot of commands into one name

%% Plot Data
plot(app.UIAxes_ImportedSPDs, 380:wlInt_User:780, app.userSPDsProp(:,1:end));
app.UIAxes_ImportedSPDs.XLim = [380,780];

