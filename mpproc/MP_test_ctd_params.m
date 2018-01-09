function MP_test_ctd_params(info,p,CTpar)

% MP_TEST_CTD_PARAMS Test a set of ctd processing parameters for a SBE52.
% By default the ctd cal file is loaded. If parameters are given in PARAMS
% then these will be used instead.
%
%   MP_test_ctd_params(info)
%
%   INPUT   info  - MP info structure
%           p     - profile number
%           CTpar - ctd parameters (optional, default: load ctd cal file)
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 10/16/2015


if ~strfind(info.CTDsensor.sn,'SBE-MP52') % SBE sensor
  error('This is not a SBE_MP52.')
end

% Path to raw data and ctd cal file
mpdatadir = MP_basedatadir(info);
RawDir = fullfile(mpdatadir,'mat');
CTD_calfile = fullfile(mpdatadir,'cal',...
              sprintf('ctd_calfile_%ssn%s.mat',info.cruise,info.sn));

% Check for input ctd parameters
if nargin<3
  LoadCTDFile = 1;
else
  LoadCTDFile = 0;
end

ni = p:p+1;

% load raw profiles
for ii = 1:numel(ni)
  b(ii) = load(fullfile(RawDir,sprintf('raw%4.4i.mat',ni(ii))));
end

% calculate salinity for the raw profiles
for ii = 1:numel(ni)
  b(ii).s = sw_salt(b(ii).ccond./sw_c3515,b(ii).ctemp,b(ii).cpres);
  b(ii).sgth = sw_pden(b(ii).s,b(ii).ctemp,b(ii).cpres,4000)-1000;
  b(ii).th = sw_ptmp(b(ii).s,b(ii).ctemp,b(ii).cpres,0);
end

%% Load data and get ctd samplerate

for ii = 1:numel(ni)

psdate = b(ii).psdate;
pstart = b(ii).pstart;
pedate = b(ii).pedate;
pstop  = b(ii).pstop;
epres = b(ii).epres;
cpres = b(ii).cpres;
ctemp = b(ii).ctemp;
ccond = b(ii).ccond;
engtime = b(ii).engtime;

% Extract the profile start and stop times
% Start
startdaytime = datenum(sprintf('%s %s',psdate,pstart),...
                       'mm/dd/yy HH:MM:SS');
% End
stopdaytime  = datenum(sprintf('%s %s',pedate,pstop),...
                       'mm/dd/yy HH:MM:SS');

% Next we create a time variable for each CTD data scan using the
% engineering data epres and etime.
jj = find(epres~=0);

% Align ctd pressure and engineering pressure to create ctd time vector
nep = jj(1);
mep = jj(end);
diffp   = abs(epres(nep)-cpres);
mindifp = min(diffp);

jj = find(diffp==mindifp);
ncp = jj(1);

diffp = abs(epres(mep)-cpres);
mindifp = min(diffp);
jj = find(diffp==mindifp);
mcp = jj(end);

ctime = [1:length(cpres)];
ctime = ctime-ctime(ncp);
ctdsamplerate = (engtime(mep)-engtime(nep))/(mcp-ncp); % days/sample
ctime = (engtime(nep)+ctime*ctdsamplerate)';

b(ii).ctime = ctime;
b(ii).ctdsamplerate = ctdsamplerate;

end

fprintf(1,'\n\nSampling frequency for the SBE52 is %4.2fHz.\n\n',1/nanmedian([b.ctdsamplerate])./24./3600);


%% First profile up or down?

if nanmedian(diff(b(1).cpres))>0
  FirstProfileDown = 1;
else
  FirstProfileDown = 0;
end
  


%% Load ctd parameters if not given

if LoadCTDFile
  load(CTD_calfile)
end

CTpar.freq = ctdsamplerate*24*3600;

%% Run thermal mass correction and p and c shift

