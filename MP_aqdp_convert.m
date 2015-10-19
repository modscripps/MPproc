function aqdp = MP_aqdp_convert(info)

% aqdp = MP_AQDP_CONVERT(info)
%
%   Read Aquadopp ascii data files and put all data into a matlab structure
%   'aqdp' for a MP deployment. Calls MP_aqdp_make.m
%
%   INPUT   info - MP info structure
%
%   OUTPUT  aqdp - structure with aquadopp raw time series data
%
%
%   Gunnar Voet  [gvoet@ucsd.edu] 
%   Created: 10/06/2015
% 
% adapted from Andy Pickering:
% AP 14 Aug 2012
%
% with input from Olavo Marques (concatenation of structures)
% Olavo Badaro Marques -- 29/Aug/2015


%% Paths
mpdatadir = MP_basedatadir (info);
aqdpdir   = fullfile(mpdatadir,'aqdp','offload');


%% List "raw" ascii files in aqdp/offload
dd = dir(fullfile(aqdpdir,'DEF*.v1'));
fprintf(1,'\n AQDP: Will process the following set of files:\n');
for i = 1:length(dd)
  [~,nm,~] = fileparts(fullfile(aqdpdir,dd(i).name));
  fprintf(1,' %s\n',nm);
  dd(i).namebase = nm;
  clear nm
end
fprintf('\n');


%% Run the conversion on all sets of files

% Only work with files that are bigger than 2kB
count = 0;
for i = 1:length(dd)
  if dd(i).bytes/1000>2
  count = count+1;
  fprintf('Processing %s:\n',dd(i).namebase);
  aqdp_tmp(count) = MP_aqdp_make(aqdpdir,dd(i).namebase);
  else
  fprintf('NOT processing %s - size < 2kB!\n',dd(i).namebase);
  end
end


%% Concatenate the structure

if length(aqdp_tmp)>1
fprintf(1,'Concatenating data from multiple files...\n');
FieldNames = fieldnames(aqdp_tmp);

% % These are the (only) expected fields to exist: 
% exptfields = { 'CoordSys_orig' ; 'SerialNum'     ; ...
%                'FirmwareVersion' ; 'T' ; 'dtnum' ; ...
%                'yday' ; 'hdg' ; 'pitch' ; 'roll' ; ...
%                'p' ; 't' ; 'burst' ; 'ensemble'  ; ...
%                'v1' ; 'v2' ; 'v3'                ; ...
%                'a1' ; 'a2' ; 'a3' ; 'processed' };
           
% These are the fields to be concatenated):
% ccatfields = exptfields(5:19);
ccatfields = FieldNames(5:16);

% Determine order
for i = 1:length(aqdp_tmp)
  ta(i) = aqdp_tmp(i).dtnum(1);
end
[~,ti] = sort(ta);

% Loop through the structures
for i = 1:length(aqdp_tmp)

  % If it's the first file, copy its data to a
  % new variable. Otherwise, concatenate.
  if i == 1
    aqdp = aqdp_tmp(ti(i));
  else
    % Loop through fields to be concatenated:
    for l = 1:length(ccatfields)

      % Set which dimension to concatenate depending on the field:
      if strcmp(ccatfields{l}, 'dtnum') || strcmp(ccatfields{l}, 'yday')
        d = 2;
      else
        d = 1;
      end

      % Concatenate data:
      aqdp.(ccatfields{l}) = cat(d,aqdp.(ccatfields{l}),...
                aqdp_tmp(ti(i)).(ccatfields{l}));
    end
  end
end

else
aqdp = aqdp_tmp;
end
clear aqdp_tmp


%% Apply compass correction (from spintest) and magnetic deviation

magdev = info.magvar;
acm_cal_filename = fullfile(mpdatadir,...
            sprintf('cal/acm_corr_coefficients_%s_%s_sn%s.mat',info.cruise,info.station,info.sn));
load(acm_cal_filename)
compass_bias = ac.bias_angles;

% Interpolate bias to headings
true_headings = 0:45:360;
compass_bias = [compass_bias(:)' compass_bias(1)];
compass_bias_i = interp1(true_headings,compass_bias,aqdp.hdg);

% The aquadopp compass goes CW from 0 to 360
% Corrected heading is hdg-bias+magdev with magdev positive for E
% Remember: The instrument tells you it's pointing north, but in reality
% you are looking 20deg E of N, so add the magnetic declination!
aqdp.hdg = aqdp.hdg-compass_bias_i+magdev;
aqdp.hdg(aqdp.hdg<0) = aqdp.hdg(aqdp.hdg<0)+360;


%% Transform velocity from beam coordinates
%  to "magnetic-Earth" coordinates:
if strcmp(aqdp.CoordSys_orig,'ENU')
aqdp = MP_aqdp_transform(aqdp, 'eb');
else
aqdp = MP_aqdp_transform(aqdp, 'be');
end

%% Add MP deployment info to aqdp structure

aqdp.datadir = fullfile(mpdatadir,'aqdp');
aqdp.cruise  = info.cruise;
aqdp.station = info.station;
aqdp.MPsn    = info.sn;

% DONE :)