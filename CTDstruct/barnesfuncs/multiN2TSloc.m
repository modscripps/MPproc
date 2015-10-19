function ctdmultiplot(S,column,propertyfile)
%function CTDMULTIPLOT(S,column,propertyfile)
%
%CTDMULTIPLOT(S,column) A default file is automatically loaded, pp1default.mat. 
%To change any variable or property values, load the structure pp3.mat 
%into the workspace and make changes there.
%
%CTDMULTIPLOT(S,column,Propertyfile) where 'S' is the structure that contains
%the data to be plotted, 'column' is the column within the data structure to
%be plotted and 'propertyfile' the stucture from which the multiaxes
%property values are taken.  An error message will occur if either
%structure that 'S' and 'propertyfile' represent are not in base workspace.

% load a new figure
figure
set(gcf,'Units','normalized','position',[.05 .1 .9 .8],'color',[1 1 1]);

% check to see if there is a property file to use
nin=nargin;
if nin==2
   load pp3default
else
   [pp]=propertyfile;
end

% change position in pp file
pp.position(1,1)=.05;
pp.position(1,3)=.2;
pp.fontsize=[10,10,10];


% plot multiaxis
Ha1=multiaxis7(S,column,pp);

% plot Z vs. N2 diagram
Ha2=axes('position',[.3, pp.position(1,2), .2, pp.position(1,4)],'box','on','ticklength',[0 .025]);
hold on

if isempty(S.n2)==1
   S=addn2toCTD(S,10);
end

ha2=plot(S.n2(:,column),S.z);
set(gca,'YDir','reverse');
XLabel('N2');
YLabel('z');


% plot TS Diagram
Ha3=axes('position',[.55, pp.position(1,2), .2, pp.position(1,4)],'box','on','ticklength',[0 .025]);
    hold on
       
ha3=plot(S.s(:,column),S.th(:,column));
set(ha3,'linestyle','none','marker','.');
Xlabel('Theta');
Ylabel('Salinity');



% plot world position using coast
load coast
lon1=zero22pi(long);
tol=0.3;
ind1=find(lon1>360-tol | lon1 < tol);
lon2=lon1;
lat(ind1)=NaN;
lon2(ind1)=NaN;

Ha4=axes('position',[.80, pp.position(1,2), .19, pp.position(1,4)],'box','on','ticklength',[0 .025]);
ha4=plot(lon2,lat,'k-');
limits=[0 360 -90 90];
axis(limits);
hold on

lats=S.lat;
longs=360+S.long;
ha5=plot(longs(column),lats(column));
set(ha5,'linestyle','none','marker','o');
XLabel('Longitude')
YLabel('Latitude')

