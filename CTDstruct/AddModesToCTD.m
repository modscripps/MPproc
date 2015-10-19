function CTD=AddModesToCTD(CTD,n_modes,plotit,dz)
%function CTD=AddModesToCTD(CTD,n_modes,plotit,dz)
%Compute the dynamic modes for a CTD structure.  All that are required are the fields
%z and n2m, the squared buoyancy freq in radian units.  Return them in the fields
%pn (hori), hn (vert), and cn (eigenspeeds).  The first n_modes (default
%30) are computed.
%
%MHA 4/04
%
%The routine will return with an error if z does not extend all the way to
%the bottom (CTD.H).
%
%9/05: added option of N2=1e-8 instead of 0 in ML, and added Jody's modes
%too (sw_vmodes).  I now do the calculation correctly for profiles that don't span the
%whole water column.
%
%MHA modes are generally the negative of Jody's modes, and are normalized
%differently.  Jody's modes also have the BT mode in the first column, and
%also compute the barotropic mode speed.  So I throw these out and only
%retain the BC modes.

if nargin < 2
    n_modes=30;
end

if nargin < 3
    plotit=1;
end

%We use the mean profile for the modes.
%Tack on a ML above the observations, and extend to the bottom.
if nargin < 4
dz=10;
end

zfull=(0:dz:max(CTD.H))';
ig=~isnan(CTD.z);
n2mfull=interp1(CTD.z(ig),CTD.n2m(ig),zfull);
%Fill in Nan's at bottom with deepest N
ilast=max(find(~isnan(n2mfull)));
n2mfull(ilast+1:end)=n2mfull(ilast);
%Tack on the first value, or a ML
ifirst=min(find(~isnan(n2mfull) & n2mfull > 0)); %change 6/15/06: start below N=0
n2mfull(1:ifirst-1)=n2mfull(ifirst);  %or a ML:%1e-8; %

[hn,pn,CTD.cn_mha]=Modes2a_fcn(zfull,sqrt(n2mfull),n_modes);
[vert,hori,CTD.EDep,CTD.cn]=sw_vmodes(zfull,sqrt(n2mfull),CTD.lat(1),n_modes+1);
vert=vert(:,2:end);
hori=hori(:,2:end);
CTD.EDep=CTD.EDep(2:end);
CTD.cn=CTD.cn(2:end);

%Now interp back to the grid

CTD.vert_mha=interp1(zfull,hn,CTD.z);
CTD.hori_mha=interp1(zfull,pn,CTD.z);
CTD.vert=interp1(zfull,vert,CTD.z);
CTD.hori=interp1(zfull,hori,CTD.z);

%Also store full-depth fields
CTD.vert_mha_full=hn;
CTD.hori_mha_full=pn;
CTD.vert_full=vert;
CTD.hori_full=hori;

CTD.n2m_full=n2mfull;
CTD.z_full=zfull;

if plotit>0
PlotModes_CTD(CTD,plotit)
end

