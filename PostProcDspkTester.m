clear all;clc;
% codedir='C:/Users/Tim/Desktop/MethaneCorrPaper/';
codedir='/home/morin.37/poolA/wetland_data/Matlab_Tim/PostProcessSubs/';
addpath(genpath(codedir));
%DataDir='/home/morin.37/poolA/wetland_data/Matlab_Tim/ORWRP/VariableStorage/';
DataDir='/home/morin.37/poolA/wetland_data/Matlab_Tim/DouglasLake/VariableStorage/';

%FluxDataDir='/home/morin.37/poolA/wetland_data/Matlab_Tim/ORWRP/';
FluxDataDir='/home/morin.37/poolA/wetland_data/Matlab_Tim/DouglasLake/';

% FluxDataDir='/home/morin.37/poolA/wetland_data/Matlab_Tim/ORWRP/';
% DataDir='C:/Users/Tim/Desktop/VariableStorage/';
% FluxDataDir='C:/Users/Tim/Desktop/VariableStorage/';
Vars={'GPP','H','LE','LWinbar','LWoutbar','L','NEE','Q','RNET','Resp','SWinbar','SWoutbar',...
    'net_lw','net_sw','pressure','rH','tair','ustar_1','ustar_2','vpd','wind_dir_1',...
    'wind_dir_2','wind_speed_1','wind_speed_2','USTflag'};

