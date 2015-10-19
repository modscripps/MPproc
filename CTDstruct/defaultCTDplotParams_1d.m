function PP=defaultCTDplotParams(whichtype)
%function PP=defaultCTDplotParams(whichtype)
%Deliver a PP for passing in to the function CTDProfilePlot1.
%

if whichtype==1
PP.plind=[1 4 5]; %T,S, sigma-theta
elseif whichtype==2
PP.plind=[1 4 5 6]; %T,S, sigma-theta, DOX
elseif whichtype==3
PP.plind=[1 4 5 17]; %T,S, sigma-theta, N2
elseif whichtype==4
elseif whichtype==5
elseif whichtype==6
else  
end



PP.wh=1;

PP.num=length(PP.plind);

PP.dy=0.06;
PP.position=[0.2 .3 .6 .6];
PP.yaxes='z';
PP.titletext=[]; %specify '' for blank, [] for default title
PP.ylabel='';
PP.autoscale=1;
PP.yticks=1;

PP.Yreverse=1; %1 for reverse y axis
PP.Ylog=0; %1 for log y axis 

PP.fontsize=[12 12 12];

PP.yaxes='z';

%Leave PP.zlim empty so it picks them automatically
PP.zlim=[];
%need xlimits, ylimits, linecolor

%Now define the plotbox structure for each variable we might want to plot.
%These are common to most
aPB.zlim=PP.zlim;
%aPB.tlim=PP.tlim;
%aPB.tvec=xvar;
aPB.zvec='CTD.z';
aPB.sk=1;
aPB.timeseriesplot=0;
aPB.smooth=1;
%aPB.plotcommands=overlay2;
aPB.killcb=0;
aPB.labcoords=[.01,.1];

%Params for multixaxis
aPB.reverse=1;
aPB.log=0;
aPB.linestyle='-';
aPB.ticks=1;
aPB.marker='none';
aPB.stair=0;
aPB.fontsize=12;
aPB.linethick=1;
aPB.linecolor=[0 0 0];
%Still need color, 
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
aPB.units='ml l^{-1}';
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
aPB.log=0;
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
aPB.log=0;
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
aPB.units='s^{-2}';
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


%Some line colors
linecolors=[     0     0     1;
     1     0     0;
     0     1     0;
     1     0     1;
     0     1     1;];

 %Now finally set the linecolor field of the ones we selected
 for c=1:length(PP.plind)
     PP.PB{PP.plind(c)}.linecolor=linecolors(c,:);
 end
 
