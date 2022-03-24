function [J_UCS, a_UCS, b_UCS, hueAngle, M_UCS] = CIECAM02UCS(spdInput,RxArray,cmf10)
% clc


%% Load Standards
% load('Standards\TM-30-18_tools_etc\TM30_V204_Arrays.mat');
% disp('Loading TM30 V2.04 Data')

% wavelength = A_CMF(1:wlInt:end,1); %it says it is unused, but it is used in CCT_Duv_Coulter_Edit

% cmf2 = A_CMF(1:wlInt:end,2:4);
% cmf10 = A_CMF(1:wlInt:end, 5:7);

MCAT02= [0.7328 0.4296 -0.1624;
        -0.7036 1.6975 0.0061;
         0.0030 0.0136 0.9834];

MCAT02_inv =    [1.096123820835514,  -0.278869000218287,   0.182745179382773;
                 0.454369041975359,   0.473533154307412,   0.072097803717229;
               -0.009627608738429,  -0.005698031216113,   1.015325639954543];

           
MHPE = [0.38971  0.68898 -0.07868;
       -0.22981  1.18340  0.04641;
           0        0         1];
%% Take in spd and scale
spdInput_Y10 = spdInput'*cmf10(:,2);
spdInputScaled = (100/spdInput_Y10)*spdInput;
%% Basic parameters
YBackground = 20;
LA = 100; %Luminance of adapting field
F = 1;

% D degree of adaptation. between 0-1. D=1 to discount illuminant (Fairchild,CRICAM02UCS)  
% D=F*(1-(1/3.6)*exp((-LA-42)/92));
% change D for mixed adaptation
D=1;
% D = F*( 1 - (1/3.6)*exp( (-LA - 42)/92) ); %incomplete adaptation, D eq(2)

k = 1/(5*LA + 1);
FL=0.2*k^4*(5*LA)+0.1*(1-k^4)^2*((5*LA)^(1/3));
% n = YBackground/XYZ_W(2);
n = YBackground/100;

z = 1.48 + sqrt(n);
Nbb = 0.725*(1/n)^0.2;
Ncb = Nbb;

c = 0.69;
%%
% Rx = A_CES(1:wlInt:end,2:3);
%
wlInt = 400/(size(spdInput,1)-1); %determine interval

