clc;
clear all;
close all;

year=2014;

addpath('/home/morin.37/poolA/wetland_data/Matlab_Tim/PostProcessSubs/');
%======================INPUT REQUIRING CHANGE==============================
DataDir=['/home/morin.37/poolA/wetland_data/Matlab_Tim/DouglasLake/Processed' num2str(year) '/'];
files=dir([DataDir 'flux/DOUG*']);
%==========================================================================

TotalLength=48*length(files);

load([DataDir 'flux/' files(1).name]);
VarsAll=fieldnames(fluxW);
i=1;
for v=1:length(VarsAll)
    Checker=VarsAll{v};
    if ~(length(Checker)>2 && strcmp(Checker(end-1:end),'QA'))
        Vars{i}=VarsAll{v};
        i=i+1;
    end
end
% Vars={'SWinbar','SWoutbar'}; %Test line

day1=str2double(files(1).name(end-11:end-9));
FullArrays=nan(TotalLength,length(Vars));
DECDAY=nan(TotalLength,1);

for v=1:length(Vars)
for i=1:length(files)
    load([DataDir 'flux/' files(i).name]);
    if eval(['isfield(fluxW,  ''' Vars{v} ''')  && size(fluxW.' Vars{v} ',2)==1']);
        eval(['FullArrays((i-1)*48+1:i*48,v)=fluxW.' Vars{v} ';']);
    end
    if v==1
        DECDAY((i-1)*48+1:i*48,1)=day1+(i-1):1/48:day1+i-1/48;
    end
end
end

for i=1:length(Vars)
    if eval(['isfield(fluxW,  ''' Vars{i} ''')  && size(fluxW.' Vars{i} ',2)==1']);
        figure;plot(DECDAY,FullArrays(:,i),'-bx');ylabel(Vars{i});
	saveas(gcf,['./out/' Vars{i} '.png']);close(gcf);
    end
end

if isfield(fluxW,'WDdegN') && (isfield(fluxW,'ubar') || isfield(fluxW,'ubar_1'))
    wind_dir_col=find(strcmp(Vars,'WDdegN'));
    if isfield(fluxW,'ubar')
        wind_speed_col=find(strcmp(Vars,'ubar'));
    elseif isfield(fluxW,'ubar_1')
        wind_speed_col=find(strcmp(Vars,'ubar_1'));
    end
    figure();wind_rose(FullArrays(:,wind_dir_col),FullArrays(:,wind_speed_col));
    saveas(gcf,'./out/WDdegN.png');close(gcf);
end
