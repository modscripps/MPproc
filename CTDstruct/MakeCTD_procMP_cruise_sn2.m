function MP = MakeCTD_procMP_cruise_sn2(cruise,sn,mooring,wh,get_eng,get_raw,get_raw_acm,get_nitrate)

% MP = MakeCTD_procMP_cruise_sn2(cruise,sn,mooring,wh,get_eng,get_raw,get_raw_acm,get_nitrate)
%
% Return a CTD object from processed MP data by calling MakeCTD_procMP.
% This routine just sets the paths and fills in the deployment information
% from MPdeploymentinfoFCN2.
% 1/05 MHA
% 6/06 change: add despiking if file is present
% 12/09: add ability to get raw acm data
% 12/11: _2 just changes the path for the new directory structures.
% 2/2012: added ability to return nitrate data if present.  Additionally,
% fluorometer and turbidity data are interpolated onto the MP pressure grid
% if they are present too.

% Set defaults
if nargin < 5
  get_eng = 1;
end
if nargin < 6
  get_raw = 0;
end
if nargin < 7
  get_raw_acm = 0;
end
if nargin < 8
  get_nitrate = 0;
end

info = MPdeploymentinfoFCN(sn,cruise,mooring);

if nargin < 4 || isempty(wh)
  wh=[1 info.n_profiles];
end

mpdatadir = MPbasedatadirFCN2(info);
matpath   = fullfile(mpdatadir, 'gridded/');


MP = MakeCTD_procMP(matpath,wh,1,get_eng,get_raw,get_raw_acm,get_nitrate); %Get an MP with engineering data
MP.info = info;
MP.H    = MP.info.H*ones(size(MP.yday));
MP.lat  = MP.info.lat*ones(size(MP.yday));
MP.lon  = MP.info.lon*ones(size(MP.yday));
MP.year = MP.info.year*ones(size(MP.yday));
MP.cruise = cruise;

%4/30/09 change: let z be the depth in m
MP.z = sw_dpth(MP.p,MP.info.lat);

%6/06 change: add despiking if present
MP = deSpike_gridded(MP);


%% Finally, interpolate nitrate onto MP pressure grid.  Repeat for other eng quantities.
if 1==0

if isfield(MP,'enitrate_umolperl')
    MP.nitrate_umolperl=nan*MP.s;
    
    for c=1:length(MP.yday)
        ig=find(~isnan(MP.epres_suna(:,c) + MP.enitrate_umolperl(:,c)));
        if length(ig) > 2
            MP.nitrate_umolperl(:,c)=nonmoninterp1(MP.epres_suna(ig,c),MP.enitrate_umolperl(ig,c),MP.p)
        end
    end
end

if isfield(MP,'efluor')
    MP.flu=nan*MP.s;
    
    for c=1:length(MP.yday)
        ig=find(~isnan(MP.epres(:,c) + MP.efluor(:,c)) & MP.epres(:,c) > 0);
        if length(ig) > 2
            MP.flu(:,c)=nonmoninterp1(MP.epres(ig,c),MP.efluor(ig,c),MP.p)
        end
    end
end

if isfield(MP,'eturb')
    MP.turb=nan*MP.s;
    
    for c=1:length(MP.yday)
        ig=find(~isnan(MP.epres(:,c) + MP.eturb(:,c)) & MP.epres(:,c) > 0);
        if length(ig) > 2
            MP.turb(:,c)=nonmoninterp1(MP.epres(ig,c),MP.eturb(ig,c),MP.p)
        end
    end
end

end
