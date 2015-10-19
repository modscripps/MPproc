function CTD=AddVelToCTD(CTD,sonar);
%function CTD=AddVelToCTD(CTD,sonar);
%Interpolate velocity (usually from a ADCP) onto the SWIMSgrid time-depth
%base.  sonar is usually processed and de-spiked before this step.
%
%sonar HAS THE FOLLOWING FIELDS: 
%u,v: [mxn matrices of velocity in m/s]
%yday: 1xn vector of time
%depth: m x 1 depth vector
%
%MHA 2/04


%For the common case of the 150-KHz BBADCP acquired through the SWIMS
%system, make some changes.
if ~isfield(sonar,'sonar_freq')
    sonar.sonar_freq='150KHz';
end
if ~isfield(sonar,'depth') & isfield(sonar,'z_adcp')
    sonar.depth=sonar.z_adcp;
end
if ~isfield(sonar,'u') & isfield(sonar,'u_wat')
    sonar.u=sonar.u_wat;
end
if ~isfield(sonar,'v') & isfield(sonar,'v_wat')
    sonar.v=sonar.v_wat;
end

CTD.u=interp2(sonar.yday,sonar.depth,sonar.u,CTD.yday,CTD.z);
CTD.v=interp2(sonar.yday,sonar.depth,sonar.v,CTD.yday,CTD.z);
CTD.sonar_freq=sonar.sonar_freq;


