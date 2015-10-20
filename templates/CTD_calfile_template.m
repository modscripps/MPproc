% CTD_calfile_template.m
%
% Template for creating a CTD calfile for a given MP deployment.  I prefer
% this routine to John's since it allows easy verification of the settings,
% and easy changing of the parameters.  This file should be changed for
% each deployment, renamed appropriately (e.g.
% 'make_ctd_calfile_[cruise][sn].m), and put in the cal directory of the
% deployment folder.
%
% 2/05 MHA
%
% 09/2015 GV added option for second set of thermal mass correction
%         parameters


%% Determine output path and filename

mpdatadir = MP_basedatadir(info);
flnm      = ['ctd_calfile_' cruise 'sn' sn];
outfile   = fullfile(mpdatadir,'cal',flnm);


%% Gather sensor information.

info = MP_deploymentinfo(sn,cruise,mooring);

%This file must set the following parameters (shown with nominal values),
%and store them in a file.

%          c_coefs: [1 0]
%        serial_ID: 0
%          p_coefs: [1 0]
%    documentation: 'Nominal, linear cals'
%          t_coefs: [1 0]
%             tlag: 1


%% Set values

serial_ID = info.CTDsensor.sn;
documentation = ['CTD cal file for ctd S/N ' serial_ID...
                 ', which was on profiler S/N ' sn...
                 ' during experiment ' ...
                 cruise '.' sprintf('\n')...
                 'Additional comments:'];

c_coefs = [1 0];
p_coefs = [1 0];
t_coefs = [1 0];

% Obsolete for SBE
tlag = 2;

% Oxygen cals.  These are from hc05d6 - CHANGE!!
doxcal.A       = -2.6122e-3;
doxcal.B       = 1.4368e-4;
doxcal.C       = -2.6577e-6;
doxcal.E       = 0.036;
doxcal.Soc     = 2.5876e-4;
doxcal.Foffset = -815.6391;
doxcal.FS_lf   = 1 / 1.20; % sample rate (Hz) for MP sensors
doxcal.Lag     = -3.0; % try -(2:3)s if Tau_0 is used, else -(5:8)s
doxcal.Tau_0   = 2.8; % try 1:3 s


% CTD MP52 parameters determined by Dave Winkel for Mendo09.  May need to
% be changed.

% CTpar.freq    = 1 / 1.20; % sample rate (Hz) for MP sensors
% Do not hardcode ctd frequency here as the sampling rate seems to have
% changed with some firmware update. Mendocino '09 was 1.2Hz whereas SP T2
% 108 has 1Hz.

CTpar.lag     = +.05;     % number of scans
CTpar.alfa    = 0.065;    % SWIMS was 0.023
CTpar.beta    = 0.06;     % SWIMS was 1/6.5
CTpar.P2T_lag = -1.0;     % lag (in scans) from pres to temp sampling


% Second set of thermal mass corrections if desired
CTpar.alfa2    = 0.005;    % SWIMS was 0.023
CTpar.beta2    = 0.001;     % SWIMS was 1/6.5


%% Save file.
%We save, reload to put all data in a structure, reload, and
% save with the structure.
eval(['save ',outfile,' serial_ID c_coefs p_coefs t_coefs tlag CTpar doxcal documentation']);

%Then, load in the file again to put all these variables in a structure,
%and store them again with the structure too.
ctd_cal=load(outfile);

eval(['save ',outfile,' serial_ID c_coefs p_coefs t_coefs tlag CTpar doxcal documentation ctd_cal']);

fprintf(1,'ctd cal file written\n');
