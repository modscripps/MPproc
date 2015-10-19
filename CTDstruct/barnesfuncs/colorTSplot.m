function Ha3=colorTSplot(S,column)
% function COLORTSPLOT(S,column)
%
%This plots a T-S graph from which the marker color is indicative of the
%depth. Inputs identical to ctdmultiplot3. woohoo.  

%work out depth limits
zmax=max(S.z);
zmin=min(S.z);
zrange=zmax-zmin;
colors=colormap(jet(zrange));

%create axes
Ha3=axes('box','on','ticklength',[0 .025]);
pos=get(Ha3,'position');
hold on

%set axes limits
%xmin=min(S.s(:,column));
%xmax=max(S.s(:,column));
%xspan=range(S.s(:,column);
%ymin=min(S.th(:,column));
%ymax=max(S.th(:,column));
%yspan=range(S.th(:,column);
%limits=[(xmin-.5) (xmax+.5) (ymin-5) (ymax+5)];
%axis(limits);

%plot data points with appropriate colors
for i=1:zrange;
    ha3(i)=plot(S.s(i,column),S.th(i,column));
    set(ha3(i),'linestyle','none','marker','.','markeredgecolor',colors(i,:));
end

%label the axes
Xlabel('SALINITY','fontweight','bold');
Ylabel('THETA','fontweight','bold');

% put in colorbar as legend and adjust location
cb3=colorbar('horiz','peer',Ha3);
cbimage=get(cb3,'children');
set(cbimage,'alphadatamapping','direct');
set(cb3,'position',[.675 .16 .2 .03]);
xt=get(cb3,'Xtick');
set(cb3,'XTick',[1,xt]);
set(get(cb3,'title'),'String','Depth(m)');
set(Ha3,'position',pos);
assignin('caller','cb3',cb3);

%put isopycnals in the background
%T=-2:.1:30;
%S=32:.1:37;
%c=2:.1:7;
%[Sg,Tg]=meshgrid(S,T);
%[Cc,Tc]=meshgrid(c,T);

%D=sw_dens(Sg/1000,Tg,0);
%[c3,h3]=contour(Sg,Tg,D-1000,'k--');


