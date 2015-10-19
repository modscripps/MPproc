function Nprofiles = MP_aqdp_split(aqdp,info,whbin)

% Nprofiles = MP_AQDP_SPLIT(aqdp,mpdatadir,whbin)
% 
%   Split big aquadopp structure into separate files for each MP profile.
%   Profiles will be written into aqdp/mat/. If a vector of bins is given
%   the output is an average over these bins.
%
%   INPUT   aqdp - big aquadopp data structure
%           info - MP info structure
%           whbin - vector with bins (optional, default is only bin 15)
%
%   OUTPUT  Nprofiles - number of profiles
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 10/06/2015
%
%   Adapted from Andy Pickering
%
% OLD DOCUMENTATION
% aqdp is structure made with MP_aqdp_make.m
%
% Split Aquadopp data up into individual profiles.
% Similar to SplitAQDPFile.m, but this one uses the
% start and stop times of the MP profiles to split
% the data; that way they are matched up correctly.
% these profiles will then get loaded during MP processing
% and put on MP grid.
%
% Note this must be run AFTER converting MP data into
% raw mat files for each profile. 
%
% For each MP profile, saves a file with corresponding
% aquadopp data in structure 'a'. Files have same naming
% convention as MP profiles , but w/ 'aqdp_' in front.
%
% 5 Aug 2012 - AP


% Set default parameters
if ~exist('whbin','var')
whbin     = 15; % Default bin 15
end

% Path to MP data
mpdatadir = MP_basedatadir(info);

% Make sure transformation to earth coordinates has happened
if ~isfield(aqdp,'u')
  error('Add ENU velocity to aqdp first (w/ MP_aqdp_transform.m)')
end

% Look at MP data dir, find how many files there are
flist = dir(fullfile(mpdatadir,'mat','raw*.mat'));
% fnames={flist.name};

if isempty(flist)
  error('No MP .mat files found ')
end

% Figure out how many files there are
Nprofiles = length(flist);
fprintf(1,'Found %d MP profiles\n',Nprofiles);

% Low-pass filter pressure time series (1000 points cutoff)
dpdt = diffs(aqdp.p);
lpp = g_lowpass(aqdp.p,1/500,2);
lpdpdt =g_lowpass(dpdt,1/500,2);


%% Cycle through profiles 
% for each one get start and end time of MP profile, then get aqdp for that
% time period.

yday = nan(1,Nprofiles);

textprogressbar('Splitting aquadopp file:    ');

for whprf = 1:Nprofiles

  clear a startdaytime stopdaytime
  
%   disp(['Working on profile ' num2str(whprf) ' out of ' num2str(Nprofiles) ])
  textprogressbar(whprf/Nprofiles*100);
  
  mpfile = flist(whprf).name;
  mp_pnum = mpfile(4:7);
  load(fullfile(mpdatadir,'mat',flist(whprf).name))

  % Extract the profile start and stop times
  % Start
  startdaytime = datenum(sprintf('%s %s',psdate,pstart),...
                         'mm/dd/yy HH:MM:SS');
  % End
  stopdaytime  = datenum(sprintf('%s %s',pedate,pstop),...
                         'mm/dd/yy HH:MM:SS');
                       
  % Find aquadopp data within ctd time limits
  idaa = find(aqdp.dtnum>startdaytime & aqdp.dtnum<stopdaytime);
  % Median ctd dpdt
  mcdpdt = nanmedian(diffs(cpres));
  % Median aqdp dpdt
  madpdt = nanmedian(dpdt(idaa));
  
  % if sign of dpdt compares favorably
  % -> look for first zero pressure crossing before center time
  % -> look for first zero pressure crossing after center time
  if sign(mcdpdt)==sign(madpdt) && abs(mcdpdt)>1e-2
    
    center_time = mean([startdaytime,stopdaytime]);
    cti = MP_near(aqdp.dtnum,center_time);
    
    if sign(mcdpdt)>0
    xa = find(lpdpdt(1:cti)<0,1,'last');
    xb = find(lpdpdt(cti:end)<0,1,'first');
    xb = xb+cti;
    else
    xa = find(lpdpdt(1:cti)>0,1,'last');
    xb = find(lpdpdt(cti:end)>0,1,'first');
    xb = xb+cti;
    end
    
    ida = xa:xb;
    
  else % for now just use ctd time steps when profiler is not moving...
       % these profiles will be mostly garbage anyways
    
    ida = idaa;
    
  end

  % Assign aquadopp data to new structure
  a.pnum     = whprf;
  a.yday_all = aqdp.yday(ida);
  a.yday     = nanmean(aqdp.yday(ida));
  a.dtnum    = aqdp.dtnum(ida);
  a.p = aqdp.p(ida);
  
  % Average over bins given in whbin
  if length(whbin)>1
  a.u = nanmean(aqdp.u(ida,whbin),2);
  a.v = nanmean(aqdp.v(ida,whbin),2);
  a.w = nanmean(aqdp.w(ida,whbin),2);
  else
  a.u = aqdp.u(ida,whbin);
  a.v = aqdp.v(ida,whbin);
  a.w = aqdp.w(ida,whbin);
  end

  a.hdg   = aqdp.hdg(ida);
  a.pitch = aqdp.pitch(ida);
  a.roll  = aqdp.roll(ida);

  a.Made = [date ' w/ ' mfilename];

  fname  = ['aqdp_' mpfile];
  outdir = fullfile(mpdatadir,'aqdp','profiles');
  save(fullfile(outdir,fname),'a');

end

textprogressbar(' Done');

% DONE :)