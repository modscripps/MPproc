function [b,a]=mybutter(order,cutoff_freq,sample_rate);
% function [b,a]=mybutter(order,cutoff_freq,sample_rate);
%   my modification of the low-pass Butterworth filter generator that accepts
%   sample rate of the time series, and the cutoff frequency

Nyquist=sample_rate/2;
Wn=cutoff_freq/Nyquist;

[b,a]=butter(order,Wn);

return
