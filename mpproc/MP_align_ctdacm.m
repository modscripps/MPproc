function  [startc,endc,starta,enda,dpdt] = MP_align_ctdacm(cpres,vup,samplerate)

% [startc,endc,starta,enda,dpdt] = MP_align_ctdacm(cpres,vup,samplerate)
%
% INPUT
% cpres = ctd pressure series
% vup = acm derived vertical velocity
% samplerate is for the CTD in scans per day
%
% OUTPUT
% startc and endc are the ctd scan numbers for the start and end of the profile
% starta and enda are those for the acm
% here start and end are where the profile speed first rises above and last
% falls below half the mean profile speed.
% dpdt is the time rate of change of the pressure, scaled to cm/s


% First compute dP/dt as centered difference using the supplied sample rate
dpdt = gradient(cpres)/(samplerate.*24*3600)*100.; 

% Filter the dpdt and vz data to better find the start and stop transients
[b,a] = butter(4,.05);
% [b,a] = butter(1,.25);

filtcpres = myfiltfilt(b,a,dpdt(:)); 
filtw     = myfiltfilt(b,a,vup(:));
dpdt      = filtcpres;

% Now find the starting and stopping transient in both the dpdt and vz data
pthresh = 0.5*mean(filtcpres);
paddresses = find(abs(filtcpres)<abs(pthresh));
dividepaddresses = find(diff(paddresses)>1);
startc = (paddresses(dividepaddresses(1)));
endc   = (paddresses(dividepaddresses(length(dividepaddresses))+1));
athresh = 0.5*mean(filtw);
aaddresses = find(abs(filtw)<abs(athresh));
divideaaddresses = find(diff(aaddresses)>1);

% MHA kluge to get things running for HOME02.  This dies sometimes because
% the velocity paths are screwy.  Since I am just calculating things for
% Thorpe scales, just put in some silly numbers.
% starta=aaddresses(divideaaddresses(1));
% enda=aaddresses(divideaaddresses(length(divideaaddresses))+1);

% 9/2010: in 12/09 I replaced the original lines (the next few shown) with
% the lines below to solve problems I was having.  However the code I
% implemented has problems in iwise10 in determining the correct start for
% the acm records.  So I return to the original code.

% ORIGINAL CODE
if isempty(divideaaddresses)
  starta = 500;
  enda   = 2500;
else
  starta = aaddresses(divideaaddresses(1));
  enda   = aaddresses(divideaaddresses(length(divideaaddresses))+1);
end


%MHA 12/09: try a different implementation that is better at aligning
%things when there is motion in the first two minutes
% if isempty(divideaaddresses)
%     starta=500;
%     enda=2500;
% elseif length(divideaaddresses)==3 %skip the first one
%     starta=aaddresses(divideaaddresses(2));
%     enda=aaddresses(divideaaddresses(length(divideaaddresses))+1);
% else
%     starta=aaddresses(divideaaddresses(1));
%     enda=aaddresses(divideaaddresses(length(divideaaddresses))+1);
%     
% end
