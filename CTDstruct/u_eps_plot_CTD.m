function FP=u_eps_plot_CTD(MP,FP)
%function u_eps_plot_CTD(MP,FP)
%plot a specified variable and epsilon over a specified time range
%req'd fields: yday, z, (v1), eps, H, d_Iso
%
%Call with no FP to return a default FP structure.
%
%3/24/
if nargin < 2
    FP.fignum=1;

    FP.clim=0.25*[-1 1];
    FP.clime=[-9 -5];

    FP.v1='v';

    FP.xl=min(MP.yday)+[0 5];
    FP.yl=[0 MP.H(1)];

    FP.nt_eps=2;
    FP.nz_eps=10;

    FP.plot_track=0;

    FP.plot_iso=1;

    FP.sk=25;

    FP.plot_ydayc=0;
    FP.contour_eps=1;
    return;
end

figure(FP.fignum)
TalkFig
clf
%sk=25;



iz=find(MP.z>FP.yl(1) & MP.z < FP.yl(2));
it=find(MP.yday > FP.xl(1) & MP.yday < FP.xl(2));

%compute log of smoothed eps now to avoid edge effects later
cle=log10(CenteredConv(MP.eps,FP.nt_eps,FP.nz_eps));

ax=MySubplot(.2,.12,0,.1,.1,0.02,1,2);

axes(ax(2))
if isfield(MP,'ydayc') & FP.plot_ydayc
    pc=pcolor(MP.ydayc(iz,it),MP.z(iz),cle(iz,it));axis ij;shading flat
else
    pc=pcolor(MP.yday(it),MP.z(iz),cle(iz,it));axis ij;shading flat
end

xlim(FP.xl)
caxis(FP.clime)
sl=SubplotLetter('\epsilon',0.01,0.1);
set(sl,'fontsize',14);set(sl,'fontweight','bold')
%colormap(jet)
xlim(FP.xl)
ylim(FP.yl)
ylabel('Depth / m')
xlabel('yearday')
%xtloff
hold on
%h=plot(MP.ydayc,MP.z,'k-');lc(h,0.6*[1 1 1])
%plot(MP.ydayc(1:sk:end,:)',MP.d_Iso(1:sk:end,:)','w-');
if diff(FP.xl) < 6 & FP.plot_track
    if isfield(MP,'ydayc')
        h=plot(MP.ydayc(iz(1:FP.sk:end),it),MP.z(iz(1:FP.sk:end)),'k-');lc(h,0.6*[1 1 1]);
    end
end
if FP.plot_iso
    if isfield(MP,'ydayc') & FP.plot_ydayc
        h=plot(MP.ydayc(iz(1:FP.sk:end),it)',MP.d_Iso(iz(1:FP.sk:end),it)','k-');lw(h,1)
    else
        h=plot(MP.yday(it),MP.d_Iso(iz(1:FP.sk:end),it)','w-');lw(h,1)
    end
end

hold off
colormap(jet) %copper w/ white is decent; or bone w/ green

MakeTrueColor(pc)
cbax=ezcb(ax(2),FP.clime,'\epsilon');
MakeTruecolor(get(cbax,'Children'))
set(cbax,'fontsize',14)
ylab=get(cbax,'ylabel');
set(ylab,'fontsize',14)


axes(ax(1))

if isfield(MP,'ydayc') & FP.plot_ydayc
    pcolor(MP.ydayc(iz,it),MP.z(iz),MP.(FP.v1)(iz,it));axis ij;shading flat
else
    pcolor(MP.yday(it),MP.z(iz),MP.(FP.v1)(iz,it));axis ij;shading flat
end

ylabel('Depth / m')
caxis(FP.clim)
set(sl,'fontsize',14);set(sl,'fontweight','bold')
colormap(bluered)

xlim(FP.xl)
ylim(FP.yl)

sl=SubplotLetter(FP.v1,0.01,0.1);
xtloff
hold on
if diff(FP.xl) < 6 & FP.plot_track
    if isfield(MP,'ydayc')
        h=plot(MP.ydayc(iz(1:FP.sk:end),it),MP.z(iz(1:FP.sk:end)),'k-');lc(h,0.6*[1 1 1]);
    end
end
if FP.plot_iso
    if isfield(MP,'ydayc') & FP.plot_ydayc
        h=plot(MP.ydayc(iz(1:FP.sk:end),it)',MP.d_Iso(iz(1:FP.sk:end),it)','w-');lw(h,1)
    else
        h=plot(MP.yday(it),MP.d_Iso(iz(1:FP.sk:end),it)','k-');lw(h,1)
    end
end
if FP.contour_eps
    [c,h]=contour(MP.yday,MP.z,cle,[-6.5 -6.5],'w-'); %should have ioption of ydayc
    lw(h,2)
end
hold off
axis ij
%pos=get(ax(2),'position')
%cbax=mycolorbar2(clim,'uMP','vert',[.97 pos(2)+pos(4)/4 .02 pos(4)/2],length(colormap),10)
cbax=ezcb(ax(1),FP.clim,FP.v1);
set(cbax,'fontsize',14)
ylab=get(cbax,'ylabel');
set(ylab,'fontsize',14)
