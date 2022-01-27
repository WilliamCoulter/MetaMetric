%% *Welcome To MetaMesmerize, Will C.*

%%%%% Assumptions
% 1) user spds are at 100%, so we divide by 100 to get spd/percent. Then
% we can multiply by 50 or 100 to get the real percent values.
% Reset everything
function [SpdMixOut,myOptimOptions,iterationStop] = Main_Optimizer_Function_App_mfile(spdPercents_0,spdChannels,  uit_constraints, myUiFun,appStopFlag)

%% *Setup Output function*
% https://www.mathworks.com/help/optim/ug/passing-extra-parameters.html
% https://www.mathworks.com/help/optim/ug/output-function-problem-based.html#UseAnOutputFunctionForProblemBasedOptimizationExample-3
myOutFun = @(solution,optimValues,state)myOutFunPassed(solution,optimValues,state,spdChannels,appStopFlag);

%% Optimizer Output
% Pass fixed parameters to objfun
objfun = @(spdPercents)myObjFun(spdPercents,spdChannels,myUiFun);

% Pass fixed parameters to confun
confun = @(spdPercents)myFunConstraint(spdPercents,spdChannels,uit_constraints);

%% Set optimization options
options = optimoptions('fmincon','MaxFunctionEvaluations',50000,...
    'MaxIterations',myUiFun.myOptIterations,'OutputFcn',myOutFun,'ScaleProblem',true,...
    'BarrierParamUpdate','predictor-corrector','HonorBounds',false,'TypicalX',50*ones(length(spdPercents_0),1),'UseParallel',false,...
    'PlotFcn',{@optimplotx,@optimplotfval,@optimplotconstrviolation});
%     'EnableFeasibilityMode',true,'SubproblemAlgorithm','cg'); %this line suggested by matlab

%% Run optimize function
[solution,objectiveValue] = fmincon(objfun,spdPercents_0,[],[],[],[],...
    zeros(size(spdPercents_0)),repmat(100,size(spdPercents_0)),confun,...
    options);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% These functions are called by fmincon
%% Objective function
    function [f] = myObjFun(spdPercents, spdChannels,myUiFun) % pg 1-39 of their optimization documentation pdf

        SpdMix = channelPercentsToSPDStruct(spdChannels,spdPercents);

        f = myUiFun.minOrMax*(SpdMix.(myUiFun.metric));

    end
%% Constraint Function

    function [c,ceq] = myFunConstraint(spdPercents, spdChannels,uit_constraints) % pg 1-39 of their optimization documentation pdf

        c = []; ceq = [];

        SpdMix = channelPercentsToSPDStruct(spdChannels,spdPercents);

        [c,ceq] = uit_constraintsToConstraintVectors(SpdMix, uit_constraints, c, ceq);

    end

%% Output Function
    function stop = myOutFunPassed(solution,optimValues,state,spdChannels,appStopFlag)
        %https://www.mathworks.com/help/optim/ug/output-functions.html
        %https://www.mathworks.com/help/optim/ug/output-function-problem-based.html
%         app.OptimizationRunStopTF_Prop
%         t = get(gcf);
        stop = false;
%         a = 1;
%         stop = app.OptimizationRunStopTF_Prop;
%         if stop == true
% %             SpdMixOut = channelPercentsToSPDStruct(spdChannels,solution);
% %             iterationStop = optimValues.iteration;
%             disp("entered")
%             return
%         end

%         stop = app.ButtonStop.Value
        switch state
            case 'init'
                myOptimOptions = options;

            case 'iter' %store only the only things that go to output function :(
                
                if optimValues.iteration ==0
%                     getappdata()
%                     disp(app.importedFileName_Prop)

%                     defFig = get(gcf);
%                     a=1;
%                     plotSPD = plot(spdChannels*spdPercents_0);
%                     set(gca, 'xlim',[380, 780]);
%                     set(plotSPD,'Tag','optimPlotSPD');
                elseif mod(optimValues.iteration,10) ==0
%                     disp(optimValues.iteration)
%                     plotSPD = findobj(get(gca,'Children'),'Tag','optimPlotSPD');
%                     set(plotSPD, 'YData', spdChannels*solution);
                end
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
