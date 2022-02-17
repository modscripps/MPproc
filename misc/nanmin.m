function y = nanmin(x, varargin)
% NANMIN Takes the mean of data excluding NaN's.
%
%       Y = nanmin(X) is a workaround for newer versions of Matlab that
%       do not provide nanmin() anymore but make you use min() instead.

if isempty(varargin)
  y = min(x, [], 'omitnan');
else
  y = min(x, varargin{1}, 'omitnan');
end
