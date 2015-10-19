function theballast = ballastFCN(t,s,dens,p)

% theballast = ballastFCN(t,s,dens,p);
% Return a record containing ballast information in celsius, psu, kg/m^3
% and dbars.
% MHA 1/05

theballast.t    = t;
theballast.s    = s;
theballast.dens = dens;
theballast.p    = p;
