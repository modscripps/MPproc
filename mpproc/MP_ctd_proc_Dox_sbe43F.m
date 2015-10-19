function Dox = MP_ctd_proc_MP_ctd_proc_Dox_sbe43F(DoxHz, T, S, P, DoxCoef)
%function Dox = Dox_sbe43F(DoxHz, T, S, P, DoxCoef)
% Compute Dox = dissolved oxygen [put dox in mg/L], given:  DoxHz = raw freqs,
%   T,S,P: temperature (degC, in situ), salinity (C.U.), pressure (MPa),
%   and DoxCoef = structure of calibration coefficients.
% may-2005, DPW, for Moored Profiler SBE43F sensor
% MHA 7/12/05: modified to take S in psu and P in dbar

Dox = NaN*DoxHz; Dox_mll = Dox;
mg_per_ml=32/22.4;

if nargin<4 | ~isstruct(DoxCoef)
    clear DoxCoef
    DoxCoef.xxx = 0;
end

% default cals:
% (sensor SN 0099, 29-Jan-2005)
A = -2.6122e-3;
B = 1.4368e-4;
C = -2.6577e-6;
E = 0.036;
Soc = 2.5876e-4;
Foffset = -815.6391;
% other parameters:
Lag = 0; % in seconds, convert to scans below
Tau_0 = 0;  % time constant, in case of future re-implementation
Tau_Ft = 0; % possible coef for temperature dependence
FS_lf= 0.833; % sample rate in Hz (MP samples every 1.20-s)
dNH = 2; % for dFreq/dt, center-difn using points +/-dNH away
% Volts/Hz, for time-resp correction (based on 0:5 V -> 0:10000 Hz ??)
VperHz = 1;%5 / 10000; % (and by comparing Soc's for Hz vs V units)
%% Tau = 4.4; % response time scale, seconds (during aeg04: for VOLTs)
vvs = {'A','B','C','E','Soc','Foffset', ...
        'Lag','Tau_0','Tau_Ft','FS_lf','dNH', 'VperHz'};
%% Check for specified values, replace defaults if present
for i=1:length(vvs)
    if isfield(DoxCoef,vvs{i})
        x = eval(['DoxCoef.' vvs{i} ';']);
        if ~isempty(x)
            eval([vvs{i} ' = x;']);
        end
    end
end
dNH = min( dNH, floor( length(Dox)/2 - .49) ); % in case of too few points

% Shift scans here (T,S also, to get proper sw_oxsat()?)
if abs(Lag)>1e-10
    Lag = Lag * FS_lf; % convert from seconds to scans (samples)
    DoxHz = MP_shift(DoxHz, Lag);
    T = MP_shift(T, Lag);
    S = MP_shift(S, Lag);
end
% option for specified response-time parameters
Tau = Tau_0; % + func(T; Tau_Ft);

%MHA: take arguments in nnormal units of dbar and psu
%S = S*1000; % parts/thousand
%P = P*100; % decibars

doxdt = 0; 
if dNH > 0 & ~isempty(find(Tau)>1e-10) % compute dV/dt for response-time correction
    clear vx tx 
    vx = DoxHz * VperHz; tx = [1:length(vx)]' / FS_lf; % (columns for MP)
    fp = dNH+1; lp = length(vx)-dNH;
    dv = ( vx(fp+dNH:lp+dNH) - vx(fp-dNH:lp-dNH) );
    dt = ( tx(fp+dNH:lp+dNH) - tx(fp-dNH:lp-dNH) );
    for i = dNH-1:-1:1 % use fewer points near ends
        x(1)=( vx(2*i+1)-vx(1) ); x(2)=( vx(end)-vx(end-2*i) );
        y(1)=( tx(2*i+1)-tx(1) );  y(2)=( tx(end)-tx(end-2*i) );
        dv = [x(1); dv; x(2)];  dt = [y(1); dt; y(2)]; % columns for MP
    end
    % fwd/bwd difn at ends (columns for MP)
    dv = [ (vx(2)-vx(1)); dv; (vx(end)-vx(end-1)) ];
    dt = [ tx(2)-tx(1); dt; tx(end)-tx(end-1) ];
    doxdt = dv ./ dt;
end

% expression from calibration sheet (response-time term added, DPW):
Dox_mll = ( Soc * ((DoxHz + Foffset) + (Tau.*doxdt)) ) ...
    .* (1.0 + A*T + B*T.^2 + C*T.^3) ...
    .* sw_oxsat(T,S/1000) .* exp(E*P./(T+273)); % deg K for pressure term
% Zero is minimum, fix any negatives
ix = find(Dox_mll<0);
Dox_mll(ix) = 0;

Dox = Dox_mll .* mg_per_ml; % put dox in mg/l
