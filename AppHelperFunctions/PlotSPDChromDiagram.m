%% Note that this is not a function. It just wraps a lot of commands into one name

%% Create Chromaticity Diagram and place channel chromaticities
% [xyUserSPDs,XYZUserSPDs] = spdsToXyXYZ(userSPDs(:,1:end), 2 );%get xy chromaticities for the imported spds
%% Rename the functions argments to be the app's properties. 
% This is verbose but might help understand code better
xyUserSPDs = app.xyUserSPDs_Prop;
%% Add the xy coordinates of the spds to the chrom diagram plot
scatter(app.UIAxes_ChromDiagram, xyUserSPDs(:,1), xyUserSPDs(:,2) ); %plot them
%% Don't overwrite plot each time a new plot is added
% previous ones Note that using "hold on" by itself will NOT work https://www.mathworks.com/help/matlab/ref/uiaxes.html
hold(app.UIAxes_ChromDiagram,'on'); 
%% Set axis aspect ratio to be square. This is same as "axis square"
pbaspect(app.UIAxes_ChromDiagram,[1 1 1]);
%% Add the spectral locus and blackbody locus
plotChromDiagram(2,app.UIAxes_ChromDiagram); %add a 2 deg chrom diagram to the axis handle



