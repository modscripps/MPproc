function out = MP_sci_plot(mp,info,pp,fig)

% MP_SCI_PLOT Quick overview plot of MP th/s/sgth/u/v
%
%   OUT = MP_sci_plot(INFO,pp)
%
%   INPUT   mp   - MP data structure
%           info - mooring info structure
%           pp   - plotting options
%           fig  - figure number (default new figure)
%       
%   OUTPUT  out - plot handles
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 10/16/2015


if nargin<3
  pp.zlim = g_range(mp.z);
end
pp.label = {'v [m/s]','u [m/s]','\sigma_{\theta} [kg/m^3]','S','\theta [°C]'};
pp.fields = {'v','u','sgth','s','th'};
if ~isfield(pp,'cmap')
pp.cmap = {brewermap(100,'*RdBu'),...
           brewermap(100,'*RdBu'),...
           brewermap(100,'Spectral'),...
           brewermap(100,'RdYlGn'),...
           brewermap(100,'*RdYlBu')};
end
if ~isfield(pp,'zlim')
  pp.zlim = g_range(mp.z);
end
if ~isfield(pp,'caxis')
  pp.caxis = {[],[],[],[],[]};
end
% if ~isfield(pp,'cmap')
%   pp.cmap = {[],[],[],[],[]};
% end
for i = 1:5
  if isempty(pp.caxis{i})
    pp.caxis{i} = g_range(mp.(pp.fields{i}));
  end
  if isempty(pp.cmap{i})
    pp.cmap{i} = brewermap(100,'Spectral');
  end
end



if nargin<4
  fig = 0;
end

if fig
  figure(fig)
else
  figure
end
clf


for i = 1:5
  ax(i) = axes('position',[0.1 0.1+(i-1)*0.15 0.7 0.15]);
end

for i = 1:length(pp.fields)
  axes(ax(i))
  hp(i) = pcolor(mp.yday,mp.z,mp.(pp.fields{i}));
  caxis(pp.caxis{i})
  colormap(ax(i),pp.cmap{i})
  shading flat
  cb(i) = colorbar('peer',ax(i),'position',[0.81 0.1+(i-1)*0.15+0.02 0.01 0.15-0.04]);
  cb(i).Label.String = pp.label{i};
%   cb(i).
end

cb(3).Direction = 'reverse';

set(ax([1 2 4 5]),'yticklabel',[])
set(ax(2:5),'xticklabel',[])
set(ax,'ydir','reverse','layer','top')

axes(ax(3))
ylabel('Depth [m]')

axes(ax(1))
xlabel('yday')

set(ax,'box','on','ylim',pp.zlim)

% header
axh = axes('position',[0.1 0.86 0.5 0.02]);
set(axh,'visible','off','xlim',[0 1],'ylim',[0 1])
ht = text(0.01,0.5,sprintf('%s %s %s sn%s',...
  info.experiment,info.deployment,info.station,info.sn));
set(ht,'fontweight','bold','verticalalignment','middle')

g_fpp(8,12)

out.ax = ax;
out.axh = axh;
out.hp = hp;
out.cb = cb;
out.pp = pp;
out.ht = ht;