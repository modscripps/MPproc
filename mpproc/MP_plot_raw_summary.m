function MP_plot_raw_summary(sum_file_name,plottime)

% A routine to make basic plots based on data derived from disp_summary.m
% This is modified by MHA to combine the panels into one figure.
% An optional second argument can specify profile number or time on the x
% axis
%
% 2/05

if nargin < 2
    plottime=1;
end

eval(['load ',sum_file_name]);

j=find(espeed>0); %DOWN profiles
k=find(espeed<0); %UP profiles

% assign the proper sort of slash, for PC & Unix
arch=computer;
if (strcmp(arch,'PCWIN'))
    slsh='\';
else
    slsh='/';
end



locs=findstr(sum_file_name,slsh);
infile=sum_file_name(locs(end)+1:end);

% let it handle underscores in_file_name more cleanly
loc=findstr('_',infile);
if (~isnan(loc))
    if (length(loc)==1)
        infile=strcat(infile(1:loc-1), '\',infile(loc:end));
    elseif (length(loc)==2)
        infile=strcat(infile(1:loc(1)-1), '\',infile(loc(1):loc(2)-1), '\',infile(loc(2):end));
    elseif (length(loc)==3)
        infile=strcat(infile(1:loc(1)-1), '\',infile(loc(1):loc(2)-1), '\',infile(loc(2):loc(3)-1), '\',infile(loc(3):end));
    end
end


cum_dist=nancumsum(epmax-epmin); %cumulative distance travelled in m

%%
%plottime=1; %0 to plot profile number, 1 to plot time
if plottime==1
    varx = starttime;
else
    varx = files;
end

figure
clf
ax=MySubplot(.1,.1,0,.1,.1,0.02,1,5);
axes(ax(1))
h=plot(varx(j),epmin(j),'r-',varx(j),epmax(j),'r-',... %plot DOWN profiles RED
    varx(k),epmin(k),'b-',varx(k),epmax(k),'b-');      %and UP profiles BLUE
xl=xlim;
if plottime==1
    datetick('x',1,'keeplimits')
end
xtloff
axis ij
grid
%xlabel('Profile number')
ylabel('min/max pres /  dbars');
title([infile ', ' num2str(max(files)) ' profiles'])
set(gcf,'Tag','sumplot')

axes(ax(2))
h=plot(varx(j),avevolt(j),'r-',varx(k),avevolt(k),'b-');
ylabel('avg voltage')
ylim([8 12 ])
xlim(xl)
if plottime==1
    datetick('x',1,'keeplimits')
end
xtloff
lg=legend(h,'DOWN','UP',3);
set(lg,'fontsize',8)

axes(ax(3))
plot(varx(j),avecur(j),'r-',varx(k),avecur(k),'b-');
ylabel('avg curr  mA ')
xlim(xl)
if plottime==1
    datetick('x',1,'keeplimits')
end
xtloff

%6/06 change: plot negative vel for upcasts MHA
axes(ax(4))
plot(varx(j),espeed(j),'r-',varx(k),-espeed(k),'b-');
%ylim([-0.32 0.32])
if nanmean(espeed(j)) < 0.3
ylim([0 0.32])
else
    ylim([0.2 0.55]) %for mp105, fast mp101
end

xlim(xl)
ylabel('Avg speed  dbar/s ')
if plottime==1
    datetick('x',1,'keeplimits')
end
xtloff
axes(ax(5))
plot(varx,cum_dist/1000);
xlim(xl)
if plottime==1
%    datetick('x',1,'keeplimits')
    datetick('x',1,'keeplimits','keepticks')
    xlabel('Time')

else
    xlabel('Profile number')
end
ylabel('Dist / km')
set(gcf,'Tag','sumplot')
ylim([0 1000])
sl=SubplotLetter(['total distance: ' num2str(max(cum_dist/1000)) ' km'],.01,.9)
