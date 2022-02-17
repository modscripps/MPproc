function y = nanmedian(x)
% NANMEDIAN Takes the median of data excluding NaN's.
%
%       Y = nanmedian(X) is a workaround for newer versions of Matlab that
%       do not provide nanmedian() anymore but make you use median() instead.


y = median(x, 'omitnan');
