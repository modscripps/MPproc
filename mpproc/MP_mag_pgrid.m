function MP_mag_pgrid(sn,cruise,mooring,nprof,prgrid)

% MP_MAG_PGRID(sn,cruise,mooring,nprof) Process and pressure bin MP CTD
%                                       profiles & ACM/AQUADOPP
%
%   INPUT   sn - MP serial number
%           cruise - cruise id
%           mooring - mooring id
%           nprof - profiles to be processed (optional, default all)
%           prgrid - pressure grid, 3 element vector with min/step/max
%                    (optional, default whole pressure range with step
%                    2dbar)
%
%   Note that bounds are currently hardcoded to
%   pressure:     [info.pmin-20 info.pmax+20] (from MP_deploymentinfo)
%   temperature:  [-2 35]
%   conductivity: [20 50]
%   velocity:     [-100 100]
%   compass:      [-1.1 1.1]
%   tilt:         [-45 45]
%
%   The minimum number of scans needed in a profile to be processed is
%   currently hardcoded to 500.
%
%
%   Gunnar Voet  [gvoet@ucsd.edu]
%   Created: 10/01/2015 (with adaptions from A. Pickerings code)
%
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ORIGINAL DOCUMENTATION:
%
% mag_pgrid.m
%
% a routine to reduce and bin data from the McLane Moored Profiler
%
%  copyright John M. Toole
%  Woods Hole Oceanographic Institution
%  December, 2001
%
% Modifed for special cases by MHA, and 2/2/05 to include John's wag
% correction.  If wag_factor is not defined, it will do nothing.
%
% modified MHA to incorporate changes
% 5/06
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


disp([' PROGRAM MP_mag_pgrid version 1.0 - Sep 2015'])
disp([' (It was mag_pgrid version MHA - Mar 2006)'])
disp([' (It was mmp_pgrid       JMT  version 1 - Dec 2001)'])
disp([' **************************************************'])

% Make sure we have at least sn, cruise and mooring as input
if nargin<3
  error('MP_mag_pgrid.m needs at least sn, cruise and mooring as inputs.')
end

% Basic deployment info from MP_deploymentinfo.m;
info = MP_deploymentinfo(sn,cruise,mooring);

% By default, do all profiles
if ~exist('nprof','var')
  stas = 0:info.n_profiles;
else
  stas = nprof;
end
stas_text = sprintf('[%03i %03i]',stas(1),stas(end));

% Parse information from info structure
MMP_id           = info.sn;
CTD_id           = info.CTDsensor.sn;
ACM_id           = info.VELsensor.sn;
experiment_name  = info.deployment;
mooring_position = [info.lat info.lon];
mag_dev          = info.magvar;

% Is this an aquadopp MP?
if strncmp(ACM_id,'AQD',3)
  IsAQDP    = 1;
  IsFSIACM  = 0;
else
  IsAQDP    = 0;
  IsFSIACM  = 1;
end

% Any velocity sensor at all?
if strncmp(ACM_id,'None',4)
  VelSensor = 0;
  IsFSIACM = 0;
  IsAQDP = 0;
else
  VelSensor = 1;
end

% input/output directories.
mpdatadir = MP_basedatadir(info);
direc  = fullfile(mpdatadir,'mat');
outdir = fullfile(mpdatadir,'gridded');

% Ask user if these are the right directories
fprintf(1,'\n Input directory:\n%s\n',direc);
fprintf(1,' Output directory:\n%s\n',outdir);
reply = input(' Are these directories correct? y/n [y]: ','s');
if isempty(reply)
  reply = 'y';
end
if ~strcmp(reply,'y')
  error('You did not like the directories')
end

% Make output directory if it does not exist.
if ~exist('outdir','dir')
  mkdir(outdir)
end

% Pressure grid min/step/max
if exist('prgrid','var')
  gmin = prgrid(1);
  gstep = prgrid(2);
  gmax = prgrid(3);
else
  gmin  = info.pmin-10;
  gstep = 2;
  gmax  = info.pmax+10;
end

% Cal files
ctd_cal_filename = fullfile(mpdatadir,...
            sprintf('cal/ctd_calfile_%ssn%s.mat',info.deployment,info.sn));
acm_cal_filename = fullfile(mpdatadir,...
            sprintf('cal/acm_calfile_%ssn%s.mat',info.deployment,info.sn));


