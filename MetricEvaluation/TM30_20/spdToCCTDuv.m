function [CCT_test,Duv_test] = spdToCCTDuv( Stest, cmf2,Table_Planck)

% CCT and Duv calculation from Ohno (2014). Practical use and calculation of CCT and Duv. Leukos, 10(1), 47-55.
% combined method. Triangular (Duv<0.002) and parabolic solution
%%
xbar = cmf2(:,1);
ybar = cmf2(:,2);
zbar = cmf2(:,3);


%%
% Tristimulus values - 2 degree observer 
X_CCT_t = sum(Stest.*xbar);
Y_CCT_t = sum(Stest.*ybar);
Z_CCT_t = sum(Stest.*zbar);

% 1960 u v coordinates 
u_t = (4*X_CCT_t)/(X_CCT_t+15*Y_CCT_t+3*Z_CCT_t);
v_t = (6*Y_CCT_t)/(X_CCT_t+15*Y_CCT_t+3*Z_CCT_t);

L_fp  = sqrt((u_t-0.292)^2+(v_t-0.24)^2);
a_CCT = acos((u_t-0.292)/L_fp);
L_bb  = (-0.00616793*a_CCT^6)+(0.0893944*a_CCT^5)+(-0.5179722*a_CCT^4)+(1.5317403*a_CCT^3)+(-2.4243787*a_CCT^2)+(1.925865*a_CCT)-0.471106;
Duv_test_initial=L_fp-L_bb;
%%
% Find Duv. if |Duv| <0.002 triangular, otherwise parabolic 


Table_Planck(:,4) = sqrt( ( u_t - Table_Planck(:,2) ).^2 + (v_t - Table_Planck(:,3)).^2);
% Table_Planck(:,5) = 1:height(Table_Planck);

%find minumum value in Planck table
[minimum,m_m]=min(Table_Planck);
m_m=m_m(1,4);
      
%if chromaticity is outside of boundaries choose the min or max value
if m_m>950
    m_m=950;
elseif m_m<2
    m_m=2;
else
end

% find T_x by triangulation 
l_m=sqrt((Table_Planck(m_m+1,2)-Table_Planck(m_m-1,2))^2+(Table_Planck(m_m+1,3)-Table_Planck(m_m-1,3))^2);
x_m=(Table_Planck(m_m-1,4)^2-Table_Planck(m_m+1,4)^2+l_m^2)/(2*l_m);
T_x=Table_Planck(m_m-1,1)+(Table_Planck(m_m+1,1)-Table_Planck(m_m-1,1))*x_m/l_m;

% find Duv
v_Tx=Table_Planck(m_m-1,3)+(Table_Planck(m_m+1,3)-Table_Planck(m_m-1,3))*x_m/l_m;

if v_t-v_Tx >=0 
Duv_test=sqrt(Table_Planck(m_m-1,4)^2-x_m^2);  
else
Duv_test=sqrt(Table_Planck(m_m-1,4)^2-x_m^2)*-1;    
end

if abs(Duv_test_initial) >= 0.002
        X_poly =(Table_Planck(m_m+1,1)-Table_Planck(m_m,1))*(Table_Planck(m_m-1,1)-Table_Planck(m_m+1,1))*(Table_Planck(m_m,1)-Table_Planck(m_m-1,1));
    a_poly =(Table_Planck(m_m-1,1)*(Table_Planck(m_m+1,4)-Table_Planck(m_m,4))+Table_Planck(m_m,1)*(Table_Planck(m_m-1,4)-Table_Planck(m_m+1,4))+Table_Planck(m_m+1,1)*(Table_Planck(m_m,4)-Table_Planck(m_m-1,4)))*X_poly^-1;
    b_poly =-(Table_Planck(m_m-1,1)^2*(Table_Planck(m_m+1,4)-Table_Planck(m_m,4))+Table_Planck(m_m,1)^2*(Table_Planck(m_m-1,4)-Table_Planck(m_m+1,4))+Table_Planck(m_m+1,1)^2*(Table_Planck(m_m,4)-Table_Planck(m_m-1,4)))*X_poly^-1; 
    c_poly =-((Table_Planck(m_m-1,4)*(Table_Planck(m_m+1,1)-Table_Planck(m_m,1))*Table_Planck(m_m,1)*Table_Planck(m_m+1,1))+(Table_Planck(m_m,4)*(Table_Planck(m_m-1,1)-Table_Planck(m_m+1,1))*Table_Planck(m_m-1,1)*Table_Planck(m_m+1,1))+(Table_Planck(m_m+1,4)*(Table_Planck(m_m,1)-Table_Planck(m_m-1,1))*Table_Planck(m_m-1,1)*Table_Planck(m_m,1)))*X_poly^-1; 
    
    %T_x closest point on planckian radiation
    T_x    = -b_poly/(2*a_poly);
    
    % correction factor: applied if CCT table is more than 0.25% increments 
    % Planck_Rad2 CCT table is from IES calculator, which is 0.25% increments. no correction
    % T_x=T_x*0.99991;
   
   if v_t-v_Tx >=0 
   Duv_test = (a_poly*(T_x)^2)+(b_poly*T_x)+c_poly;  
   else
   Duv_test = -((a_poly*(T_x)^2)+(b_poly*T_x)+c_poly);    
   end
