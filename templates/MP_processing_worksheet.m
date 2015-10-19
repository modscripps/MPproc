%% MP PROCESSING WORKSHEET
% McLane Moored Profiler processing worksheet.
% Go through this worksheet cell by cell.
% FSI / AQDP mark cells specific to either FSI ACM or Nortek Aquadopp.

clear

%% Specify the cruise and the sn of the moored profiler to process.

cruise  = '';
mooring = '';
sn      = '';

%% Basics: first make sure the database is correct.
% Make sure all information for this deployment are correct.
% AQDP: For the aquadopp to be recognized in the processing you need to put
% in a serial number starting with 'AQD'
edit('MP_deploymentinfo')

%% Then verify that the base data function is correct.
%  This will point to the directory that contains all project directories.
edit('MP_basedatadir')

%% Get MP info and base directory.

info      = MP_deploymentinfo(sn,cruise,mooring);
mpdatadir = MP_basedatadir(info);

% Change to current directory. This processing worksheet should reside in
% mpdatadir.
cd(mpdatadir)
fprintf(1,'\nNow working in\n %s/\n\n',pwd);


%% Create folders

% Make directories if needed. This won't overwrite any existing
% directories. Aquadopp directories will be created as well if needed.
MP_create_directories(mpdatadir,info);


%% Put raw MP files in 'raw'


%% Unpack MP files into offload

% For this use the windows version of unpacker. Modify the file
% mmp_unpacker.ini in C:\Windows to match the firmare version of the
% profiler.

% unpacker version used: ?

% Please unpack the deploy.txt and exception files and make them machine
% readable.


%% AQDP: Unpack and move data files

% You should manually move the .PRF / SYSLOG01.TXT files to ~/aqdp/raw.
%      (are there other files????)

% You should manually move the raw text files to ~/aqdp/offload.
% These are the files generated from .PRF by Nortek's Windows
% program. These are the files named DEF*, with extensions
%  .a1 / .a2 / .a3 / .hdr / .hr2 / .sen / .ssl / .v1 / .v2 / .v3


%% At this point if you want to see a quick plot of pmin, pmax, run
sk = 1; % plot every (sk) profile
MP_eng_depth_history(info,sk);
gpr(sprintf('plots/depth_history_%s_%s_sn%s',...
            info.cruise,info.station,info.sn))


%% Compass error analysis.
% We do this at this point to have values for the acm cal files.  In most
% cases the corrections will be small; it just takes a moment to verify
% this here. This uses the offloaded text files.


%% Create spin test file
% This will plot the calibration data and let the user pick points where
% the direction was held stable for about 10 seconds. Will give a warning
% if spinfile already exists. Start with north (should be first and last
% stop in the rotation).

% AQDP: modify calibration txt file to only contain one column with
% headings before running this.

% File- or pathname to existing cal file.
CalFile = 'filename_of_cal_file.txt';
MP_acm_create_spintest_file(CalFile);


%% FSI ACM: Part 1. compass offset and scale
% Estimate ACM offset and scale for a set of given profiles. Offset and
% scale are calculated over a range of profiles and then averaged for the
% calibration.

% Pass input parameters:
% Vector with profile numbers. if []: calcs on all profiles
UseProfiles = [20:40];
% Chose a profile for plotting.
PlotProfile = 30;

% Run calculations
ac = MP_acm_offset_and_scale(mpdatadir,UseProfiles,PlotProfile);

%% FSI ACM: Part 2. compass error (from spin test)
% Make a copy of the spintest data file and keep only 8 lines in there,
% each for one of the spin test headings. Start with north. Name this file
% spintest.txt and then run acm_corr with this file.
% -> This was probably all done above using MP_acm_create_spintest_file()
[~,~,ac.bias_angles,ac.average_bias] = MP_acm_correction('spintest.txt',1);


%% AQDP: compass error (from spin test)
ac = MP_aqdp_correction('spintest.txt');