% Bounds
p_bounds = [info.pmin-20 info.pmax+20];
t_bounds = [-2 35];
c_bounds = [20 50];
vel_bounds = [-100 100];
compass_bounds = [-1.1 1.1];
tilt_bounds = [-45 45];

% min # of scans requuired to process a profile
nscans_test = 500;

%-----------------------------------------------------
% end of new function header replacing the gui parsing
%-----------------------------------------------------

% Create log file
docname = sprintf('mmp_pgrid_%03d_%03d.txt',stas(1),stas(end));
docpath = fullfile(outdir,docname);
fid     = fopen(docpath,'w');

fprintf(fid,' \n Documentation file for a run of program mag_pgrid.m version %1.1f\n',3.0);
fprintf(fid,' Date of Pressure Gridding:  %s\n',date);
fprintf(fid,' \n Experiment name %s\n',experiment_name);
fprintf(fid,'\n Mooring position = %s\n',mooring_position);
fprintf(fid,'\n MP identification number = %s\n',MMP_id);
fprintf(fid,'     with CTD identification number %s\n',CTD_id);
fprintf(fid,'     and  ACM identification number %s\n',ACM_id);
fprintf(fid,'\n Magnetic deviation used in this run is %g degrees.\n',...
        mag_dev);
% I wish mag_dev specified in degrees.
fprintf(fid,'\n This run is for stations %s\n',stas_text);
fprintf(fid,'\n Input data directory  = %s\n',direc);
fprintf(fid,' Output data directory = %s\n',outdir);
fprintf(fid,'\n Minimum number of scans to process a drop = %g\n',...
        nscans_test);

% Use the grid bounds to estimate how many CTD and ACM data scans you
% expect from a full profile
nscans_expected = fix((gmax-gmin)/.25*1.5)+400;
fprintf(1,' Based on the gridding, we expect %d scans in a data file\n',...
        nscans_expected);

% Load the cal files
% CTD
if exist(ctd_cal_filename,'file')
  load(ctd_cal_filename);
else
  msg='Could not find CTD cal file.  Re-enter the correct path and filename';
  msg_window(msg);
  while (findobj('type','figure','tag','msgwin'))
    pause(2)
  end
end

% ACM
if VelSensor
if exist(acm_cal_filename,'file')
  load(acm_cal_filename);
else
  msg='Could not find ACM cal file.  Re-enter the correct path and filename';
  msg_window(msg);
  while (findobj('type','figure','tag','msgwin'))
    pause(2)
  end
end
end

fprintf(fid,'\n CTD calibration filename = %s\n',ctd_cal_filename);
fprintf(fid,'     Pres coeffs = %g %g \n',p_coefs);
fprintf(fid,'     Temp coeffs = %g %g \n',t_coefs);
fprintf(fid,'     Cond coeffs = %g %g \n',c_coefs);
if isempty(strfind(CTD_id,'SBE-MP52')) % FSI sensor
fprintf(fid,'     Temp Lag    = %g \n',tlag);
else % SBE-MP52
fprintf(fid,'     Lag                 = %g \n',CTpar.lag);
fprintf(fid,'     P2T Lag             = %1.1f \n',CTpar.P2T_lag);
fprintf(fid,'     Thermal mass alpha  = %g \n',CTpar.alfa);
fprintf(fid,'     Thermal mass beta   = %g \n',CTpar.beta);
if isfield(CTpar,'alfa2')
fprintf(fid,'     Second thermal mass correction applied:\n');
fprintf(fid,'     Thermal mass alpha2 = %g \n',CTpar.alfa2);
fprintf(fid,'     Thermal mass beta2  = %g \n',CTpar.beta2);
end
end

if IsFSIACM
fprintf(fid,'\n ACM calibration filename = %s\n',acm_cal_filename);
fprintf(fid,'     Hx_bias  = %g \n',Hx_bias);
fprintf(fid,'     Hx_range = %g \n',Hx_range);
fprintf(fid,'     Hy_bias  = %g \n',Hy_bias);
fprintf(fid,'     Hy_range = %g \n',Hy_range);
fprintf(fid,'     Vab_bias = %g \n',Vab_bias);
fprintf(fid,'     Vcd_bias = %g \n',Vcd_bias);
fprintf(fid,'     Vef_bias = %g \n',Vef_bias);
fprintf(fid,'     Vgh_bias = %g \n',Vgh_bias);
if numel(compass_bias)<8
  fprintf(fid,'\n     Compass bias   = %g degrees \n',compass_bias);
