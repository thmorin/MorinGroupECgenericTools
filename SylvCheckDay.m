% "TMSTAMP","RECNBR","t_hmp_Avg","rh_hmp_Avg","e_hmp_Avg","batt_volt_Avg","panel_temp_Avg","SR01Up_Avg","SR01Dn_Avg","IR01Up_Avg","IR01Dn_Avg","TC_Avg","water_content_1_Avg","elec_cond_1_Avg","ST_1_Avg","water_content_2_Avg","elec_cond_2_Avg","ST_2_Avg","water_content_3_Avg","elec_cond_3_Avg","ST_3_Avg","water_content_4_Avg","elec_cond_4_Avg","ST_4_Avg","PAR_Den_Avg"
%  1           2           4           5           6              7             8              9             10          11            12          13           14                  15               16                 17                  18         19                  20                21            22              23                  24            25          26                          


year=2013;
day = 365;

VarOI='Q';

datadir='/home/morin.37/poolA/wetland_data/Matlab_Tim/Sylvania/';
Site='SYLV';

addpath(genpath('/home/morin.37/poolA/wetland_data/Matlab_Tim/PreProcessSubs/'));

if strcmp(VarOI,'Tmp')
    VariableColumn=7;
    VarType='fast';
elseif strcmp(VarOI,'W')
    VariableColumn=6;
    VarType='fast';
elseif strcmp(VarOI,'V')
    VariableColumn=5;
    VarType='fast';
elseif strcmp(VarOI,'U')
    VariableColumn=4;
    VarType='fast';
elseif strcmp(VarOI,'Q')
    VariableColumn=10;
    VarType='fast';
elseif strcmp(VarOI,'humbar')
    VariableColumn=5;
    VarType='slow';
elseif strcmp(VarOI,'C')
    VariableColumn=9;
    VarType='fast';
elseif strcmp(VarOI,'wc4')
    VariableColumn=23;
    VarType='slow';
elseif strcmp(VarOI,'wc3')
    VariableColumn=20;
    VarType='slow';
elseif strcmp(VarOI,'wc2')
    VariableColumn=17;
    VarType='slow';
elseif strcmp(VarOI,'wc1')
    VariableColumn=14;
    VarType='slow';
end

[mo,d]=DayOY2Date(day,year);
load([datadir 'Processed' num2str(year) '/FastData/' Site '_' num2str(year) '_' num2str(day, '%03.0f') '_FastData.mat']);
load([datadir 'Processed' num2str(year) '/SlowData/' Site '_' num2str(year) '_' num2str(day, '%03.0f') '_SlowData.mat']);
load([datadir 'Processed' num2str(year) '/DespikeW/' Site '_' num2str(year) '_' num2str(day, '%03.0f') '_DespikeW.mat']);
load([datadir 'Processed' num2str(year) '/W1min/' Site '_' num2str(year) '_' num2str(day, '%03.0f') '_W1min.mat']);
load([datadir 'Processed' num2str(year) '/flux/' Site '_' num2str(year) '_' num2str(day, '%03.0f') '_flux.mat']);

if strcmp(VarType,'slow')
    RelColumn=Sdata(:,VariableColumn);
    NumRepsInHH=30;
elseif strcmp(VarOI,'Q') && day<121
    RelColumn=Fdata(:,VariableColumn)*(1000/18.0153);
    NumRepsInHH=30*60*10;
elseif strcmp(VarOI,'C') && day<121
    RelColumn=Fdata(:,VariableColumn)/44.01;
    NumRepsInHH=30*60*10;
else
    RelColumn=Fdata(:,VariableColumn);
    NumRepsInHH=30*60*10;
end

clearvars Fdata

eval(['A=repmat(fluxW.' VarOI 'QA(:,2),1,NumRepsInHH);']);
B=reshape(A',48*NumRepsInHH,1);

eval(['C=fluxW.' VarOI 'QA(:,3)+fluxW.' VarOI 'QA(:,4);']);
D=repmat(C,1,NumRepsInHH);
E=reshape(D',48*NumRepsInHH,1);

figure;plot(RelColumn,'bx');hold on;
if strcmp(VarType,'slow')
    if strcmp(VarOI,'tair')
       plot(W1min.Tm,'gx');
    elseif strcmp(VarOI,'p_vapor_bar')
       plot(W1min.Pvapor/1000,'gx');
    elseif strcmp(VarOI,'LWinbar')
       plot(W1min.IRUp,'gx');
    elseif strcmp(VarOI,'humbar')
       plot(W1min.Hum,'gx');
    else
       eval(['plot(W1min.' VarOI ',''gx'')']);
    end
else
    eval(['plot(DespikeW.' VarOI ',''gx'')']);
end
plot(B,'-xc');
plot(E,'-xk');
hold off
