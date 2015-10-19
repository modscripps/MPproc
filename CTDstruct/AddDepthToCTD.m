function CTD=AddDepthToCTD(CTD);
%function CTD=AddDepthToCTD(CTD);
%Add a vector of water depth to a CTD structure.
%It is cruise-dependent since the depth data typically come from different
%places.
%
%MHA 02./04
switch CTD.cruise
    case 'ml04',
        CTD.H=5000*ones(size(CTD.yday));  %Water depth is approximate and very deep.
    otherwise,
        disp 'unimplemented cruise.  Storing NaNs.'
        CTD.H=NaN*CTD.yday;
end
