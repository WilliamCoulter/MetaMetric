function [SpdMixOut,options,objectiveValue, fminconOutput,solution] = Main_Optimizer_Function_App_mfile(spdPercents_0,spdChannels, myUiCon,myUiFun,optimPlots)
% persistent SpdMix
%% *Setup Output function*
% https://www.mathworks.com/help/optim/ug/passing-extra-parameters.html
% https://www.mathworks.com/help/optim/ug/output-function-problem-based.html#UseAnOutputFunctionForProblemBasedOptimizationExample-3
myOutFun = @(solution,optimValues,state)myOutFunPassed(solution,optimValues,state,spdChannels);
SpdMix = [];
spdPercentsCheck = [];
% optimValuesHist = [];
% f = figure;
% plotAx = axes(f);
%% Optimizer Output
% Pass fixed parameters to objfun
objfun = @(spdPercents)myObjFun(spdPercents,spdChannels,myUiFun);

% Pass fixed parameters to confun
confun = @(spdPercents)myFunConstraint(spdPercents,spdChannels,myUiCon);

%% Set optimization options
options = optimoptions('fmincon','MaxFunctionEvaluations',50000,...
    'MaxIterations',myUiFun.myOptIterations,...
    'OutputFcn',myOutFun,...
    'ScaleProblem',true,...
    'BarrierParamUpdate','predictor-corrector',...
    'HonorBounds',false,...
    'TypicalX',50*ones(length(spdPercents_0),1),...
    'UseParallel',false);
%     'PlotFcn',{@optimplotx,@optimplotfval,@optimplotconstrviolation});%
% options.Display = 'iter';
% options.StepTolerance = 1;
% options = optimoptions('fmincon','MaxFunctionEvaluations',50000,...
%     'MaxIterations',myUiFun.myOptIterations,'ScaleProblem',true,...
%     'BarrierParamUpdate','predictor-corrector','HonorBounds',false,'TypicalX',50*ones(length(spdPercents_0),1),'UseParallel',false,...
%     'PlotFcn',{@optimplotfval});%
%
% 'PlotFcn',{@optimplotx,@optimplotfval,@optimplotconstrviolation});
%     'EnableFeasibilityMode',true,'SubproblemAlgorithm','cg'); %this line suggested by matlab

%% Run optimize function
[solution,objectiveValue,myExitFlag, fminconOutput] = fmincon(objfun,spdPercents_0,[],[],[],[],...
    zeros(size(spdPercents_0)),repmat(100,size(spdPercents_0)),confun,...
    options);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% These functions are called by fmincon
%% Objective function
    function [f] = myObjFun(spdPercents, spdChannels,myUiFun) % pg 1-39 of their optimization documentation pdf

        SpdMix = channelPercentsToSPDNestedStruct(spdChannels,spdPercents);

        f = myUiFun.minOrMax*( getfield( SpdMix, myUiFun.targetPath{:}) ) ;

        spdPercentsCheck = spdPercents;
    end
%% Constraint Function

    function [c,ceq] = myFunConstraint(spdPercents, spdChannels,myUiCon) % pg 1-39 of their optimization documentation pdf

        c = []; ceq = [];
        if any(spdPercents~= spdPercentsCheck)
            SpdMix = channelPercentsToSPDNestedStruct(spdChannels,spdPercents);
        end

        [c,ceq] = uit_constraintsToConstraintVectors(SpdMix,myUiCon, c, ceq);

    end


SpdMixOut = channelPercentsToSPDNestedStruct(spdChannels,solution);

% Output Function
    function stop = myOutFunPassed(solution,optimValues,state,spdChannels)
        %         %https://www.mathworks.com/help/optim/ug/output-functions.html
        %         %https://www.mathworks.com/help/optim/ug/output-function-problem-based.html
        stop = false;
        switch state
            case 'init'
%                 optimPlots(1).XData = NaN(options.MaxIterations,1);
%                 optimPlots(1).YData = NaN(options.MaxIterations,1);
%                 optimPlots(2).XData = NaN(options.MaxIterations,1);
%                 optimPlots(2).YData = NaN(options.MaxIterations,1);
            case 'iter' %store only the only things that go to output function :(
                currentIter = optimValues.iteration;
                if currentIter ~=0 %first iteration is 0, and we cannot index that way
                    try
                        optimPlots(1).XData(optimValues.iteration) = optimValues.iteration;
                    catch
                        error('caught'); %for debugging workspace.
                    end
                    % plot onto the two tiles
                    optimPlots(1).YData(optimValues.iteration) = optimValues.fval;
                    optimPlots(1).Parent.Title.String = "obj. val: " + optimValues.fval;
                    optimPlots(2).XData(optimValues.iteration) = optimValues.iteration;
                    optimPlots(2).YData(optimValues.iteration) = optimValues.constrviolation;
                    optimPlots(2).Parent.Title.String = "Constr Violation: " + optimValues.constrviolation;
                    drawnow
                end
            case 'done' %recreate all the metrics
                optimPlots(1).XData(optimValues.iteration) = optimValues.iteration;
                optimPlots(1).YData(optimValues.iteration) = optimValues.fval;
                optimPlots(2).XData(optimValues.iteration) = optimValues.iteration;
                optimPlots(2).YData(optimValues.iteration) = optimValues.constrviolation;
                drawnow
        end
    end
%




end