% CTpar.lag     = 0.05;   % number of scans
% CTpar.alfa    = 0.065;    % was 0.05
% CTpar.beta    = 0.06;    % was 0.055
% CTpar.P2T_lag = -1.0;   % lag (in scans) from pres to temp sampling
for ii = 1:2;
c(ii) = MP_ctd_proc_MP52(b(ii).cpres, b(ii).ctemp, b(ii).ccond, b(ii).cdox, CTpar);
end
% c.pres
% c.cond
% c.temp
% c.sal
% c.dox
% c.th
% c.sgth


%% Plot profiles and TS

% color
col = brewermap(12,'Paired');


if FirstProfileDown
col = col([1 2 5 6],:);
LegText = {'down raw','down corr','up raw','up corr'};
else
col = col([5 6 1 2],:);
LegText = {'up raw','up corr','down raw','down corr'};
end

figure(50)
clf

ax(1) = axes('position',[0.1 0.1 0.25 0.8]);
hold on
for ii = 1:2
  h(ii) = plot(b(ii).s,b(ii).cpres,'color',col(2*ii-1,:));
end
for ii = 1:2
  h2(ii) = plot(c(ii).sal,c(ii).pres,'color',col(2*ii,:));
end

set(gca,'ydir','reverse','box','on')
grid on
ylabel('Pressure [dbar]')
xlabel('Salinity')
legend([h(1) h2(1) h(2) h2(2)],LegText)

ax(2) = axes('position',[0.38 0.1 0.5 0.6]);

alpha = 125;
tref = 0.6:.01:2;
sref = nanmin(b(1).s)-0.002:.001:nanmax(b(1).s)+0.002;
for j = 1:length(tref)
  for ii = 1:length(sref)
    dens(j,ii) = sw_pden(sref(ii),tref(j),0,4000);
  end
end
dens = dens-1000;


[cc,h]=contour(sref,tref,dens,[45.85:.01:45.97],'k');
clabel(cc,h,'labelspacing',800,'fontsize',8,'color',gr(.3));
set(h,'color',gr(.7),'linewidth',0.25)

hold on
hsr(1) = plot(b(1).s,b(1).th,'o');
hsr(2) = plot(c(1).sal,c(1).th,'o');
hsr(3) = plot(b(2).s,b(2).th,'o');
hsr(4) = plot(c(2).sal,c(2).th,'o');

for ii = 1:4;
  set(hsr(ii),'markerfacecolor',col(ii,:),...
             'markeredgecolor','none',...
             'markersize',5);
end



set(gca,'ydir','normal','ylim',g_range(b(1).th)+[-0.05 0.05],'xlim',g_range(b(1).s)+[-0.002 0.002],...
  'xcolor',gr(.3),'ycolor',gr(.3))
set(ax(2),'yaxislocation','right')
% title('TS','fontsize',12,'color',gr(.3))
% grid on
ylabel('\theta [°C]')
xlabel('Salinity')
% hleg = legend(hsr,'down','up','down corr','up corr');
% set(hleg,'edgecolor','none','color',gr(.85),'textcolor',gr(0.3))

box on

drawnow
for ii = 1:4
sMarkers = hsr(ii).MarkerHandle;
sMarkers.FaceColorData(4) = 100;
end


ax(3) = axes('position',[0.38 0.68 0.5 0.2]);
set(ax(3),'visible','off','xlim',[0 1],'ylim',[0 1]);
ht(1) = text(0.01,1,sprintf('Thermal Lag Correction %s %s sn%s profiles %i/%i',info.deployment,info.station,info.sn,p,p+1));
ht(2) = text(0.01,0.8,sprintf('lag (scans): %0.3f',CTpar.lag));
ht(3) = text(0.01,0.6,sprintf('\\alpha_1: %0.4f \\beta_1: %0.4f',CTpar.alfa,CTpar.beta));
if isfield(CTpar,'alfa2')
ht(4) = text(0.01,0.4,sprintf('\\alpha_2: %0.4f \\beta_2: %0.4f',CTpar.alfa2,CTpar.beta2));
end
if LoadCTDFile
  text(0.01,0.2,sprintf('Parameters from %s',strrep(sprintf('cal/ctd_calfile_%ssn%s.mat',info.cruise,info.sn),'_','\_')),...
  'fontsize',7)
end
set(ht(1),'fontweight','bold')

