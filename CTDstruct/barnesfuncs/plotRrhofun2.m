function plotRrhofun2(s,t,p,zsm)

%Now plot rrho too
[Rrho,angle]=MyRrhofun2(s,t,p/100,8);
pgrid=p;
%Rrho
isf=find(Rrho>1);
idr=find(Rrho>0 & Rrho < 1);
ist=find(Rrho < 0);

xmin=-2;
xmax=2;

%clip at xmin and xmax
rrp=Rrho;
rrp(find(Rrho>xmax))=xmax;
rrp(find(Rrho<xmin))=xmin;
%axes('Position',pos_rrho)
axrrho=axes;
plot(rrp,pgrid,rrp(isf),pgrid(isf),'b.',rrp(idr),pgrid(idr),'r.')
axis ij
%ylim([pmin pmax])
%xlim([xmin xmax])
set(gca,'XTick',(xmin:xmax))
set(gca,'YTicklabel','')
grid
xlabel('R_{\rho}')