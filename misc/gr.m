function y = gr(x)

% GR Expand a single value into a gray color
%
%   INPUT   x - grayscale (single value or vector)
%       
%   OUTPUT  y - vector or matrix with grayscales
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Last modification: 07/16/2013

[m,n] = size(x);
if n>m
  if m~=1
    error('must be single value or matrix')
  else
  x = x(:);
  end
elseif n~=1
  error('must be single value or matrix')
end

y = repmat(x,1,3);