function prof_range_out = MP_convert(info,prof_range)

% Routine to read in files of ACM, CTD and ENG data
% from each MMP profile: A*.TXT, C*.TXT, E*.TXT
%
% Assign variable names and output as Matlab-format data files raw*.mat
% to a user-specified data directory
%
% Input:  a series of .TXT files created by MRL's unpacking program unpk2_07
% Output: a series of raw*.mat files

% MFC & JMT 02/2002
%   modified for use with GUI, and added some error checking 3/02 ETM
%      (was MMP_asc2mat.m)
%
% 12/2011: changes made to add fluor and turb variables - MHA
%
% 09/2015 GV: created this function from do_convert2.m that is used in the
% gui.


mpdatadir = MP_basedatadir(info);
rawdir = fullfile(mpdatadir,'offload');
matdir = fullfile(mpdatadir,'mat');

% FSI ACM or Nortek Aquadopp?
if strncmp(info.VELsensor.sn,'AQD',3)
  IsAQD = 1;
else
  IsAQD = 0;
end


%% Look for good files
if nargin<2 || isempty(prof_range)
  dd = dir(fullfile(rawdir,'E*.TXT'));
  di = find([dd.bytes]~=0);
  prof_range = nan(1,length(di));
  for i = 1:length(di)
    prof_range(i) = str2num(dd(di(i)).name(2:8));
  end
  din = find([dd.bytes]==0);
  % warn about empty engineering files
  for i = 1:length(din)
    fprintf(1,'No data in %s\n',dd(din).name);
  end
end


%% Quick overview plot of file sizes
de = dir(fullfile(rawdir,'E*.TXT'));
dc = dir(fullfile(rawdir,'C*.TXT'));
da = dir(fullfile(rawdir,'A*.TXT'));
figure
ax(1) = axes('position',[0.1 0.1 0.8 0.25]);
h(1)  = bar([de.bytes]./1000);
hold on
if ~isempty(find([de.bytes]==0))
  h1 = plot(find([de.bytes]==0),0,'rs');
  set([h1],'markerfacecolor','r','markersize',3)
end
ylabel('file size E (kB)')
xlabel('profile number')

ax(2) = axes('position',[0.1 0.4 0.8 0.25]);
h(2)  = bar([da.bytes]./1000);
hold on
if ~isempty(find([da.bytes]==0))
  h2 = plot(find([da.bytes]==0),0,'rs');
  set([h2],'markerfacecolor','r','markersize',3)
end
ylabel('file size A (kB)')

ax(3) = axes('position',[0.1 0.7 0.8 0.25]);
h(3)  = bar([dc.bytes]./1000);
hold on
if ~isempty(find([dc.bytes]==0))
  h3 = plot(find([dc.bytes]==0),0,'rs');
  set([h3],'markerfacecolor','r','markersize',3)
end
ylabel('file size C (kB)')

set(h,'edgecolor','none','facecolor',[0.5 0.5 0.5])


%% Now convert
stas = prof_range;