else
  fprintf(fid,'\n     Compass bias   = [%g %g %g %g %g %g %g %g] degrees \n',compass_bias);
end
fprintf(fid,'     Direction sign = %g \n',dir_sign);
fprintf(fid,'     Velocity Scale = %g \n',velocity_scale);
if TiltCorrection
  fprintf(fid,'     Tilt correction applied\n');
else
  fprintf(fid,'     No tilt correction applied\n');
end
elseif IsAQDP
fprintf(fid,'\n ACM calibration filename = %s\n',acm_cal_filename);
fprintf(fid,'     Nortek Aquadopp SN %s\n',info.VELsensor.sn);
end


% Check for sensor edit parameters
if ~exist('p_bounds','var') ||...
   ~exist('t_bounds','var') ||...
   ~exist('c_bounds','var') ||...
   ~exist('vel_bounds','var')

  disp([' ']);
  disp([' Now you must enter sensor edit parameters: ']);
  disp(['     For each raw parameter, enter the minimum and maximum acceptable value as a two-element vector, e.g. [2 24] '])
  disp([' ']);

  p_bounds   = input(' Pressure bounds: ');
  t_bounds   = input(' Temperature bounds: ');
  c_bounds   = input(' Conductivity bounds: ');
  vel_bounds = input(' Velocity bounds: ');
end

fprintf(fid,'\n Pressure edit bounds     = %g %g \n',p_bounds);
fprintf(fid,' Temperature edit bounds  = %g %g \n',t_bounds);
fprintf(fid,' Conductivity edit bounds = %g %g \n',c_bounds);
fprintf(fid,' Velocity edit bounds     = %g %g \n',vel_bounds);
fprintf(fid,' Compass edit bounds      = %g %g \n',compass_bounds);

if exist('wag_factor','var') %MHA 2/3/05
  fprintf(fid,' Wag correction factor    = %g \n',wag_factor);
end



%**************************************************************************
% Now start the processing

