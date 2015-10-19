function PP=defaultCTDplotParams(CTD,whichtype,xvar)
%function PP=defaultCTDplotParams(whichtype)
%Deliver a PP for passing in to the function GenericCTDplot1.
%

if nargin < 3
    xvar = 'yday';
end

PP.figname='multpan1';
if whichtype==1
    PP.plind=[1 4 5 9 10]; %T, S, sigma, u,v
elseif whichtype==2
    PP.plind=[1 4 9 10 11]; %T, S, u,v, eps
elseif whichtype==3
    PP.plind=[1 4 9 10 18]; %T, S, u,v, N^2
elseif whichtype==4
    PP.plind=[1 4]; %T, S only
elseif whichtype==5
    PP.plind=[1 4 6 7]; %T, S, DOX, flu 
elseif whichtype==6 %windspeed, Jb, T, S, sigma, u, v
    PP.plind=[20 19 1 4 9 11];
elseif whichtype==7 %u,v
    PP.plind=[9 10];
elseif whichtype==8 %windspeed, Jb, u,v
    PP.plind=[20 19 9 10];
else  
    PP.plind=[12 3 4 10 11 5 6]; %tide, V, strain, v shear, shear^2, inv Ri, eps
end

%PP.plind=[3 4 9 11 5 6];

PP.num=length(PP.plind);

%positions
PP.mx=0.1;
PP.bx=0.8;
PP.mb=.05;
PP.mt=.98;
PP.by=(PP.mt-PP.mb)/PP.num;
PP.cmap='jet';

PP.fs=10;

PP.scut=5;
PP.wh=1:50:length(CTD.zvals);
PP.fignum=1;
PP.mincolor=0;
PP.maxcolor=1;
PP.ncolors=32;

%Plotting X variable.  Choose one:
if nargin < 3
xvar='CTD.yday';
end
%xvar='cum_dist';

if strcmp(xvar,'cum_dist')
    [d, cdo, b] = nav2(CTD.lat, CTD.lon);
    cum_dist = [0 nm2km(cdo)];
    PP.xlab='dist / km';
elseif strcmp(xvar,'CTD.yday')
    PP.xlab='yearday';
end

%Plot isopycnals spaced by (wh).
overlay1=['hold on;h=plot(' xvar ',CTD.d_Iso(PP.wh,:),''k-'');lc(h,0.6*[1 1 1]);hold off'];
%Plot isopycnals and pluses where the profiles were.
overlay2=['hold on;h1=plot(' xvar ',PP.zlim(1)*ones(size(CTD.yday)),''k+'');h=plot(' xvar ',CTD.d_Iso(PP.wh,:),''k-'');lc(h,0.6*[1 1 1]);hold off'];

%Set default time and depth limits
PP.zlim=[min(CTD.z) max(CTD.z)];
PP.zlim=[1 200];

eval(['PP.tlim=[min(' xvar ') max(' xvar ')];'])

%Now define the plotbox structure for each variable we might want to plot.
%These are common to most
aPB.zlim=PP.zlim;
aPB.tlim=PP.tlim;
aPB.tvec=xvar;
aPB.zvec='CTD.z';
aPB.sk=1;
aPB.timeseriesplot=0;
aPB.smooth=0;
aPB.plotcommands='';%overlay2;
aPB.killcb=0;
aPB.labcoords=[.01,.1];
%These are different for each.

%Temperature
aPB.str='CTD.t';
aPB.lab='T';
aPB.units='^oC';
aPB.lim=[13 20];

PP.PB{1}=aPB;

%2: theta
aPB.str='CTD.th';
aPB.lab='\theta';

PP.PB{2}=aPB;

%3: cond
aPB.str='CTD.c';
aPB.lab='C';
aPB.units='S / m';
aPB.lim=[2 5];

PP.PB{3}=aPB;

%4: salinity
aPB.str='CTD.s';
aPB.lab='S';
aPB.units='psu';
aPB.lim=[34.2 35];

PP.PB{4}=aPB;

%5: sigma-theta
aPB.str='CTD.sgth';
aPB.lab='\sigma_\theta';
aPB.units='kg m^{-3}';
aPB.lim=[24 25.4];

PP.PB{5}=aPB;

%6: DOX
aPB.str='CTD.dox';
aPB.lab='DOX';
aPB.units='ml / l';
aPB.lim=[4 6];

PP.PB{6}=aPB;

%7: flu
aPB.str='CTD.flu';
aPB.lab='chl';
aPB.units='V';
aPB.lim=[0 1];

PP.PB{7}=aPB;

%8: obs
aPB.str='CTD.obs';
aPB.lab='OBS';
aPB.units='FTU';
aPB.lim=[0 1];

PP.PB{8}=aPB;

%9,10: u, v
aPB.str='CTD.u';
aPB.lab='u';
aPB.units='m s^{-1}';
aPB.lim=[-0.5 .5];

PP.PB{9}=aPB;
aPB.str='CTD.v';
aPB.lab='v';
PP.PB{10}=aPB;

%11: eps
aPB.str='log10(CTD.eps)';
aPB.lab='\epsilon';
aPB.units='log_{10} \epsilon / W/kg';
aPB.lim=[-10 -6];
PP.PB{11}=aPB;

%12: K
aPB.str='log10(CTD.krho)';
aPB.lab='K_\rho';
aPB.units='log_{10} K_\rho / m^2s^{-1}';
aPB.lim=[-6 -3];
PP.PB{12}=aPB;

