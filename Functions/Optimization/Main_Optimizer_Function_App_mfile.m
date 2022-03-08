function [SpdMixOut,myOptimOptions,objectiveValue, fminconOutput,channelSolution] = Main_Optimizer_Function_App_mfile(spdPercents_0,spdChannels, myUiCon,myUiFun)

%% *Setup Output function*
% https://www.mathworks.com/help/optim/ug/passing-extra-parameters.html
% https://www.mathworks.com/help/optim/ug/output-function-problem-based.html#UseAnOutputFunctionForProblemBasedOptimizationExample-3
myOutFun = @(solution,optimValues,state)myOutFunPassed(solution,optimValues,state,spdChannels);

%% Optimizer Output
% Pass fixed parameters to objfun
objfun = @(spdPercents)myObjFun(spdPercents,spdChannels,myUiFun);

% Pass fixed parameters to confun
confun = @(spdPercents)myFunConstraint(spdPercents,spdChannels,myUiCon);

%% Set optimization options
options = optimoptions('fmincon','MaxFunctionEvaluations',50000,...
    'MaxIterations',myUiFun.myOptIterations,'OutputFcn',myOutFun,'ScaleProblem',true,...
    'BarrierParamUpdate','predictor-corrector','HonorBounds',false,'TypicalX',50*ones(length(spdPercents_0),1),'UseParallel',false,...
    'PlotFcn',{@optimplotx,@optimplotfval,@optimplotconstrviolation});
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

    end
%% Constraint Function

    function [c,ceq] = myFunConstraint(spdPercents, spdChannels,myUiCon) % pg 1-39 of their optimization documentation pdf

        c = []; ceq = [];

        SpdMix = channelPercentsToSPDNestedStruct(spdChannels,spdPercents);

        [c,ceq] = uit_constraintsToConstraintVectors(SpdMix,myUiCon, c, ceq);

    end

%% Output Function
    function stop = myOutFunPassed(solution,optimValues,state,spdChannels)
        %https://www.mathworks.com/help/optim/ug/output-functions.html
        %https://www.mathworks.com/help/optim/ug/output-function-problem-based.html

        stop = false;


%         stop = app.ButtonStop.Value
        switch state
            case 'init'
                myOptimOptions = options;

            case 'iter' %store only the only things that go to output function :(
               
            case 'done' %recreate all the metrics


        end
        SpdMixOut = channelPercentsToSPDNestedStruct(spdChannels,solution);
        channelSolution = solution;

    end


end
