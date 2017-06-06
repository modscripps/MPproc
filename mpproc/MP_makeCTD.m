function MP = MP_makeCTD(info,wh,get_eng,get_raw,get_raw_acm,get_nitrate,despiking)

% MP_MAKECTD Put gridded MP data into a CTD structure
%
%   MP = MP_makeCTD(INFO,WH,GET_ENG,GET_RAW,GET_RAW_ACM,GET_NITRATE,DESPIKING)
%   Put gridded MP ctd and velocity data into a CTD structure.
%
%   INPUT   info        - MP data structure
%           wh          - Vector with first and last profile to be
%                         processed. Leave empty to process all profiles.
%           get_eng     - Get engineering data (default 1)
%           get_raw     - Get raw ctd data (default 0)
%           get_raw_acm - Get raw acm data (default 0)
%           get_nitrate - Get nitrate data (default 0)
%           despiking   - Run despiking (default 0)
%       
%   OUTPUT  MP - MP data structure in CTD format with lots of fields.
%
%   This is a combination of MakeCTD_procMP_cruise_sn.m and
%   MakeCTD_procMP_cruise_sn2.m.
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 10/08/2015

% Parse values from the info structure
sn      = info.sn;
cruise  = info.cruise;
mooring = info.station;

mpdatadir = MP_basedatadir(info);

% Set defaults
if nargin < 2 || isempty(wh)
  wh = [1 info.n_profiles];
end
if nargin < 3
  get_eng = 1;
end
if nargin < 4
  get_raw = 0;
end
if nargin < 5
  get_raw_acm = 0;
end
if nargin < 6
  get_nitrate = 0;
end
if nargin < 7
  despiking = 0;
end


pref = 0;

% See how many profiles we are processing
if size(wh) < 2
  st = wh;
else
  st  = wh(1);
  wh = wh(2);
end
numout = wh-st+1;

% If nitrate is output, output eng too since the array sizes are the same.
if get_nitrate==1 && get_eng==0
  fprintf(1,'nitrate selected; outputting engineering files too.\n');
  get_eng = 1;
end

% Get array size by loading the first file
LoadFile = fullfile(mpdatadir,'gridded',sprintf('grd%04d',st));
a = load(LoadFile);
numz = length(a.tave);

% Initialize datenum field
MP.datenum = nan(1,numout);

% Pre-allocate other fields
MP.p    = nan(numz,1);
MP.t    = nan(numz,numout);
MP.th   = MP.t;
MP.c    = MP.t;
MP.sgth = MP.t;
MP.s    = MP.t;
MP.u    = MP.t;
MP.v    = MP.t;
MP.w    = MP.t;
MP.dox  = MP.t;
MP.pitch = MP.t;
MP.roll  = MP.t;
MP.time  = MP.t;

% Engineering fields
if get_eng==1
  EngFile = fullfile(mpdatadir,'mat',sprintf('raw%04d',st));
  ae = load(EngFile);
  [numze,dum] = size(ae.epres);
  MP.epres      = nan(numze,numout);
  MP.evolt      = nan(numze,numout);
  MP.ecurr      = nan(numze,numout);
  MP.engtime    = nan(numze,numout);
  MP.edpdt      = nan(numze,numout);
  MP.eturb      = nan(numze,numout);
  MP.eturbgain  = nan(numze,numout);
  MP.efluor     = nan(numze,numout);
  MP.efluorgain = nan(numze,numout);
end

% Nitrate fields
if get_nitrate==1
    MP.enitrate_umolperl = nan*MP.epres;
    MP.epres_suna        = nan*MP.epres;
end

% Raw ctd fields
if get_raw
  RawFile = fullfile(mpdatadir,'mat',sprintf('raw%04d',st));
  if ~get_eng
    ae = load(RawFile); % We probably already got this file above for eng
  end
  nslop = 50;
  [numzr,dum] = size(ae.cpres); % Get enough room for variations in size
  MP.pr    = nan(numzr+nslop,numout);
  MP.tr    = nan(numzr+nslop,numout);
  MP.thr   = nan(numzr+nslop,numout);
  MP.cr    = nan(numzr+nslop,numout);
  MP.doxr  = nan(numzr+nslop,numout);
  MP.sr    = nan(numzr+nslop,numout);
  MP.sgthr = nan(numzr+nslop,numout);
end


