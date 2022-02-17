function y = nanmax(x, varargin)
% NANMAX Takes the max of data excluding NaN's.
%
%       Y = nanmax(X) is a workaround for newer versions of Matlab that
%       do not provide nanmax() anymore but make you use max() instead.

if isempty(varargin)
  y = max(x, [], 'omitnan');
else
  y = max(x, varargin{1}, 'omitnan');
end
