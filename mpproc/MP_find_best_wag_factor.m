function best = MP_find_best_wag_factor(info, prof,slims,plotit)

% best = MP+find_best_wag_factor(info, prof,slims,plotit)
% MHA 4/09
% Determine the best moment arm length (wag factor / 2) to reduce wagging
% for MP.
% 6/17/09 modified to minimize vy - cross instrument flow.


if nargin < 4 
  plotit = 1;
end
if nargin < 3 
  slims = [100 300];
end
if nargin < 2 
  prof = 10; %use the tenth profile if not specified
end

Lvec = 0:5:120;

%vector of answers
varvec = NaN*Lvec;
p1vec  = varvec;
p2vec  = varvec;
p3vec  = varvec;

samprate = 1.85; %sample rate in Hz from MP manual; Toole used 1.82

% set directories
mpdatadir = MP_basedatadir(info);
matpath   = fullfile(mpdatadir,'mat');
matstr    = sprintf('raw%04d.mat',prof);
grdpath   = fullfile(mpdatadir,'gridded');
grdstr    = sprintf('grd%04d.mat',prof);

load(fullfile(matpath,matstr))

if nargin < 3
    slims = [];
end

if isempty(slims)
    smin=1;
    smax=length(asnum);
else
    smin=slims(1);
    smax=slims(2);
end

for c = 1:length(Lvec)

L = Lvec(c);

dir = atan2(aHx,aHy);
dir = continuousdir(dir); % make dir continuous rather than wrapping at 2pi

wag=-samprate*L*gradient(dir); %Toole's correction.  v=L*d(theta)/dt.


[b,a]=mybutter(4,.01,1);

dirhi=dir-myfiltfilt(b,a,dir)';

Vx=-(Vab+Vef)/(2.*.707);
Vy=(Vab-Vef)/(2.*.707);
Vz1=Vx-Vgh/.707;
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

speed=sqrt(Vx.*Vx+vy.*vy);

Reldir=atan2(Vy,Vx);

reldir=atan2(vy,Vx);

veast=speed.*cos(dir+reldir);
vnorth=speed.*sin(dir+reldir);

Veast=Speed.*cos(dir+Reldir);
Vnorth=Speed.*sin(dir+Reldir);

%spectrum

%data1=Vnorth(smin:smax);
%data2=vnorth(smin:smax);
data1=Veast(smin:smax);
data2=veast(smin:smax);
data3=vy(smin:smax);
nfft=100;
dt=1/samprate;

[f,P1,P1s]=myspectrum2(data1,nfft,dt,1/80);
[f,P2,P2s]=myspectrum2(data2,nfft,dt,1/80);
[f,P3,P3s]=myspectrum2(data3,nfft,dt,1/80);

df=f(2)-f(1);
p1vec(c)=sqrt(sum(P1)*df);
p2vec(c)=sqrt(sum(P2)*df);
p3vec(c)=sqrt(sum(P3)*df);

%fill in answers
varvec(c)=nanstd(vy);

if plotit==1
  titlestr=[info.cruise ', sn ' info.sn ', #' num2str(prof) ', L=' num2str(L) ' cm'];
  figure(1)
  clf
  plot(asnum,Vy,asnum,vy)
  xlim([smin smax])
  legend('Raw','corrected')
  title([titlestr ', cross instrument flow'])
  ylabel('cm/s')
  figure(3);
  clf
  ax=MySubplot(.1,.1,0,.1,.1,0,1,5);
  axes(ax(1))
  plot(asnum,Vyhi,asnum,Vyhi-wag,asnum,wag)
  title(titlestr)
  xlim([smin smax])
  ylabel('[vhi, wag] / cm/s')
  xtloff
  axes(ax(2))
  plot(asnum,Speed,asnum,speed)
  xlim([smin smax])
  ylabel('speed / cm/s')
  %plot(asnum,Reldir,asnum,reldir)
  xtloff
  axes(ax(3))
  plot(asnum,continuousdir(Reldir),asnum,continuousdir(reldir))
  %plot(asnum,Reldir,asnum,reldir)
  xlim([smin smax])
  ylabel('dir / rads')
  xtloff
  axes(ax(4))
  plot(asnum,Veast,asnum,veast)
  xlim([smin smax])
  ylabel('u / m/s')
  xtloff
  axes(ax(5))
  plot(asnum,Vnorth,asnum,vnorth)
  xlim([smin smax])
  ylabel('v / m/s')
  xlabel('scan number')


  figure(4)
  clf

  loglog(f,P1,f,P2,f,P3)
  xlabel('f / Hz')
  ylabel('\Phi_{vel} / (cm/s)^2Hz^{-1}')

end
end
%%

figure(3)
clf
plot(Lvec,varvec,Lvec,p2vec,Lvec,p3vec)
grid
xlabel('L')
ylabel('rms cross-instrument flow')

best = Lvec(find(p3vec==min(p3vec)));

