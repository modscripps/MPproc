function CTD=AddIsopycnalDepthToCTD(CTD,zvals,tavg);
%function CTD=AddIsopycnalDepthToCTD(CTD,zvals,tavg);
%Given a structure CTD, specify a set of mean depths, zvals,
%for which to compute isopyncal depth.  The following fields are added to
%the structure:
%d_Iso: the instantaneous depth of the isopyncals whose mean depths are
%    given by zvals
%zvals: the mean depths
%mdens: the mean density profile
%eta: the instantaneous upward displacement of isopyncals relative to their
% mean position.  This can be either the time-mean or the slowly-varying
% time-mean (see below).
%
%MHA 08/03
%
%Change 06/04: if CTD.dvals exists, then use those.  This allows a pre-set
%set of densities to be used.
%Transpose so zvals is a column vector
if nargin < 2
    zvals=CTD.z;
end

[m,n]=size(zvals);
if n > m 
    zvals=zvals.';
end

%
if nargin < 3
    tavg=0;
end
%Now compute a mean density profile
mdens=nanmean(CTD.sgth')';
%Pick some mean-depth surfaces to track
CTD.zvals=zvals;
CTD.mdens=mdens;
if ~isfield(CTD,'dvals')
    %The densities of these are
    CTD.dvals=interp1(CTD.z,mdens,zvals);
end

CTD.d_Iso=zeros(length(CTD.dvals),length(CTD.yday))*NaN;
%And the depth is
for c=1:length(CTD.yday)
    ind=find(~isnan(CTD.sgth(:,c)));
    if length(ind)>2
        CTD.d_Iso(:,c)=nonmoninterp1(CTD.sgth(ind,c),CTD.z(ind),CTD.dvals)';   
    end
end


%This does not account for long-term changes
if tavg==0
    CTD.eta=-(CTD.d_Iso-CTD.zvals*ones(size(CTD.yday)));
    %This does
else
    %Now adjust for long-term density changes by smoothing over tavg days
    [b,a]=MHAButter(1,tavg./nanmean(diff(CTD.yday)));
    tmp1=CTD.d_Iso;
    tmp2=NaN*tmp1;
    [m,n]=size(tmp1);
    for c=1:m
        ind=find(~isnan(tmp1(c,:))); %Find good ones
        if length(ind)>12 %3 times 4-th order filter
            tmp2(c,ind)=filtfilt(b,a,tmp1(c,ind));
        end
    end
    CTD.eta=-(CTD.d_Iso-tmp2);
end