%RemovedVars={'SoilTemp','footprint_kidneys','footprint_lawns','footprint_wetland_edge','footprint_wetland_macro','footprint_wetland_tower','footprint_wetland_upland','footprint_wetland_water','footprint_wetland_water','footprint_wetlands_combo',,'footprint_flag'

DOYrange=[2013 158
          2013 261];

for i=1:length(Vars)
    eval([Vars{i} '_concat=[];']);
end
SW=[];dn=[];decyr=[];decd=[];
WT_1_con=[];WT_2_con=[];DO_1_con=[];DO_2_con=[];WL_con=[];
Outs=dir([DataDir 'SeasonNum*']);
Seasons=nan(length(Outs),1);
for i=1:length(Outs)
    Seasons(i)=str2double(Outs(i).name(10));
end
Seasons=unique(Seasons);

for i=1:length(Seasons)
    files=dir([DataDir 'SeasonNum' num2str(Seasons(i)) '*']);
    load([DataDir files(end).name]);
    if strcmp('Summer',SeasonStatus)
        SW=[SW;ones(length(Fc),1)];
    else
        SW=[SW;zeros(length(Fc),1)];
    end
    dn=[dn;daynight];decyr=[decyr;DECYear];decd=[decd;DECDAY];
    WT_1_con=[WT_1_con;extra_vars.WT_1_Avg];WT_2_con=[WT_2_con;extra_vars.WT_2_Avg];
    DO_1_con=[DO_1_con;extra_vars.DO_1];DO_2_con=[DO_2_con;extra_vars.DO_2];
    WL_con=[WL_con;extra_vars.WL];
    for j=1:length(Vars)
        eval([Vars{j} '_concat=[' Vars{j} '_concat;' Vars{j} '];']);
    end
end

start_year=DOYrange(1,1);
start_DOY=DOYrange(1,2);
end_year=DOYrange(2,1);
end_DOY=DOYrange(2,2);

if start_year==end_year
    totallength=end_DOY-start_DOY+1;
    DateList=nan(totallength,2);
    DateList(:,1)=start_year;
    DateList(:,2)=start_DOY:end_DOY;
else    
    ly1=leapyear(start_year);
    ly2=leapyear(start_year+1);
    year1total=(365+leapyear(start_year)-start_DOY)+1;
    year2total=365+ly2;
    year3total=end_DOY;
    totallength=year1total+year2total+year3total;
    DateList=nan(totallength,2);
    DateList(1:year1total,1)=start_year;
    DateList(year1total+1:year1total+year2total,1)=2012;
    DateList(year1total+year2total+1:end,1)=2013;
    DateList(1:year1total,2)=start_DOY:365+ly1;
    DateList(year1total+1:year1total+year2total,2)=1:365+ly2;
    DateList(year1total+year2total+1:end,2)=1:end_DOY;
end
loops=1;NumWindMeasures=2;
[DOY,DECDAY,DECYear,C,Fc,H,L,LE,LWinbar,LWoutbar,net_lw,net_sw,pressure,...
    p_vapor_bar,p_vaporSat_bar,Q,rho_cp,rH,RNET,SoilTemp,Spectral_correction,SWinbar,SWoutbar,tair,ustar_1,...
    ~,wts,ww,vv_1,wind_dir_1,wind_speed_1,ustar_2,vv_2,wind_dir_2,wind_speed_2,Total_PAR,Diffuse_PAR]=...
    InitializeArrays(totallength,loops,NumWindMeasures);
GPP=nan(length(DOY),1);
Resp=nan(length(DOY),1);
NetRad=nan(length(DOY),1);

for i=1:length(DateList)
    year=DateList(i,1);ly=leapyear(year);
    currentday=DateList(i,2);
    files=dir([FluxDataDir 'Processed' num2str(year) '/flux/DOUG_' num2str(year) '_' num2str(currentday,'%03.0f') '_flux*']);
    if ~isempty(files)
        load([FluxDataDir 'Processed' num2str(year) '/flux/' files(1).name]);
        GPP((i-1)*48+1:i*48)=fluxW.Fc;GPP(USTflag_concat | ~dn)=nan;
        Resp((i-1)*48+1:i*48)=fluxW.Fc;Resp(USTflag_concat | dn)=nan;
        H((i-1)*48+1:i*48)=fluxW.H;
        LE((i-1)*48+1:i*48)=fluxW.LE;
        LWinbar((i-1)*48+1:i*48)=fluxW.LWinbar;
        LWoutbar((i-1)*48+1:i*48)=fluxW.LWoutbar;
        L((i-1)*48+1:i*48)=fluxW.L;
        Q((i-1)*48+1:i*48)=fluxW.Q;
        RNET((i-1)*48+1:i*48)=fluxW.NetRad;
        %SoilTemp((i-1)*48+1:i*48)=fluxW.STat8cmOW_W1;
        SWinbar((i-1)*48+1:i*48)=fluxW.SWinbar;
        SWoutbar((i-1)*48+1:i*48)=fluxW.SWoutbar;
        net_lw((i-1)*48+1:i*48)=fluxW.NetRl;
        net_sw((i-1)*48+1:i*48)=fluxW.NetRs;
        pressure((i-1)*48+1:i*48)=fluxW.pressure;
        rH((i-1)*48+1:i*48)=fluxW.humbar;
        tair((i-1)*48+1:i*48)=fluxW.tair;
        ustar_1((i-1)*48+1:i*48)=fluxW.ustar;
        %ustar_2((i-1)*48+1:i*48)=fluxW.ustar_2;
        if isfield(fluxW,'WD_1_degN');
        wind_dir_1((i-1)*48+1:i*48)=fluxW.WD_1_degN;
        end
        %wind_dir_2((i-1)*48+1:i*48)=fluxW.WD_2_degN;
        wind_speed_1((i-1)*48+1:i*48)=fluxW.ubar;
        %wind_speed_2((i-1)*48+1:i*48)=fluxW.ubar_2;
        DO_1((i-1)*48+1:i*48)=fluxW.DO_1;
        DO_2((i-1)*48+1:i*48)=fluxW.DO_2;
        WT_1((i-1)*48+1:i*48)=fluxW.WT_1_Avg;
        WT_2((i-1)*48+1:i*48)=fluxW.WT_2_Avg;
        WL((i-1)*48+1:i*48)=fluxW.WL;
    end
    DOY((i-1)*48+1:i*48)=currentday;
    DECDAY((i-1)*48+1:i*48)=(0:1/48:1-1/48) + currentday;
    DECYear((i-1)*48+1:i*48)=year+DECDAY((i-1)*48+1:i*48)/(365+ly);
end
figure();plot(DECYear,GPP,'r.',DECYear,GPP_concat,'b.');title('GPP');
figure();plot(DECYear,Resp,'r.',DECYear,Resp_concat,'b.');title('Resp');
figure();plot(DECYear,H,'r.',DECYear,H_concat,'b.');title('H');
figure();plot(DECYear,LE,'r.',DECYear,LE_concat,'b.');title('LE');
figure();plot(DECYear,LWinbar,'r.',DECYear,LWinbar_concat,'b.');title('LWinbar');
figure();plot(DECYear,LWoutbar,'r.',DECYear,LWoutbar_concat,'b.');title('LWoutbar');
figure();plot(DECYear,Q,'r.',DECYear,Q_concat,'b.');title('Q');
figure();plot(DECYear,L,'r.',DECYear,L_concat,'b.');title('L');
figure();plot(DECYear,RNET,'r.',DECYear,RNET_concat,'b.');title('NetRad');
% figure();plot(DECYear,SoilTemp,'r.',DECYear,SoilTemp_concat,'b.');title('SoilTemp');
figure();plot(DECYear,SWinbar,'r.',DECYear,SWinbar_concat,'b.');title('SWinbar');
figure();plot(DECYear,SWoutbar,'r.',DECYear,SWoutbar_concat,'b.');title('SWoutbar');
figure();plot(DECYear,net_lw,'r.',DECYear,net_lw_concat,'b.');title('net_lw');
figure();plot(DECYear,net_sw,'r.',DECYear,net_sw_concat,'b.');title('net_sw');
figure();plot(DECYear,pressure,'r.',DECYear,pressure_concat,'b.');title('pressure');
figure();plot(DECYear,rH,'r.',DECYear,rH_concat,'b.');title('rH');
figure();plot(DECYear,tair,'r.',DECYear,tair_concat,'b.');title('tair');
figure();plot(DECYear,ustar_1,'r.',DECYear,ustar_1_concat,'b.');title('ustar_1');
figure();plot(DECYear,ustar_2,'r.',DECYear,ustar_2_concat,'b.');title('ustar_2');
figure();plot(DECYear,wind_dir_1,'r.',DECYear,wind_dir_1_concat,'b.');title('wind_dir_1');
figure();plot(DECYear,wind_speed_1,'r.',DECYear,wind_speed_1_concat,'b.');title('wind_speed_1');
figure();plot(DECYear,wind_speed_2,'r.',DECYear,wind_speed_2_concat,'b.');title('wind_speed_2');
figure();plot(DECYear,WT_1,'r.',DECYear,WT_1_con,'b.');title('WT_1');
figure();plot(DECYear,WT_2,'r.',DECYear,WT_2_con,'b.');title('WT_2');
figure();plot(DECYear,DO_1,'r.',DECYear,DO_1_con,'b.');title('DO_1');
figure();plot(DECYear,DO_2,'r.',DECYear,DO_2_con,'b.');title('DO_2');
figure();plot(DECYear,WL,'r.',DECYear,WL_con,'b.');title('WL');