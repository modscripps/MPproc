function y = MP_shift(x,t)

% MP_SHIFT
%      y = MP_shift(x,t) shifts the time series x by t samples. The variable t 
%      does not have to be an integer, and can be negative (representing a 
%      lag).  The algorithm linearly interpolates if the shift is a
%      non-integer.  A positive shift yields a lagged time series while a
%      negative one advances the time series.

y = x; % ensure size is retained (dpw,5/05)

if t==0
  return;
end

N = length(x);
int_shift = floor(t);
part_shift = t-int_shift; 
% Notice that part_shift is always greater or equal to zero.

if int_shift>0
  % shift forward, stretching the initial value...
  y(int_shift+1:N) = x(1:N-int_shift);
  y(1:int_shift) = ones(1,int_shift)*x(1);
elseif int_shift<0
  y(1:N+int_shift) = x(1-1*int_shift:N);
  y(N+int_shift+1:N) = x(N)*ones(1,-1*int_shift);
else
  y = x;
end;

if part_shift > 0
  y(2:N) = (1-part_shift)*diff(y)+y(1:N-1);
end;



