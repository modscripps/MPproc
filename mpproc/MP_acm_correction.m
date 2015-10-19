function [offsets, scale_factors, bias_angles, average_bias] = MP_acm_correction(fn,MakePlot)
% MP_ACM_CORRECTION acm Compass Correction
%   loads processed ACM field data
%   plots raw data vs unit circle
%   calculates corrections using non-linear minimization
%     (Nelder-Mead Simplex algorithm, repeated calls "force" a good seed value)
%   plots corrected values
%   displays offset and scale parameters
%
% Copyright 2002 Todd Morrison McLane Reaearch Laboratories, Inc.
%
% Modified by GV; Jul 2015

% *******************************************************************************

% global HX HY U SQRT2 M

SQRT2 = sqrt(2);

t = [-180:1:180]' .* pi ./ 180;
x = sin(t);
y = cos(t);

fid = fopen(fn, 'r') ;
% Make sure file is being read correctly
if fid == -1
  error('Could not find specified file in the current directory')
end

% Distinguish between regular data file and spin test file
if strcmp(fn,'spintest.txt')
  H = [fscanf(fid, '%f %f %f %f %f', [5, inf])]';
else
  H = [fscanf(fid, '%f %f %f %f %f %f %f %f %f', [9, inf])]';
end

% Close file
fclose(fid);

% Extract direction information
HX = H(:,3);
HY = H(:,4);

U  = ones(size(HX));

% pass variables on to c_circle
save tmpfile.mat HX HY U

% lambda = [Xo, Yo, Xs, Ys]
lambda = [0, 0, 1, 1] ;
lambda = fminsearch('c_circle', lambda) ; % second call has a better guess seed
lambda = fminsearch('c_circle', lambda) ; % and tends to give better convergence
lambda = fminsearch('c_circle', lambda) ; % superfluous or just anal retentive?

!rm tmpfile.mat

Xo = lambda(1) ; Yo = lambda(2) ;
Xs = lambda(3) ; Ys = lambda(4) ;
  
MX = (HX - Xo) ./ Xs ;
MY = (HY - Yo) ./ Ys ;

% if (fn == 'spintest' & length(HX) == 8)
if strcmp(fn,'spintest.txt') && length(HX) == 8
  HA = atan2(MX, MY) .* 180 ./ pi ;           % compass angle
  XA = [1 SQRT2 0 -SQRT2 -1 -SQRT2 0 SQRT2]' ;
  YA = [0 SQRT2 1 SQRT2 0 -SQRT2 -1 -SQRT2]' ;
  TA = atan2(XA, YA).* 180 ./ pi ;            % true angle
  if (HA(7) < 0)
    TA(7) = -TA(7) ;
  end
  DA = TA - HA ;                              % bias angles
  AA = mean(DA) ;                             % mean bias angle
end

% offsets       = sprintf('%+6.3f           %+6.3f', Xo, Yo) ;
offsets = [Xo,Yo];

% scale_factors = sprintf('%+6.3f           %+6.3f', Xs, Ys) ;
scale_factors = [Xs, Ys];

% if (fn == 'spintest' & length(HX) == 8)
if strcmp(fn,'spintest.txt') && length(HX) == 8
%   bias_angles  = sprintf('  %+5.1f', DA) ;
%   bias_angles  = bias_angles(3:length(bias_angles)) ;
  bias_angles = DA;
%   average_bias = sprintf('%+.1f', AA) ;
  average_bias = AA;
else
  bias_angles  = [];
  average_bias = [];
end

% Plot
if MakePlot
  figure(1)
  clf
  plot([1,-1], [0, 0], 'b', [0, 0], [1,-1], 'b', ...
       [1,-1], [1,-1], 'b', [-1,1], [1,-1], 'b', ...
       HY, HX, 'ko', MY, MX, 'ro', y, x, 'g')
  axis square
  grid
  xlabel('HY_{CORRECTED}')
  ylabel('HX_{CORRECTED}')
  title('Corrected ACM Compass - Non-Linear Optimization')
  axis([-1, 1, -1, 1]) ;
  set(gca, 'xtick', [-1 -.75 -.5 -.25 0 .25 .5 .75 1]) ;
  set(gca, 'ytick', [-1 -.75 -.5 -.25 0 .25 .5 .75 1]) ;
  drawnow
end