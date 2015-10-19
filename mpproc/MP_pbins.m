function [pgrid,cscan1,cscan2] = MP_pbins(gmin,gmax,gstep,cpres)

% Routine to determine the ctd scan numbers bracketing each pressure bin
%  of the gridded output series
%  jmt 11/97

cscan1 = [];
cscan2 = [];

pgrid = [gmin:gstep:gmax];

nlevs = length(pgrid);
halfbin = gstep/2;

for j = 1:nlevs;

pmin = pgrid(j)-halfbin;
pmax = pgrid(j)+halfbin;

i = find(cpres>=pmin & cpres<=pmax);

if ~isempty(i)
  cscan1(j) = min(i);
  cscan2(j) = max(i);
else
  cscan1(j) = nan;
  cscan2(j) = nan;
end % if

end % j

end % function
