function CTD=FilterCTD(CTD,FP);
%function CTD=FilterCTD(CTD,FP);
%Take a CTD and filter u, v, and etaEUL in a specified
%range.  The records need to be evenly sampled before calling this.
%10/05
%MHA
%Specify FP.ffilt (cpd),FP.bandwidth.  This will band-pass filter a
%timeseries.
if ~isfield(FP,'bandwidth')
    FP.bandwidth=4/5;
end

FP.samplefreq=1/nanmean(diff(CTD.yday));
%Form the filters.
fn=FP.samplefreq/2; %nyquist

fc1=FP.bandwidth*FP.ffilt;
fc2=1/FP.bandwidth*FP.ffilt;
[b,a]=butter(4,[fc1/fn fc2/fn]);

%Now form arrays for the filtered records
if isfield(CTD,'u')
    CTD.uf=zeros(size(CTD.u))*NaN;
elseif isfield(CTD,'v')
    CTD.uf=zeros(size(CTD.v))*NaN;
elseif isfield(CTD,'etaEUL')
    CTD.uf=zeros(size(CTD.etaEUL))*NaN;
else error('CTD must have u, v or etaEUL')
end

CTD.vf=CTD.uf;
CTD.etaf=CTD.uf;

if ~isfield(FP,'UMAX')
    FP.UMAX=2;
end
if ~isfield(FP,'DMAX')
    FP.DMAX=300;
end

%Filter to the chosen frequency range.  NOTE check the pre- and post- filtering
%spectra and time series- watch for ringing, etc.
%First check for bad data flags and spikes.  Remove them and warn.
if isfield(CTD,'u') %8/09: don't do this if u doen't exist
    for c=1:length(CTD.z)
        indg=find(~isnan(CTD.u(c,:)) & abs(CTD.u(c,:)) < FP.UMAX);
        %disp(['record contains ' num2str(length(CTD.time) - length(indg)) ' NaNs'])
        if length(indg) > 24 %more than 3 times filter order
            CTD.uf(c,indg)=filtfilt(b,a,CTD.u(c,indg));
        end
    end
end
if isfield(CTD,'v') %8/09: don't do this if v doen't exist
    for c=1:length(CTD.z)
        indg=find(~isnan(CTD.v(c,:)) & abs(CTD.v(c,:)) < FP.UMAX);
        %disp(['record contains ' num2str(length(CTD.time) - length(indg)) ' NaNs'])
        if length(indg) > 24
            CTD.vf(c,indg)=filtfilt(b,a,CTD.v(c,indg));
        end
    end
end
if isfield(CTD,'etaEUL') %6/09: don't do this if etaEUL doen't exist
    for c=1:length(CTD.z)
        indg=find(~isnan(CTD.etaEUL(c,:)) & abs(CTD.etaEUL(c,:)) < FP.DMAX);
        %disp(['record contains ' num2str(length(CTD.time) - length(indg)) ' NaNs'])
        if length(indg) > 24
            CTD.etaf(c,indg)=filtfilt(b,a,CTD.etaEUL(c,indg));
        end
    end
end

