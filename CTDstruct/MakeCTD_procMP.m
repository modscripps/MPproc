function MP = MakeCTD_procMP(pathstr,num,sk,output_eng,output_raw,output_raw_acm,output_nitrate)

% MP = MakeCTD_procMP(pathstr,[start end],sk,output_eng, output_raw,output_nitrate);
%
% Put gridded MP t, s and vel data into a CTD structure.
% Specify the path, and starting/ending profiles to process. [start/end] may
% be a single index, in which case a single profile is returned.
%
% We store NaN's in lat, lon and H, for adding in later.
%
% 1/2004 MHA
%
% This has been mostly superseded by MakeCTD_procMP_cruise_sn, which calls this routine and allows
% specification of the cruise and sn only - lat, lon and other information
% are filled in as well.
% 1/05 MHA
% 2/2012: added flag and ability to output SUNA nitrate data if present

if nargin < 3
	sk=1;
end

if nargin < 4
	output_eng = 0;
end
if nargin < 5
	output_raw = 0;
end
if nargin < 6
	output_raw_acm = 0 ;
end
if nargin < 7
	output_nitrate = 0;
end

if size(num) < 2
  st = num;
else
  st  = num(1);
  num = num(2);
end

numout = num-st+1;

% If nitrate is output, output eng too since the array sizes are the same.
if output_nitrate==1 && output_eng==0
    disp('nitrate selected; outputting engineering files too.')
    output_eng = 1;
end

% Get array size by loading the first file
c = st;
if c<10
  str1='000';
elseif c>=10 & c<100
  str1='00';
elseif c>=100 & c<1000
  str1='0';
else
  str1='';
