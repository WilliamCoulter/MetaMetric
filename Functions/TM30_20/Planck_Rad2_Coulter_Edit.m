function [Duv_test, m_m] = Planck_Rad2_Coulter_Edit

% Generate Planckian (blackbody) source


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