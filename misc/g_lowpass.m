function [sig_out,b,a] = g_lowpass(sig,Wn,order)

% G_LOWPASS    Lowpassfilter with a butterworth filter
%
%   [FILTERED_SIGNAL,B,A] = G_LOWPASS(SIG,WN,ORDER)
%   Input:  SIG   - time series in
%           WN    - bandstop frequency, e.g. 1/50
%                   is a lowpass with period 100h
%                   if the sampling frequency of the signal
%                   is one hour
%           ORDER - Order of the filter (integer)
%
%   Output: FILTERED_SIGNAL
%           B,A   - Butterworth filter parameters

% Remove NaN's in input vector
x = isnan(sig);
sig_out = nan(size(sig));
sig = sig(~x);

% Make sure there were no NaN's in the middle, this would mess up the time
% series.
dx = diff(find(x==0));
ddx = find(dx~=1);
if length(ddx) > 1
error('NaN''s in the middle of the input vector. Will not low pass this.')
end



[b,a] = butter(order,Wn);
sig_mean = nanmean(sig);
sig_var = sig-sig_mean;
sig_var2 = filtfilt(b,a,sig_var);

sig_out(~x) = sig_var2 + sig_mean;