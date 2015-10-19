function MP3f=TimeGridCTD(MP3,dt)
%function MPf=TimeGridCTD(MP,dt)
%Interpolate MP data onto constant-time grid.
%Fields u, v, t, th, s, and sgth are done.
%10/05 MHA

MP3f=MP3;

if nargin < 2
dt=nanmean(diff(MP3.yday));
end

MP3f.yday=MP3.yday(1):dt:MP3.yday(end);
MP3f.u=zeros(length(MP3.z),length(MP3f.yday))*NaN;
MP3f.v=zeros(length(MP3.z),length(MP3f.yday))*NaN;
MP3f.t=zeros(length(MP3.z),length(MP3f.yday))*NaN;
MP3f.th=zeros(length(MP3.z),length(MP3f.yday))*NaN;
MP3f.s=zeros(length(MP3.z),length(MP3f.yday))*NaN;
MP3f.sgth=zeros(length(MP3.z),length(MP3f.yday))*NaN;

for c=1:length(MP3.z)
    MP3f.u(c,:)=interp1(MP3.yday,MP3.u(c,:),MP3f.yday);
    MP3f.v(c,:)=interp1(MP3.yday,MP3.v(c,:),MP3f.yday);
    MP3f.t(c,:)=interp1(MP3.yday,MP3.t(c,:),MP3f.yday);
    MP3f.s(c,:)=interp1(MP3.yday,MP3.s(c,:),MP3f.yday);
    MP3f.th(c,:)=interp1(MP3.yday,MP3.th(c,:),MP3f.yday);
    MP3f.sgth(c,:)=interp1(MP3.yday,MP3.sgth(c,:),MP3f.yday);
end