%% Compass: Save
% Save the calculated cmpass parameters. They will later be read into the
% acm cal file.
SaveName = sprintf('cal/acm_corr_coefficients_%s_%s_sn%s.mat',...
                    info.cruise,info.station,info.sn);
save(SaveName,'ac')


%% First, convert MP text files to matlab.
% Convert ascii files using the new script. Specify a range of profile
% numbers (optional). Default is to look for engineering files that have
% more than 0 bytes and to convert all of them. Files are written into mat/
% Empty acm and ctd files are processed and filled with bad values to be
% filtered out later.
prof_range = MP_convert(info);

% Save file size overview figure
gpr(sprintf('plots/file_size_overview_%s_%s_sn%s',...
            info.cruise,info.station,info.sn),0)


%% Generate a summary file.
% Pressure limits from info structure. Summary file gets written into mat/
MP_raw_summary(info,[1:info.n_profiles])


%% Plot summary with time on x-axis

plottime = 1; % use time on x-axis
SummaryFile = fullfile(mpdatadir,'mat',sprintf('summary_%s_%s_sn%s.mat',info.cruise,info.station,info.sn));
MP_plot_raw_summary(SummaryFile,plottime)
PrintName = fullfile(mpdatadir,'plots',sprintf('summary1_%s_sn%s_time',info.cruise,info.sn));
gpr(PrintName,0)
% WritePDF(['summary1_' info.cruise '_' ['sn' info.sn] '_time'],fullfile(mpdatadir,'plots'))


%% Plot summary with profile number on x-axis

plottime = 0; % use profile number on x-axis
MP_plot_raw_summary(SummaryFile,plottime)
PrintName = fullfile(mpdatadir,'plots',sprintf('summary1_%s_sn%s_profilenum',info.cruise,info.sn));
gpr(PrintName,0)
% WritePDF(['summary1_' info.cruise '_' ['sn' info.sn] '_profilenum'],fullfile(mpdatadir,'plots'))


%% AQDP: convert and split aquadopp files
% Convert aquadopp ascii files to a big .mat structure. Apply compass
% correction and magnetic deviation and transform from beam to earth
% coordinates.
aqdp = MP_aqdp_convert(info);

% Save to aqdp/mat/
SaveName = fullfile(mpdatadir,'aqdp/mat',...
      sprintf('AQDP_all_%s_%s_sn%s.mat',info.cruise,info.station,info.sn));
save(SaveName,'-v7.3','aqdp');


%% AQDP: split data into separate files for each of the MP profiles.
% Give a range of bins (optional) for bin averaging. Default is only bin 15.
% Nprofiles = MP_aqdp_split(aqdp, info);
Nprofiles = MP_aqdp_split(aqdp, info, [5:20]);


%% FSI ACM: Velocity bias and path error analysis.
% Need to estimate velocity path biases using find_acm_biasMHA.m.  This
% compares the paths from ab, cd, ef and gh at the surface and the bottom
% while the profiler is not moving.  So, these should all give the same
% answer (ab, ef positive, cd, gh negative).  

mpo.acm.pathbias = 'top'; % 'top','bottom','both'
PathBiasProfiles = 2:info.n_profiles;
[ab.bias_ab,ab.bias_cd,ab.bias_ef,ab.bias_gh] = MP_acm_find_bias(info,mpo,PathBiasProfiles);


%% FSI ACM: Save velocity path bias
PrintName = sprintf('%s/plots/pathbias1_%s_%s_sn%s.mat',...
                    mpdatadir,info.cruise,info.station,info.sn);
gpr(PrintName,0)
% WritePDF(['pathbias1_' info.cruise '_' ['sn' info.sn]],fullfile(mpdatadir,'plots'))

% In this plot, ab and ef (red and blue) should be positive and nearly
% equal. cd and gh (green and magenta) should be negative and nearly equal.

% If these are significant, enter them into the acm_calfile.  If there
% really appear to be depth-dependent path biases, then use the routines in
% pathbias directory.  I am not very trusting of the ideas behind a
% depth-dependent bias though so as a first attempt just use a
% depth-independent one.

