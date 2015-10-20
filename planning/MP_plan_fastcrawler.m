%MMPPlan.m
%1/18/05

%% Set parameters
speed=0.33; %profile speed in m/s
cdfac=(speed/0.25)^2;
totaldist = 1e6*1.5/cdfac; %Max m set by battery

%%
%Settable parameters
pmin=2240; %shallow pressure stop in m
pmax=3700; %deep pressure stop in m 

profile_interval = 1.5*3600; %profile interval in seconds

profile_dist=pmax-pmin; %compute distance per profile

profile_time=profile_dist./speed;

upload_time=4*60; %time to upload data

%%
if profile_interval < upload_time + profile_time 
    disp(['Warning: It will take ' num2str(profile_time/3600) ' hours to complete this cycle; too long for the ' num2str(profile_interval/3600) '-hour interval specified.'] )
    disp(['The longest profiling interval completable in ' num2str(profile_interval/3600) ' h is ' num2str(speed*(profile_interval-upload_time)) ' m.'])
else
    disp(['It will take ' num2str(profile_time/3600) ' hours to complete this cycle; this is OK given the ' num2str(profile_interval/3600) '-hour interval specified.'] )
end

tot_profiles=fix(totaldist./profile_dist);


disp(['Total distance of ' num2str(totaldist) ' m (' num2str(tot_profiles) ' profiles) reached after ' num2str(tot_profiles*profile_interval/3600/24) ' days.'])

