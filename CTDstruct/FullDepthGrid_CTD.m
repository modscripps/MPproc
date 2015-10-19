function CTD=FullDepthGrid_CTD(CTD)
%function CTD=FullDepthGrid_CTD(CTD)
%
%Add regions above and below the resolved grid if necessary to extend overage to the 
%surface and bottom.  NaN's are stored to indicate no data there.
%

%If depth is constant, annex on swaths
if max(CTD.H)==min(CTD.H)
   CTD2=CTD;
   dz=nanmean(diff(CTD.z));
   CTD2.z=0:dz:CTD2.H(1);
   
end