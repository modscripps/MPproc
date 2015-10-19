function MP=FinishProcessingMP(MP,PP)
%function MP=FinishProcessingMP(MP,PP)

if nargin < 2    
    %Eventually if there are many parameters, make a default function
    PP.zsm_sh=10; %smoothing interval for shear
    PP.zsm_n2=4; %and for N2
    PP.ft=1; %# of profiles to average over for Ri and shear
    PP.twin = 5; %time interval in days over which to smooth mean density for d_Iso
    PP.zvals=min(MP.z):mean(diff(MP.z)):max(MP.z); %1-m intervals
    PP.computeoverturns=0;
end

%Final editing - added 2/05
MP.sgth(find(MP.sgth==0))=NaN; %Find some zero densities that appear
MP.s(find(MP.s==0))=NaN; 
MP.t(find(MP.t==0))=NaN; 
MP.th(find(MP.th==0))=NaN; 

dz=mean(diff(MP.z));
nv=fix(PP.zsm_sh/dz); %For 10-m shear

disp 'Computing isopycnal depths'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute isopycnal depth and N2 for the Toole profiler
MP=AddIsopycnalDepthToCTD(MP,PP.zvals,PP.twin);
disp 'Computing N2'

%Now add in other derived parameters
MP=AddN2toCTD(MP,PP.zsm_n2); %4-m N2
disp 'Computing Eulerian quantities'

MP=AddETA_EULToCTD(MP);
disp 'Computing BC vel'
MP=AddBCVelToCTD(MP);
disp 'Computing energy'

MP=AddEnergyToCTD(MP);

disp 'Computing shear, Ri and Gregg-Henyey'

%Now shear
MP.uz=diffs(MP.u)/dz;
MP.vz=diffs(MP.v)/dz;
MP.uzs=CenteredConv(MP.uz,PP.ft,nv);
MP.vzs=CenteredConv(MP.vz,PP.ft,nv);
MP.shear=sqrt(MP.uzs.^2+MP.vzs.^2);
MP.shearm=nanmean(MP.shear')';

MP.gregg=GreggHenyeyDissFCN(MP.shear,sqrt(MP.n2m));
MP.greggm=nanmean(MP.gregg')';

MP.greggm_sm=CenteredConv(MP.greggm,PP.ft,nv);
%Ri
%fz=10;
%ft=2;
MP.shearsm=CenteredConv(MP.shear,PP.ft,nv);
MP.n2sm=CenteredConv(MP.n2,PP.ft,nv);
MP.invri=MP.shearsm.^2./MP.n2sm;

%Compute Strain and smooth it
MP.strain=diffs(MP.d_Iso)./dz - 1;
MP.strains=CenteredConv(MP.strain,PP.ft,nv);
MP.strainEULs=CenteredConv(MP.strainEUL,PP.ft,nv);

MP.PP=PP; %return the parameters used

if PP.computeoverturns==1
    [MP,MPOverturns,MPout,o]=AddMPoverturns(MP);
end

MP=Add_correct_yday_MP2(MP);
