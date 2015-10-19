function [bias_ab,bias_cd,bias_ef,bias_gh] = MP_acm_find_bias(info,mpo,varargin)

% [bias_ab,bias_cd,bias_ef,bias_gh] = MP_ACM_FIND_BIAS(info,mpo,prof_range)
%
% Estimate path biases for an ACM aboard an MP.  To do this we load in raw
% matlab files and examine the period at the surface and bottom when the
% profiler was not moving.  During these times the profiler should be
% oriented into the flow and all paths should give the same reading.
% 2/05
%
%   INPUT   info - info structure from procesing worksheet
%           mpo  - MP options structure from processing worksheet
%           prof_range - range of profiles to use (optional)
%       
%   OUTPUT  bias_ab - bias for each path
%           bias_cd
%           bias_ef
%           bias_gh
%
% _2 (11/2012 MHA) is updated for the new directory structure.
%
% 09/2015 GV Now saving this function as MP_acm_find_bias. Adding option
% for choosing top/bottom/both. New version of the path bias plot.

% Get paths
mpdatadir = MP_basedatadir(info);
matdir = fullfile(mpdatadir,'mat');

% check for option % 'top','bottom','both'
if strcmp(mpo.acm.pathbias,'top')
  UseRange = 'surf';
  fprintf(1,'\n\n Using top only for ACM bias.\n');
elseif strcmp(mpo.acm.pathbias,'bottom')
  UseRange = 'bot';
  fprintf(1,'\n\n Using bottom only for ACM bias.\n');
elseif strcmp(mpo.acm.pathbias,'both')
  UseRange = 'all';
  fprintf(1,'\n\n Using bottom and top for ACM bias.\n');
else
  error('\n Need to chose ''top'', ''bottom'' or ''both'' as option.')
end

if nargin==2
% Let user chose the profile range for the path bias calculation.
disp('Make sure there is a range of alternating up/down profiles.')
stas = input('input the range of profiles starting w/ downcast (e.g. 5:150):   ');
elseif nargin==3
stas = varargin{1};
end

% Pre-allocate vectors for mean velocities at top and bottom of each
% profile.
Vab_mean_surf = [];
Vcd_mean_surf = [];
Vef_mean_surf = [];
Vgh_mean_surf = [];

Vab_mean_bot  = [];
Vcd_mean_bot  = [];
Vef_mean_bot  = [];
Vgh_mean_bot  = [];

% Load raw .mat files and calculate mean over top and bottom 2 minutes
% when MP doesn't move in the vertical.
for mm = 1:2:length(stas)
  
  % downcasts
  matfile = sprintf('raw%4.4i.mat',stas(mm));
  load(fullfile(matdir,matfile))
  disp([sprintf('\n'),'working on file  :   ',matfile]);
  
  % make sure this is a downcast
  dp = median(diff(epres));
  if dp<0
    error('cast %04d is not a downcast!',stas(mm))
  end

  ab_s = mean(Vab(1:150));
  cd_s = mean(Vcd(1:150));
  ef_s = mean(Vef(1:150));
  gh_s = mean(Vgh(1:150));

  Vab_mean_surf = [Vab_mean_surf ab_s]; %#ok<*AGROW>
  Vcd_mean_surf = [Vcd_mean_surf cd_s];
  Vef_mean_surf = [Vef_mean_surf ef_s];
  Vgh_mean_surf = [Vgh_mean_surf gh_s];


  ab_b = mean(Vab(end-150:end)); %#ok<*COLND>
  cd_b = mean(Vcd(end-150:end));
  ef_b = mean(Vef(end-150:end));
  gh_b = mean(Vgh(end-150:end));

  Vab_mean_bot = [Vab_mean_bot ab_b];
  Vcd_mean_bot = [Vcd_mean_bot cd_b];
  Vef_mean_bot = [Vef_mean_bot ef_b];
  Vgh_mean_bot = [Vgh_mean_bot gh_b];


  % upcasts
   matfile = sprintf('raw%4.4i.mat',stas(mm+1));
  load(fullfile(matdir,matfile))
  disp([sprintf('\n'),'working on file  :   ',matfile]);
  
  % make sure this is an upcast
  dp = median(diff(epres));
  if dp>0
    error('cast %04d is not an upcast!',stas(mm+1))
  end


  ab_s = mean(Vab(end-150:end));
  cd_s = mean(Vcd(end-150:end));
  ef_s = mean(Vef(end-150:end));
  gh_s = mean(Vgh(end-150:end));

  Vab_mean_surf = [Vab_mean_surf ab_s];
  Vcd_mean_surf = [Vcd_mean_surf cd_s];
  Vef_mean_surf = [Vef_mean_surf ef_s];
  Vgh_mean_surf = [Vgh_mean_surf gh_s];


  ab_b = mean(Vab(1:150));
  cd_b = mean(Vcd(1:150));
  ef_b = mean(Vef(1:150));
  gh_b = mean(Vgh(1:150));

  Vab_mean_bot = [Vab_mean_bot ab_b];
  Vcd_mean_bot = [Vcd_mean_bot cd_b];
  Vef_mean_bot = [Vef_mean_bot ef_b];
  Vgh_mean_bot = [Vgh_mean_bot gh_b];

