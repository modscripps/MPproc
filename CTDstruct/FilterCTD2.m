function CTD=FilterCTD2(CTD,FP);
%function CTD=FilterCTD2(CTD,FP);
%Take a CTD structure (req'd fields: yday, z) and filter the fields specified in FP.vars in a specified
%range.  The records need to be evenly sampled.
%10/05
%MHA
%Specify FP.ffilt (cpd),FP.bandwidth, FP.vars.

if ~isfield(FP,'bandwidth')
    FP.bandwidth=4/5;
end

if ~isfield(FP,'ffilt')
    FP.ffilt=24/12.4; %semidiurnal
end

FP.samplefreq=1/nanmean(diff(CTD.yday));
%Form the filters.
fn=FP.samplefreq/2; %nyquist

fc1=FP.bandwidth*FP.ffilt;
fc2=1/FP.bandwidth*FP.ffilt;
[b,a]=butter(4,[fc1/fn fc2/fn]);

for rec=1:length(FP.vars)
    varn=[FP.vars{rec} 'f'];
    CTD.(varn)=nan(size(CTD.(FP.vars{rec})));
    
    %Filter to the chosen frequency range.  
    %First check for nans.
    if isfield(CTD,FP.vars{rec}) %
        for c=1:length(CTD.z)
            indg=find(~isnan(CTD.(FP.vars{rec})(c,:)) );
            %disp(['record contains ' num2str(length(CTD.time) - length(indg)) ' NaNs'])
            if length(indg) > 24 %more than 3 times filter order
                CTD.(varn)(c,indg)=filtfilt(b,a,CTD.(FP.vars{rec})(c,indg));
            end
        end
    end
    
end

