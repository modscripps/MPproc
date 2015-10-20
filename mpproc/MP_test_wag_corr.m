function ax = MP_test_wag_corr(info, prof,slims, L)

% ax=MP_test_wag_corr(info, prof,slims, L)
% Generate a diagnostic plot for identifying the presence and magnitude of
% the 'wagging' problem.  This routine works from the raw matlab files.
% Time series and before/after spectra are plotted.
%
% Pass in info and prof to identify the profile. optional: slims: scan lims
% min, max.  Pass nothing or empty for whole profile.
% L: moment arm length. Toole used 37 cm (default), but in his email to me
% he found good agreement in the PS03 data with L=125/2 cm.
%
% Function form of MooredProfiler/processing/test_wag_corr.m.
% 1/05 MHA
% 12/2011: _2 just uses the updated directory structure.
%
% Test Toole's strategy that he implemented for removing the wagging.
% 7/27/04
% use the section from scans 400-600 of drop 52 of the FSI unit in the 
% PS03 deployment.  There is a clear wagging signal, and these routines
% definitely reduce it, but I find a greater L is needed than Toole used.
% Perhaps it is different for the McLane unit than the WHOI profilers.
%
% Thinking about this, I don't see how L can be as long as it is.  The ACM
% is only 20 cm or so from the wire.
%
% However on drop 53, I see that L=37.81 works better for the bump near scan
% 1350, but is too small earlier on.
%
% The corrections work very well with 2.5 times Toole's value on drop 55.
%
% So to conclude I see definite matching between the wagging vel and the
% high-passed Vy when I use L = 2.5*37.81=94 cm.  I don't see why it can be
% this long though.  The velocities are still noisy by about 1 cm/s due to
% vibrations, though.  They are probably too high-freq to correct for from
% the tilt/roll sensors...

if nargin < 4
  L=37.81;
end

% Use these for a demo
% L=2.5*37.81; %Length in cm from wire to ACM sensing volume; Toole's value is 37.81
% prof=52;
% smin=400;
% smax=600;

titlestr=[info.cruise ', sn ' info.sn ', #' num2str(prof) ', L=' num2str(L) ' cm'];

samprate=1.85; %sample rate in Hz from MP manual; Toole used 1.82


% Set path and filenames
mpdatadir = MP_basedatadir(info);
matpath   = fullfile(mpdatadir,'mat');
grdpath   = fullfile(mpdatadir,'gridded');
if prof<10
  str1='000';
elseif prof>=10 & prof<100
  str1='00';
elseif prof>=100 & prof<1000
  str1='0';
else
  str1='';
end

matstr = ['raw' str1 num2str(prof) '.mat'];
grdstr = ['grd' str1 num2str(prof) '.mat'];

load(fullfile(matpath,matstr))

%b=load(grdstr);

if nargin < 3
    slims=[];
end

if isempty(slims)
    smin=1;
    smax=length(asnum);
else
smin=slims(1);
smax=slims(2);
end


dir = atan2(aHx,aHy);
dir = continuousdir(dir);

wag=-samprate*L*gradient(dir); %Toole's correction.  v=L*d(theta)/dt.


[b,a] = mybutter(4,.01,1);

dirhi = dir-myfiltfilt(b,a,dir)';

Vx  = -(Vab+Vef)/(2.*.707);
Vy  = (Vab-Vef)/(2.*.707);
Vz1 = Vx-Vgh/.707;
Vz2=-Vx+Vcd/.707;
avevz=mean(Vz1);
if(avevz<0);
Vz=Vz1;
else
Vz=Vz2;
end


Speed=sqrt(Vx.*Vx+Vy.*Vy);

Vxlo=myfiltfilt(b,a,Vx)';
Vylo=myfiltfilt(b,a,Vy)';

Speedlo=sqrt(Vxlo.*Vxlo+Vylo.*Vylo);

Vysim=Vylo+wag+Speedlo.*sin(dirhi);

%plot(asnum,Vy-Vylo,asnum,wag)

Vyhi=Vy-Vylo;

vy=Vy-wag;

figure(1)
clf
plot(asnum,Vy,asnum,vy)
xlim([smin smax])

speed=sqrt(Vx.*Vx+vy.*vy);

Reldir=atan2(Vy,Vx);

reldir=atan2(vy,Vx);

veast=speed.*cos(dir+reldir);
vnorth=speed.*sin(dir+reldir);

Veast=Speed.*cos(dir+Reldir);
Vnorth=Speed.*sin(dir+Reldir);

% figure(2)
% subplot(211)
% plot(asnum,Speed,asnum,speed)
% title(titlestr)
% xlim([smin smax])
% ylabel('speed / cm/s')
% %plot(asnum,Reldir,asnum,reldir)
% subplot(212)
% plot(asnum,continuousdir(Reldir),asnum,continuousdir(reldir))
% xlim([smin smax])
% ylabel('dir / rads')
% xlabel('scan number')
% 
figure(3);
clf
ax=MySubplot(.1,.1,0,.1,.1,0,1,5);
axes(ax(1))
plot(asnum,Vyhi,asnum,Vyhi-wag,asnum,wag)
title(titlestr)
xlim([smin smax])
ylabel('[vhi, wag] / cm/s')
set(gca,'xticklabel',[])
axes(ax(2))
plot(asnum,Speed,asnum,speed)
xlim([smin smax])
ylabel('speed / cm/s')
%plot(asnum,Reldir,asnum,reldir)
set(gca,'xticklabel',[])

axes(ax(3))
plot(asnum,continuousdir(Reldir),asnum,continuousdir(reldir))
%plot(asnum,Reldir,asnum,reldir)
xlim([smin smax])
ylabel('dir / rads')
set(gca,'xticklabel',[])

axes(ax(4))
plot(asnum,Veast,asnum,veast)
xlim([smin smax])
ylabel('u / m/s')
set(gca,'xticklabel',[])

axes(ax(5))
plot(asnum,Vnorth,asnum,vnorth)
xlim([smin smax])
ylabel('v / m/s')
xlabel('scan number')

%WriteEPS('wag1','/Users/malford/Projects/PugetSound/Fall03/MP/processing/Notes1/figs')

data1=Vnorth(smin:smax);
data2=vnorth(smin:smax);
data1=Veast(smin:smax);
data2=veast(smin:smax);
nfft=100;
dt=1/samprate;

[f,P1,P1s]=myspectrum(data1,nfft,dt,1/80);
[f,P2,P2s]=myspectrum(data2,nfft,dt,1/80);

df=f(2)-f(1);
figure(4)
clf

loglog(f,P1,f,P2)
xlabel('f / Hz')
ylabel('\Phi_{vel} / (cm/s)^2Hz^{-1}')
sqrt(sum(P1)*df)
sqrt(sum(P2)*df)

%WriteEPS('wagspec1','/Users/malford/Projects/PugetSound/Fall03/MP/processing/Notes1/figs')

%I did this and there is a clear peak at just faster than 10 s.  The rms
%velocity is about 2.9 cm/s for east in drop 51 before the correction, and
%1.84 after.
