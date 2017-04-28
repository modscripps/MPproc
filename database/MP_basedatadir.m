function mpdatadir = MP_basedatadir(info)

% MP_basedatadir Set base path for MP data directory
%
%   MPDATADIR = MP_basedatadir(info)
%
%   INPUT   info - MP info structure
%       
%   OUTPUT  mpdatadir - path to directory containing all Projects with MP
%                       data
%
%   If working in the data archive, the base directory would be
%   /Volumes/Ahua/data_archive/WaveChasers-DataArchive/
%
%   Gunnar Voet   [gvoet@ucsd.edu]
%
%   10/2015


% SET YOUR PATH HERE
% basedatadir = '/Users/gunnar/scratch/sp_mp_processing/';


% Path on the server
% basedatadir='/Volumes/Ahua/data_archive/WaveChasers-DataArchive/';
basedatadir='/Users/gunnar/Projects/fleat/data/';

% Path to current deployment                % e.g.
mpdatadir = fullfile(basedatadir,...        % -------------
                     info.experiment,...    % SamoanPassage
                     'Moorings',...
                     info.deployment,...    % sp14
                     info.station,...       % T4
                     'MP',...
                     ['sn' info.sn]);       % 105