%13, 14: uz, vz
aPB.str='100*CTD.uz';
aPB.lab='100 u_z';
aPB.units='100 m s^{-1}';
aPB.lim=[-1 1];
PP.PB{13}=aPB;

aPB.str='100*CTD.vz';
aPB.lab='100 v_z';
PP.PB{14}=aPB;

%15: S2
aPB.str='CTD.s2';
aPB.lab='S^2';
aPB.units=' s^{-2}';
aPB.lim=[0 1e-4];
PP.PB{15}=aPB;

%16: log10 S2
aPB.str='log10(CTD.s2)';
aPB.lab='S^2';
aPB.units='log_{10} S^2 / s^{-2}';
aPB.lim=[-6 -3];
PP.PB{16}=aPB;

%17: N2
aPB.str='CTD.n2';
aPB.lab='N^2';
aPB.units=' s^{-2}';
aPB.lim=[0 1e-4];
PP.PB{17}=aPB;

%18: log10 N2
aPB.str='real(log10(CTD.n2))';
aPB.lab='N^2';
aPB.units='log_{10} N^2 / s^{-2}';
aPB.lim=[-6 -3];
PP.PB{18}=aPB;

%Time series plots
%19: Jb
aPB.str='1e7*CTD.Jb';
aPB.lab='10^7 J_b';
aPB.units='W / kg';

aPB.timeseriesplot=1;
aPB.lim=[-5 5];
aPB.plotcommands='';
PP.PB{19}=aPB;

%20: windspeed
aPB.str='CTD.windspeed';
aPB.lab='wind speed';
aPB.units='m/s';
aPB.timeseriesplot=1;
aPB.lim=[0 30];
aPB.plotcommands='grid';
PP.PB{20}=aPB;



% PP.strs={'MP.Tide';'MP.u';'MP.v'; ... %1,2,3
%         'real(log10(MP.strainEULs))';'real(log10(MP.invri))';'log10(MP.eps2)';  ... %4,5,6
%         'real(log10(MP.n2))';'log10(MP.k)'; 'MP.uzs'; ... %7,8,9
%         'MP.vzs';'log10(MP.shearsm.^2)';'MP.Current';'log10(nanmean(MP.eps))'};
% %strs={'MP.tide';'MP.u';'MP.v';'real(log10(MP.strainEULs))';'real(log10(MP.invri))';'log10(MP.eps2)';   'real(log10(MP.n2))';'log10(MP.k)'; 'MP.uzs';  'MP.vzs';'log10(MP.shearsm.^2)';  'riinvl';'ri'};
% PP.labs={'SL';'U';     'V'; ...
%         'log10(\gamma)'; 'Ri';'log_{10} \epsilon';...
%         'N^2';  'K_\rho';'U_z';...
%         'V_z';'S^2';'U_{tide}';...
%         'log_{10} <\epsilon>'};
% PP.units={'m';'ms^{-1}';'ms^{-1}';...
%         'log10(\gamma)';'log_{10}Ri^{-1}';'log_{10} \epsilon / W kg^{-1}';...
%         'log_{10} N^2 / s^{-2}';'log_{10} K / m^2s^{-1}';'s^{-1}';...
%         's^{-1}';'log_{10} S^2 / s^{-2}';'ms^{-1}';'log_{10} <\epsilon> / W kg^{-1}'};
% PP.lims={[-4 4];[-.3 .3];[-.3 .3];...
%         [-1 1];[-1 log10(4)];[-8 -6];...
%         [-6 -3];[-6 -2];[-.01 .01];...
%         [-.01 .01];[-6 -3];[-0.5 0.5];[-9 -6]};
% PP.zlims={[PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];...
%         [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];...
%         [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];...
%         [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax];
%         [PP.zmin PP.zmax];[PP.zmin PP.zmax];[PP.zmin PP.zmax]};
% 
% PP.tlims={[PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax];...
%         [PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax];...
%         [PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax];...
%         [PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax];...
%         [PP.tmin PP.tmax];[PP.tmin PP.tmax];[PP.tmin PP.tmax]};
% 
% PP.tvecs={'MP.yday';'MP.yday';'MP.yday';...
%         'MP.yday';'MP.yday';'MP.yday';...
%         'MP.yday';'MP.yday';'MP.yday';...
%         'MP.yday';'MP.yday';'MP.yday';...
%         'MP.yday';'MP.yday';'MP.yday';...
%         'MP.yday'};
% 
% PP.zvecs={'MP.z';'MP.z';'MP.z';...
%         'MP.z';'MP.z';'MP.z';...
%         'MP.z';'MP.z';'MP.z';...
%         'MP.z';'MP.z';'MP.z';...
%         'MP.z';'MP.z';'MP.z';...
%         'MP.z';'MP.z'};
% 
% PP.sks={1 1 1 ...
%         1 1 1 ...
%         1 1 1 ...
%         1 1 1 ...
%         1 1 1 1};
% 
% PP.killcb={1 0 0 ...
%         0 0 0 ...
%         0 0 0 ...
%         0 0 1 ...
%         0 0 0 ...
%         0};
% 
% PP.timeseriesplot={1 0 0 ...
%         0 0 0 ...
%         0 0 0 ...
%         0 0 1 ...
%         1 0 0 ...
%         0};
% PP.smooth={0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0};
% 
% PP.plotcommands={'';overlay1;overlay1;...
%         overlay1;overlay1;overlay1;...
%         overlay1;overlay1;overlay1;...
%         overlay1;overlay1;'';...
%         '';};
