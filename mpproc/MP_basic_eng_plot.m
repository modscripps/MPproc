function ax = MP_basic_eng_plot(MP,c)

% ax = MP_basic_eng_plot(MP,c)
% Basic plot of presure, current, voltage and dpdt versus profile time for
% a MP structure and the specified profile.
%
% 1/25/05 MHA

% Set default profile
if nargin < 2
    c = 1;
end

% Try to compute edpdt if it is not computed.
MP.edpdt2 = 100*abs(diffs(MP.epres)./(diffs(MP.engtime)*24*3600));

itime = 3; % sometimes needs to be > 1 if there is a zero first...
nsm   = 5; % smoothing factor for convolution

clf

ax = MySubplot(.1,.1,0.03,.1,.1,0.03,1,4);

% Pressure
axes(ax(1))
plot((MP.engtime(:,c)-MP.engtime(itime,c))*24,MP.epres(:,c))
title([MP.info.cruise ', SN ' MP.info.sn ', profile#' num2str(MP.id(c)) ', yday ' num2str(MP.yday(c))])
xtloff
xlim([0 max((MP.engtime(:,c)-MP.engtime(itime,c))*24)])
ylabel('dbar')
SubplotLetter('pres',.01,.5)
grid on

% Current
axes(ax(2))
%plot((MP.engtime(:,c)-MP.engtime(itime,c))*24,MP.ecurr(:,c))
%smooth ecurr first
plot((MP.engtime(:,c)-MP.engtime(itime,c))*24,CenteredConv(MP.ecurr(:,c),1,nsm))
xtloff
ylabel('mA')
ylim([0 700])
xlim([0 max((MP.engtime(:,c)-MP.engtime(itime,c))*24)])
powerused=nansum(MP.ecurr(:,c))*nanmean(diff(MP.engtime(:,c)))/1000*24; %power used in Ah
SubplotLetter('curr',.01,.9)
% SubplotLetter([num2strMHA(powerused,2) ' A-h used'],.7,.9)
SubplotLetter(sprintf('%0.2f A-h used',powerused),.7,.9)
grid on

% Voltage
axes(ax(3))
plot((MP.engtime(:,c)-MP.engtime(itime,c))*24,MP.evolt(:,c))
xtloff
ylabel('V')
xlim([0 max((MP.engtime(:,c)-MP.engtime(itime,c))*24)])
SubplotLetter('volt',.01,.9)
grid on

% Profiling speed
axes(ax(4))
plot((MP.engtime(:,c)-MP.engtime(itime,c))*24,CenteredConv(MP.edpdt(:,c),1,nsm),...
    (MP.engtime(:,c)-MP.engtime(itime,c))*24,CenteredConv(MP.edpdt2(:,c),1,nsm))
ylabel('cm/s')
ylim([0 40])
xlim([0 max((MP.engtime(:,c)-MP.engtime(itime,c))*24)])
grid
SubplotLetter('dpdt',.01,.9)
xlabel('time / hour')