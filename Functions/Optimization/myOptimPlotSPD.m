function stop = myOptimPlotSPD(x,optimValues,state,varargin)


stop = false;
switch state
    case 'iter'
        % Reshape if x is a matrix
        x = x(:);
        xLength = length(x);
        xlabelText = getString(message('MATLAB:optimfun:funfun:optimplots:LabelNumberOfVariables',sprintf('%g',xLength)));

        % Display up to the first 100 values
        if length(x) > 100
            x = x(1:100);
            xlabelText = {xlabelText,getString(message('MATLAB:optimfun:funfun:optimplots:LabelShowingOnlyFirst100Variables'))};
        end
        
        if optimValues.iteration == 0
            % The 'iter' case is  called during the zeroth iteration,
            % but it now has values that were empty during the 'init' case
            plotx = bar(x);
            title(getString(message('MATLAB:optimfun:funfun:optimplots:TitleCurrentPoint')),'interp','none');
            ylabel(getString(message('MATLAB:optimfun:funfun:optimplots:LabelCurrentPoint')),'interp','none');
            xlabel(xlabelText,'interp','none');
            set(plotx,'edgecolor','none')
            set(gca,'xlim',[0,1 + xLength])
            set(plotx,'Tag','optimplotx');
        else
            plotx = findobj(get(gca,'Children'),'Tag','optimplotx');
            set(plotx,'Ydata',x);
        end 
end

