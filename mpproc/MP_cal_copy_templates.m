function CalFiles = MP_cal_copy_templates(info)

% MP_CAL_COPY_TEMPLATES(info)
%
%   MP_cal_copy_templates(INFO) Copy templates for ctd and acm cal files
%   into cal/
%
%   INPUT   info - MP info structure
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 10/08/2015
%   Updated: 10/09/2015 Output cal file names


mpdatadir = MP_basedatadir(info);
cruise    = info.cruise;
sn        = info.sn;

% Get the template path
template_path = which('MP_mag_pgrid.m');
xi = strfind(template_path,filesep);
template_path = fullfile(template_path(1:xi(end)),'templates/');

ACM_calfile = fullfile(mpdatadir,'cal',...
                       sprintf('make_acm_calfile_%s_sn%s.m',cruise,sn));

CTD_calfile = fullfile(mpdatadir,'cal',...
                       sprintf('make_ctd_calfile_%s_sn%s.m',cruise,sn));

fprintf(1,'\n');
% ACM
if ~exist(ACM_calfile,'file')
  copyfile(fullfile(template_path,'ACM_calfile_template.m'),ACM_calfile)
  fprintf(1,'Copy ACM cal file from\n%s\nto\n%s\n\n',template_path,ACM_calfile);
else
  fprintf(1,'ACM calfile found; doing nothing.\n\n');
end

% CTD
if ~exist(CTD_calfile,'file')
  copyfile(fullfile(template_path,'CTD_calfile_template.m'),CTD_calfile)
  fprintf(1,'Copy CTD cal file from\n%s\nto\n%s\n\n',template_path,CTD_calfile);
else
  fprintf(1,'CTD calfile found; doing nothing.\n\n');
end

CalFiles.ACM_calfile = ACM_calfile;
CalFiles.CTD_calfile = CTD_calfile;