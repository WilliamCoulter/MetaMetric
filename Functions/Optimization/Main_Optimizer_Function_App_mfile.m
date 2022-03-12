function [SpdMixOut,options,objectiveValue, fminconOutput,solution] = Main_Optimizer_Function_App_mfile(spdPercents_0,spdChannels, myUiCon,myUiFun,plotAx)
% persistent SpdMix
%% *Setup Output function*
% https://www.mathworks.com/help/optim/ug/passing-extra-parameters.html
% https://www.mathworks.com/help/optim/ug/output-function-problem-based.html#UseAnOutputFunctionForProblemBasedOptimizationExample-3
myOutFun = @(solution,optimValues,state)myOutFunPassed(solution,optimValues,state,spdChannels);
SpdMix = [];
spdPercentsCheck = [];
% f = figure;
% plotAx = axes(f);
%% Optimizer Output
% Pass fixed parameters to objfun
objfun = @(spdPercents)myObjFun(spdPercents,spdChannels,myUiFun);

% Pass fixed parameters to confun
confun = @(spdPercents)myFunConstraint(spdPercents,spdChannels,myUiCon);

%% Set optimization options
options = optimoptions('fmincon','MaxFunctionEvaluations',50000,...
    'MaxIterations',myUiFun.myOptIterations,'OutputFcn',myOutFun,'ScaleProblem',true,...
    'BarrierParamUpdate','predictor-corrector','HonorBounds',false,'TypicalX',50*ones(length(spdPercents_0),1),'UseParallel',false);% 
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
% 
        stop = false;
% 
% 
% %         stop = app.ButtonStop.Value
        switch state
            case 'init'
%                 f = figure;
%                 plot(plotAx,optimValues.iteration,optimValues.fval,'-o');
%                 drawnow
%                 myOptimOptions = options;
% 
            case 'iter' %store only the only things that go to output function :(
%                 if mod(optimValues.iteration,2)
%                 plot(plotAx,optimValues.iteration,optimValues.fval,'-o');
%                 hold on;

                if mod(optimValues.iteration,3) ==0
                    plot(plotAx,optimValues.iteration,optimValues.fval,'-o');
                    hold on;
                    drawnow
                end
            case 'done' %recreate all the metrics
                plot(plotAx,optimValues.iteration,optimValues.fval,'-o');
                drawnow
% 
        end
%         SpdMixOut = channelPercentsToSPDNestedStruct(spdChannels,solution);
%         channelSolution = solution;
% 
    end
% 
% 



end
