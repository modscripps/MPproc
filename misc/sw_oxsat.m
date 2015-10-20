function oxs = sw_oxsat(T,S);
% oxs = sw_oxsat(T,S); Oxygen saturation value (ml/l) for seawater at T,S and 1 atm
%	T = in situ temperature (deg C);
%	S = salinity (cu);  [convert to parts/thousand]
%	oxs = oxygen saturation value (ml/l), figured at 1 atmosphere of pressure
%
%	Test values: sw_oxsat([4 20], [0.010 0.035]) = [8.57 5.17];
%	Coded 19-Jul-2001 by David Winkel, per SeaBird Appl. Note 64 (SBE 43 DO Sensor)
%		from Weiss, 1970, DSR 17
%
% SBE Note: "The units are ml/l, the oxygen saturation value is the volume
%	of the gas (STP) absorbed from water saturated air at a total pressure of
%	one atmosphere, per unit volume of the liquid at the temperature of measurement
%	where: S = salinity in parts per 1000, T = oC + 273.15 (absolute temperature)"

%----------------------
% CHECK INPUT ARGUMENTS
%----------------------
if nargin ~=2
   error('sw_oxsat.m: Must pass 2 parameters')
end %if

S=1000*S; % to ppt
T=T+273.15; % to K

% CHECK S,T,P dimensions and verify consistent
[ms,ns] = size(S);
[mt,nt] = size(T);
% CHECK THAT S & T HAVE SAME SHAPE
if (ms~=mt) | (ns~=nt)
   error('check_stp: S & T must have same dimensions')
end %if

oxs = NaN*T; % initialize

% Formula coeffecients:
A1 = -173.4292;
A2 = 249.6339;
A3 = 143.3483;
A4 = -21.8492;
B1 = -0.033096;
B2 = 0.014259;
B3 = -0.00170;

%% Compute:

t100 = T/100;

oxs = exp( A1 + A2*(1./t100) + A3*log(t100) + A4*(t100)+ ...
   S .* (B1 + B2*(t100) + B3*(t100).^2) );
