function ny = MP_clean(y,ms)

% NY = MP_CLEAN Performs robust cleaning of data 
%  usage: ny = MP_clean(y,ms)
%   ms = median filter length (must be odd)
%
%  from Arthur Newhall

if (nargin==1), ms=3; end;

if (rem(ms,2)~=1), error('median filter length must be an ODD number');end;

[Ny,My] = size(y);
y = y(:)';
N = max(Ny,My);

ny = y;

yy = zeros(ms,N-ms+1);
ym = zeros(1,N);

for i = 1:ms,              % Do the middle bits
  yy(i,:) = y(i:N-ms+i);
end;

ym(fix(ms/2)+1:N-fix(ms/2)) = median(yy); 

for i = 1:fix(ms/2),       % Fix the ends
   ym(i)     = median(y(1:2*i-1));
   ym(N-i+1) = median(y(N-2*i+2:N));
end;

smad = median(abs(y-ym)');    % MAD


ii = find(abs(y-ym)> 3*smad);  % Guess the outliers, 3 times std here

ny(ii) = ym(ii);               % replace outliers with interpolated values.

ny = reshape(ny,Ny,My);

