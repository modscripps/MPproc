function [H_cont,axcb] = swims_LatLonDotPlot(CTDdata,infile);
% Usage: [data_lim] = CTD_LatLonDotPlot(CTD, infile);
% Modified from Mike's swims_LatLonDotPlot function to work on CTD
% structures.
%Several differences: no new window is created.  Second, the user can
%specify colorbar properties, 'vert','horiz' or 'none', and its position.
%Third, the handles to the axes are returned.
%MHA, 2/04
%
%
% Required fields of infile
%   cruise: String cruise name, e.g. 'ml04';
%   group: Integer data group number, e.g. 4;
%   vars: String names of CTDdata variables, within a cell if more than
%       one, e.g. {'t1', 's1'}.
%   fetch: A structure with fields defining how data are selected, usually
%       by pressure or depth
%       var: any variable returned by get_swims_data.  'p_ctd' or
%           'z_ctd' are usually used, but 'sgth1' and other variables can
%           usually be used.
%       lb: Number giving the lower bound of the fetch variable, e.g. 0.1
%       ub: Number giving the upper bound of the fetch variable, e.g. 0.3
%   operation: A string that may be 'avg', 'max', 'min'.  This operation
%           will be performed for every profile on all data returned by fetch.
%           For instance,for 'avg' the specified region in each profile
%           is averaged, and the plot shows the variability of the profile
%           averages.
%
% Optional fields of infile
%   plot_lim: A 2-element vector on n x 2 array with lower and upper plot
%       limits.
%   contours: A structure with fields
%       draw: 'y' or something else (required if contours is a field of infile)
%       levels: A vector with the data levels to be contoured,
%           e.g. [12:.05:12.5];
%       n_levels: An integer with the number of contours to draw between
%           data_max and data_min.  If 'levels' is also specified,
%           it will override n_levels.  If the length of vars > the number
%           of rows of n_levels, the last row of n_level will be replicated for
%           the rest of the variables.
% Output:
%   data_lim: An n x 2 array of max and min data values for each profile,
%       where n is the number of plots.
% Function: Plots swims data characteristics as colored dots on a lat-lon
% grid.  Intervals in profiles can be specified by limits on any of the
% CTDdata returned by swims, but most often pressure or depth limits are
% used.
% mgregg, 1mar04

if nargin < 2
    infile.cruise = 'ml04';
    infile.group = 27;
    infile.vars = {'t'};
    infile.operation = 'avg';
    infile.plot_lim = [16 19.5];
    infile.fetch.var = 'z_ctd';
    infile.fetch.lb = 15;
    infile.fetch.ub = 40;
    infile.contours.draw = 'y';
    %infile.cborientation='vert';
    %infile.cbposition=[.8 .4 .03 .2];
    infile.cborientation='horiz';
    infile.cbposition=[.4 .08 .2 .02];
    infile.plotvel=1;
    infile.ax=[]; %specify either a valid axes or [] to create a new one.
    infile.dlon=0.005;
    infile.dlat=0.005;
    infile.gridvel=0;
    infile.dotsize=8;
    infile.ur=0.5;
end

N_CONTOUR_LEVELS = 10;

%%%%%%%%%%%%%%%%%%%%%%%%% Check required fields of infile %%%%%%%%%%%%%%%%%%%%%%%%%
% Check for field cruise
if ~isfield(infile, 'cruise')
    error(['infile must have field ''cruise'''])
else
    if isempty(infile.cruise)
        error(['infile.cruise is empty'])
    else
        cruise = infile.cruise;
    end
end

% Check for field group
if ~isfield(infile, 'group')
    error(['infile must have field ''group'''])
else
    if isempty(infile.group)
        error(['infile.group is empty'])
    else
        if length(infile.group) > 1
            display('contour_swims_group_var: Only the first group will be plotted.')
        end
        i_gr = infile.group(1);
    end
end

% Check for field vars
if ~isfield(infile, 'vars')
    error(['infile must have field ''vars'''])
else
    if isempty(infile.vars)
        error(['infile.group is empty'])
    else
        vars = infile.vars;
    end
end

% Check for field plot_lim and write it as a variable in the workspace.
% If it exists and has fewer rows than the
% length of infile.vars, replicate the last plot_lim so plot_lim has a row
% for every variable.
if isfield(infile, 'plot_lim')
    if isempty(infile.plot_lim)
        error('infile.plot_lim exists but is empty')
    else
        [n_row, n_col] = size(infile.plot_lim);

        if n_row < length(infile.vars)
            plot_lim(1:n_row,:) = infile.plot_lim(1:n_row,:);
            for i = n_row+1:length(infile.vars)
                plot_lim(i,:) = infile.plot_lim(n_row,:);
            end
        else
            plot_lim = infile.plot_lim;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Check optional fields of infile %%%%%%%%%%%%%%%%%%%%%%
