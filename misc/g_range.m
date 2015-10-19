function y = g_range(x)

% G_RANGE Find minimum and maximum of a vector
%
%   Y = g_range(X)
%
%   INPUT   x - vector, row or column, can have NaN's
%       
%   OUTPUT  y - 2-element vector with min and max of x
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 06/25/2015

if any(size(x)==1)
  y(1) = nanmin(x);
  y(2) = nanmax(x);
else
  y(1) = nanmin(nanmin(x));
  y(2) = nanmax(nanmax(x));
end