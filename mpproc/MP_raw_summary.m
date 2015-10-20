function MP_raw_summary(info,prof_range)

% MP_RAW_SUMMARY Extract summary information form raw MP data in .mat
% format.
%
%   MP_raw_summary(INFO,PROF_RANGE)
%
%   INPUT   info - MP info structure
%           prof_range - vector specifying profiles to be used (optional)
%
%   Gunnar Voet   [gvoet@ucsd.edu]
%   10/2015
%   
% OLD DOCUMENTATION
% This program takes the raw mmp data files in matlab format
% from a user specified directory and extracts summary information
%
% Note that input files are assumed to be called rawNNNN.mat where NNNN
% is the profile number, and the file structure assumes UNIX protocols.

%  copyright John Toole  Woods Hole Oceanographic Institution
%  February, 2002

% MHA change: if the variables exist, then clear them

% 09/2015 GV: making this into function without the gui.

clear files starttime endtime neng nctd nacm...
      cpmin cpmax epmin epmax espeed avevolt avecur

minp = info.pmin;
maxp = info.pmax;

mpdatadir = MP_basedatadir(info);

MatDir = fullfile(mpdatadir,'mat');
OutDir = MatDir;

OutName = sprintf('summary_%s_%s_sn%s',info.cruise,info.station,info.sn);
outfilename = fullfile(OutDir,OutName);

stas = prof_range;
slsh = filesep;

textprogressbar('Reading files for summary:    ');

for h=1:length(stas)
  textprogressbar(h/max(stas)*100);
  file=[MatDir slsh,'raw',sprintf('%4.4i',stas(h)),'.mat'];
  if exist(file,'file');
    eval(['load ',MatDir slsh,'raw',sprintf('%4.4i',stas(h)),'.mat']);
    files(h)=stas(h);

    j=find(psdate=='/');
    psdate(j)=' ';
    date=str2num(psdate);

    month=date(1);
    day=date(2);
    year=date(3)+2000;
    if(date(3)==0);
      year=2000;
    end
    if(date(3)==9);
      year=1999;
    end


    j=find(pstart==':');
    pstart(j)=' ';
    start=str2num(pstart);

    hour=start(1);
    minute=start(2);
    second=start(3);

    starttime(h)=datenum(year,month,day,hour,minute,second);

    j=find(pedate=='/');
    pedate(j)=' ';
    date=str2num(pedate);

    month=date(1);
    day=date(2);
    year=date(3)+2000;
    if(date(3)==0);
      year=2000;
    end
    if(date(3)==9);
      year=1999;
    end

    j=find(pstop==':');
    pstop(j)=' ';
    stop=str2num(pstop);

    hour=stop(1);
    minute=stop(2);
    second=stop(3);

    endtime(h)=datenum(year,month,day,hour,minute,second);

    neng(h)=length(epres);

    if(exist('Vab')==1);
      nacm(h)=length(Vab);
    else
      nacm(h)=0;
    end

    if(exist('cpres')==1);
      nctd(h)=length(cpres);

      j=find(cpres>1 & cpres<5000); %11/2012 change.
      if ~isempty(j) % GV change this for empty ctd
        cpmin(h)=min(cpres(j));
        cpmax(h)=max(cpres(j));
      else
        nctd(h)=0;
        cpmin(h)=nan;
        cpmax(h)=nan;
      end
    else
      nctd(h)=0;
      cpmin(h)=nan;
      cpmax(h)=nan;
    end

    j=find(epres>10 & epres<5000);

    %9/2011 addition to allow summary to continue if file has few or no
    %valid pressures
    if ~isempty(j)
    epmin(h)=min(epres(j));
    epmax(h)=max(epres(j));
    else
    epmin(h)=nan;epmax(h)=nan;
    end

    j=find(epres>=minp & epres<=maxp);
    jlen=length(j);
    if(jlen>2);
      espeed(h)=(epres(j(1))-epres(j(jlen)))/((engtime(j(1))-engtime(j(jlen)))*86400.);
      avecur(h)=mean(ecurr(j));
      avevolt(h)=mean(evolt(j));
      %aveV2(h)=mean(eV2(j));
    else
      espeed(h)=nan;
      avecur(h)=nan;
      avevolt(h)=nan;
      %aveV2(h)=nan;
    end

    clear cpres;
    clear Vab;

  else   %if file doesn't exist
    files(h)=nan;
    starttime(h)=nan;
    endtime(h)=nan;
    neng(h)=nan;
    nctd(h)=nan;
    nacm(h)=nan;
    cpmin(h)=nan;
    cpmax(h)=nan;
    epmin(h)=nan;
    epmax(h)=nan;
    avecur(h)=nan;
    espeed(h)=nan;
    avevolt(h)=nan;
    %aveV2(h)=nan;

  end   %if file exists

end	%end looping on files

textprogressbar(' Done');

% Save summary file
fprintf('Writing summary file: %s\n',OutName);
save(outfilename,'files','starttime','endtime','neng','nctd','nacm',...
        'cpmin','cpmax','epmin','epmax','espeed','avevolt','avecur');


