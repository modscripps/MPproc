function CTD=AddBCVelToCTD(CTD)
%function CTD=AddBCVelToCTD(CTD)
%For each velocity record, subtract the depth mean.
%Fields required: u, v
%Fields added: ubc and vbc and ubt and vbt.
%MHA 08/03
CTD.ubc=CTD.u*NaN;
CTD.vbc=CTD.u*NaN;

CTD.ubt=nanmean(CTD.u);
CTD.vbt=nanmean(CTD.v);

for c=1:length(CTD.yday)
CTD.ubc(:,c)=CTD.u(:,c)-CTD.ubt(:,c);
CTD.vbc(:,c)=CTD.v(:,c)-CTD.vbt(:,c);
end
