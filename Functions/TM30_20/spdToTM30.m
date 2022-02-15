function [SOut] = spdToTM30(StestIn)

%% ANSI_IES_TM_30_20_Coulter_Edit Help: Takes an spd from 380nm to 780nm in either 1 or 5nm increments (401,1) or (81,1)
%% and an array of CMFs
%% arrayCMFs should have [wavelength, x2,y2,z2, x10,y10,z10] in 380 to 780 in 1 nm increments
%%
arguments
    StestIn (1,1) {isstruct}
end

persistent A_CMF_Inside RxArray A_TCS_Inside A_DSeries_Inside A_Planck
% disp(width(StestIn))
%%Explanation of changes from original
% Note:

% 1) Edited to load the file as a mat instead of csv read each time, and made
% it persistent to only load if it wasn't used in function before
% 2) Output values as a struct, TM30
% 3) Assume SPD is 380:5:780 or 380:1:780
% 4) Loads TM30 V2.04 data instead of V2.01 toolbox
% 5) To avoid use of persistent, pass data as argument.

% Uncertainties / Todo:
% 1) Update CCT calculation
% 2)
%%
Stest = StestIn.s; % no index so the code is flexible. rewritten each time
%%move on with Stest as the metric to run
%% determine wl itnerval from iput stest
if length(Stest)==81
    wlInt = 5;
elseif length(Stest) == 401
    wlInt = 1;
elseif length(Stest) == 201
    wlInt = 2;
else
    error("SPD is in wrong wavelength range or interval")
end
%% I want to use persistent values, but I want them different from the table so I don't have issues
if isempty(A_CMF_Inside) || isempty(RxArray) || isempty(A_TCS_Inside) || isempty(A_DSeries_Inside)
    load('Standards\TM-30-18_tools_etc\TM30_V204_Arrays.mat');
    disp('Loading TM30 V2.04 Data')
    A_CMF_Inside = A_CMF;
    RxArray = A_CES(1:wlInt:end,2:end);

    A_TCS_Inside = A_TCS;
    A_DSeries_Inside = A_DSeries;
end

if isempty(A_Planck)
    fileName = 'Table_Planck.mat';
    filePath = which(fileName);
    %         load("Functions/TM30_20/Table_Planck.mat");
    load(filePath);
    disp('Loaded Table Planck')
    A_Planck = Table_Planck;
    A_Planck(:,5) = 1:height(A_Planck);
end
%% Calculate IES-TM-30-20, Rf, Rg, CCT and Duv
% IES TM-30: https://store.ies.org/product/tm-30-20-ies-method-for-evaluating-light-source-color-rendition/
% preserve code style from original
wavelength = A_CMF_Inside(1:wlInt:end,1); %it says it is unused, but it is used in CCT_Duv_Coulter_Edit
xbar        = A_CMF_Inside(1:wlInt:end,2); %it says it is unused, but it is used in CCT_Duv_Coulter_Edit
ybar        = A_CMF_Inside(1:wlInt:end,3); %it says it is unused, but it is used in CCT_Duv_Coulter_Edit
zbar        = A_CMF_Inside(1:wlInt:end,4); %it says it is unused, but it is used in CCT_Duv_Coulter_Edit
xbar_10     = A_CMF_Inside(1:wlInt:end,5);
ybar_10     = A_CMF_Inside(1:wlInt:end,6);
zbar_10     = A_CMF_Inside(1:wlInt:end,7);
%%
S_0 = A_DSeries_Inside(:,2);
S_0 = S_0(1:wlInt:end);

S_1 = A_DSeries_Inside(:,3);
S_1 = S_1(1:wlInt:end);

S_2 = A_DSeries_Inside(:,4);
S_2 = S_2(1:wlInt:end);
%% Rescale test SPD so SPDxVlamd=100
Stest=Stest*(100/sum(Stest.*ybar_10));
%% generate the reference illuminant
% calculate test SPD CCT and Duv (Tt) according to Ohno CCT Duv Leukos
[T_t, Duv_test] = spdToCCTDuv(Stest, [xbar,ybar,zbar],A_Planck ); %2deg cmf for cct calculation

%% Generate reference spectrum based on the CCT of the test source
if T_t <= 4000
    % Planckian radiation constants
    c2=0.014388;
    % IES TM-30-20 Excel calculator uses
    c1=3.7415*10^-16;

    % Le,lamnda numerator)
    Le_num = zeros(1,length(wavelength) );
    for kk=1:length(wavelength)
        Le_num(kk)=(c1/((wavelength(kk,1)*0.000000001)^5)/(exp(c2/((wavelength(kk,1)*0.000000001)*T_t))-1));
    end

    % Rescale ref SPD so SPDxVlamd=100
    Sref=Le_num'*(100/sum(Le_num'.*ybar_10));

