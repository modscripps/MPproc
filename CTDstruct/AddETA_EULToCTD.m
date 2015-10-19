function CTD=AddETA_EUL(CTD);
%function CTD=AddETA_EUL(CTD);
%Here we compute eulerian eta and d_Iso by interpolation of the eta at the
%isopycnal's instantaneous depth.
CTD.etaEUL=NaN*CTD.sgth;
CTD.d_IsoEUL=CTD.etaEUL;


%First obtain an Eulerian version of this.
for c=1:length(CTD.yday)
    indg=find(~isnan(CTD.eta(:,c)));
    %length(indg)
    if length(indg)>3
        CTD.etaEUL(:,c)=nonmoninterp1(CTD.d_Iso(indg,c),CTD.eta(indg,c),CTD.z);
        CTD.d_IsoEUL(:,c)=nonmoninterp1(CTD.d_Iso(indg,c),CTD.d_Iso(indg,c),CTD.z);
%        CTD.strain2EUL(:,c)=nonmoninterp1(CTD.d_Iso(indg,c),CTD.strain(indg,c),CTD.z);
    end
end

%1/11/04 - add Eul strain calc
tmp=CTD.n2m*ones(size(CTD.yday));
CTD.strainEUL=tmp./CTD.n2;