for mm=1:length(stas)
    
    %define the input data file names
    
    efile=['E',sprintf('%7.7i',(stas(mm)))];
    afile=['A',sprintf('%7.7i',(stas(mm)))];
    cfile=['C',sprintf('%7.7i',(stas(mm)))];
    sfile=['S',sprintf('%7.7i',(stas(mm)))]; %SUNA
    
    % assign the proper sort of slash, for PC & Unix
    arch=computer;
    if (strcmp(arch,'PCWIN'))
        slsh='\';
    else
        slsh='/';
    end
    
    %now load the respective files and assign the variables
    %  ENGINEERING FILE
    
    if exist([rawdir slsh efile,'.TXT'])
        eval(['load ',rawdir slsh efile,'.TXT']);
        eng=eval(efile);
    elseif exist ([rawdir slsh,'e',sprintf('%7.7i',(stas(mm))),'.txt'])
        eval(['load '  rawdir slsh ,'e',sprintf('%7.7i',(stas(mm))),'.txt'])
        eng=eval(['e',sprintf('%7.7i',(stas(mm)))]);
    else
        msg=['the ENG file specified was not found: please re-enter the path and click CONVERT again'];
        msg_window(msg);
    end
    
    disp([sprintf('\n'),'Processing ENG file:  ',efile]);
    %MHA: Check to see if the size is too small, as created by unpacker 3.0.
    esnum=[1:1:length(eng)];
    [m,n]=size(eng);
    if n < 9
        [eyr,emo,eday,ehr,emin,esec,ecurr,evolt,epres,dum] = MP_read_eng(rawdir,stas(mm));
    else
        
    epres=eng(:,9);
    ecurr=eng(:,7);
    evolt=eng(:,8);
    
    
    emo=eng(:,1);
    eday=eng(:,2);
    eyr=eng(:,3);
    ehr=eng(:,4);
    emin=eng(:,5);
    esec=eng(:,6);
    
    end
    
    engtime=datenum(eyr,emo,eday,ehr,emin,esec);
    
    
    [meng,neng]=size(eng);
    if neng < 10
        %12/04 change: new unpacker does not compute dpdt.  Compute it
        %here.  We desire it in cm/s.
        dt=nanmean(diff(engtime))*24*3600;
        edpdt=-100*diffs(epres)./dt;
    else
        edpdt=eng(:,10);
    end
    %12/2011: add variables regardless; just have them be nan if there is
    %no data
    efluor=nan*epres;
    efluorgain=nan*epres;
    eturb=nan*epres;
    eturbgain=nan*epres;
    %12/11 addition for fluor data. MHA
    if neng >=11
        efluor=eng(:,10);
        efluorgain=eng(:,11);
    end
    %10/06 addition for turb data from ore05. MHA
    if neng >=13
        eturb=eng(:,12);
        eturbgain=eng(:,13);
    end
    
    psdate=datestr(engtime(1),2);
    pedate=datestr(engtime(end),2);
    pstart=datestr(engtime(1),13);
    pstop=datestr(engtime(end),13);
    
    %  CTD FILE
    
    if exist([rawdir slsh cfile,'.TXT'])
        eval(['load ',rawdir slsh cfile,'.TXT']);
        ctd=eval(cfile);
    elseif exist ([rawdir slsh,'c',sprintf('%7.7i',(stas(mm))),'.txt'])
        eval(['load '  rawdir slsh,'c',sprintf('%7.7i',(stas(mm))),'.txt'])
        ctd=eval(['c',sprintf('%7.7i',(stas(mm)))]);
    else
        msg=['the file CTD specified was not found: please re-enter the path and click CONVERT again'];
        msg_window(msg);
    end
    
    disp(['Processing CTD file:  ',cfile]);
    if ~isempty(ctd)
    csnum=[1:1:length(ctd)];
    ccond=ctd(:,1);
    ctemp=ctd(:,2);
    cpres=ctd(:,3);
    else
    fprintf(1,'No data in %s\n',cfile);
    csnum = [1:1:500];
    ccond = zeros(size(csnum'));
    ctemp = ccond;
    cpres = ccond;
    end
    
    %mha change 5/05: get oxygen data if they are there.
    %12/31/2011: put in nan's if they are not.
    [dum,c_ncols]=size(ctd);
    if c_ncols > 3
        cdox=ctd(:,4);
    else
        cdox=nan(size(cpres));
    end
    %  ACM FILE
    if ~IsAQD % only for FSI ACM
        if exist([rawdir slsh afile,'.TXT'])
            eval(['load ',rawdir slsh afile,'.TXT']);
            acm=eval(afile);
        elseif exist ([rawdir slsh,'a',sprintf('%7.7i',(stas(mm))),'.txt'])
            eval(['load '  rawdir slsh,'a',sprintf('%7.7i',(stas(mm))),'.txt'])
            acm=eval(['a',sprintf('%7.7i',(stas(mm)))]);
        else
            msg=['the ACM file specified was not found: please re-enter the path and click CONVERT again'];
            msg_window(msg);
        end
        
        disp(['Processing ACM file:  ',afile]);
        
        if ~isempty(acm)
        asnum=[1:1:length(acm)];
        aTx=acm(:,1);
        aTy=acm(:,2);
        aHx=acm(:,3);
        aHy=acm(:,4);
        aHz=acm(:,5);
        Vab=acm(:,6);
        Vcd=acm(:,7);
        Vef=acm(:,8);
        Vgh=acm(:,9);
        else % for empty acm files
        fprintf(1,'No data in %s\n',afile);
        BADVAL = 0;
        asnum=[1:1:500];
        aTx=0*ones(size(asnum'));
        aTy=aTx;
        aHx=aTx;
        aHy=aTx;
        aHz=aTx;
        Vab=BADVAL*ones(size(asnum'));
        Vcd=BADVAL*ones(size(asnum'));
        Vef=BADVAL*ones(size(asnum'));
        Vgh=BADVAL*ones(size(asnum'));
        end
        
    elseif IsAQD
        BADVAL=6; %temporarily enter 6 cm/s - just need a constant value greater than 5 cm/s as mag_pgrid nan's out <5\.  For tilt and compass, enter 0
        asnum=[1:1:500];
        aTx=0*ones(size(asnum'));
        aTy=aTx;
        aHx=aTx;
        aHy=aTx;
        aHz=aTx;
        Vab=BADVAL*ones(size(asnum'));
        Vcd=BADVAL*ones(size(asnum'));
        Vef=BADVAL*ones(size(asnum'));
        Vgh=BADVAL*ones(size(asnum'));
    end
    
    %load suna file if it exists
    if exist([rawdir slsh sfile,'.TXT'],'file')
        disp('loading SUNA file...')
        eval(['load ',rawdir slsh efile,'.TXT']);
        eng = eval(efile);
    end
    
    clear A* C* E* a0* c0* e0*
    
    SaveName = fullfile(matdir,sprintf('raw%4.4i.mat',stas(mm)));
    save(SaveName,'psdate','pedate','pstart','pstop','esnum','epres',...
                  'ecurr','evolt','edpdt','engtime','efluor',...
                  'efluorgain','eturb','eturbgain','csnum','ccond',...
                  'ctemp','cpres','cdox','asnum','Vab','Vcd','Vef',...
                  'Vgh','aTx','aTy','aHx','aHy','aHz');
%     eval(['save ',matdir,slsh,'raw',sprintf('%4.4i',stas(mm)),'.mat psdate pedate pstart pstop esnum epres ecurr evolt edpdt engtime efluor efluorgain eturb eturbgain csnum ccond ctemp cpres cdox asnum Vab Vcd Vef Vgh aTx aTy aHx aHy aHz'])
    
    
end	%looping on sets

prof_range_out = prof_range;
