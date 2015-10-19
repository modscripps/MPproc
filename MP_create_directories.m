function MP_create_directories(mpdatadir,info)

% MP_CREATE_DIRECTORIES(mpdatadir,info)
%
%   Create basic directory structure for MP processing. Directories will
%   only be created if they do not exist yet.
%
%   The data for a deployment are stored in
%   [mpdatadir]/experiment/'Moorings'/deployment/'MP'/sn[sn]
%
%   This directory contains
%     raw       (raw McLane files)
%     offload   (unpacked machine-readable text files)
%     mat       (raw matlab files)
%     gridded   (gridded matlab files)
%     cal       (calibration files)
%     comms     (tattleterm communications logs)
%     plots     (processing plots)
%     spike     (list of files with locations of spikes)
%     processed (final processed data structure)
%     aqdp      (aquadopp data, if present)
%       |- raw      (raw aquadopp files)
%       |- offload  (ascii files)
%       |- mat      (raw matlab)
%       |- profiles (raw split into profiles)
%
%
%   INPUT   mpdatadir - Base directory (from MP_basedatadir)
%           info      - MP info structure (from MP_deploymentinfo)
%
%   Gunnar Voet  [gvoet@ucsd.edu]
%
%   Created: 10/06/2015

% Create base directories - only if they don't exist yet.
dirs = {'raw','offload','mat','gridded','cal','comms','plots','spike',...
        'processed'};
for i = 1:length(dirs)
  D = fullfile(mpdatadir,dirs{i});
  if ~exist(D,'dir')
    mkdir(D)
  end
end

% Print directory structure and information to screen
fprintf(1,'\n');
fprintf(1,'Creating MP directory structure in\n');
fprintf(1,'  %s\n',mpdatadir);
fprintf(1,'   |--raw       (raw McLane files)\n');
fprintf(1,'   |--offload   (unpacked machine-readable text files)\n');
fprintf(1,'   |--mat       (raw matlab files)\n');
fprintf(1,'   |--gridded   (gridded matlab files)\n');
fprintf(1,'   |--cal       (calibration files)\n');
fprintf(1,'   |--comms     (tattleterm communications logs)\n');
fprintf(1,'   |--plots     (processing plots)\n');
fprintf(1,'   |--processed (final processed data)\n');
fprintf(1,'   |--spike     (list of files with locations of spikes)\n');

% Create aquadopp directories if MP was equipped with an aquadopp current
% meter
dirsaqd = {'aqdp','aqdp/mat','aqdp/offload','aqdp/profiles','aqdp/raw'};
if strncmp(info.VELsensor.sn,'AQD',3)
for i = 1:length(dirsaqd)
  D = fullfile(mpdatadir,dirsaqd{i});
  if ~exist(D,'dir')
    mkdir(D)
  end
end
fprintf(1,'   |--aqdp\n');
fprintf(1,'   |   |-- raw      (raw aquadopp files)\n');
fprintf(1,'   |   |-- offload  (ascii files)\n');
fprintf(1,'   |   |-- mat      (raw matlab)\n');
fprintf(1,'   |   |-- profiles (raw split into profiles)\n');
end

fprintf(1,'\n');