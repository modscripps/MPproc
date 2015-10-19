function SWIMSgrid=MakeProcCTD_SWIMS(begtime,endtime,cruise,uniformgrid)
%function SWIMSgrid=MakeProcCTD_SWIMS(begtime,endtime,cruise,uniformgrid)
%Load in and process data given a start/end time and a cruise.
%If uniformgrid = 1 (0 default) data are interpolated onto a uniform,
%10-min grid.  This is helpful if SWIMS was not profiling when ADCP data is
%desired.
%
%MHA 03/04

if nargin < 4
    uniformgrid=0;
end

%Set index-fil paths, etc for the specified cruise
set_swims_paths

%Now load in data
disp 'loading data.'
SWIMSgrid = get_swims_data(begtime,endtime, fullfile(localindexdir,index_fileSWIMS), data_pathSWIMS,{},1);

if strcmp(cruise,'stf07')==1
%for stf07, load in ADCP data
adcpdatapath='/Users/malford/Sites/stf07/adcp';
load(fullfile(adcpdatapath, 'os150bb'))
ADCP.yday=data.dday;
ADCP.u=data.uabs_sm/100;
ADCP.v=data.vabs_sm/100;
ADCP.lat=data.lat;
ADCP.lon=data.lon;
ADCP.z=data.z;
ADCP.depth=data.z;

else
ADCP=get_adcp_data(begtime,endtime, fullfile(localindexdir,index_fileADCP), data_pathADCP,{},1);
end

%Turn the SWIMSgrid into a CTD structure.
SWIMSgrid=MakeCTD_SWIMS(SWIMSgrid,cruise);

if uniformgrid==1
    disp 'interpolating to a uniform grid.'
    SWIMSgrid=GridCTD_uniformtime(SWIMSgrid);
end
%Add ADCP data.  This is from our ADCP in this experiment - other
%experiments can specify other vel data in the ADCP structure.
disp 'adding velocity.'
SWIMSgrid=AddVelToCTD(SWIMSgrid,ADCP);
%Add a water-depth vector to the structure.
disp 'adding water depth.'
%SWIMSgrid=AddDepthToCTD(SWIMSgrid);
if strcmp(cruise,'stf07')
    SWIMSgrid.depth_knudsen=NaN*SWIMSgrid.yday;
else
SWIMSgrid=AddKnudsenDepthToSWIMSgrid(SWIMSgrid,cruise);
end
%Add N2.
disp 'adding N2'
SWIMSgrid=AddN2toCTD(SWIMSgrid);
%Need shear uz, vz, s2 and s2m.
%Also Ri.
%Also Greg-Henyey.  These are all in StandardProcessing for the MP
%(Fall03?)
disp 'adding isopyncal depth.'
%Compute isopycnal depths
SWIMSgrid=AddIsopycnalDepthToCTD(SWIMSgrid);