elseif T_t >= 5000
    % daylight

    if T_t <= 7000
        x_D=((-4.6070*10^9)/T_t^3)+((2.9678*10^6)/T_t^2)+((0.09911*10^3)/T_t)+0.244063;
        y_D=-3*(x_D^2)+2.87*x_D-0.275;
    else
        x_D=((-2.0064*10^9)/T_t^3)+((1.9018*10^6)/T_t^2)+((0.24748*10^3)/T_t)+0.23704;
        y_D=-3*(x_D^2)+2.87*x_D-0.275;
    end

    M_1=(-1.3515-1.7703*x_D+5.9114*y_D)/(0.0241+0.2562*x_D-0.7341*y_D);
    M_2=(0.03-31.4424*x_D+30.0717*y_D)/(0.0241+0.2562*x_D-0.7341*y_D);
    Sref=S_0+(M_1*S_1)+(M_2*S_2);

    % Rescale ref SPD so SPDxVlamd=100
    Sref=Sref*(100/sum(Sref.*ybar_10));

else
    % a mix of Plackian and Daylight

    % Planckian radiation constants
    c2=0.014388;

    % Le,lamnda numerator)
    Le_num = zeros(1, length(wavelength) );
    for kk=1:length(wavelength)
        Le_num(kk)=(1/((wavelength(kk,1)*0.000000001)^5)/(exp(c2/((wavelength(kk,1)*0.000000001)*T_t))-1));
    end

    %(Le,lamnda denomenator)
    Le_denom = zeros(1, length(wavelength));
    for kk=1:length(wavelength)
        Le_denom(kk)=(1/((560*0.000000001)^5)/(exp(c2/((560*0.000000001)*T_t))-1));
    end

    % St,p (normalized Planckian)
    Sref_P=Le_num'./Le_denom';

    % normalize - max to area
    Sref_P3=Sref_P/sum(Sref_P);

    % daylight

    if T_t <= 7000
        x_D=((-4.6070*10^9)/T_t^3)+((2.9678*10^6)/T_t^2)+((0.09911*10^3)/T_t)+0.244063;
        y_D=-3*(x_D^2)+2.87*x_D-0.275;
    else
        x_D=((-2.0064*10^9)/T_t^3)+((1.9018*10^6)/T_t^2)+((0.24748*10^3)/T_t)+0.23704;
        y_D=-3*(x_D^2)+2.87*x_D-0.275;
    end
    M_1=(-1.3515-1.7703*x_D+5.9114*y_D)/(0.0241+0.2562*x_D-0.7341*y_D);
    M_2=(0.03-31.4424*x_D+30.0717*y_D)/(0.0241+0.2562*x_D-0.7341*y_D);
    Sref_D=S_0+(M_1*S_1)+(M_2*S_2);

    % normalize - max to area
    Sref_D3=Sref_D/sum(Sref_D);

    % mixed reference illuminant
    Sref=((5000-T_t)/1000)*Sref_P3+(1-((5000-T_t)/1000))*Sref_D3;

    % Rescale ref SPD so SPDxVlamd=100
    Sref=Sref*(100/sum(Sref.*ybar_10));
end
%%
cmf10 = [xbar_10, ybar_10, zbar_10];
[JUCS_test, aUCS_test, bUCS_test,~] = CIECAM02UCS(Stest,RxArray,cmf10);
[JUCS_ref, aUCS_ref, bUCS_ref, h_angle_ref] = CIECAM02UCS(Sref,RxArray,cmf10);