for h = 1:length(stas) % loop over all profiles
  
  rawmatfile = fullfile(direc,sprintf('raw%4.4i.mat',stas(h)));
  
  % Display information on screen
  fprintf(1,'\n   working on file %s\n',rawmatfile);
  
  % Print to log file
  fprintf(fid,'\nProcessing file %s \n',rawmatfile);
  
  % Load raw .mat-file
  if exist(rawmatfile,'file')==2
    [okay Vab Vcd Vef Vgh aHx aHy aHz aTx aTy cpres ctemp ccond cdox ...
      psdate pstart pedate pstop epres ecurr edpdt evolt engtime]...
      = MP_load_rawmatfmt(rawmatfile,nscans_test);
  else
    msg = ['Could not find ' rawmatfile,'. '...
           'Re-enter the correct path and filename'];
    msg_window(msg);
    while (findobj('type','figure','tag','msgwin'))
      pause(2)
    end
  end
  
  % check that this file is okay, if not skip this profile
  if (okay==1);

  % Extract the profile start and stop times
  % Start
  startdaytime = datenum(sprintf('%s %s',psdate,pstart),...
                         'mm/dd/yy HH:MM:SS');
  % End
  stopdaytime  = datenum(sprintf('%s %s',pedate,pstop),...
                         'mm/dd/yy HH:MM:SS');

  % Next we create a time variable for each CTD data scan using the
  % engineering data epres and etime.
  jj = find(epres~=0);

  %------------------------------------------------------------------------
  % FIX START
  % 2/2/05 change: correct a problem with the offloaded data on sn103,
  % aeg04 cruise in which the first scan is sometimes from the
  % previous profile.  This causes an error in the ctdsamplerate.
  TCUT = 30/60/24; %1-2 hour
  if (strcmp(experiment_name,'AEG04')==1 ||...
      strcmp(experiment_name,'aeg04')==1) &&...
      strcmp(MMP_id,'103')==1
    if engtime(jj(2)) - engtime(jj(1)) > TCUT
      jj = jj(2:end);
    end
  end

  % Allow this to run for hc05d5, which always has zero for epres for
  % the drops where the CTD malfunctioned - and set a flag for below
  malf_hc05d5 = 0;
  if strcmp(experiment_name,'hc05d5') == 1 && length(jj) < 5
    jj = 1:length(epres);
    malf_hc05d5 = 1;
  end
  % FIX END
  %------------------------------------------------------------------------

  % Align ctd pressure and engineering pressure to create ctd time vector
  nep = jj(1);
  mep = jj(end);
  diffp   = abs(epres(nep)-cpres);
  mindifp = min(diffp);
  
  jj = find(diffp==mindifp);
  ncp = jj(1);
  
  diffp = abs(epres(mep)-cpres);
  mindifp = min(diffp);
  jj = find(diffp==mindifp);
  mcp = jj(end);

  ctime = [1:length(cpres)];
  ctime = ctime-ctime(ncp);
  ctdsamplerate = (engtime(mep)-engtime(nep))/(mcp-ncp); % days/sample
  ctime = (engtime(nep)+ctime*ctdsamplerate)';

  %------------------------------------------------------------------------
  % FIX START
  % Fill in ctdsamplerate and ctime for hc05d5 assuming nominal values
  if strcmp(experiment_name,'hc05d5')==1 && malf_hc05d5 ==1
    ctdsamplerate=1.2/24/3600;
    ctime=[1:length(cpres)];
    ctime=(engtime(1)+120/24/3600+ctime*ctdsamplerate)';
  end
  % FIX END
  %------------------------------------------------------------------------

  % Now we edit the CTD and ACM data

  %------------------------------------------------------------------------
  % FIX START
  % For Mamala Bay, the ACM ef path failed at drop 200.  Replace it with
  % path Vab as per Toole's suggestions MHA 8/4/03
  if strcmp(experiment_name,'HOME02')==1 && stas(h) >= 200 &&...
                                            stas(h) <= 1303
    Vef = Vab;
  end
  % FIX END
  %------------------------------------------------------------------------
  
  % Edit bounds and spikes
  cpres = MP_edit(p_bounds,3,cpres);
  ctemp = MP_edit(t_bounds,3,ctemp);
  ccond = MP_edit(c_bounds,3,ccond);
  

  
  
  % Tag ACM path current data very near zero as bad. This is done to
  % eliminate some data spikes occasionally seen in the data.
  if IsFSIACM
  j = find(abs(Vab)<0.05);
  if ~isempty(j)
    Vab(j)=-1000;
  end

  j = find(abs(Vcd)<0.05);
  if ~isempty(j)
    Vcd(j)=-1000;
  end

  j = find(abs(Vef)<0.05);
  if ~isempty(j)
    Vef(j)=-1000;
  end

  j = find(abs(Vgh)<0.05);
  if ~isempty(j)
    Vgh(j)=-1000;
  end
    
  % Edit bounds and spikes
  Vab   = MP_edit(vel_bounds,11,Vab);
  Vcd   = MP_edit(vel_bounds,11,Vcd);
  Vef   = MP_edit(vel_bounds,11,Vef);
  Vgh   = MP_edit(vel_bounds,11,Vgh);
  aHx   = MP_edit(compass_bounds,11,aHx);
  aHy   = MP_edit(compass_bounds,11,aHy);
  aHz   = MP_edit(compass_bounds,11,aHz);
  aTx   = MP_edit(tilt_bounds,11,aTx);
  aTy   = MP_edit(tilt_bounds,11,aTy);
  
  end % FSIACM only
  %    [epres]=MP_edit(p_bounds,1,epres);
  
  

  % Here we apply calibrations to the CTD and ACM sensor data
  % GV: cals are already applied in the SBE52 itself, this is to apply
  % some kind of post-cal calibration. coefs [1 0] do not change any of
  % the data.
  cpres = polyval(p_coefs,cpres);
  ctemp = polyval(t_coefs,ctemp);
  ccond = polyval(c_coefs,ccond);
  
  if IsFSIACM
  % Velocity bias corrections
  Vab = (Vab-Vab_bias)*velocity_scale;
  Vcd = (Vcd-Vcd_bias)*velocity_scale;
  Vef = (Vef-Vef_bias)*velocity_scale;
  Vgh = (Vgh-Vgh_bias)*velocity_scale;
  
  % Compass bias (this correction should be really minor)
  aHx = (aHx-Hx_bias)/Hx_range;
  aHy = (aHy-Hy_bias)/Hy_range;
  end % FSIACM only

  % FSI CTD
  % Recursively filter the conductivity and pressure to match the
  % temperature
  if isempty(strfind(CTD_id,'SBE-MP52')) % FSI sensor
    % 4/09 MHA change: allow use of a time-variable tlag.  This is a
    % vector the same length as the number of profiles.  So if tlag is
    % a vector, we use the value for the current profile.
    if length(tlag)==1
      tlag_use=tlag;
    else % we have a vector tlag
      itmp = max(find(~isnan(tlag))); % find the last non-nan lag in the
                                      % list
      if stas(h)< 1 % use the lag for the first profile on the 0th profile
        tlag_use = tlag(1);
      elseif stas(h)>itmp % if tlag was not computed for the whole
                          % record, use the last one
        tlag_use = tlag(itmp);
      else
        tlag_use = tlag(stas(h));
      end
    end

    ccond = MMP_recur_filt(ccond,tlag_use);
    cpres = MMP_recur_filt(cpres,tlag_use);
  end

  % SBE CTD
  if strfind(CTD_id,'SBE-MP52') % SBE sensor
    % Compute lagged p,c and t, correct for thermal mass and then compute
    % sgth, s, th, and dox using these.  These are all output in the
    % structure csbe.
    CTpar.freq = ctdsamplerate*24*3600;
    csbe = MP_ctd_proc_MP52(cpres, ctemp, ccond, cdox, CTpar, doxcal);
    cpres = csbe.pres;
    ctemp = csbe.temp;
    ccond = csbe.cond;
    cdox  = csbe.dox;
    csal  = csbe.sal;
    cth   = csbe.th;
    csgth = csbe.sgth;
  end


  % here we lowpass filter the pres, temp & cond, Vab, Vcd, Vef, Vgh,
  % aHx, and aHy data
  % MHA I allow CTD data to be filtered less severely than the ACM data.
  % At sample freq of 0.17, 0.08 corresponds to 2/.17/.08=4.24 m.  Try a
  % 2-m filter.
  [b,a] = butter(8,.08);
  %        [bctd,actd]=butter(8,.16); %beware: John now uses
  %        butter(1,.25) saying that the 8-th order one rings at steps
  [bctd,actd] = butter(1,.25); % 5/9/2006: change to John's filter
  cpres = myfiltfilt(bctd,actd,cpres);
  ctemp = myfiltfilt(bctd,actd,ctemp);
  ccond = myfiltfilt(bctd,actd,ccond);
  if ~isempty(strfind(CTD_id,'SBE-MP52'))
    csal  = myfiltfilt(bctd,actd,csal);
    cth   = myfiltfilt(bctd,actd,cth);
    csgth = myfiltfilt(bctd,actd,csgth);
  end
  
  if IsFSIACM
  Vab = myfiltfilt(b,a,Vab);
  Vcd = myfiltfilt(b,a,Vcd);
  Vef = myfiltfilt(b,a,Vef);
  Vgh = myfiltfilt(b,a,Vgh);
  aHx = myfiltfilt(b,a,aHx);
  aHy = myfiltfilt(b,a,aHy);
  % need these too when applying tilt correction
  aHz = myfiltfilt(b,a,aHz);
  aTx = myfiltfilt(b,a,aTx);
  aTy = myfiltfilt(b,a,aTy);

  %######################################################################
  % FIX START
  %MHA - 10/2011.  For iwise11, H04, Vef craps out during profile
  %426. So hardwire Vef = Vab.
  %Hardwire to use Vz2 for Mamala Bay 10-199.  8/4/03
  if strcmp(experiment_name,'iwise11')==1 && stas(h) >= 426
    Vef=Vab;
  end
  % FIX END
  %**********************************************************************

  
  
  % Now calculate the velocity in instrument and geographic coordinates
  % first, derive the velocity data in Cartesian instrument coordinates
  Vx  = -(Vab+Vef)/(2.*.707);
  Vy  = (Vab-Vef)/(2.*.707);
  Vz1 = Vx-Vgh/.707;
  Vz2 = -Vx+Vcd/.707;

  % MHA notes: these correspond to
  %        Vab=acm(:,6);
  %        Vcd=acm(:,7);
  %        Vef=acm(:,8);
  %        Vgh=acm(:,9);
  %
  % Which according to the manual are the velocities from the
  % +X, +Y, -X and -Y paths respectively.
  % So Vab=+X, Vcd=+Y,Vef=-X, and Vgh=-Y.

  % now select the vertical velocity channel that is "upstream"
  avevz = mean(Vz1);
  if(avevz<0);
    Vz = Vz1;
  else
    Vz = Vz2;
  end

  %######################################################################
  % FIX START
  %MHA - as per John's suggestions,
  %Hardwire to use Vz2 for Mamala Bay 10-199.  8/4/03
  if strcmp(experiment_name,'HOME02')==1 && stas(h) >= 10 && stas(h) <= 199
    Vz=Vz2;
  end
  % FIX END
  %**********************************************************************


  % Here we normalize the compass data onto a unit circle, and derive the
  % compass heading of the ACM sting
  Hmag = sqrt(aHx.*aHx+aHy.*aHy+aHz.*aHz);
  aHx  = aHx./Hmag;
  aHy  = aHy./Hmag;
  aHz  = aHz./Hmag;
  
  
  % 1/08 MHA: allow for 8-point compass cals. To activate, make
  % compass_bias an 8-element vector in acm_calfile instead of a single
  % number. compass_bias should be the 8 output values from the spin
  % test, in degrees, for N-NE-E-SE-S-SW-W-NW.  Positive values indicate
  % the measured heading is clockwise of the true heading.
  % tested.
  if length(compass_bias) > 1 %==8
    compass_bias_save = compass_bias;
    compass_raw = dir_sign*atan2(aHx,aHy)*180/pi; % angle in degrees CCW from E
    true_heading = 0:45:315; %angles in degs CW from N of the spin test bias values
    ccw_heading = zero22pi(-true_heading+90); % angles CCW from E of these
    % now sort the values
    [ccw_heading_sort,is] = sort(ccw_heading);
    compass_bias_sort = compass_bias(is);
    % add one more value for 360 degrees
    ccw_heading_sort = [ccw_heading_sort 360];
    compass_bias_sort = [compass_bias_sort compass_bias_sort(1)];
    % We now have a bias that is defined for all angles between 0
    % and 360.  Now we interpolate it using the observed angle to
    % make a vector of compass_bias the same length as the raw
    % heading that we will use to correct it in the next step.
    compass_bias = interp1(ccw_heading_sort,compass_bias_sort,zero22pi(compass_raw));
  end

  % mvpdir=dir_sign*atan2(aHx,aHy)+compass_bias+mag_dev;

  % 5/9/06 MHA: mag_var is no longer converted to radians at top of
  % script, since compass_bias is not converted there.  Hence, these
  % are to be specified IN DEGREES; they are converted to radians here.

  % 5/10/06 change MHA: mvpdir is defined as CCW with 0 = E.
  % Hence, mag_dev is a SUBTRACTIVE correction.
  % That is, an E magnetic deviation means MP's true heading (measured CW
  % from N) is GREATER than its magnetic heading.  Thus, its angle
  % measured CCW is LESS than the magnetic angle.
  % That is, HDG_T = HDG_magnetic + MAGVAR - compass_bias
  % To be clear: specify mag_var as the eastward magnetic deviation in
  % degrees, and compass_bias as the actual angle the compass reads
  % (measured CW from NORTH!) when pointed toward magnetic north.
 
  mvpdir = dir_sign*atan2(aHx,aHy)+compass_bias/180*pi-mag_dev/180*pi;

  % MHA 2/2/05: insert John's wagging correction here.
  % here we apply a correction to the velocity data for the wagging given
  % by the time rate of change of the instrument heading times a distance
  % factor
  if exist('wag_factor','var')
    mvpdir = continuousdir(mvpdir);
    dddt   = gradient(mvpdir);
    wagv   = wag_factor*dddt;
    Vy     = Vy+wagv;
  end

  % Now derive East and North velocity components    