end
%%

% if abs(Duv_test_initial) < 0.002
%     % triangular solution 
%     Planck_Rad2_Coulter_Edit;     
% else
%     % parabolic solution 
%     Planck_Rad2_Coulter_Edit;
%       
%     X_poly =(Table_Planck(m_m+1,1)-Table_Planck(m_m,1))*(Table_Planck(m_m-1,1)-Table_Planck(m_m+1,1))*(Table_Planck(m_m,1)-Table_Planck(m_m-1,1));
%     a_poly =(Table_Planck(m_m-1,1)*(Table_Planck(m_m+1,4)-Table_Planck(m_m,4))+Table_Planck(m_m,1)*(Table_Planck(m_m-1,4)-Table_Planck(m_m+1,4))+Table_Planck(m_m+1,1)*(Table_Planck(m_m,4)-Table_Planck(m_m-1,4)))*X_poly^-1;
%     b_poly =-(Table_Planck(m_m-1,1)^2*(Table_Planck(m_m+1,4)-Table_Planck(m_m,4))+Table_Planck(m_m,1)^2*(Table_Planck(m_m-1,4)-Table_Planck(m_m+1,4))+Table_Planck(m_m+1,1)^2*(Table_Planck(m_m,4)-Table_Planck(m_m-1,4)))*X_poly^-1; 
%     c_poly =-((Table_Planck(m_m-1,4)*(Table_Planck(m_m+1,1)-Table_Planck(m_m,1))*Table_Planck(m_m,1)*Table_Planck(m_m+1,1))+(Table_Planck(m_m,4)*(Table_Planck(m_m-1,1)-Table_Planck(m_m+1,1))*Table_Planck(m_m-1,1)*Table_Planck(m_m+1,1))+(Table_Planck(m_m+1,4)*(Table_Planck(m_m,1)-Table_Planck(m_m-1,1))*Table_Planck(m_m-1,1)*Table_Planck(m_m,1)))*X_poly^-1; 
%     
%     %T_x closest point on planckian radiation
%     T_x    = -b_poly/(2*a_poly);
%     
%     % correction factor: applied if CCT table is more than 0.25% increments 
%     % Planck_Rad2 CCT table is from IES calculator, which is 0.25% increments. no correction
%     % T_x=T_x*0.99991;
%    
%    if v_t-v_Tx >=0 
%    Duv_test = (a_poly*(T_x)^2)+(b_poly*T_x)+c_poly;  
%    else
%    Duv_test = -((a_poly*(T_x)^2)+(b_poly*T_x)+c_poly);    
%    end
% 
% end
%%
% CCT of the test light source 
CCT_test = T_x;
% 1931 x y coordinates of the test light source 
x_test =(X_CCT_t)/(X_CCT_t+Y_CCT_t+Z_CCT_t);
y_test = (Y_CCT_t)/(X_CCT_t+Y_CCT_t+Z_CCT_t);
% 1976 u' v' coordinates of the test light source 
uprime_test = (4*X_CCT_t)/(X_CCT_t+15*Y_CCT_t+3*Z_CCT_t);
vprime_test = (9*Y_CCT_t)/(X_CCT_t+15*Y_CCT_t+3*Z_CCT_t);
end