end

mean_abs=mean(Vab_mean_surf); median_abs=median(Vab_mean_surf);
mean_cds=mean(Vcd_mean_surf); median_cds=median(Vcd_mean_surf);
mean_efs=mean(Vef_mean_surf); median_efs=median(Vef_mean_surf);
mean_ghs=mean(Vgh_mean_surf); median_ghs=median(Vgh_mean_surf);
mean_abb=mean(Vab_mean_bot);  median_abb=median(Vab_mean_bot);
mean_cdb=mean(Vcd_mean_bot);  median_cdb=median(Vcd_mean_bot);
mean_efb=mean(Vef_mean_bot);  median_efb=median(Vef_mean_bot);
mean_ghb=mean(Vgh_mean_bot);  median_ghb=median(Vgh_mean_bot);



% Calculate ``true flow'' and individual path biases for top, bottom and
% both. Then select which one to use.

% Surface
a.surf.ab = median_abs;
a.surf.cd = median_cds;
a.surf.ef = median_efs;
a.surf.gh = median_ghs;
% The magnitude of the ``true'' flow is 
a.surf.trueflow = 0.25*(a.surf.ab+a.surf.ef-a.surf.cd-a.surf.gh);
% Individual paths are biased by these amounts:
a.surf.bias_ab = a.surf.ab-a.surf.trueflow;
a.surf.bias_cd = a.surf.cd- (-a.surf.trueflow);
a.surf.bias_ef = a.surf.ef-a.surf.trueflow;
a.surf.bias_gh = a.surf.gh- (-a.surf.trueflow);

% Bottom
a.bot.ab = median_abb;
a.bot.cd = median_cdb;
a.bot.ef = median_efb;
a.bot.gh = median_ghb;
% The magnitude of the ``true'' flow is 
a.bot.trueflow = 0.25*(a.bot.ab+a.bot.ef-a.bot.cd-a.bot.gh);
% Individual paths are biased by these amounts:
a.bot.bias_ab = a.bot.ab-a.bot.trueflow;
a.bot.bias_cd = a.bot.cd- (-a.bot.trueflow);
a.bot.bias_ef = a.bot.ef-a.bot.trueflow;
a.bot.bias_gh = a.bot.gh- (-a.bot.trueflow);

% Bottom & Surface
a.all.ab = 0.5*(median_abb+median_abs);
a.all.cd = 0.5*(median_cdb+median_cds);
a.all.ef = 0.5*(median_efb+median_efs);
a.all.gh = 0.5*(median_ghb+median_ghs);
% The magnitude of the ``true'' flow is 
a.all.trueflow = 0.25*(a.all.ab+a.all.ef-a.all.cd-a.all.gh);
% Individual paths are biased by these amounts:
a.all.bias_ab = a.all.ab-a.all.trueflow;
a.all.bias_cd = a.all.cd- (-a.all.trueflow);
a.all.bias_ef = a.all.ef-a.all.trueflow;
a.all.bias_gh = a.all.gh- (-a.all.trueflow);

% Assign output depending on option chosen
bias_ab = a.(UseRange).ab;
bias_cd = a.(UseRange).cd;
bias_ef = a.(UseRange).ef;
bias_gh = a.(UseRange).gh;


%% Plotting

% Colors for plotting
col = brewermap(12,'Paired');
col = col([1:6 9:10],:);


figure
ax1 = axes('position',[0.1 0.1 0.6 0.6]);
hb(1) = plot(stas,Vab_mean_bot,'r--');
hold on
hb(2) = plot(stas,Vcd_mean_bot,'m--');
hb(3) = plot(stas,Vef_mean_bot,'b--');
hb(4) = plot(stas,Vgh_mean_bot,'g--');
hs(1) = plot(stas,Vab_mean_surf,'r');
hs(2) = plot(stas,Vcd_mean_surf,'m');
hs(3) = plot(stas,Vef_mean_surf,'b');
hs(4) = plot(stas,Vgh_mean_surf,'g');

mmx  = stas(end)+5;
mmx2 = stas(end)+8;
mmx3 = stas(end)+10;
mmx4 = stas(end)+13;

