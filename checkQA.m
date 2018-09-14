clear all

%==========================USER INPUT HERE=================================
year=2015;
% datadirectory = '/home/morin.37/poolA/morin.37/Sylvania/Processed2013/flux/';
% datadirectory = ['/home/morin.37/poolA/wetland_data/Matlab_Tim/DouglasLake/Processed' num2str(year) '/flux/'];
datadirectory = 'D:/timWorkComputerBackup/Box Sync/OWCdata/Eddycov/flux/';
%datadirectory = ['/home/morin.37/poolA/wetland_data/Matlab_Tim/ORWRP/Processed' num2str(year) '/flux/'];
% files=dir([datadirectory 'SYLV*']);
%files=dir([datadirectory 'OWR*']);
files=dir([datadirectory '*flux.mat']);
%==========================================================================

load([datadirectory files(1).name]);
day1=str2double(files(1).name(end-11:end-9));
VarsAll=fieldnames(fluxW);
i=1;
for v=1:length(VarsAll)
    Checker=VarsAll{v};
    if length(Checker)>2 && strcmp(Checker(end-1:end),'QA')
        Vars{i}=VarsAll{v};
        i=i+1;
    end
end
%Vars={'LWinbarQA','LWoutbarQA','SWinbarQA','SWoutbarQA'};
TotalLength=length(files)*48;

MinMaxTest=nan(TotalLength,length(Vars));
STDTest=nan(TotalLength,length(Vars));
DECDAY=nan(TotalLength,1);

for v=1:length(Vars)
for CD=1:length(files)
    load([datadirectory files(CD).name]);
    if eval(['isfield(fluxW,''' Vars{v} ''')'])
        if eval(['length(fluxW.' Vars{v} '(:,3))==48'])
        eval(['MinMaxTest((CD-1)*48+1:CD*48,v)=fluxW.' Vars{v} '(:,3)+fluxW.' Vars{v} '(:,4);']);
        eval(['STDTest((CD-1)*48+1:CD*48,v)=fluxW.' Vars{v} '(:,5);']);
        end
    end
    if v==1
        DECDAY((CD-1)*48+1:CD*48,1)=(day1+CD-1):1/48:day1+CD-1/48;
    end
end
end

MinMaxTest(MinMaxTest==12)=0;

for i=1:length(Vars)
    figure;plot(DECDAY,MinMaxTest(:,i),'bx');ylabel(Vars{i});    
end
