% Coulter again edited this to load a mat file containing the array instead
% of csvreading it each time. It also only loads mat file once if it isn't
% there.

% Generate Planckian (blackbody) source

% Load table from IES-TM-30 online calc. 
% filePlanck = 'source_PlanckTable.csv';
% Table_Planck = csvread(filePlanck);

%beginning coulter edit
% persistent Table_Planck

% if isempty(Table_Planck)
%     load("Project_Libraries/Durmus_TM3020_Coulter_Edit/Table_Planck.mat");
% end

% end of coulter edit
% Table_Planck = [Table_Planck, ones(size(Table_Planck,1),2) ]; %add columns to preallocate
% for ttt=1:size(Table_Planck,1)
%  % distance between planck u,v and test u,v
% %     Table_Planck(ttt,4)=sqrt((u_t-Table_Planck(ttt,2))^2+(v_t-Table_Planck(ttt,3))^2);
% %     Table_Planck(ttt,5)=ttt;
%     Table_Planck(ttt,4:5)=[ sqrt((u_t-Table_Planck(ttt,2))^2+(v_t-Table_Planck(ttt,3))^2), ttt];
% %     Table_Planck(ttt,5)=ttt;
% end 
        
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