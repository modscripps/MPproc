function bottomaxis(position,dy);
% BOTTOMAXIS Plots axes with origin in the upper right, rather
%           than lower left. Call this *after* you finish fiddling
%           with setting xtick, ylim, and all those other properties.
%          
%           BOTTOMAXIS(1) - only draws the vertical axis
%

% Author: R. Pawlowicz (rich@boreas.whoi.edu).

nin=nargin;
if (nin < 2);
    dy = 0.05;
end

%ticklen=get(gca,'ticklength');
Xt=get(gca,'xtick');
Xl=get(gca,'xticklabel');
Yt=get(gca,'ytick');
Yl=get(gca,'yticklabel');
Xlm=get(gca,'xlim');
Ylm=get(gca,'ylim');
bk=1-get(gcf,'color');

%
%      Draw Bottom Label
%

position(2) = position(2) - dy;
ticklen=[.05*.2/position(3) .025];
axes('position',position,'xtick',Xt,'ytick',[],'box','off');
set(gca,'ticklength',ticklen);

hold on
h = plot(Xlm,[min(Ylm) min(Ylm)],'w.');
axis([Xlm Ylm]);
set(h,'markersize',0.01);
set(gca,'ycolor','k');
