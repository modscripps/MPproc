function MMP=MakeCTD_gridMMP(drops,zmaxg,dz)
%Specify a range of drops and a maximum depth for a gridded vector.
%This routine will create a CTD-like gridded structure containing 
%all of the information from that range of MMP drops.  It will
%look up the mmplog structure and fill in yday, lat, lon, etc if they are 
%present.
%drops=11455:11590;
%drops=drops(1:3);

if nargin < 3
    dz=0.5;
end

cruise=read_cruises_mmp(drops(1));
mmpfolders
%cruise='ps02'
load([procdata filesep cruise filesep 'mmplog'])

%Smoothing for density ratio
zsm=8;

%The deepest drop was to 220 m.  
%dz=0.5;
%zmaxg=220;

zgrid=(0:dz:zmaxg)';

MMP.z=zgrid;

for c=1:length(drops)
    drop=drops(c);
    indlog=find(mmplog(:,1)==drop);
    
    DisplayProgress(drop,1)
    [epsilon, pr_eps, w_eps]=get_epsilon2_mmp(drop);
    [pr_thetasd,t,theta,salinity,sgth]=get_thetasd2_mmp(drop,'t','th','s','sgth',0);
    salinity=salinity*1000;
    [Rrho,angle]=MyRrhofun2(salinity,theta,pr_thetasd,zsm);
    %[chi, pr_chi]=get_chi1_mmp(drop);
    dox=get_dox_mmp(drop);
    if isempty(find(~isnan(dox)))
        dox=NaN*zeros(size(t));
    end
    
    %Now interpolate onto the grid
    MMP.dox(:,c)=nonmoninterp1(pr_thetasd*100,dox,zgrid);
    MMP.t(:,c)=nonmoninterp1(pr_thetasd*100,t,zgrid);
    MMP.th(:,c)=nonmoninterp1(pr_thetasd*100,theta,zgrid);
    MMP.s(:,c)=nonmoninterp1(pr_thetasd*100,salinity,zgrid);
    MMP.sgth(:,c)=nonmoninterp1(pr_thetasd*100,sgth,zgrid);
    MMP.rrho(:,c)=nonmoninterp1(pr_thetasd*100,Rrho,zgrid);
    MMP.tu(:,c)=nonmoninterp1(pr_thetasd*100,angle,zgrid);
    MMP.eps(:,c)=10.^nonmoninterp1(pr_eps*100,log10(epsilon),zgrid);
    %MMP.chi(:,c)=10.^nonmoninterp1(pr_chi*100,log10(chi),zgrid);
    MMP.w(:,c)=nonmoninterp1(pr_eps*100,w_eps,zgrid);
    
    
    %Then fill in the easy ones
    MMP.yday(c)=mmplog(indlog,3)';
    MMP.lat(c)=mmplog(indlog,4)';
    MMP.lon(c)=mmplog(indlog,5)';
    MMP.mmpid(c)=mmplog(indlog,11)';
    MMP.drop(c)=mmplog(indlog,1)';
end

%Final error checking

%Now put NaN's in where the dox is negative
ind1=find(MMP.dox(100,:)<0);
MMP.dox(:,ind1)=NaN;

%subtract 1000 from sgth
MMP.sgth=MMP.sgth-1000;

