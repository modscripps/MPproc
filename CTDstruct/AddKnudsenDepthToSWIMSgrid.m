function SWIMSgrid=AddKnudsenDepth(SWIMSgrid,cruise);
%Take a SWIMSgrid structure and load the depth from the Knudsen sounder, stored in KVH,
%and interpolate it onto the SWIMSgrid timebase after smoothing a bit.  Recall the PCtimestamp
%is used so there can be up to 10 secs or so offsets.

%cruise='aeg04';

set_swims_paths

ydaystart=min(SWIMSgrid.yday);
ydayend=max(SWIMSgrid.yday);

KVH=get_KVHmisc_data(ydaystart, ydayend, fullfile(localindexdir,index_fileKVH), data_pathKVH, 1);
%Now interpolate on to the SWIMS grid
depthfilt=medfilt1(KVH.bot_depth,5);
depthfilt=CenteredConv(depthfilt,30,1);
%plot(KVH.PCtimestamp,KVH.bot_depth,KVH.PCtimestamp,depthfilt)
SWIMSgrid.H=nonmoninterp1(KVH.PCtimestamp,depthfilt,SWIMSgrid.yday);

