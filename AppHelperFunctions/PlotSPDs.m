%% Note that this is not a function. It just wraps a lot of commands into one name

%% Plot Data
plot(app.UIAxes_ImportedSPDs, 380:wlIntUser:780, app.userSPDs_Prop(:,1:end));
app.UIAxes_ImportedSPDs.XLim = [380,780];

