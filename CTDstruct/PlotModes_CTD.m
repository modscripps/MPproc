function PlotModes_CTD(CTD,plotit)
%function PlotModes_CTD(CTD,plotit)
%Plot the modes of a CTD structure that has had modes added by
%AddModesToCTD.
%
%1/4/06

subplot(131)
plot(CTD.n2m_full,CTD.z_full,CTD.n2m,CTD.z);axis ij
ylim([0 max(CTD.H)])
xlabel('N^2 / (rads^{-1})^2')
subplot(132)
wh=plotit;
h=plot(-CTD.vert_mha_full(:,wh),CTD.z_full,...
    CTD.vert_full(:,wh),CTD.z_full,...
    -CTD.vert_mha(:,wh),CTD.z,...
    CTD.vert(:,wh),CTD.z);
lc(h,'k')
lc(h([1 3]),'r')
lw(h(3:4),2)
axis ij
ylim([0 max(CTD.H)])
xlabel('Vert')
title(['Mode ' num2str(wh)])
subplot(133)
h=plot(-CTD.hori_mha_full(:,wh),CTD.z_full,...
    CTD.hori_full(:,wh),CTD.z_full,...
    -CTD.hori_mha(:,wh),CTD.z,...
    CTD.hori(:,wh),CTD.z);
lc(h,'k')
lc(h([1 3]),'r')
lw(h(3:4),2)
axis ij
ylim([0 max(CTD.H)])
xlabel('Horiz')
legend(h([3 4]),'(-) MHA','sw\_vmodes',3)
