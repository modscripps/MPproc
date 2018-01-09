function PP=DefaultOverturnPP_MP(MP);
%function PP=DefaultOverturnPP_MP(MP);
%Default overturn params for Moored Profiler, using gridded data.
%7/05 MHA

%Return a list of default parameters for a Thorpe Scale calculation.
    PP=DefaultOverturnPP;
    
    %Adjust for MP
    PP.tvar='t';
    PP.svar='s'; %use the filtered salinity from the lagged cond
    PP.cvar='';
    PP.sgthvar='sgth'; %leave empty to compute it.
    PP.pvar='p';
    PP.drho=2e-4;
    PP.gridded='yes'; %yes if one pressure vector corresponds to all drops in structure
    PP.sortvar='dens'; %specify 'dens' to use density.
    
    PP.wh=1:length(MP.yday);
    PP.threshold=0.01;
    PP.zmin=min(MP.z);
    PP.zmax=max(MP.z);
    
    PP.CUTOFF=0;
    PP.THRESH_GK=1e20;
    PP.n=2;
    PP.THRESH_t=0.5; %require that temperature invert too
