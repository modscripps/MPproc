function y = nanmean(x, varargin)
% NANMEAN Takes the mean of data excluding NaN's.
%
%       Y = nanmean(X) is a workaround for newer versions of Matlab that
%       do not provide nanmean() anymore but make you use mean() instead.

if isempty(varargin)
  y = mean(x, 'omitnan');
else
  y = mean(x, varargin{1}, 'omitnan');
end