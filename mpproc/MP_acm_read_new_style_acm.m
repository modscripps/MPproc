function acm = MP_acm_read_new_style_acm(FileName)

% MP_read_new_fsi_acm Read new style FSI ACM file skipping header and
% footers
%
%   acm = MP_read_new_fsi_acm(FileName) longer description if needed
%
%   INPUT   FileName - acm file name
%       
%   OUTPUT  acm - cell array with 9 fields, as for the older style acms
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 2017-04-22

fid = fopen(FileName);
test = fgetl(fid);
fclose(fid);
if strcmp(test(1:6),'Sample')
%   acm = textread(FileName,'%f',9,'headerlines',1);
  fprintf('\n this is a new style acm file\n')
  fid = fopen(FileName);
  header = fgetl(fid);
  tmp = 'a';
  
  % open tmp file
  fid2 = fopen('acm_tmp.txt','w');
  
  while ischar(tmp) && ~isempty(tmp)
    tmp = fgetl(fid);
%     fprintf(1,'%s\n',tmp);
  if ~isempty(tmp)
    fprintf(fid2,'%s\n',tmp);
  end
  end
  
  fclose(fid);
  fclose(fid2);
  
   [date, time, dummy, acm1, acm2, acm3,...
   acm4, acm5, acm6, acm7, acm8, acm9]  =...
   textread('acm_tmp.txt','%s %s %f %f %f %f %f %f %f %f %f %f');
  
end

acm = [acm1,acm2,acm3,acm4,acm5,acm6,acm7,acm8,acm9];