XYZ_Test     = (spdInputScaled.*RxArray(1:wlInt:end,:))'*cmf10;
XYZ_W = (spdInputScaled'*cmf10); 
%% Deal with the reference metrics. The reference is the same for all Rx values

RGB_W = XYZ_W*(MCAT02');

%%%%% Because we are setting D = 1, the true equation, commented out, is simplified. 
% D_RGB = [D*XYZw(2)/RGB_W(1) + 1 - D, D*XYZw(2)/RGB_W(2) + 1 - D, D*XYZw(2)/RGB_W(3) + 1 - D];
% D_RGB = [1*XYZw(2)/RGB_W(1) + 1 - 1, 1*XYZw(2)/RGB_W(2) + 1 - 1, 1*XYZw(2)/RGB_W(3) + 1 - 1];
% D_RGB = [XYZw(2)/RGB_W(1), XYZw(2)/RGB_W(2), XYZw(2)/RGB_W(3)];
% D_RGB = XYZw(2)/RGB_W; 
D_RGB = XYZ_W(2)./RGB_W; % D_RGB

% Convert the RGB (CAT02) that was chromatically adapted to Hunt-Pointer-Estevez RGB space via the MHPE matrix
RGB_W_HPE(1,:) = MHPE*MCAT02_inv*( (D_RGB.*RGB_W)' );

preProcess_RGB_W_H_HPE_Adapted =  ( (FL.*abs(RGB_W_HPE)./100).^0.42 );
% RGB_W_HPE_Adapted = 400*( ((FL*RGB_W_HPE/100).^0.42)   ./ (  ((FL*RGB_W_HPE/100).^0.42)  +27.13)  )+0.1;% RGB_Reference_CAT02
RGB_W_HPE_Adapted = 400*sign(RGB_W_HPE).*( preProcess_RGB_W_H_HPE_Adapted   ./ (  preProcess_RGB_W_H_HPE_Adapted  +27.13)  )+0.1;% RGB_Reference_CAT02

Aw = Nbb*( ( 2*RGB_W_HPE_Adapted(1) + RGB_W_HPE_Adapted(2) + RGB_W_HPE_Adapted(3)/20)  - 0.305);

%% Ok, so now do the reflected spds. Same as section above, except it is for 99 

RGB_Test = XYZ_Test*(MCAT02');
% RGB_Test_ChromAdapt = XYZ_Test(2)./RGB_Test;
RGB_Test_HPE = ( MHPE*MCAT02_inv*( (D_RGB.*RGB_Test)' ) )';

preProcessedPower = (FL*abs(RGB_Test_HPE)./100).^0.42;
% RGB_Test_Adapted = 400*(((FL*RGB_Test_HPE/100).^0.42)./((FL*RGB_Test_HPE/100).^0.42+27.13))+0.1;
% RGB_Test_Adapted = 400*(  (FL*abs(RGB_Test_HPE)./100).^0.42   ./(   (FL*abs(RGB_Test_HPE)./100).^0.42   +27.13))+0.1;
RGB_Test_Adapted = 400*(  preProcessedPower   ./(   preProcessedPower   +27.13))+0.1;


%%

a = RGB_Test_Adapted(:,1) - 12*RGB_Test_Adapted(:,2)./11 + RGB_Test_Adapted(:,3)./11;
b = (RGB_Test_Adapted(:,1) + RGB_Test_Adapted(:,2) - 2*RGB_Test_Adapted(:,3) )./9;

hueAngle = mod( 360+ atan2d(b,a),360) ;

%Hue composition not needed, but could be calculated as follows
% hueAngleAdj = hueAngle;
% hueAngleAdj(hueAngleAdj< 20.14) = hueAngleAdj(hueAngleAdj<20.14)+360; %adjust hue angle if it is below 20.14

et = (cos(hueAngle*pi/180+2)+3.8)/4;
%% achromatic response A
A = ( 2.*RGB_Test_Adapted(:,1) + RGB_Test_Adapted(:,2) + RGB_Test_Adapted(:,3)./20 - 0.305).*Nbb;
% Lightness J
J = 100.*(A./Aw).^(c*z);
% brightness q
Q = (4/c).*sqrt(J./100).*(Aw+4).*FL.^0.25;

t=(50000/13*1*Ncb*et.*sqrt(a.^2+b.^2))./( RGB_Test_Adapted(:,1) + RGB_Test_Adapted(:,2) + (21/20).*RGB_Test_Adapted(:,3) ); %Nc = 1


% similarly, this term appears multiple times
preProcessedTermN = (1.64 - 0.29.^n).^0.73;
PreProcessedPowert = t.^0.9;
% chroma
% C = (t.^0.9).*sqrt(J./100).*(1.64 - 0.29.^n).^0.73;
C   = PreProcessedPowert.*sqrt(J./100).*preProcessedTermN;

% colorfulness
M = C.*FL.^0.25;
%saturation
% s = 100.*sqrt(M./Q); 
%%


% ( RGB_Test_Adapted(:,1) + RGB_Test_Adapted(:,2) + (21/20).*RGB_Test_Adapted(:,3) );


% C=((t^0.9)*sqrt((100*(A/Aw)^(0.69*z))/100)*(1.64-0.29^n)^0.73 );
% M=((t.^0.9).*sqrt(  J./100) *(1.64-0.29.^n).^0.73 ).*FL.^0.25;
M=(PreProcessedPowert.*sqrt(   J./100)*( preProcessedTermN )  ).*   FL.^0.25;

% s=100*sqrt(M/Q);


% CIECAM02UCS coordinates 
% J_UCS=(1.7*(     100*(A./Aw).^(0.69*z)      ))./(1+0.007*(     100*(A./Aw).^(0.69*z)     ));
J_UCS=(1.7*(     J            ))./(1+0.007*(    J     ));

M_UCS=43.86.*log(1+0.0228.*M);
a_UCS=M_UCS.*cosd(hueAngle);
b_UCS=M_UCS.*sind(hueAngle);

end