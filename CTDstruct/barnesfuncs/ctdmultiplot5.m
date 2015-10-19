function ctdmultiplot3(S,column,propertyfile)
%function CTDMULTIPLOT(S,column,propertyfile)
%
%CTDMULTIPLOT(S,column,Propertyfile) where 'S' is the structure that contains
%the data to be plotted, 'column' is the column within the data structure to
%be plotted and 'propertyfile' the stucture from which the multiaxes
%property values are taken.  An error message will occur if either
%structure that 'S' and 'propertyfile' represent are not in base workspace.
%
%CTDMULTIPLOT(S,column) A default file is automatically loaded, pp3default.mat. 
%To change any variable or property values, load the structure pp3.mat 
%into the workspace and make changes there.
%


% load a new figure
figure
set(gcf,'Units','normalized','position',[.05 .1 .7 .8],'color',[1 1 1]);

% check to see if there is a property file to use
nin=nargin;
if nin==2
   load pp4default
else
   [pp]=propertyfile;
end

% change position in pp file
pp.position(1,1)=.05;
pp.position(1,2)=.32;
pp.position(1,3)=.25;
pp.fontsize=[10,10,10];
pp.dy=0.04;


% plot multiaxis
Ha1=multiaxis9(S,column,pp);
lims1=get(gca,'ylim');
hold on

%titlestring=[S.lat(1,column) S.long(1,column)];
%titlestring=num2str(titlestring);
%text(.2,.1, titlestring);

% plot Z vs. N2 diagram

Ha2=axes('position',[.375, pp.position(1,2), pp.position(1,3), pp.position(1,4)],'box','on','ticklength',[0 .025]);

if isempty(S.n2)==1
   S=AddN2toCTD(S,4);
end

ha2=plot(S.n2(:,column),S.z,'color','red');
set(gca,'YDir','reverse','box','off','ycolor','red','xcolor','red');
xlabel('N2','fontweight','bold');
ylabel('z','fontweight','bold');
set(gca,'ylim',lims1);
hold on
plotRrhofun2(S.s(:,column),S.t(:,column),S.z,4);
set(gca,'position',[.375, pp.position(1,2), pp.position(1,3), pp.position(1,4)],'box','off','ticklength',[0 .025]);
set(gca,'color','none','XAxisLocation','top','YAxisLocation','right','ylim',lims1);

% plot TS Diagram
Ha3=colorTSplot2(S,column);
slims=get(Ha3,'xlim');
tlims=get(Ha3,'ylim');
set(Ha3,'position',[.7, pp.position(1,2), pp.position(1,3), pp.position(1,4)],'box','on','ticklength',[0 .025],'xlim',slims,'ylim',tlims);
%move colorbar to appropriate location
set(cb3,'position',[.8, .946, .15, .02]);
hold on      

% plot world position using coast
%load coast
%lon1=zero22pi(long);
%tol=0.3;
%ind1=find(lon1>360-tol | lon1 < tol);
%lon2=lon1;
%lat(ind1)=NaN;
%lon2(ind1)=NaN;

Ha4=axes('position',[.7, .06, .4, .2],'box','on','ticklength',[0 .025]);
latmin=min(S.lat);
latmax=max(S.lat);
latspan=latmax-latmin;
latmin=latmin-.5*latspan; latmax=latmax+.5*latspan;

longmin=min(S.long);
longmax=max(S.long);
longspan=longmax-longmin;
longmin=longmin-longspan; longmax=longmax+longspan;

PSShorePlot(latmin,latmax,longmin,longmax);
hold on
lats=S.lat;
longs=S.long;
ha5=plot(longs(column),lats(column));
set(ha5,'linestyle','none','marker','o','color','r')

Ha5=axes('position',[.4, .1, .35, .2],'visible','off');
day=num2str(S.yday(1,column));
year=num2str(S.year(1,column));
datestring=[ 'Cruise Date: ' day ', ' year ];
text(0,.4,datestring);
latstr=num2str(lats(column));
lonstr=num2str(longs(column));
locstring=[ 'Location: ' latstr ', ' lonstr];
text(0,.8,locstring);
colstr=num2str(column);
caststr=['Profile: ' colstr];
text(0,1.2,caststr);

%ha4=plot(lon2,lat,'k-');
%limits=[0 360 -90 90];
%axis(limits);
%hold on

%lats=S.lat;
%longs=360+S.long;
%ha5=plot(longs(column),lats(column));
%set(ha5,'linestyle','none','marker','o');
%XLabel('Longitude','fontweight','bold')
%YLabel('Latitude','fontweight','bold')

