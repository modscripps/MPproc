function [n2,pout,dthetadz,dsdz]=nsqfcn(s,t,p,p0,dp)
% nsq
%   Usage: [n2,pout,dthetadz,dsdz]=nsqfcn(s,t,p,p0,dp);
%      s is salinity (concentration units) in a column array,
%      t is in-situ temperature (deg C) in a column array
%      p is pressure (MPa) in a column array
%      p0 is the lower bound for pressures (MPa) used for nsq
%      dp is the pressure interval (MPa) over which potential
%         density is first-differenced on the reference surface
%      n2 is the square of the buoyancy frequency, in (rad/s)^2
%      pout is pressure (MPa) at the center of the nsq windows
%      dthetadz is the gradient of potential temperature
%      dsdz is the salinity gradient
%   Function: (a) low-pass filters t,s,p over dp, (b) linearly interpolates
%      t and s onto pressures, p0, p0+dp, p0+2dp, ...., (3) computes
%      upper and lower potential densities at p0+dp/2, p0+3dp/2,...
%      (4) converts differences in potential density into nsq
%      (5) returns NaNs if the filtered pressure is not monotonic.
   
G=9.80655;
dz=100*dp;

% delete negative pressures
i=find(p>=0);

p=p(i); s=s(i); t=t(i);

% reverse order of upward profiles
if p(length(p))<p(1)
	p=flipud(p); t=flipud(t); s=flipud(s);
end

% low pass temp and salinity to match specified dp
dp_data=diff(p);
dp_med=median(dp_data);
%[b,a]=butter(4,2*dp_med/dp); %causing problems...
a=1; b=hanning(2*floor(dp/dp_med)); b=b./sum(b);
tlp=filtfilt(b,a,t); 
slp=filtfilt(b,a,s);
plp=filtfilt(b,a,p);

% check that p is monotonic
diffp=diff(plp);
i=find(diffp>0);
if length(i)==length(plp)-1;

	pmin=plp(1);
	pmax=plp(length(plp));

	% determine the number of output points
	i=find(plp<=pmax-dp);
	npts=length(i);

	while p0<=pmin
		p0=p0+dp;
	end

	% end points of nsq window
	pwin=(p0:dp:pmax)'; 
	t_ep=interp1(plp,tlp,pwin);
	s_ep=interp1(plp,slp,pwin);
	npts=length(t_ep);

	% compute pressures at end points
	pout=(p0+dp/2:dp:max(pwin))';

	% compute potential density of upper window pts at output pressures
	i_u=(1:1:length(pwin)-1);
	pt_u=sw_pden(s_ep(i_u),t_ep(i_u),pwin(i_u),pout);

	% compute potential density of lower window pts at output pressures
	i_l=(2:1:length(pwin));
	pt_l=sw_pden(s_ep(i_l),t_ep(i_l),pwin(i_l),pout);
	
	n2=G^2*(pt_l - pt_u)/(dp*1e6);

	dthetadz=(potemp(s_ep(i_u),t_ep(i_u),pwin(i_u)) - ...
                potemp(s_ep(i_l),t_ep(i_l),pwin(i_l)))/dz;
        dsdz=(s_ep(i_u)-s_ep(i_l))/dz;
else
	disp('  filtered pressure not monotonic')
	n2=NaN; pout=NaN; dthetadz=NaN; dsdz=NaN;
end