% Check field contours
if isfield(infile, 'contours')
    if isempty(infile.contours)
        error('infile.contours is optional, but it cannot be empty.')
    end
    if ~isfield(infile.contours, 'draw')
        error('If infile.contours is specified, it must have field ''draw''')
    end
    if isfield(infile.contours, 'levels')
        [n_row, n_col] = size(infile.contours.levels);
        if n_row < length(infile.vars)
            levels(1:n_row, :) = infile.contours.levels(1:n_row,:);
            for i = n_row+1:length(infile.vars)
                levels(i,:) = infile.contours.levels(n_row,:);
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cruise = infile.cruise;

%eval([cruise '_folders'])

% Load final cruise log and find index number for swims data
%eval(['load ' setstr(39) [cruise '_FinalCruiseLog.mat'] setstr(39)])
%eval(['load ' setstr(39) [cruise_logs filesep cruise '_FinalCruiseLog.mat'] setstr(39)])

% i_dat = 1;
% while ~strcmp(char(cr.data_names(i_dat)), 'swims')
%     i_dat = i_dat + 1;
% end
%
% % Load the full ctd data for the time of this group
% CTDdata = get_swims_data(cr.data(i_dat).group(i_gr).yday(1), ...
%     cr.data(i_dat).group(i_gr).yday(end), swims_griddata_indexfile, ...
%     swims_griddata_datapath, {});

% if strcmp(vars{1},'u')==1 | strcmp(vars{1},'v')==1 | strcmp(vars{2},'u')==1 | strcmp(vars{2},'v')==1
% ADCP=get_adcp_data(cr.data(i_dat).group(i_gr).yday(1), ...
%     cr.data(i_dat).group(i_gr).yday(end), adcp_indexfile,adcp_datapath,{},1);
%
% %Put vel onto the SWIMS grid
% CTDdata.u=interp2(ADCP.yday,ADCP.z_adcp,ADCP.u_wat,CTDdata.yday,CTDdata.z_ctd);
% CTDdata.v=interp2(ADCP.yday,ADCP.z_adcp,ADCP.v_wat,CTDdata.yday,CTDdata.z_ctd);
% end

% Set positions for plot and colorbar
pos_cont = [0.15 0.27 0.8 0.65];
pos_cbar = [0.15 0.12 0.8 0.05];

for i = 1:length(infile.vars)
    %figure
    %H_cbar = axes('position', pos_cbar);
    if ~isfield(infile,'ax')
        infile.ax=[];
    end
    if isempty(infile.ax)
        H_cont = axes('position', pos_cont);
    else
        axes(infile.ax)
        H_cont=gca;
    end

    % Find the row indices of the fetch variable
    eval(['i_fetch = find(CTDdata.' infile.fetch.var '>= ' num2str(infile.fetch.lb) ...
        ' & CTDdata.' infile.fetch.var ' <= ' num2str(infile.fetch.ub) ');']);

    % Compute the data limits, i.e. max and min when the operation is performed on each
    % profile
    switch infile.operation
        case 'avg'
            eval(['data = nanmean(CTDdata.' infile.vars{i} '(i_fetch,:));'])
            if isfield(CTDdata,'u') & isfield(CTDdata,'v')
                eval(['um = nanmean(CTDdata.' 'u' '(i_fetch,:));'])
                eval(['vm = nanmean(CTDdata.' 'v' '(i_fetch,:));'])
            end
        case 'max'
            eval(['data = max(CTDdata.' infile.vars{i} '(i_fetch,:));'])
        case 'min'
            eval(['data = min(CTDdata.' infile.vars{i} '(i_fetch,:));'])
    end
    data_min = min(data);
    data_max = max(data);
    data_lim(i,:) = [data_min data_max];

    % Set the colormap and color axis
    cmp = jet(256);
    if ~isfield(infile,'plot_lim')
        plot_lim(i,:) = data_lim(i,:);
    else
        plotlim(i,:)=infile.plot_lim;
    end

    caxis(plot_lim(i,:));
    colormap(cmp);

    % Plot the data as dots filled with color that is proportional to their
    % value
    scatter(CTDdata.lon, CTDdata.lat, infile.dotsize, data, 'filled')
    hold on
    if isfield(CTDdata,'u') & isfield(CTDdata,'v') & infile.plotvel==1
        %quiver(lon_adcp, lat_adcp, u_mean, v_mean)
        %Now make a reference arrow by adding a known value to the end of
        %the list to be plotted with quiver - plot it at upper right
        %        quiver(CTDdata.lon, CTDdata.lat,um,vm)
        %ur=0.5;
        if         infile.gridvel == 0
         lims=axis;
        latr=lims(3)+0.9*(lims(4)-lims(3));
        lonr=lims(1)+0.6*(lims(2)-lims(1));
        tbr(lonr,latr,[num2str(infile.ur) ' m/s'])
           quiver([CTDdata.lon lonr], [CTDdata.lat latr],[um infile.ur],[vm 0])
        else
            len_grid = 30;
            lon_min = min(CTDdata.lon); lon_max = max(CTDdata.lon);
            lon = ones(len_grid+1,1)*(lon_min:(lon_max-lon_min)/len_grid:lon_max);
            lat_min = min(CTDdata.lat); lat_max = max(CTDdata.lat);
            lat = (lat_min:(lat_max-lat_min)/len_grid:lat_max)'*ones(1,len_grid+1);

            % Run griddata
            indg=find(~isnan(um) & ~isnan(vm) & ~isnan(CTDdata.lon) & ~isnan(CTDdata.lat));
