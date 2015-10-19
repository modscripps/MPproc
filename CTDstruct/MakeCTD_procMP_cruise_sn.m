function MP=MakeCTD_procMP_cruise_sn(cruise,sn,wh,get_eng,get_raw,get_raw_acm)
%function MP=MakeCTD_procMP_cruise_sn(cruise,sn,wh,get_eng,get_raw,get_raw_acm)
%Return a CTD object from processed MP data by calling MakeCTD_procMP.
%This routine just sets the paths and fills in the deployment information
%from MPdeploymentinfoFCN.
%1/05 MHA
%6/06 change: add despiking if file is present
%12/09: add ability to get raw acm data
%
%2/2012: added a warning message since this routine has ben replaced by the
%_2 version.

warning('This routine has been replaced by MakeCTD_procMP_cruise_sn2.m and is no longer supported.')

if nargin < 4 
    get_eng=1;
end
if nargin < 5 
    get_raw=0;
end
if nargin < 6 
    get_raw_acm=0;
end

info=MPdeploymentinfoFCN(sn,cruise);

if nargin < 3 | isempty(wh)
    wh=[1 info.n_profiles];
end

%mpdatadir='~malford/Data/MP/';
mpdatadir=MPbasedatadirFCN;

%matpath=[mpdatadir cruise '/sn'  sn '/gridded/'];
matpath=fullfile(mpdatadir, 'gridded/');

%MP=MakeCTD_procMP(matpath,1279);

MP=MakeCTD_procMP(matpath,wh,1,get_eng,get_raw,get_raw_acm); %Get an MP with engineering data
MP.info=info;
MP.H=MP.info.H*ones(size(MP.yday));
MP.lat=MP.info.lat*ones(size(MP.yday));
MP.lon=MP.info.lon*ones(size(MP.yday));
MP.year=MP.info.year*ones(size(MP.yday));
%MP.id=str2num(MP.info.sn)*ones(size(MP.yday)); %1/25/05 change: MP.id is
%now the profile number
MP.cruise=cruise;

%4/30/09 change: let z be the depth in m
MP.z=sw_dpth(MP.p,MP.info.lat);

%6/06 change: add despiking if present
MP=deSpike_gridded(MP);
