function CTD=MakeCTD(T,S,z,lat,lon,...
    H,year,yday,cruise,id,ispres,ispotemp,pref);
%function CTD=MakeCTD(T,S,z,lat,lon,...
%    H,year,yday,cruise,id,ispres,ispotemp,pref);
%Make a structure CTD out of specified fields T, S and z.
%T must be in degC, S in psu, z in m.  pressure may be specified; in this
%case, it is converted to depth.  Only the first three fields are required.
%
%
%This defines the CTD class:
%%%%%%%%%%%%%%%%
%Position, time info:
%CTD.yday %yday of measurement
%CTD.year %year
%CTD.lat %lat, lon
%CTD.lon
%CTD.H  %water depth, m
%CTD.cruise
%CTD.id
%%%%%%%%%%%
%Data fields:
%CTD.t  %temperature, degsC
%CTD.s  %salinity, psu
%CTD.sgth %sigma-theta.
%CTD.z  %Use the routine CTD_PtoZ to convert pressure to depth.
%
%These may be either column vectors or matrices.  If matrices, length of
%fields yday, lat, lon and H must equal the number of columns.
%
%Several routines exist for coverting other types of structures to CTD
%structures. i.e. gridded and raw MMP, MP, SWIMSgrid.
%
%A number of routines exist now that act upon the CTD structure.
%Other derived fields can thus be computed easily; e.g., sigma-theta, N2,
%isopycnal depth.
%
%These routines are:
%AddN2ToCTD
%AddIsopycnalDepthToCTD
%AddVelToCTD (specify a sonar record for interpolation)
%AddBCVelToCTD (compute BT and BC vel)
%AddDepthToCTD (this should be a case statement where all cruises are handled
%   in the same place... or pass in a timeseries for interpolation as in AddVel)
%AddModesToCTD
%
%AddModalDecompToCTD (needed)
%AddPPrimeToCTD (needed) could be incorporated into AddFlux.  Use Flux1 and
%AddFlux1ToSWIMSgrid from Mamala.  Need to determine how to distinguish b/w
%modal fits and raw profiles.  Make product consistent with a Flux
%structure. (?)
%AddFluxToCTD (needed)

%Other routines for processing:
%GridCTD_uniformtime
%Need one to do harmonic analysis if uniformly gridded

%Plotting
%GenericPlot1_CTD
%others

if nargin < 3
    error('Not enough input arguments.');
end

[m,n]=size(T);
[m,np]=size(z);

if nargin < 13
    pref=0;
end
if nargin < 12
    ispotemp=0;
end
if nargin < 11
    ispres=0;
end
if nargin < 11
    id=NaN*ones(1,n);
end

if nargin < 9
    cruise='?';
end

if nargin < 8
    yday=NaN*zeros(1,n);
end

if nargin < 7
    year=NaN;
end
if nargin < 6
    H=NaN*zeros(1,n);
end
if nargin < 5
    lon=NaN*zeros(1,n);
end
if nargin < 4
    lat=NaN*zeros(1,n);
end

%If pressure not depth is given, convert to depth
if ispres==1
    p=z;
    z=NaN*p;
    for c=1:np
        %        z(:,c)=p2z(S(:,1)/1000,T(:,1),z(:,c)) %Changed to use T and S from
        %        the c'th drop not the first - 11/5/04 MHA
        %        z(:,c)=p2z(S(:,c)/1000,T(:,c),z(:,c))
        ig=max(find(~isnan(S(:,c)+T(:,c))));
%        [pgrid,zgrid]=p2z(S(:,c),T(:,c),z(:,c),lat(:,c)); %9/05 change: use lat-dependent routine
%        [pgrid,zgrid]=p2z(S(1:ig,c),T(1:ig,c),p(1:ig,c),lat(c)); %9/05 change: use lat-dependent routine
%        z(1:ig,c)=interp1(pgrid,zgrid,p(1:ig,c));
        z(1:ig,c)=sw_dpth(p(1:ig,c),lat); %8/2012 change: use sw_dpth
    end
else
    %Compute pressure for the specified depth.
    for c=1:np
        %        p(:,c)=z2p(S(:,1)/1000,T(:,1),z(:,c))*100; %in dbar
        p(:,c)=z2p(S(:,c),T(:,c),z(:,c)); %in dbar - same change as above here.
    end
end

%Either way both z and p are defined here.

CTD.t=T;
CTD.s=S;
CTD.z=z;
CTD.p=p;

CTD.yday=yday;
CTD.year=year;
CTD.H=H;
CTD.lat=lat;
CTD.lon=lon;
CTD.cruise=cruise;
CTD.id=id;


if ispotemp==1
    TH=T;
else
    %TH=sw_ptmp(S/1000,T,p/100,pref/100); %recall that Mike rewrote all the toolbox routines
    %to use MPa and s in c.u..
    TH=sw_ptmp(S,T,p,pref); %changed back!
end

D=sw_dens(S,TH,pref); %changed back!
if max(D)>1000
    D=D-1000; %sometimes the toolbox does not subtract 1000.  Do it here.
end

CTD.th=TH;
CTD.sgth=D;





