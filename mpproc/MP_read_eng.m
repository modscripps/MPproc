function [yr,mon,day,hr,min,sec,curr,vlt,press,vel] = MP_read_eng(datapath,profile)

%function [yr,mon,day,hr,min,sec,curr,vlt,press,vel] = MP_read_eng(datapath,profile);
% from David Walsh, 2/13/03

% function [mon,day,yr,hr,min,sec,curr,vlt,press,vel] = MP_read_eng(profile);
%
% loads machine-readable versions of MMP engineering files

varname = sprintf('e%7.7d.txt',profile);
fname   = fullfile(datapath,varname);

% Check whether date and time are vector or string
fid = fopen(fname);
line = fgetl(fid);
if ~isempty(strfind(line,':'))
  IsDateStr = 1;
   % some files have commas after date and time...
  if length(strfind(line,','))==3
    DateStrWith3Commas = 1;
  else
    DateStrWith3Commas = 0;
  end
else
  IsDateStr = 0;
end
fclose(fid);

if ~IsDateStr
A = load(fname);

% % % %MHA 8/2012:
% % % %Use the version for unpacker 3 if needed.
% % % %[m,n]=size(varname);
% % % if 0%n < 9
% % %     [yr,mon,day,hr,min,sec,curr,vlt,press,vel] = MP_read_eng_unpacker3(datapath,profile);
% % %     return
% % % end

mon = A(:,1);
day = A(:,2);
yr  = A(:,3);
hr  = A(:,4);
min = A(:,5);
sec = A(:,6);
curr = A(:,7);
vlt = A(:,8);
press = A(:,9);
[m,n] = size(A);
if n>=10
  vel = A(:,10);
else
  vel = NaN*press;
end

% % % % 
% % % % eval(['mon = ',varname,'(:,1);'])
% % % % eval(['day = ',varname,'(:,2);'])
% % % % eval(['yr = ',varname,'(:,3);'])
% % % % eval(['hr = ',varname,'(:,4);'])
% % % % eval(['min = ',varname,'(:,5);'])
% % % % eval(['sec = ',varname,'(:,6);'])
% % % % eval(['curr = ',varname,'(:,7);'])
% % % % eval(['vlt = ',varname,'(:,8);'])
% % % % eval(['press = ',varname,'(:,9);'])
% % % % eval(['[m,n]=size(' varname ');'])
% % % % if n>=10
% % % % eval(['vel = ',varname,'(:,10);'])
% % % % 
% % % % else
% % % %     vel=NaN*press;
% % % % end


else % need to parse date and time strings
  
  fid = fopen(fname);
  if DateStrWith3Commas
    A = textscan(fid,'%2d/%2d/%4d %2d:%2d:%2d,%d,%f,%f');
  else
    A = textscan(fid,'%2d/%2d/%4d %2d:%2d:%2d %d %f %f');
  end
  mon   = double(A{1});
  day   = double(A{2});
  yr    = double(A{3});
  hr    = double(A{4});
  min   = double(A{5});
  sec   = double(A{6});
  curr  = double(A{7});
  vlt   = A{8};
  press = A{9};
  fclose(fid);

  
%   fid = fopen(fname);
%   line = fgetl(fid);
%   count = 0;
%   while line>0
%     count = count + 1;
%     A = sscanf(line,'%2d/%2d/%4d %2d:%2d:%2d %d %f %f\n');
%     mon(count)   = A(1);
%     day(count)   = A(2);
%     yr(count)    = A(3);
%     hr(count)    = A(4);
%     min(count)   = A(5);
%     sec(count)   = A(6);
%     curr(count)  = A(7);
%     vlt(count)   = A(8);
%     press(count) = A(9);
%     
%     line = fgetl(fid);
%   end
%   fclose(fid);
  
  vel = NaN*press;
  
end