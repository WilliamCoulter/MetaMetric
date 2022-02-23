function [SpdMixOut,myOptimOptions,iterationStop] = Main_Optimizer_Function_App_mfile_practice(spdPercents_0,spdChannels, myUiCon,myUiFun)
%% *Setup Output function*
% https://www.mathworks.com/help/optim/ug/passing-extra-parameters.html
% https://www.mathworks.com/help/optim/ug/output-function-problem-based.html#UseAnOutputFunctionForProblemBasedOptimizationExample-3
myOutFun = @(solution,optimValues,state)myOutFunPassed(solution,optimValues,state,spdChannels,spdPercents);
%% Optimizer Output
% Pass fixed parameters to objfun
objfun = @(spdPercents)myObjFun(spdPercents,spdChannels,myUiFun);
% Pass fixed parameters to confun
confun = @(spdPercents)myFunConstraint(spdPercents,spdChannels,myUiCon);

%%
SpdMix = channelPercentsToSPDStruct(spdChannels,spdPercents);
% ;
%% Set optimization options
options = optimoptions('fmincon','MaxFunctionEvaluations',50000,...
    'MaxIterations',myUiFun.myOptIterations,'OutputFcn',myOutFun,'ScaleProblem',true,...
    'BarrierParamUpdate','predictor-corrector','HonorBounds',false,...
    'TypicalX',50*ones(length(spdPercents_0),1),'UseParallel',false,...
    'PlotFcn',{@optimplotx,@optimplotfval,@optimplotconstrviolation});
%% Run optimize function
[solution,objectiveValue] = fmincon(objfun,spdPercents_0,[],[],[],[],...
    zeros(size(spdPercents_0)),repmat(100,size(spdPercents_0)),confun,...
    options);
%% Objective function
    function [f] = myObjFun(spdPercents, spdChannels,myUiFun) % pg 1-39 of their optimization documentation pdf
%         SpdMix = channelPercentsToSPDStruct(spdChannels,spdPercents);
        f = myUiFun.minOrMax*(SpdMix.(myUiFun.metric));
    end
%% Constraint Function

    function [c,ceq] = myFunConstraint(spdPercents, spdChannels,myUiCon) % pg 1-39 of their optimization documentation pdf
        c = []; ceq = [];

%         SpdMix = channelPercentsToSPDStruct(spdChannels,spdPercents);
        [c,ceq] = uit_constraintsToConstraintVectors(SpdMix,myUiCon, c, ceq);
    end
%% Output Function
    function stop = myOutFunPassed(solution,optimValues,state,spdChannels,spdPercents)
        %https://www.mathworks.com/help/optim/ug/output-functions.html
        %https://www.mathworks.com/help/optim/ug/output-function-problem-based.html
        %         app.OptimizationRunStopTF_Prop
        %         t = get(gcf);
        stop = false;
        switch state
            case 'init'
                SpdMix = channelPercentsToSPDStruct(spdChannels,spdPercents);

                myOptimOptions = options;
            case 'iter' %store only the only things that go to output function :(
                SpdMix = channelPercentsToSPDStruct(spdChannels,spdPercents);
            case 'done' %recreate all the metrics
                SpdMixOut = channelPercentsToSPDStruct(spdChannels,solution);
                SpdMixOut.Solution = solution;
                iterationStop = optimValues.iteration;
        end
        SpdMixOut = channelPercentsToSPDStruct(spdChannels,solution);
        SpdMixOut.Solution = solution;
        SpdMixOut.IterationStop = optimValues.iteration;
        SpdMixOut.SpdPercents0 = spdPercents_0;
        iterationStop = optimValues.iteration;
    end


end