% Raw acm fields (only if this is an FSI ACM)
if get_raw_acm && ~strncmp(info.VELsensor.sn,'AQD',3)
  RawFile = fullfile(mpdatadir,'mat',sprintf('raw%04d',st));
  if ~get_eng || ~get_raw
    ae = load(RawFile); % We probably already got this file above for eng
  end
  nslop = 50;
  [numzra,dum] = size(ae.Vab); %Get enough room for variations in size
  MP.Vab = nan(numzra+nslop,numout);
  MP.Vcd = nan(numzra+nslop,numout);
  MP.Vef = nan(numzra+nslop,numout);
  MP.Vgh = nan(numzra+nslop,numout);
  MP.aHx = nan(numzra+nslop,numout);
  MP.aHy = nan(numzra+nslop,numout);
  MP.aHz = nan(numzra+nslop,numout);
  MP.aTx = nan(numzra+nslop,numout);
  MP.aTy = nan(numzra+nslop,numout);
end


% Loop over all gridded files
textprogressbar('Reading all grid files:    ');

for c = st:wh
  textprogressbar(c/wh*100);

  iout = c-st+1;

  GrdFile = fullfile(mpdatadir,'gridded',sprintf('grd%04d.mat',c));
  if exist(GrdFile,'file')
    a = load(GrdFile);

    MP.p(1:length(a.pgrid),1)   = a.pgrid;
    MP.t(1:length(a.tave),iout) = a.tave;
    MP.s(1:length(a.tave),iout) = a.s_ave;
    MP.c(1:length(a.tave),iout) = a.cave;
    MP.time(1:length(a.tave),iout) = a.ctimave;

    if ~isfield(a,'doxave')
      a.doxave = NaN;
    end
    if ~isempty(find(~isnan(a.doxave) & a.doxave > 0))
      MP.dox(1:length(a.tave),iout) = a.doxave;
    end     

    % Compute th and sgth here if this is not a SBE52
    if ~isempty(strfind(info.CTDsensor.sn,'SBE-MP52'))
      pref = 0;
      MP.th(1:length(a.pgrid),iout) = sw_ptmp(MP.s(:,iout),MP.t(:,iout),...
                                              a.pgrid',pref);
      D = sw_dens(MP.s(:,iout),MP.th(:,iout),pref);
      if max(D)>1000
        D = D-1000; % sometimes the toolbox does not subtract 1000
      end
      MP.sgth(1:length(a.pgrid),iout) = D;

    else % has already been calculated in MP_ctd_proc_MP52
      MP.th(1:length(a.tave),iout)   = a.thetave;
      MP.sgth(1:length(a.tave),iout) = a.sigthave;
    end

    MP.u(1:length(a.tave),iout) = a.uave;
    MP.v(1:length(a.tave),iout) = a.vave;
    MP.w(1:length(a.tave),iout) = a.wave;

    MP.datenum(iout) = a.startdaytime;
    
    if isfield(a,'Txave')
    MP.pitch(1:length(a.Txave),iout) = a.Txave;
    MP.roll(1:length(a.Tyave),iout)  = a.Tyave;
    end
    
    % include profiling speed for diagnostics:
    MP.dpdtave(1:length(a.tave),iout) = a.dpdtave / 100;


    if get_eng
      EngFile = fullfile(mpdatadir,'mat',sprintf('raw%04d',c));
      ae = load(EngFile);
      MP.epres(1:length(ae.epres),iout)   = ae.epres;
      MP.ecurr(1:length(ae.epres),iout)   = ae.ecurr;
      MP.evolt(1:length(ae.epres),iout)   = ae.evolt;
      MP.edpdt(1:length(ae.epres),iout)   = ae.edpdt;
      MP.engtime(1:length(ae.epres),iout) = ae.engtime;
      if isfield(ae,'eturb')
        MP.eturb(1:length(ae.epres),iout)     = ae.eturb;
        MP.eturbgain(1:length(ae.epres),iout) = ae.eturbgain;
      end
      if isfield(ae,'efluor')
        MP.efluor(1:length(ae.epres),iout)     = ae.efluor;
        MP.efluorgain(1:length(ae.epres),iout) = ae.efluorgain;
      end
    end


    if get_nitrate
      NitratePath = fullfile(mpdatadir,'offload');
      suna = read_mmp_sunaFCN(NitratePath,c);
      MP.enitrate_umolperl(1:length(suna.nitrate_umolperl),iout) = suna.nitrate_umolperl;
      MP.epres_suna(1:length(suna.nitrate_umolperl),iout) = suna.pres_suna;
      MP.enitrate_umolperl(MP.epres_suna==0) = NaN;
      MP.epres_suna(MP.epres_suna ==0) = NaN;
    end
    
    if get_raw
      % Load the file if we did not request engineering data
      if ~get_eng
        EngFile = fullfile(mpdatadir,'mat',sprintf('raw%04d',c));
        ae = load(EngFile);
      end
      
      % Raw CTD
      MP.pr(1:length(ae.cpres),iout)   = ae.cpres;
      MP.tr(1:length(ae.cpres),iout)   = ae.ctemp;
      MP.cr(1:length(ae.cpres),iout)   = ae.ccond;
            
      % Compute derived from the raw quantites - beware of spiking
      MP.sr(1:length(ae.cpres),iout) = 1000*salinityfcn(ae.ccond/10,ae.ctemp,ae.cpres/100);
      MP.thr(1:length(ae.cpres),iout) = sw_ptmp(MP.sr(1:length(ae.cpres),iout),...
                                                ae.ctemp,ae.cpres,pref);
      MP.sgthr(1:length(ae.cpres),iout) = sw_dens(MP.sr(1:length(ae.cpres),iout),...
          MP.thr(1:length(ae.cpres),iout),pref)-1000;
      
      % Raw Oxygen
      if ~isfield(ae,'cdox') %fill in NaN's for dox if it does not exist.
        ae.cdox = NaN*ae.ctemp;
      end
      MP.doxr(1:length(ae.cpres),iout) = ae.cdox;
      
      % Raw Velocity
      if get_raw_acm && ~strncmp(info.VELsensor.sn,'AQD',3)
        MP.Vab(1:length(ae.Vab),iout) = ae.Vab;
        MP.Vcd(1:length(ae.Vab),iout) = ae.Vcd;
        MP.Vef(1:length(ae.Vab),iout) = ae.Vef;
        MP.Vgh(1:length(ae.Vab),iout) = ae.Vgh;
        MP.aHx(1:length(ae.Vab),iout) = ae.aHx;
        MP.aHy(1:length(ae.Vab),iout) = ae.aHy;
        MP.aHz(1:length(ae.Vab),iout) = ae.aHz;
        MP.aTx(1:length(ae.Vab),iout) = ae.aTx;
        MP.aTy(1:length(ae.Vab),iout) = ae.aTy;
      end

    end   

  end % profile exists
  
  MP.id(iout) = c;
  
end % loop over all profiles

textprogressbar(' Done');


% Convert velocities to m/s if not an aquadopp
if ~strncmp(info.VELsensor.sn,'AQD',3)
  MP.u = MP.u./100;
  MP.v = MP.v./100;
  MP.w = MP.w./100;
end

% More MP info stuff
MP.yday = datenum2yday(MP.datenum);

MP.info = info;
MP.H    = MP.info.H*ones(size(MP.yday));
MP.lat  = MP.info.lat*ones(size(MP.yday));
MP.lon  = MP.info.lon*ones(size(MP.yday));
MP.year = MP.info.year*ones(size(MP.yday));
MP.z    = sw_dpth(MP.p,MP.info.lat);


% Remove zeros that were put in in the event that the largest file was
% larger than accounted for by nslop
if get_raw
    ind = find(MP.pr==0);
    MP.pr(ind)    = NaN;
    MP.tr(ind)    = NaN;
    MP.cr(ind)    = NaN;
    MP.sr(ind)    = NaN;
    MP.thr(ind)   = NaN;
    MP.sgthr(ind) = NaN;
end


%% Add despiking if present
if despiking
  MP = deSpike_gridded(MP);
end


%% Interpolate nitrate onto MP pressure grid.  Repeat for other eng quantities.
if 0

if isfield(MP,'enitrate_umolperl')
  MP.nitrate_umolperl=nan*MP.s;
  for c=1:length(MP.yday)
    ig=find(~isnan(MP.epres_suna(:,c) + MP.enitrate_umolperl(:,c)));
    if length(ig) > 2
      MP.nitrate_umolperl(:,c)=nonmoninterp1(MP.epres_suna(ig,c),MP.enitrate_umolperl(ig,c),MP.p)
    end
  end
end

if isfield(MP,'efluor')
  MP.flu=nan*MP.s;
  for c=1:length(MP.yday)
    ig=find(~isnan(MP.epres(:,c) + MP.efluor(:,c)) & MP.epres(:,c) > 0);
    if length(ig) > 2
      MP.flu(:,c)=nonmoninterp1(MP.epres(ig,c),MP.efluor(ig,c),MP.p)
    end
  end
end

if isfield(MP,'eturb')
  MP.turb=nan*MP.s;
  for c=1:length(MP.yday)
    ig=find(~isnan(MP.epres(:,c) + MP.eturb(:,c)) & MP.epres(:,c) > 0);
    if length(ig) > 2
      MP.turb(:,c)=nonmoninterp1(MP.epres(ig,c),MP.eturb(ig,c),MP.p)
    end
  end
end

end