end
%eval(['a=load(''~malford/Projects/GlobalOverturns/tmp/grd' str1 num2str(c) ''');']);
% eval(['a=load(''' pathstr 'grd' str1 num2str(c) ''');']);
LoadFile = fullfile(pathstr,sprintf('grd%04d',c));
a = load(LoadFile);

% Correct size was not being stored because a.tave is a row vector.
numz = length(a.tave(1:sk:end));
%[numz,dum]=size(a.tave(1:sk:end));

% Initialize datenum field
MP.datenum = nan(1,numout);

MP.p    = zeros(numz,1)*NaN;
MP.t    = zeros(numz,numout)*NaN;
MP.th   = MP.t;
MP.c    = MP.t;
MP.sgth = MP.t;
MP.s    = MP.t;
MP.u    = MP.t;
MP.v    = MP.t;
MP.w    = MP.t;
MP.dox  = MP.t;

if output_eng==1
  % We need to get to the ../mat directory.  Older deployments I called
  %the gridded directory grd instead of gridded; I include this for
  %backwards compatibility.
  if ~isempty(strfind(pathstr,'gridded'))
      pathstr2=pathstr(1:end-8);
      pathstr2=[pathstr2 'mat/'];
  elseif ~isempty(strfind(pathstr,'grd'))
      pathstr2=pathstr;
      pathstr2(end-3:end)='mat/';
  end
  
  eval(['ae=load(''' pathstr2 'raw' str1 num2str(c) ''');']);
  
  [numze,dum]=size(ae.epres(1:sk:end));
  MP.epres=zeros(numze,numout)*NaN;
  MP.evolt=zeros(numze,numout)*NaN;
  MP.ecurr=zeros(numze,numout)*NaN;
  MP.engtime=zeros(numze,numout)*NaN;
  MP.edpdt=zeros(numze,numout)*NaN;
  MP.eturb=zeros(numze,numout)*NaN; % 10/06 addition to allow loading in of turbidity data if present
  MP.eturbgain=zeros(numze,numout)*NaN; 
  MP.efluor=zeros(numze,numout)*NaN; % 2/12 addition to allow loading in of fluorometer data if present
  MP.efluorgain=zeros(numze,numout)*NaN; 
end

%output nitrate if selected - only sn106 has the SUNA.  Here we make
%arrays; we get the data in the loop below.
if output_nitrate==1
    MP.enitrate_umolperl=nan*MP.epres;
    MP.epres_suna=nan*MP.epres;
end

if output_raw==1
    %We need to get to the ../mat directory.  Older deployments I called
    %the gridded directory grd instead of gridded; I include this for
    %backwards compatibility.
    if ~isempty(strfind(pathstr,'gridded'))
        pathstr2=pathstr(1:end-8);
        pathstr2=[pathstr2 'mat/'];
    elseif ~isempty(strfind(pathstr,'grd'))
        pathstr2=pathstr;
        pathstr2(end-3:end)='mat/';
    end

    if output_eng==0 %load the file if we did not request engineering data
        eval(['ae=load(''' pathstr2 'raw' str1 num2str(c) ''');']);
    end
    nslop=50;
    [numzr,dum]=size(ae.cpres(1:end)); %Get enough room for variations in size
    MP.pr=zeros(numzr+nslop,numout)*NaN;
    MP.tr=zeros(numzr+nslop,numout)*NaN;
    MP.thr=zeros(numzr+nslop,numout)*NaN;
    MP.cr=zeros(numzr+nslop,numout)*NaN;
    MP.doxr=zeros(numzr+nslop,numout)*NaN;
    MP.sr=zeros(numzr+nslop,numout)*NaN;
    MP.sgthr=zeros(numzr+nslop,numout)*NaN;
    if output_raw_acm
        [numzra,dum]=size(ae.Vab); %Get enough room for variations in size
        MP.Vab=zeros(numzra+nslop,numout)*NaN;
        MP.Vcd=zeros(numzra+nslop,numout)*NaN;
        MP.Vef=zeros(numzra+nslop,numout)*NaN;
        MP.Vgh=zeros(numzra+nslop,numout)*NaN;
        MP.aHx=zeros(numzra+nslop,numout)*NaN;
        MP.aHy=zeros(numzra+nslop,numout)*NaN;
        MP.aHz=zeros(numzra+nslop,numout)*NaN;
        MP.aTx=zeros(numzra+nslop,numout)*NaN;
        MP.aTy=zeros(numzra+nslop,numout)*NaN;
     end
    
end

for c=st:num
    iout=c-st+1;
    DisplayProgress(c,1);
    if c<10
        str1='000';
    elseif c>=10 & c<100
        str1='00';
    elseif c>=100 & c<1000
        str1='0';
    else
        str1='';
    end

    %eval(['a=load(''~malford/Projects/GlobalOverturns/tmp/grd' str1 num2str(c) ''');']);
    %See if the file exists
    eval(['b=exist(''' pathstr 'grd' str1 num2str(c) '.mat' ''');']);
    if b == 2
        eval(['a=load(''' pathstr 'grd' str1 num2str(c) ''');']);
        %a.ctemp(find(a.ctemp<0))=NaN;
        MP.p(1:length(a.pgrid(1:sk:end)),1)=a.pgrid(1:sk:end);
        MP.t(1:length(a.tave(1:sk:end)),iout)=a.tave(1:sk:end);
        MP.s(1:length(a.tave(1:sk:end)),iout)=a.s_ave(1:sk:end);
        MP.c(1:length(a.tave(1:sk:end)),iout)=a.cave(1:sk:end); %9/3/2010 change: output cond too
        if ~isfield(a,'doxave')
            a.doxave=NaN;
        end

        if ~isempty(find(~isnan(a.doxave) & a.doxave > 0))

            %        if isfield(a,'doxave')
            MP.dox(1:length(a.tave(1:sk:end)),iout)=a.doxave(1:sk:end);
        end

        %MP.sgth(1:length(a.tave),c)=a.sigthave;
        %Compute th and sgth here
        pref=0;
        MP.th(1:length(a.pgrid(1:sk:end)),iout)=sw_ptmp(MP.s(:,iout),MP.t(:,iout),a.pgrid(1:sk:end)',pref); %change back to normal units 5/05

        %        D=sw_dens(MP.s(:,iout)/1000,MP.th(:,iout),pref/100);
        D=sw_dens(MP.s(:,iout),MP.th(:,iout),pref); %sw_dens changed back
        if max(D)>1000
            D=D-1000; %sometimes the toolbox does not subtract 1000.  Do it here.
        end

        MP.sgth(1:length(a.pgrid(1:sk:end)),iout)=D;

        MP.u(1:length(a.tave(1:sk:end)),iout)=a.uave(1:sk:end)/100;  %Put in m/s
        MP.v(1:length(a.tave(1:sk:end)),iout)=a.vave(1:sk:end)/100;
        MP.w(1:length(a.tave(1:sk:end)),iout)=a.wave(1:sk:end)/100;
        MP.datenum(iout)=a.startdaytime;
        MP.dpdtave(1:length(a.tave),iout)=a.dpdtave / 100; %include this for diagnostics
        if output_eng==1
            eval(['ae=load(''' pathstr2 'raw' str1 num2str(c) ''');']);
            MP.epres(1:length(ae.epres),iout)=ae.epres;
            MP.ecurr(1:length(ae.epres),iout)=ae.ecurr;
            MP.evolt(1:length(ae.epres),iout)=ae.evolt;
            MP.edpdt(1:length(ae.epres),iout)=ae.edpdt;
            MP.engtime(1:length(ae.epres),iout)=ae.engtime;
            if isfield(ae,'eturb')              %10/06: add turbidity if present
            MP.eturb(1:length(ae.epres),iout)=ae.eturb;
            MP.eturbgain(1:length(ae.epres),iout)=ae.eturbgain;
            end
            if isfield(ae,'efluor')              %2/12: add fluorometer if present
            MP.efluor(1:length(ae.epres),iout)=ae.efluor;
            MP.efluorgain(1:length(ae.epres),iout)=ae.efluorgain;
            end
            
        end
        
        %2/10/12: output nitrate.
        if output_nitrate==1
            %Get to the offload directory simply by saving pwd, cding to
            %it, getting with pwd and cding back to where we were.
            tmp=pwd;
            cd(pathstr)
            cd ../offload
%            datapath=fullfile(pathstr,'offload');
            datapath=pwd;
            cd(tmp)
            suna=read_mmp_sunaFCN(datapath,c);
%            suna.pres_suna(find(suna.pres_suna ==0))=nan;
            MP.enitrate_umolperl(1:length(suna.nitrate_umolperl),iout)=suna.nitrate_umolperl;
            MP.epres_suna(1:length(suna.nitrate_umolperl),iout)=suna.pres_suna;
            MP.enitrate_umolperl(find(MP.epres_suna ==0))=nan;
            MP.epres_suna(find(MP.epres_suna ==0))=nan;
        end
        
        if output_raw ==1
            if output_eng==0 %load the file if we did not request engineering data
                eval(['ae=load(''' pathstr2 'raw' str1 num2str(c) ''');']);
            end
            
            if output_raw_acm
                MP.Vab(1:length(ae.Vab),iout)=ae.Vab;
                MP.Vcd(1:length(ae.Vab),iout)=ae.Vcd;
                MP.Vef(1:length(ae.Vab),iout)=ae.Vef;
                MP.Vgh(1:length(ae.Vab),iout)=ae.Vgh;
                MP.aHx(1:length(ae.Vab),iout)=ae.aHx;
                MP.aHy(1:length(ae.Vab),iout)=ae.aHy;
                MP.aHz(1:length(ae.Vab),iout)=ae.aHz;
                MP.aTx(1:length(ae.Vab),iout)=ae.aTx;
                MP.aTy(1:length(ae.Vab),iout)=ae.aTy;
               
                
            end
            
            MP.pr(1:length(ae.cpres),iout)=ae.cpres;
            MP.tr(1:length(ae.cpres),iout)=ae.ctemp;
            MP.cr(1:length(ae.cpres),iout)=ae.ccond;

            if ~isfield(ae,'cdox') %fill in NaN's for dox if it does not exist.
                ae.cdox=NaN*ae.ctemp;
            end

            MP.doxr(1:length(ae.cpres),iout)=ae.cdox;

            %Compute salinity from the raw quantites - beware of spiking
            MP.sr(1:length(ae.cpres),iout) = 1000*salinityfcn(ae.ccond/10,ae.ctemp,ae.cpres/100);
            %pot temp
            thr=sw_ptmp(MP.sr(1:length(ae.cpres),iout),...
                ae.ctemp,ae.cpres,pref);
            MP.thr(1:length(ae.cpres),iout)=thr;

            MP.sgthr(1:length(ae.cpres),iout)=sw_dens(MP.sr(1:length(ae.cpres),iout),...
                thr,pref)-1000; %sw_dens changed back
        end
    end
    MP.id(iout)=c;
end

MP.yday=datenum2yday(MP.datenum);
MP.z=MP.p; 

MP.lat=NaN*ones(size(MP.yday));
MP.lon=NaN*ones(size(MP.yday));
MP.H=NaN*ones(size(MP.yday));
%MP.id=NaN*ones(size(MP.yday)); Filled in above as the profile number
MP.year=NaN*ones(size(MP.yday));

%Now remove zeros that were put in in the event that the largest file was
%larger than accounted for by nslop
if output_raw ==1
    ind=find(MP.pr==0);
    MP.pr(ind)=NaN;
    MP.tr(ind)=NaN;
    MP.cr(ind)=NaN;
    MP.sr(ind)=NaN;
    MP.thr(ind)=NaN;
    MP.sgthr(ind)=NaN;
end