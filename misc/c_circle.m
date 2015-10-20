function epsilon = c_circle(lambda)
%
% Compass Circle - sub function for Nelder-Mead Simplex calculation
%   fminsearch adjusts lambda to minimize epsilon
%   U is the unit circle, HX and HY are compass data columns
%
% Copyright 2002 Todd Morrison McLane Reaearch Laboratories, Inc.

% **********************************************************************

% global HX HY U SQRT2 M
load tmpfile.mat

MX = (HX - lambda(1)) ./ lambda(3) ;
MY = (HY - lambda(2)) ./ lambda(4) ;
M  = (MX .^ 2) + (MY .^ 2) ;

epsilon = norm(M - U) ;
