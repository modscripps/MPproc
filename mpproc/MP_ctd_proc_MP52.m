function c = MP_ctd_proc_MP52(cpres, ctemp, ccond, cdox, CTpar, doxcal)

% C = PROC_CTD_MP52(cpres, ctemp, ccond, cdox, CTpar, doxcal)
%
% specify cond in mmho/cm (S/m*10), dox in raw freq.
% Apply editing and lag corrections to SBE 52MP data from the moored
% profiler. This is adapted from Dave's Calc_Sci_MP.m and salin_swims.m.
%
% 7/05 MHA
%
% 09/2015 GV changing routine to accept two sets of thermal mass correction
% parameters.

% Set default values
if ~exist('p_bounds','var')
  p_bounds = [0 6000];
end
if ~exist('c_bounds','var')
  c_bounds = [20 60];
end
if ~exist('t_bounds','var')
  t_bounds = [0 25];
end

% O2: If not specified, use parameters for SBE MP52-002, deployment hc05d1.
if nargin < 6
  doxcal.A=-2.6122e-3;
  doxcal.B=1.4368e-4;
  doxcal.C=-2.6577e-6;
  doxcal.E=0.036;
  doxcal.Soc=2.5876e-4;
  doxcal.Foffset=-815.6391;
  doxcal.FS_lf = 1 / 1.20; % sample rate (Hz) for MP sensors
  doxcal.Lag = -3.0; % try -(2:3)s if Tau_0 is used, else -(5:8)s
  doxcal.Tau_0 = 2.8; % try 1:3 s
end

% GV: We shouldn't use default thermal mass parameters. 
% if nargin < 5
%   CTpar.freq = 1 / 1.20; % sample rate (Hz) for MP sensors
%   CTpar.lag = +.05; % number of scans
%   CTpar.alfa = 0.005; % SWIMS was 0.023
%   CTpar.beta = 0.15; % SWIMS was 1/6.5
%   CTpar.P2T_lag = -1.0; % lag (in scans) from pres to temp sampling
% end


% MHA: We apply lags to pressure and cond.  So, do these in the matrix
% versions PP and CC.  We do not apply any changes to T.
TT = ctemp;      % deg C
CC = ccond./10;  % convert from mS/cm to S/m (needed in thermal mass corr)
PP = cpres;      % dbar
DO_freq = cdox;

SS = TT*NaN; % initialize salin, theta, sigma_theta, dis. oxygen
TH = SS;
SG = SS;
DO = SS;

nP = size(PP,2); % number of profiles - should only be one for regular MP
                 % processing as mag_pgrid cycles over all profiles
if nP>1
  nP = size(PP,1);
end
if nP>1
  error('fix me!')
end

for ip = 1:nP

  % Reference to pressure of water later sampled at temperature probe
  if abs(CTpar.P2T_lag)>0.001
    PP(:,ip) = MP_shift(PP(:,ip), -CTpar.P2T_lag);
  end
  T = TT(:,ip);
  C = CC(:,ip);
  P = PP(:,ip);

  ig = find(~isnan(T+C+P)); % good data

  if length(ig)>5

    % Shift conductivity
    Craw = C;
    if length(CC) > abs(CTpar.lag)+2
        CC(:,ip) = MP_shift(Craw, CTpar.lag);
    end
    C = CC(:,ip);
        
    % Thermal Mass algorithm is from SeaBird SeaSoft-Win32 manual (pdf)
    if CTpar.alfa>1e-10 && CTpar.beta>=0
      % compute/initialize temp diffs, cond corrections
      dTp = T;
      dTp(2:end) = diff(T);
      dTp(1) = dTp(2);
      dcdt = 0.1 * (1 + 0.006*(T-20));
      ctm = 0*dTp;
      % a,b
      aa = 2 * CTpar.alfa / (2 + CTpar.beta/CTpar.freq);
      bb = 1 - (2*aa/CTpar.alfa);
      % compute corrections
      for i = 2:length(C)
        ctm(i) = -1.0*bb*ctm(i-1) + aa*dcdt(i)*dTp(i);
      end
      C = C + ctm;
    end
    
    
    % Second thermal mass algorithm if second set of parameters given
    if isfield(CTpar,'alfa2') && isfield(CTpar,'beta2')
      % compute/initialize temp diffs, cond corrections
      dTp = T;
      dTp(2:end) = diff(T);
      dTp(1) = dTp(2);
      dcdt = 0.1 * (1 + 0.006*(T-20));
      ctm = 0*dTp;
      % a,b
      aa = 2 * CTpar.alfa2 / (2 + CTpar.beta2/CTpar.freq);
      bb = 1 - (2*aa/CTpar.alfa2);
      % compute corrections
      for ii = 2:length(C)
        ctm(ii) = -1.0*bb*ctm(ii-1) + aa*dcdt(ii)*dTp(ii);
      end
      CC(:,ip) = C + ctm;
    end
      
  end
    
    % Seawater toolbox, needs C in mS/cm
    display('calculating salinity for SBE52 using seawater toolbox')
    SS(ig,ip) = sw_salt(CC(ig,ip).*10./sw_c3515,T(ig),PP(ig,ip));
    
    % theta and sigma_theta
    TH(ig,ip) = sw_ptmp(SS(ig,ip), T(ig), PP(ig,ip), 0);
    SG(ig,ip) = sw_dens(SS(ig,ip), TH(ig,ip), 0) - 1000;

    ig = find(~isnan(T+C+P+SS(:,ip)+DO_freq(:,ip)));
    if length(ig)>5 % dissolved oxygen, mg/L
      clear Dox
      Dox = MP_ctd_proc_Dox_sbe43F(DO_freq(ig,ip), T(ig), SS(ig,ip), PP(ig,ip), doxcal);
      DO(ig,ip) = Dox;
    end
    
end


c.pres = PP;
c.cond = CC * 10; % convert back to mS/cm (mmho/cm)
c.temp = TT;
c.sal  = SS;
c.dox  = DO;
c.th   = TH;
c.sgth = SG;