%            udata = griddata(CTDdata.lon, CTDdata.lat, um, lon, lat);
%            vdata = griddata(CTDdata.lon, CTDdata.lat, vm, lon, lat);
            udata = griddata(CTDdata.lon(indg), CTDdata.lat(indg), um(indg), lon, lat);
            vdata = griddata(CTDdata.lon(indg), CTDdata.lat(indg), vm(indg), lon, lat);
            wh=5;
            udata(end,wh)=infile.ur;
            vdata(end,wh)=0;
            tbr(lon(end,wh),lat(end,wh),[num2str(infile.ur) ' m/s'])

            quiver(lon, lat,udata,vdata)
        end

    end

    set(gca, 'dataaspectratio',[1 cos(pi*nanmean(CTDdata.lat)/180) 1], ...
        'fontsize', 12, 'box', 'on')
    Hyl=ylabel('Latitude'); Hxl=xlabel('Longitude');
    set([Hxl Hyl], 'fontsize', 12)
    caxis(plot_lim(i,:));

    if isfield(infile, 'contours')
        if strcmp(infile.contours.draw, 'y')
            % Setup lat & lon grids as input to griddata
            len_grid = 30;
            lon_min = min(CTDdata.lon); lon_max = max(CTDdata.lon);
            lon = ones(len_grid+1,1)*(lon_min:(lon_max-lon_min)/len_grid:lon_max);
            lat_min = min(CTDdata.lat); lat_max = max(CTDdata.lat);
            lat = (lat_min:(lat_max-lat_min)/len_grid:lat_max)'*ones(1,len_grid+1);

            % Run griddata
%            indg=find(~isnan(data));
            indg=find(~isnan(data) & ~isnan(CTDdata.lon) & ~isnan(CTDdata.lat));

            gdata = griddata(CTDdata.lon(indg), CTDdata.lat(indg), data(indg), lon, lat);

            % Determine the data values to contour
            if isfield(infile.contours, 'n_levels')
                n_levels = infile.contours.n_levels;
            else
                n_levels = N_CONTOUR_LEVELS;
            end
            if isfield(infile.contours, 'levels')
                V = infile.contours.levels;
            else
                V = data_min:(data_max-data_min)/(n_levels-1):data_max;
            end

            [C,H]=contour(lon, lat, gdata, V);
            set(H(:),'linewidth',2)
        end
    end

    title([infile.cruise, ', group: ' int2str(infile.group) ...
        ', data: ' infile.vars{i} ' ' infile.operation ' ' num2str(infile.fetch.lb) '-' num2str(infile.fetch.ub)])


    axis([lon_min-infile.dlon lon_max+infile.dlon lat_min-infile.dlat lat_max+infile.dlat])

    % Label the xaxis of the color bar to match vars{i}
    switch infile.vars{i}
        case {'t1', 't2','t'}
            labstr='Temperature / {}^oC';
        case {'s1', 's2','s'}
            labstr='Salinity / ppt';
        case {'sgth', 'sgth2','sgth'}
            labstr='\sigma_{\theta} / kg\ m^{-3}';
        case {'u', 'v'}
            labstr='vel / m / s';
        case {'d_Iso', 'eta'}
            labstr='\eta / m';
        case {'le'}
            labstr='log_{10} \epsilon / Wkg^{-1}';
        case {'lk'}
            labstr='log_{10} K_\rho / m^2s^{-1}';
    end
    if strcmp(infile.cborientation,'none')==0
        axcb=mycolorbar2(plot_lim(i,:),labstr,infile.cborientation,infile.cbposition)
    else
        axcb=[];
    end
end