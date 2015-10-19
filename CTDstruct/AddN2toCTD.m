function CTD=AddN2toCTD(CTD,dz_n2)
%function CTD=AddN2toCTD(CTD,dz_n2)
%fields req'd: t, z, s
%Compute N2 over windows of specified size in m, dz_n2.  
%All units should be in psu, degs, and m - output units are (rad/s)^2
%default smoothing dz_n2 is 8 m.
if nargin < 2
    dz_n2=8;
end

%zgrid=mp.b.p(:,54);
[m,n]=size(CTD.t);
[m,np]=size(CTD.z); %if we are gridded np will be one

%dz_n2=4;

CTD.n2=NaN*CTD.t;

for c=1:n

    if np==1 %gridded
        whp=1;
    else
        whp=c;
    end
    
    salinity=CTD.s(:,c);
    t=CTD.t(:,c);
    p=CTD.z(:,whp);
    %7/31/2012 change, MHA
    %dz=CTD.z(2)-CTD.z(1);
    dz=nanmean(diff(CTD.z));
    indg=find(~isnan(salinity) & ~isnan(t) & ~isnan(p));

    if length(indg)>6*dz_n2/dz %make sure there are enough good points for nsq
        %Then call Mike's routine which takes c.u. and MPa units as inputs
        [n2,pout,dthetadz,dsdz]=nsqfcn(salinity(indg),t(indg),p(indg),dz_n2,dz_n2);
%        [n2,pout,dthetadz,dsdz]=nsqfcn(salinity(indg)/1000,t(indg),p(indg)/100,dz_n2/100,dz_n2/100);
% 3/05 changed Mike's routine to accept normal units again        
        %Now interpolate onto the grid
        CTD.n2(:,c)=nonmoninterp1(pout,n2,CTD.z(:,whp));
    end
    
    
end

%Added this 1/11/04
if n==1
    CTD.n2m=CTD.n2;
else    
    CTD.n2m=nanmean(CTD.n2')';
end
