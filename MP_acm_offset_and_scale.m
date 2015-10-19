function ac = MP_acm_offset_and_scale(mpdatadir,UseProfiles,PlotProfile)

% ac = MP_acm_offset_and_scale(mpdatadir,UseProfiles,PlotProfile)
%
% Wrapper function for MP_acm_correction.m to calculate ACM offset and scale.
%
% Input: mpdatadir - base directory
%        UseProfiles - vector with profile numbers to process. [] will
%                      process all available profiles (default)
%        PlotProfiles - chose profile for plotting (default first of
%                       UseProfiles)
%
% Output: ac - structure with results:
%           .mean_offset - mean offset calculated for all UseProfiles
%           .median_offset - median offset
%           .mean-scale_factors -
%           .median_scale_factors - 
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 09/08/2015


datadir = fullfile(mpdatadir,'offload/');

dd = dir('offload/A*.TXT');
if isempty(UseProfiles)
  UseProfiles = 1:length(dd);
  UseAll = 1;
else
  UseAll = 0;
end

% Check if PlotProfile is member of UseProfiles, warn if not
if ~ismember(UseProfiles,PlotProfile)
  fprintf('\n\n acm_offset_and_scale.m:\n PlotProfile not found within UseProfiles, not plotting.\n\n')
end

count = 0;
for i = 1:length(UseProfiles)
  if UseAll
    fn = fullfile(mpdatadir,dd(i).name);
  else
    fn = fullfile(mpdatadir,sprintf('offload/A%07d.TXT',UseProfiles(i)));
  end
  count = count+1;
  if UseProfiles(i)==PlotProfile; MakePlot = 1; else MakePlot = 0; end
  fprintf(' Profile %03d: calculating compass offset & scale\n',UseProfiles(i))
  [acmcorr(count).offsets,...
   acmcorr(count).scale_factors,...
   acmcorr(count).bias_angles,...
   acmcorr(count).average_bias] = MP_acm_correction(fn,MakePlot);
end

% Calculate mean, median and std of the coefficients
for i = 1:length(acmcorr)
  offset1(i) = acmcorr(i).offsets(1);
  offset2(i) = acmcorr(i).offsets(2);
  scalefactor1(i) = acmcorr(i).scale_factors(1);
  scalefactor2(i) = acmcorr(i).scale_factors(2);
end

ac.mean_offset(1) = nanmean(offset1);
ac.mean_offset(2) = nanmean(offset2);
ac.median_offset(1) = nanmedian(offset1);
ac.median_offset(2) = nanmedian(offset2);

ac.mean_scale_factors(1) = nanmean(scalefactor1);
ac.mean_scale_factors(2) = nanmean(scalefactor2);
ac.median_scale_factors(1) = nanmedian(scalefactor1);
ac.median_scale_factors(2) = nanmedian(scalefactor2);

fprintf(1,' MP_acm_offset_and_scale: DONE\n');