deltaE_CAM02 = sqrt((JUCS_test-JUCS_ref).^2+(aUCS_test-aUCS_ref).^2+(bUCS_test-bUCS_ref).^2);
%% Define hue bins
% code credit to Tucker Downs
% Rename my variables to fit Tucker Downs
test.CES.Jabz = [JUCS_test, aUCS_test, bUCS_test];
ref.CES.Jabz = [JUCS_ref, aUCS_ref, bUCS_ref];
%
hueBins = linspace(0,360,17); hueBins = hueBins(2:17);
sampleBins = sum(h_angle_ref(:)' < hueBins(:) );


mask = double(sampleBins == (1:16)');
mask(mask == 0) = nan;


test.Bins.Jabz = flip(permute(mean(test.CES.Jabz .* permute(mask, [2,3,1]), 'omitnan'), [3,2,1]));
ref.Bins.Jabz = flip(permute(mean( ref.CES.Jabz .* permute(mask, [2,3,1]), 'omitnan'), [3,2,1]));
% %%%%% Calculate Rg

refPgon = polyarea( ref.Bins.Jabz(:, 2),  ref.Bins.Jabz(:, 3));
testPgon = polyarea(test.Bins.Jabz(:, 2), test.Bins.Jabz(:, 3));

fullData.Rg = 100 * testPgon / refPgon;
% %%%%%%Rf per bin

mask = sampleBins == (1:16)';
n = sum(mask, 2);

Rfp = flip(100 - 6.73 * (sum(deltaE_CAM02' .* mask, 2) ./ n));
fullData.Bins.Rf = 10 * log(exp(Rfp/10)+1);

% %%%%%Rcs per bin

denom = sqrt(sum(ref.Bins.Jabz(:,[2,3]).^2, 2));
fullData.Bins.Rcs = ...
    (test.Bins.Jabz(:,2) - ref.Bins.Jabz(:,2)) ./ denom .* cosd(hueBins' - 11.25) +...
    (test.Bins.Jabz(:,3) - ref.Bins.Jabz(:,3)) ./ denom .* sind(hueBins' - 11.25);

% %%%%%Rhs per bin

fullData.Bins.Rhs = ...
    -(test.Bins.Jabz(:,2) - ref.Bins.Jabz(:,2)) ./ denom .* sind(hueBins' - 11.25) +...
    (test.Bins.Jabz(:,3) - ref.Bins.Jabz(:,3)) ./ denom .* cosd(hueBins' - 11.25);

%%
% for i = 1:width(StestIn)

binArgs(:,1) = reshape([ [ cellstr( "rfBin" + (1:numel(fullData.Bins.Rf(:)') )) ]; [num2cell(fullData.Bins.Rf(:)')] ] , [], 1);
binArgs(:,2) = reshape([ [ cellstr( "csBin" + (1:numel(fullData.Bins.Rcs(:)') )) ]; [num2cell(fullData.Bins.Rcs(:)')] ] , [], 1);
binArgs(:,3) = reshape([ [ cellstr( "hsBin" + (1:numel(fullData.Bins.Rhs(:)') )) ]; [num2cell(fullData.Bins.Rhs(:)')] ] , [], 1);
SOut = struct(binArgs{:});

SOut.hsBins = fullData.Bins.Rhs;
SOut.csBins = fullData.Bins.Rcs;
SOut.rfBins = fullData.Bins.Rf;

SOut.wl      = wavelength;
SOut.sref    = Sref;
SOut.stest   = Stest;
%     SOut.stest0  = SOut;

%     SOut.t2XYZ   = Stest'*[xbar,ybar,zbar];
t2XYZ   = Stest'*[xbar,ybar,zbar];
SOut.test2degX    = t2XYZ(1);
SOut.test2degY   = t2XYZ(2);
SOut.test2degZ  = t2XYZ(3);


%     SOut.t2xy    = SOut.t2XYZ(1:2)./sum(SOut.t2XYZ);
t2xy    = t2XYZ(1:2)./sum(t2XYZ);
SOut.test2degx = t2xy(1);
SOut.test2degy = t2xy(2);


%     SOut.t10XYZ  = Stest'*[xbar_10, ybar_10, zbar_10];
t10XYZ = Stest'*[xbar_10, ybar_10, zbar_10];
SOut.test10degX = t10XYZ(1);
SOut.test10degY = t10XYZ(2);
SOut.test10degZ = t10XYZ(3);

%     SOut.t10xy    = SOut.t10XYZ(1:2)./sum(SOut.t10XYZ);
t10xy    = t10XYZ(1:2)./sum(t10XYZ);
SOut.test10degx = t10xy(1);
SOut.test10degy = t10xy(2);


%     SOut.r2XYZ   = Sref'*[xbar,ybar,zbar];
r2XYZ = Sref'*[xbar,ybar,zbar];
SOut.ref2X = r2XYZ(1);
SOut.ref2Y = r2XYZ(2);
SOut.ref2Z = r2XYZ(3);

%     SOut.r10XYZ  = Sref'*[xbar_10,ybar_10,zbar_10];
r10XYZ  = Sref'*[xbar_10,ybar_10,zbar_10];
SOut.ref10X = r10XYZ(1);
SOut.ref10Y = r10XYZ(2);
SOut.ref10Z = r10XYZ(3);

SOut.cct     = T_t;
SOut.duv     = Duv_test;
%             Rf_hbin = 10*log(exp(Rf_h_temp/10)+1);

SOut.rf = 100 - 6.73 * (sum(deltaE_CAM02) ./ 99);
SOut.rg = fullData.Rg;


%     SOut.hsBins = fullData.Bins.Rhs;
%     SOut.csBins = fullData.Bins.Rcs;
%     SOut.rfBins = fullData.Bins.Rf;
%
% %     binArgs(:,1) = reshape( [ []])
%     binArgs(:,1) = reshape([ [ cellstr( "rfBin" + (1:numel(fullData.Bins.Rf) )) ]; [num2cell(fullData.Bins.Rf)] ] , [], 1);
%     binArgs(:,2) = reshape([ [ cellstr( "csBin" + (1:numel(fullData.Bins.Rcs) )) ]; [num2cell(fullData.Bins.Rcs)] ] , [], 1);
%     binArgs(:,3) = reshape([ [ cellstr( "hsBin" + (1:numel(fullData.Bins.Rhs) )) ]; [num2cell(fullData.Bins.Rhs)] ] , [], 1);


%     binFields = "hsBins" + string(1:numel(hsBins))


SOut.gref = ref.Bins.Jabz(:,2:3);
SOut.gtest = test.Bins.Jabz(:,2:3);

SOut.radWatts = trapz(SOut.wl, SOut.stest);
SOut.ler2  = SOut.test2degY./SOut.radWatts;
SOut.ler10 = SOut.test10degY./SOut.radWatts;


%     SOout = orderfields(SOut, [49:end, 1:48])
% end

end