% Save acm bias parameters to cal directory to load them into the acm cal
% file later
SaveName = sprintf('cal/acm_bias_coefficients_%s_%s_sn%s.mat',info.cruise,info.station,info.sn);
save(SaveName,'ab')


%% FSI ACM: Determine wag correction.
% Choose a piece of a profile near a strong flow.  See
% DetermineBestWagFactor.m if you wish to cycle through a few profiles.
slims  = [100 300];
prof   = 40;
plotit = 0;

close all
bestL = MP_find_best_wag_factor(info, prof,slims, plotit);
bestL = 35;

% TODO: wag correction for AQDP?

%% FSI ACM: Verify wag correction.
% Once the factor is verified, it can be entered into the acm calfile.
% Note the factor there is twice L here since it folds in the 2-Hz
% samplerate.

ax = MP_test_wag_corr(info, prof,slims, bestL);
    
%Get lims from the plot
axes(ax(5));

slims = xlim;
smin  = slims(1);
smax  = slims(2);

%% FSI ACM: Save wag correction
PrintName = fullfile(mpdatadir,'plots',...
  sprintf('MPwagplot_%s_sn%s_%d_%d-%d-L%d',info.cruise,info.sn,prof,smin,smax,bestL));
gpr(PrintName)


% Save wag factor to cal directory to automatically include it in the acm
% cal file
SaveName = ['cal/acm_wag_factor_',info.cruise,'_',info.station,'_sn',info.sn,'.mat'];
save(SaveName,'bestL')


%% Put cal files into the cal directory.
% Copy the files CTD_calfile_template.m and ACM_calfile_template.m into the
% cal directory and name them make_ctd_calfile_[cruise][sn].m and
% make_acm_calfile_[cruise][sn].m.  Then run them, which will create mat
% files.
CalFiles = MP_cal_copy_templates(info);


%% Now edit these files and make sure they are accurate.

edit(CalFiles.ACM_calfile)
edit(CalFiles.CTD_calfile)


%% Then evaluate the m files to creat the .mat files in the cal directory

run(CalFiles.ACM_calfile)
run(CalFiles.CTD_calfile)


%% Verify ctd calibration parameters

% Modify these parameters and add CTpar as 3rd argument to function or use
% parameters from ctd cal file instead.
% CTpar.lag     = +.05;     % number of scans
% CTpar.alfa    = 0.06;
% CTpar.beta    = 0.06;
% CTpar.P2T_lag = -1.0;     % lag (in scans) from pres to temp sampling
% CTpar.alfa2    = 0.0035;
% CTpar.beta2    = 0.0004;
MP_test_ctd_params(info,10)
if 1
PrintName = sprintf('plots/ctd_cal_%s_%s_sn%s',info.cruise,info.station,info.sn);
gpng(PrintName)
end

%% Pressure gridding (and CTD & ACM/AQUADOPP calcs)

MP_mag_pgrid(sn,cruise,mooring,1:info.n_profiles)


%% Basic engineering plots.

% Determine a representative one to plot.
figure
for wh = [31];
  MP1 = MP_makeCTD(info,wh)
  ax  = MP_basic_eng_plot(MP1,1);
end

%% Print engineering plot
WritePDF(sprintf('basiceng_%s_sn%s_prof%d',info.cruise,info.sn,wh(1)),...  
         fullfile(mpdatadir,'plots'))

%% Create data structure with all gridded data
% Get raw and engineering data too
MPall = MP_makeCTD(info,[1 info.n_profiles],1,1);

SaveName = fullfile(mpdatadir,'processed',...
        sprintf('MPall_%s_%s_sn%s.mat',info.cruise,info.station,info.sn));
save(SaveName,'MPall')


%% Overview plot
%  plot th/s/sgth/u/v

% Set color limits {v,u,sgth,s,th}
pp.caxis = {[-0.3 0.3],[-0.3 0.3],[],[],[]};

out = MP_sci_plot(MPall,info,pp,20);

PrintName = sprintf('plots/sci2_%s_%s_sn%s',info.cruise,info.station,info.sn);
gpng(PrintName)
