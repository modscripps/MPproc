function MP2=MakeCTD_rawMP(pathstr,num,numz,filt);
%function MP2=MakeCTD_rawMP(pathstr,num,numz);
%Grab the raw data from a specified path and make a CTD structure out of
%it.  Do some basic processing and error checking on it.
%pathstr='~malford/Data/MP/HOME02/Mat/';

disp 'This routine has not been checked.  A glance at salinities indicated '
disp 'that they showed some spiking.  Also, temperature needs to be despiked.'
disp 'MHA 8/4/03'

%order of median filter
ord_med=5;
%lagged conductivity
off=1;

%Default is to filter
if nargin < 4 
    filt=1;
end


%numz=4000;
%num=1302;

%Make arrays
MP2.p=zeros(numz,num)*NaN;
MP2.t=MP2.p;
MP2.c=MP2.p;

disp 'loading raw data...'
for c=1:num
    DisplayProgress(c,100);
    if c<10 
        str1='000';
    elseif c>=10 & c<100
        str1='00';
    elseif c>=100 & c<1000
        str1='0';
    else str1='';
    end
    
    %eval(['a=load(''~malford/Data/MP/HOME02/Mat/raw' str1 num2str(c) ''');']);
    eval(['a=load(''' pathstr 'raw' str1 num2str(c) ''');']);
    a.ctemp(find(a.ctemp<0))=NaN;
    a.ccond(find(a.ccond<0))=NaN;
    a.ccond=medfilt1(a.ccond,ord_med);
    MP2.p(1:length(a.cpres),c)=a.cpres;
    MP2.t(1:length(a.ctemp),c)=a.ctemp;
    MP2.c(1+off:length(a.cpres)+off,c)=a.ccond; %put cond in at a lag

    Vx=-(a.Vab+a.Vef)/(2.*.707);
	Vy=(a.Vab-a.Vef)/(2.*.707);
    MP2.Vx(1:length(Vx),c)=Vx;
    MP2.Vy(1:length(Vy),c)=Vy;
    
end

[m,n]=size(MP2.t);
if filt ~=0
    disp 'filtering...'
    %filter t,c to 1 m and p to 5 m
    [b,a]=MHAButter(1/4,1);
    [bp,ap]=MHAButter(1/4,5);
    for c=1:n
        indg=find(~isnan(MP2.t(:,c)));
        if length(indg) > 3
            MP2.t(indg,c)=filtfilt(b,a,MP2.t(indg,c));
        end
        indg=find(~isnan(MP2.c(:,c)));
        if length(indg) > 3
            MP2.c(indg,c)=filtfilt(b,a,MP2.c(indg,c));
        end
        indg=find(~isnan(MP2.p(:,c)));
        if length(indg) > 3
            MP2.p(indg,c)=filtfilt(bp,ap,MP2.p(indg,c));
        end
    end
end

%Compute salinity for each, using S/m and MPa
%MP2.s = 1000*salinityfcn(MP2.c/10,MP2.t,MP2.p/100);
