function MP = deSpike_gridded( MP )
%function MP = deSpike_gridded(MP)
%   We have picked out some spikes by hand.
%   saved in 'spike' of each mooring profile
%   This function loads in the data file and
%   sets the spike data as nan;
%   update @ Jun. 3, 2006
%   MHA 06/11/12: several bugs fixed (use of k in nested loops, fixed bug that only updated the first profile). 
%   This routine takes the spikes found in the spikes file and applies them
%   to not only the raw data but also the gridded data.  In this way,
%   the despike files can be applied to the gridded data without regridding
%   them.

%read out MP info
cruise = MP.info.cruise;
sn = MP.info.sn;
file_spk = [cruise '_' sn '_spike.mat'];
%run the base path

%basepath = MPbasedatadirFCN;
%bsc 11-19-13 fix
basepath=MP_basedatadir(MP.info);

%check if exist the spike's datafile
if ~exist( fullfile(basepath,'spike', file_spk), 'file')
    disp('Not find datafile of spikes, please make sure!' )
    return
end

%load date file of spikes
load(fullfile(basepath,'spike', file_spk));
eval(['spk_record  = ' cruise '_' sn '_spike;']);

%loop to set spikes as NaN
for k = 1:length( MP.id ) 
    if isfield( spk_record, ['Cast' num2str(MP.id(k))] )
        disp( ['using despike_gridded on Cast ' num2str(MP.id(k))] )
        eval( ['T = spk_record.Cast' num2str(MP.id(k)) '.T;'])
        eval( ['C = spk_record.Cast' num2str(MP.id(k)) '.C;'])

        if ~isempty(T)
            for d = 1 : size( T, 2) %ZZ was cycling through k in both loops! change to d here.
%                MP.tr( T(1,k):T(2,k), 1) = NaN;
                %check and make sure we are in range; mHA 4/07
                
                if T(2,d) > size(MP.tr,1)
                    T(2,d)=size(MP.tr,1);
                end
                MP.tr( T(1,d):T(2,d), k) = NaN; %MHA: fix ZZ's bug that always edits the 1st
                %Find the bad region in the gridded data too. If either of the
                %specified scans are NaN, then we know we just set the
                %limits for the whole profile with AddSpike.m; so set the
                %pressure limits manually here for NaN'ing out the gridded
                %data.  4/7 mha
%                 ib=find(MP.p >= min(MP.pr(T(:,d),k)) & MP.p <= max(MP.pr(T(:,d),k))); 
                 if isnan(MP.pr(T(1,d),k)) || isnan(MP.pr(T(2,d),k))
                     pmin=0;pmax=10000;
                 else
                 pmin=min(MP.pr(T(:,d),k));
                 pmax=max(MP.pr(T(:,d),k));
                 end
                 
                 ib=find(MP.p >= pmin & MP.p <= pmax); 
                MP.t(ib, k) = NaN; 
            end
        end

        if ~isempty(C)
            for d = 1 : size( C, 2)
%                MP.cr( C(1,k):C(2,k), 1) = NaN;
                %check and make sure we are in range; mHA 4/07
                if C(2,d) > size(MP.cr,1)
                    C(2,d)=size(MP.cr,1);
                end
                MP.cr( C(1,d):C(2,d), k) = NaN; %MHA: fix ZZ's bug that always edits the 1st
                %Find the bad region in the gridded data too.
 %               ib=find(MP.p > MP.pr(C(1,d),MP.id(k)) & MP.p < MP.pr(C(2,d),MP.id(k))); 
%                ib=find(MP.p >= min(MP.pr(C(:,d),k)) & MP.p <= max(MP.pr(C(:,d),k))); 
                 if isnan(MP.pr(C(1,d),k)) || isnan(MP.pr(C(2,d),k))
                     pmin=0;pmax=10000;
                 else
                 pmin=min(MP.pr(C(:,d),k));
                 pmax=max(MP.pr(C(:,d),k));
                 end
                 
                 ib=find(MP.p >= pmin & MP.p <= pmax); 
                MP.s(ib, k) = NaN; 
                MP.sgth(ib, k) = NaN; 
                MP.th(ib, k) = NaN; 
            end
        end
    end
end