hms(1) = plot(mmx,mean_abs,'r*','markersize',10);
hmb(1) = plot(mmx,mean_abb,'r*');
hms(2) = plot(mmx,mean_cds,'m*','markersize',10);
hmb(2) = plot(mmx,mean_cdb,'m*');
hms(3) = plot(mmx2,mean_efs,'b*','markersize',10);
hmb(3) = plot(mmx2,mean_efb,'b*');               
hms(4) = plot(mmx2,mean_ghs,'g*','markersize',10);
hmb(4) = plot(mmx2,mean_ghb,'g*');


hms2(1) = plot(mmx3,median_abs,'r.','markersize',20);
hmb2(1) = plot(mmx3,median_abb,'r.','markersize',10);
hms2(2) = plot(mmx3,median_cds,'m.','markersize',20);
hmb2(2) = plot(mmx3,median_cdb,'m.','markersize',10);
hms2(3) = plot(mmx4,median_efs,'b.','markersize',20);
hmb2(3) = plot(mmx4,median_efb,'b.','markersize',10);
hms2(4) = plot(mmx4,median_ghs,'g.','markersize',20);
hmb2(4) = plot(mmx4,median_ghb,'g.','markersize',10);

for i = 1:4
  set(hs(i),'color',col(2*i-1,:),'linestyle','-')
  set(hb(i),'color',col(2*i,:),'linestyle','-')
  set(hmb(i),'color',col(2*i,:))
  set(hms(i),'color',col(2*i-1,:))
  set(hmb2(i),'color',col(2*i,:))
  set(hms2(i),'color',col(2*i-1,:))
end

title('Vab,Vef should be pos, Vcd, Vgh should be neg.');
xlabel('cast #');
grid on; zoom on;

% legend
ax2 = axes('position',[0.7 0.1 0.2 0.6]);
set(ax2,'visible','off','xlim',[0 1],'ylim',[0 1])
hold on
legnames = {'Vab','Vcd','Vef','Vgh'};
for i = 1:4
  text(0.2,0.8-0.1*i,legnames{i},'color',col(2*i-1,:),'horizontalalignment','center')
  text(0.4,0.8-0.1*i,legnames{i},'color',col(2*i,:),'horizontalalignment','center')
end
text(0.2,0.8,'top','rotation',90,'color',gr(.3))
text(0.4,0.8,'bottom','rotation',90,'color',gr(.3))

text(0.1,0.25,'mean: ','verticalalignment','middle')
text(0.1,0.2,'median: ')
plot(0.5,0.25,'marker','*','markersize',10,'color',gr(.3))
plot(0.5,0.2,'marker','.','markersize',15,'color',gr(.3))

% cruise and sn
text(0.1,0.05,[info.cruise,'  ',info.sn,'  ',info.station],'fontsize',16,'fontweight','bold')


% results
ax3 = axes('position',[0.1 0.7 0.8 0.2]);

htt(1) = text(0,0.9,sprintf('SURFACE True flow: %1.2f cm/s',a.surf.trueflow));
hts(1) = text(0,0.7, sprintf('bias_{ab} = %1.2f cm/s',a.surf.bias_ab));
hts(2) = text(0,0.55,sprintf('bias_{cd} = %1.2f cm/s',a.surf.bias_cd));
hts(3) = text(0,0.4, sprintf('bias_{ef} = %1.2f cm/s',a.surf.bias_ef));
hts(4) = text(0,0.25,sprintf('bias_{gh} = %1.2f cm/s',a.surf.bias_gh));


htt(2) = text(0.35,0.9,['AVERAGE True flow: ' num2str(a.all.trueflow)]);
hta(1) = text(0.35,0.7, sprintf('bias_{ab} = %1.2f cm/s',a.all.bias_ab));
hta(2) = text(0.35,0.55,sprintf('bias_{cd} = %1.2f cm/s',a.all.bias_cd));
hta(3) = text(0.35,0.4, sprintf('bias_{ef} = %1.2f cm/s',a.all.bias_ef));
hta(4) = text(0.35,0.25,sprintf('bias_{gh} = %1.2f cm/s',a.all.bias_gh));


htt(3) = text(0.7,0.9,['BOTTOM True flow: ' num2str(a.bot.trueflow)]);
htb(1) = text(0.7,0.7, sprintf('bias_{ab} = %1.2f cm/s',a.bot.bias_ab));
htb(2) = text(0.7,0.55,sprintf('bias_{cd} = %1.2f cm/s',a.bot.bias_cd));
htb(3) = text(0.7,0.4, sprintf('bias_{ef} = %1.2f cm/s',a.bot.bias_ef));
htb(4) = text(0.7,0.25,sprintf('bias_{gh} = %1.2f cm/s',a.bot.bias_gh));

set(htt,'fontweight','bold')
for i = 1:4
  set([hts(i) hta(i) htb(i)],'color',col(2*i,:))
end

set(ax3,'visible','off','xlim',[0 1],'ylim',[0 1])
