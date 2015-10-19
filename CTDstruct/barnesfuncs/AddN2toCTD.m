function CTD=AddN2toCTD(CTD,dz_n2)
%function CTD=AddN2toCTD(CTD,dz_n2)
%Compute N2 over windows of specified size in m, dz_n2.  
%All units should be in psu, degs, and m - output units are (rad/s)^2


%zgrid=mp.b.p(:,54);
[m,n]=size(CTD.t);
[m,np]=size(CTD.z); %if we are gridded np will be one

%dz_n2=4;

MP.n2=NaN*CTD.t;

for c=1:n
    if np==1 %gridded
        whp=1;
    else
        whp=c;
    end
    
    salinity=CTD.s(:,c);
    t=CTD.t(:,c);
    p=CTD.z(:,whp);
    
    indg=find(~isnan(salinity) & ~isnan(t) & ~isnan(p));
    if length(indg)>10 %make sure there are enough good points
        %Then call Mike's routine which takes c.u. and MPa units as inputs
        [n2,pout,dthetadz,dsdz]=nsqfcn((salinity(indg))/1000,t(indg),p(indg)/100,dz_n2/100,dz_n2/100);
        
        %Now interpolate onto the grid
        CTD.n2(:,c)=nonmoninterp1(pout*100,n2,CTD.z(:,whp));
    end
    
    
end

