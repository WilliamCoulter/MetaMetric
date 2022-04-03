function [melOut]= spdToMel(spd_In)
%%
persistent mel
if isempty(mel)
    load('C:\Users\Will\Box\Lighting Research Group\WilliamCoulter\Gantt Chart Deliverables\Software\Matlab_PNNL_Paper_Project\Project\Project_Data\Standards\Unknown\mel.mat')
end
spd(:,1) = spd_In;
k_bar = 72640.25; %scaling for melanopsin.

% mel= 72640.25*dot(melbar(:,2),input(inputmelstart:inputmelend,2));
Tristim = spd'*mel(:,2);

melOut= k_bar.*Tristim;

end