%   speed  = sqrt(Vx.*Vx+Vy.*Vy);
%   reldir = atan2(Vy,Vx);
%   trudir = mvpdir+reldir;
%   Veast  = speed.*cos(trudir);
%   Vnorth = speed.*sin(trudir);

  % Run ACM calcs, either 2D or 3D
  [Veast,Vnorth,Vvert,Head,HeadTot] = MP_acm_calcs(Vx,Vy,Vz,...
         aHx,aHy,aHz,aTx,aTy,dir_sign,compass_bias,mag_dev,TiltCorrection);
       
  end % FSIACM only
  
  
  %% AQDP: Load aquadopp data & filter
  
  % Loads the following subvariables in structure a:
  % pnum, yday_all, yday, p, u, v, w, hdg, pitch, roll
  
  if IsAQDP
    aqfile = fullfile(mpdatadir,'aqdp','profiles',sprintf('aqdp_raw%4.4i.mat',stas(h)));
    fprintf(1,'Loading Aquadopp file: %s\n',aqfile);
    load(aqfile)
  
    % AQDP: bound and spike edit
    FieldNames = {'u','v','w'};
    for i = 1:length(FieldNames)
      if length(a.dtnum)>11
        a.(FieldNames{i}) = MP_edit(vel_bounds,11,a.(FieldNames{i}));
      end
    end
    % also need to do hdg, pitch, roll
    
    % AQDP: filter
    [baqdp,aaqdp] = butter(1,.25); % what's a good value here?
    FieldNames = {'u','v','w','hdg','pitch','roll'};
    for i = 1:length(FieldNames)
    a.(FieldNames{i}) = myfiltfilt(baqdp,aaqdp,a.(FieldNames{i}));
    end
  
  end % IsAQDP
  
  %% Pressure binning
  % Now we start the pressure binning. first find the scan numbers for
  % the ctd and acm at profile start and end
  if IsFSIACM
  [startc,endc,starta,enda,dpdt] = MP_align_ctdacm(cpres(:),Vz,ctdsamplerate);
  elseif IsAQDP
  [startc,endc,dpdt] = MP_align_ctd(cpres(:),ctdsamplerate);
  else
  [startc,endc,dpdt] = MP_align_ctd(cpres(:),ctdsamplerate);
  end

  % Find the CTD scans that correspond to each pressure interval
  cscan1 = [];
  cscan2 = [];
  [pgrid,cscan1,cscan2] = MP_pbins(gmin,gmax,gstep,cpres);
  
  % AQDP: Find scans as well
  if IsAQDP
  [~,aqscan1,aqscan2] = MP_pbins(gmin,gmax,gstep,a.p);
  end

  % Average everything inside each pressure bin
  pave    = [];
  tave    = [];
  cave    = [];
  uave    = [];
  vave    = [];
  wave    = [];
  dpdtave = [];
  ascan1  = [];
  ascan2  = [];
  ctimave = [];
  Hxave   = [];
  Hyave   = [];
  Hzave   = [];
  Txave   = [];
  Tyave   = [];
  Headave = [];
  HeadTotave = [];
  if exist('cdox','var'); doxave=[]; end
  if ~isempty(strfind(CTD_id,'SBE-MP52'))
    s_ave = [];
    thave = [];
    sgthave = [];
  end

  
  
  for j = 1:length(pgrid);

    % First check if we have any data in a given bin,  if no, set all =
    % nan

    if isnan(cscan1(j))==1 || isnan(cscan2(j))==1;

      pave(j)    = nan;
      tave(j)    = nan;
      cave(j)    = nan;
      uave(j)    = nan;
      vave(j)    = nan;
      wave(j)    = nan;
      dpdtave(j) = nan;
      ascan1(j)  = nan;
      ascan2(j)  = nan;
      ctimave(j) = nan;
      Txave(j)   = nan;
      Tyave(j)   = nan;
      Hxave(j)   = nan;
      Hyave(j)   = nan;
      Hzave(j)   = nan;
      Headave(j) = nan;
      HeadTotave(j) = nan;
      if exist('cdox','var'); doxave(j)=nan; end
      if ~isempty(strfind(CTD_id,'SBE-MP52'))
        s_ave(j)    = nan;
        thetave(j)   = nan;
        sigthave(j) = nan;
      end
    
    else

      pave(j)    = mean(cpres(cscan1(j):cscan2(j)));
      tave(j)    = mean(ctemp(cscan1(j):cscan2(j)));
      cave(j)    = mean(ccond(cscan1(j):cscan2(j)));
      dpdtave(j) = mean(dpdt(cscan1(j):cscan2(j)));
      ctimave(j) = mean(ctime(cscan1(j):cscan2(j)));
      if exist('cdox','var') && length(cdox) >= cscan2(j)
        doxave(j) = nanmean(cdox(cscan1(j):cscan2(j)));
      end
      if ~isempty(strfind(CTD_id,'SBE-MP52'))
        s_ave(j) = mean(csal(cscan1(j):cscan2(j)));
        thetave(j) = mean(cth(cscan1(j):cscan2(j)));
        sigthave(j) = mean(csgth(cscan1(j):cscan2(j)));
      end

      if IsFSIACM
      % Next derive the acm scans corresponding to the ctd scan interval
      ascan1(j) = fix(starta+(cscan1(j)-startc)*(enda-starta)/(endc-startc));
      ascan2(j) = fix(starta+(cscan2(j)-startc)*(enda-starta)/(endc-startc));

      if(ascan1(j)<1);
        ascan1(j)=1;
      end
      if ascan1(j)>length(Vz);
        ascan1(j)=length(Vz);
      end
      if(ascan2(j)<1);
        ascan2(j)=1;
      end
      if ascan2(j)>length(Vz);
        ascan2(j)=length(Vz);
      end

      uave(j) = mean(Veast(ascan1(j):ascan2(j)));
      vave(j) = mean(Vnorth(ascan1(j):ascan2(j)));
      wave(j) = mean(Vz(ascan1(j):ascan2(j)));
      
      % Tilt
      Txave(j) = mean(aTx(ascan1(j):ascan2(j)));
      Tyave(j) = mean(aTy(ascan1(j):ascan2(j)));

      % Compass and heading
      Hxave(j) = mean(aHx(ascan1(j):ascan2(j)));
      Hyave(j) = mean(aHy(ascan1(j):ascan2(j)));
      Hzave(j) = mean(aHz(ascan1(j):ascan2(j)));
      Headave(j) = mean(Head(ascan1(j):ascan2(j)));
      HeadTotave(j) = mean(HeadTot(ascan1(j):ascan2(j)));
      end % IsFSIACM
      
      
      if IsAQDP
      if isfinite(aqscan1(j)) && isfinite(aqscan2(j))
      uave(j) = mean(a.u(aqscan1(j):aqscan2(j)));
      vave(j) = mean(a.v(aqscan1(j):aqscan2(j)));
      wave(j) = mean(a.w(aqscan1(j):aqscan2(j)));

      Headave(j) = mean(a.hdg(aqscan1(j):aqscan2(j)));
      Txave(j)   = mean(a.pitch(aqscan1(j):aqscan2(j)));
      Tyave(j)   = mean(a.roll(aqscan1(j):aqscan2(j)));
      else
      uave(j) = NaN;
      vave(j) = NaN;
      wave(j) = NaN;

      Headave(j) = NaN;
      Txave(j)   = NaN;
      Tyave(j)   = NaN;
      end
      end
      
      if VelSensor==0
      uave(j) = NaN;
      vave(j) = NaN;
      wave(j) = NaN;

      Headave(j) = NaN;
      Txave(j)   = NaN;
      Tyave(j)   = NaN;
      end
      

    end

  end
  

  % Remove the profiler's vertical velocity to get water vertical velocity
  wmeas = wave;         % measured w before subtracting MP velocity
                        % check sign here??
  wave = wmeas-dpdtave; % water vertical velocity
  

  % GV: This is odd. What is this correction doing here? Now using the
  % salinity from proc_CTD_MP52.m if this is a SBE CTD and only running
  % this for the FSI CTD.
  if isempty(strfind(CTD_id,'SBE-MP52'))
    display('calculating salinity for FSI CTD')
    CR = cave/sw_c3515.*(1-(6.5e-6).*(tave-2.) + (1.5e-8).*(pave-2000.));
    s_ave    = sw_salt(CR,tave,pave);
    thetave  = sw_ptmp(s_ave,tave,pave,0);
    sigthave = sw_pden(s_ave,tave,pave,0)-1000.;
  end

  % lastly write the binned data to file
  OutPath = fullfile(outdir,sprintf('grd%4.4i.mat',stas(h)));
  if ~exist('doxave','var')
    save(OutPath,'pgrid','pave','tave','cave','s_ave','thetave',...
                 'sigthave','uave','vave','wave','dpdtave',' cscan1',...
                 'cscan2','ascan1','ascan2','startdaytime','stopdaytime',...
                 'psdate','pstart','pedate','pstop','ctimave',...
                 'Txave','Tyave','Hxave','Hyave','Hzave','Headave',...
                 'HeadTotave','wmeas');
  else
    save(OutPath,'pgrid','pave','tave','cave','s_ave','thetave',...
                 'sigthave','doxave','uave','vave','wave','dpdtave',...
                 'cscan1','cscan2','ascan1','ascan2','startdaytime',...
                 'stopdaytime','psdate','pstart','pedate','pstop',...
                 'ctimave',...
                 'Txave','Tyave','Hxave','Hyave','Hzave','Headave',...
                 'HeadTotave','wmeas');
  end

  fprintf(fid,'   OKAY \n');

  else	%if data file okay loop
  disp(['File ',rawmatfile,' skipped- try with a smaller min scans to process value'])
  fprintf(fid,'   **PROBLEM   FILE SKIPPED** \n');

  end
  
end	%end looping on files/profiles

fclose(fid); % close log file
