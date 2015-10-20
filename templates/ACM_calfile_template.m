% ACM_calfile_template.m
%
% Template for creating an acm calfile for a given MP deployment. This file
% should be changed for each deployment, renamed appropriately (e.g.
% 'make_acm_calfile_[cruise][sn].m), and put in the cal directory of the
% deployment folder.
% 2/05 MHA
%
% Changed this to automatically load bias, offset and wag factor if desired
% Jul 2015 GV
%
% Updated: GV 10/08/2015 to work for both FSI ACM and Nortek Aquadopp


%% FSI ACM: Tilt Correction
% Set to 1 if you want tilt correction, 0 otherwise
TiltCorrection = 0;

%% FSI ACM: Path Bias
% Set to 1 if you want to use the path bias correction, 0 otherwise
PathBiasCorrection = 0;

%% No user settings below this point


%% Determine output path and filename
mpdatadir = MP_basedatadir(info);
flnm      = ['acm_calfile_' cruise 'sn' sn];
outfile   = fullfile(mpdatadir,'cal',flnm);

%% Gather sensor information.  
info = MP_deploymentinfo(sn,cruise,mooring);

%This file must set the following parameters (shown with nominal values),
%and store them in a file.

% serial_ID: 0
% documentation: 'nominal'
% Hx_bias: 0
% Hx_range: 1
% Hy_bias: 0
% Hy_range: 1
%
% dir_sign: 1
% compass_bias: 0
%
% Vab_bias: 0
% Vcd_bias: 0
% Vef_bias: 0
% Vgh_bias: 0
%
% velocity_scale: 1
% wag_factor: 120


%% Get values from various input files and save cal file

% FSI ACM or Nortek Aquadopp?
serial_ID = info.VELsensor.sn;
if strncmp(info.VELsensor.sn,'AQD',3)
  IsAQD = 1;
else
  IsAQD = 0;
end


documentation = ['ACM cal file for acm S/N ' serial_ID...
                 ', which was on profiler S/N ' sn...
                 ' during experiment ' ...
                 cruise '.' sprintf('\n')...
                 'Additional comments:'];

if ~IsAQD % FSI ACM

  % Magnetic bias and scales.  From acm_corr.m
  LoadName = ['cal/acm_corr_coefficients_',info.cruise,'_',info.station,'_sn',info.sn,'.mat'];
  LoadName = fullfile(mpdatadir,LoadName);
  load(LoadName,'ac')

  Hx_bias  = ac.median_offset(1);
  Hx_range = ac.median_scale_factors(1);
  Hy_bias  = ac.median_offset(2);
  Hy_range = ac.median_scale_factors(2);

  % Compass bias from spin test.
  dir_sign = 1; %should not have to change this from 1.
  % compass_bias = 0;
  compass_bias = ac.bias_angles(:)'; % making sure this is a row vector!

  % Velocity path biases.
  if PathBiasCorrection
    LoadName = ['cal/acm_bias_coefficients_',info.cruise,'_',info.station,'_sn',info.sn,'.mat'];
    LoadName = fullfile(mpdatadir,LoadName);
    load(LoadName,'ab')
    Vab_bias = ab.bias_ab;
    Vcd_bias = ab.bias_cd;
    Vef_bias = ab.bias_ef;
    Vgh_bias = ab.bias_gh;
  
  % Set path bias to 0 if you don't want to correct for it
  else
    Vab_bias = 0;
    Vcd_bias = 0;
    Vef_bias = 0;
    Vgh_bias = 0;
  end

  velocity_scale = 1; %velocity scale factor; should not change from 1.

  % Wag_factor. Use twice the best value obtained in ProcessingWorksheet6.m.
  wag_factor = 120; % default for L=60 seems to work well for most profilers/deployments.

  LoadName = ['cal/acm_wag_factor_',info.cruise,'_',info.station,'_sn',info.sn,'.mat'];
  LoadName = fullfile(mpdatadir,LoadName);
  load(LoadName,'bestL')
  wag_factor = bestL*2;
  

elseif IsAQD % Nortek Aquadopp
  
   % Create some FSI dummies for AQDP processing
  Hx_bias  = NaN;
  Hx_range = NaN;
  Hy_bias  = NaN;
  Hy_range = NaN;
  
  dir_sign = 1;
  Vab_bias = NaN;
  Vcd_bias = NaN;
  Vef_bias = NaN;
  Vgh_bias = NaN;
  velocity_scale = 1;
  wag_factor = NaN;
  
  % Compass bias from spin test.
  LoadName = ['cal/acm_corr_coefficients_',info.cruise,'_',info.station,'_sn',info.sn,'.mat'];
  LoadName = fullfile(mpdatadir,LoadName);
  load(LoadName,'ac')
  compass_bias = ac.bias_angles(:)';
  
end


%% Save calibration file

% We save, reload to put all data in a structure, reload, and
% save with the structure.
eval(['save ',outfile,' serial_ID Hx_bias Hx_range Hy_bias Hy_range dir_sign compass_bias Vab_bias Vcd_bias ',...
    'Vef_bias Vgh_bias velocity_scale wag_factor documentation TiltCorrection']);

% Then, load in the file again to put all these variables in a structure,
% and store them again with the structure too.
acm_cal = load(outfile);

eval(['save ',outfile,' serial_ID Hx_bias Hx_range Hy_bias Hy_range dir_sign compass_bias Vab_bias Vcd_bias ',...
    'Vef_bias Vgh_bias velocity_scale wag_factor documentation acm_cal TiltCorrection']);

fprintf(1,'acm cal file written\n');
