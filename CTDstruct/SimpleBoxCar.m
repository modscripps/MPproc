function [var_out,time_out]=SimpleBoxCar(var,t_avg,time);
%function [out,timeout]=SimpleBoxCar(var,t_avg,time);
%Average records of var together in blocks of length t_avg.  NAN's are not included.
%If var is m x n, the output will be m x n / n_avg.
%If time is not specified, 1:n is used and t_avg indicates the number of
%records to average.
[m,n]=size(var);
if nargin < 3
    time=1:n;
end

time_out=(time(1)+t_avg/2):t_avg:time(end);

var_out=zeros(m,length(time_out))*NaN;

wbar=1;
if wbar==1
    h=waitbar(0,'Please wait... averaging.');
end
for c=1:length(time_out)
        %DisplayProgress(c,1000)
if wbar==1
waitbar(c/length(time_out),h);
end

        tind=find(time >= time_out(c) - t_avg/2 & time < time_out(c) + t_avg/2);
    if ~isempty(tind)
        var_out(:,c)=nanmean(var(:,tind).').';
    end
end
if wbar==1
delete(h)
end