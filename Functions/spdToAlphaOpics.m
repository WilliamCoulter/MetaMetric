function [SOut] = spdToAlphaOpics( SpdIn)
%% Takes in 380:1:780nm spd in Watts and returns a structure of the alpha-opic efficacies of luminous radiation according to CIE S026E2018 in "W/Lm"

%% Definition
% K_a,v (alpha opic efficacy of luminous radiation) is the quotientof the
% alpha-opic radiant flux and the luminous flux. They state that we can
% abbreviate it as "alpha opic ELR"
%% source data
%my vlambda is from luox's github, but CIE S026 E2018 uses ISO 23539/CIE
%010.
%% check against their standard (make equal energy by spd = ones(401,1)
% equal energy spectrum is supposed to give (Table A.1) [S,M,L,Rhod,Mel] = [0.756,
% 1.397, 1.639, 1.330, 1.201] mW/lm

%% Units in equation
% They say in 3.4 note 4 that AlphaOpic ELR is W/lm, but then in table A.1 they
% report as mW/lm. I will express as W/lm. The numerator and denominator
% should cancel out. The units are purely from the inverse of K_m

%Alpha Opic Radiant Flux (W)
%Luminous Flux (?)
%K_m is Lm/W

% Alpha Opic ELR ( mW/Lm) = (1/K_M) * (units cancel) = (1/K_m) * [Alpha
% Opic Radiant Flux / Luminous Flux]

% SOut.s = SpdIn; %keep original input as SpdOut. No matter what, we attach the fields of this function to SpdOut


arguments
    SpdIn (1,1) {isstruct}
end
%% Deal with possible (preferred) structure input
% if isstruct(SpdIn) == 1 %
%     %it is a sructure, so we want to go through this code and add the
%     %fields at the end to the input.
%     SOut = SpdIn;
%     spd = SpdIn.stest; %reassing and just get the spectrum, which is what the code expects. so it uses SpdIn, rewritten if it is struct
% elseif ~isstruct(SpdIn)
%     spd = SpdIn;
%     SOut.stest = SpdIn;
% end
% spd = SpdIn.s;
%% Set Constants
K_m = 683.002; %lm/Watt
unitScale = 1000; %default output is watts. Multiply by 1000 to get mW/lm

%%
% spd(:,1) = SpdIn; %ensure column vec
% 
if length(SpdIn.Power.s) ==401
    wlInt =1;
elseif length(SpdIn.Power.s) ==81
    wlInt = 5;
elseif length(SpdIn.Power.s) == 201
    wlInt = 2;
else
    error("wavelength interval is inocorrect")
end
% wlInt = 
%% Load Data
persistent T_Alpha_Opic_Radiometric
if isempty(T_Alpha_Opic_Radiometric)
    load('Standards\CIES026_E2018\CIE_S026_AlphaOpic_v1049a.mat','T_Alpha_Opic_Radiometric');
end
persistent vLambda1924
if isempty(vLambda1924)
    load('Standards\ISOCIE_11664_1_2019\LuminousEfficiencyFunction.mat','vLambda1924');
end
vLambda = vLambda1924(21:421,2); %vlambda cropped to 380:1:780
vLambda = vLambda(1:wlInt:end);
% [~,minInd] = min(abs(vLambda1924(:,1)-380));
% [~,maxInd] = min(abs(vLambda1924 - 780) );
% vLambda = vLambda1924(minInd:maxInd,2);

persistent smlmelrOpicLoad
if isempty(smlmelrOpicLoad)
%     smlmelrOpicLoad = [T_Alpha_Opic_Radiometric.sc(1:wlInt:end),T_Alpha_Opic_Radiometric.mc(1:wlInt:end),T_Alpha_Opic_Radiometric.lc(1:wlInt:end),...
%     T_Alpha_Opic_Radiometric.mel(1:wlInt:end),T_Alpha_Opic_Radiometric.rh(1:wlInt:end)];
%     smlmelrOpicLoad(isnan(smlmelrOpicLoad))=0;
    smlmelrOpicLoad = [T_Alpha_Opic_Radiometric.sc,T_Alpha_Opic_Radiometric.mc,T_Alpha_Opic_Radiometric.lc,...
    T_Alpha_Opic_Radiometric.mel,T_Alpha_Opic_Radiometric.rh];
    smlmelrOpicLoad(isnan(smlmelrOpicLoad))=0;
end
smlmelrOpic = smlmelrOpicLoad(1:wlInt:end,:);
%% Assign Values and remove Nans
% wlOpic = T_Alpha_Opic_Radiometric.nm;
% sOpic = T_Alpha_Opic_Radiometric.sc(1:wlInt:end);
% mOpic = T_Alpha_Opic_Radiometric.mc(1:wlInt:end); 
% lOpic = T_Alpha_Opic_Radiometric.lc(1:wlInt:end);
% rOpic = T_Alpha_Opic_Radiometric.rh(1:wlInt:end);
% melOpic = T_Alpha_Opic_Radiometric.mel(1:wlInt:end);


%remove nans if needed
% sOpic(isnan(sOpic))     = 0;
% mOpic(isnan(mOpic))     = 0;
% lOpic(isnan(lOpic))     = 0;
% melOpic(isnan(melOpic)) = 0;
% rOpic(isnan(rOpic))     = 0;
%% Obtain Luminous Efficacy Of Radiation

% spectrum is 401 x 1. Opics are 401 x5. We want a 5x1 or 1x5. 1x5 makes
% sense for each row to be a variable
%therefore, it is s' *opics
% alpha_opic_radiant_flux = spd'*[sOpic, mOpic, lOpic, melOpic, rOpic];
alpha_opic_radiant_flux = SpdIn.Power.s'*[smlmelrOpic];

% the luminous flux is the same for each opic calculation
luminous_flux           = K_m*SpdIn.Power.s'*vLambda;

% SOut.sOpicELR   = unitScale*(alpha_opic_radiant_flux(1) / luminous_flux);
% SOut.mOpicELR   = unitScale*(alpha_opic_radiant_flux(2) / luminous_flux);
% SOut.lOpicELR   = unitScale*(alpha_opic_radiant_flux(3) / luminous_flux);
% SOut.melOpicELR = unitScale*(alpha_opic_radiant_flux(4) / luminous_flux);
% SOut.rOpicELR   = unitScale*(alpha_opic_radiant_flux(5) / luminous_flux);
% sOpicELR   = unitScale*(alpha_opic_radiant_flux(1) / luminous_flux);
% mOpicELR   = unitScale*(alpha_opic_radiant_flux(2) / luminous_flux);
% lOpicELR   = unitScale*(alpha_opic_radiant_flux(3) / luminous_flux);
% melOpicELR = unitScale*(alpha_opic_radiant_flux(4) / luminous_flux);
% rOpicELR   = unitScale*(alpha_opic_radiant_flux(5) / luminous_flux);

smlmelrOpicELR = unitScale.*alpha_opic_radiant_flux/luminous_flux;
%% Obtain Daylight (D65) Efficacy Ratio
%Alpha Opic Efficacy of Luminous Radiation For Daylight (D65), CIE S026
%2018, 3.10
% K_D65.s = 0.8173; %mW/lm
% K_D65.m = 1.4558; %mW/lm
% K_D65.l = 1.6289; %mW/lm
% K_D65.mel = 1.3262;  %mW/Lm
% K_D65.r = 1.4497; %mW/lm
K_D65_smlmelr = [0.8173, 1.4558, 1.6289, 1.3262, 1.4497];

% Via Note 2 to entry, abbreviated term is Alpha-Opic DER

SOut.sOpicDER   = smlmelrOpicELR(1) / K_D65_smlmelr(1);
SOut.mOpicDER   = smlmelrOpicELR(2) / K_D65_smlmelr(2);
SOut.lOpicDER   = smlmelrOpicELR(3) / K_D65_smlmelr(3);
SOut.melOpicDER = smlmelrOpicELR(4) / K_D65_smlmelr(4);
SOut.rOpicDER   = smlmelrOpicELR(5) / K_D65_smlmelr(5);
% 
% SOut.ELR2 = luminous_flux/trapz( (380:wlInt:780), spd);

end
