function MP_eng_depth_history(info,sk,nmax)

% MP_ENG_DEPTH_HISTORY(info,sk,nmax)
%
% Plot a quick record of the pressure limits as a function of drop number.
% This uses only engineering files.
%
%   INPUT   info - structure with cruise info
%           sk   - plot every (sk) profiles (optional, default 5)
%           nmax - number of profiles (optional, default taken from info)       

% Modified from depth_history by David Walsh.
%
% 2/09/05
% depth history 2 uses the new directory structure.
%
% 09/2015 GV changed to new file name, streamlining figure

% check for optional input parameters
if nargin < 2
  sk = 5;
end

if nargin < 3
  nmax = info.n_profiles;
  disp(['Using nmax = ' num2str(nmax)])
end

% Paths
mpdatadir = MP_basedatadir(info);
dpath     = fullfile(mpdatadir,'offload/');
ppath     = fullfile(mpdatadir,'plots/');

% Plot
figure(1)
clf

ax = axes('position',[0.1 0.1 0.8 0.8]);
set(ax,'ydir','reverse')
hold on
xlabel('Cast Number')
ylabel('Pressure (dB)')
grid on
title('Reading raw files...')

cum_dist = 0;

for i = 1:sk:nmax
  [yr,mon,day,hr,mins,sec,curr,vlt,press,vel] = MP_read_eng(dpath,i);
  press(press==0) = NaN; %get rid of the zeros at the top
  plot(i,press(1:5:end),'k.');
  drawnow
  dist = max(press(press < 7000))-min(press(press>0));
  cum_dist = cum_dist+sk*dist; % Compute total distance travelled assuming
                               % that the (sk) profiles are all the same
  fprintf(1,'\n total distance travelled so far is %6d m\n',...
            fix(cum_dist));
end


TitleString = sprintf(['%s, SN %s, ',...
                       'total dist = %d m, ',...
                       'final voltage = %1.2f V'],...
                       info.cruise,info.sn,fix(cum_dist),nanmean(vlt) );
title(TitleString)