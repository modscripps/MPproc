function CTDgrid=GridCTD_uniformtime(CTD,ydaynew,THRESH,method)
%function CTDgrid=GridCTD_uniformtime(CTD,ydaynew,THRESH,method)
%Given a non-uniformly sampled CTD series, re-sample it at evenly spaced
%intervals.  NaN's are placed where there is no data within THRESH of that
%time.  'method' is that used in the interpolation.
%
%2/04
%MHA

%Now go through and interpolate onto a uniform grid
if nargin < 4
    method='nearest';
end

if nargin < 3
    THRESH=20 / 60 / 24;  %  20 min
end

if nargin < 2
    dt=mean(diff(CTD.yday));
    ydaynew=min(CTD.yday):dt:max(CTD.yday);
end

%if only a scalar is specified, make a vector with that spacing
if length(ydaynew) ==1
    dt=ydaynew;
    ydaynew=min(CTD.yday):dt:max(CTD.yday);
end

for c=1:length(ydaynew)
    DisplayProgress(c,100)
    %determine the number of data points that are withing a certain time of this point
    good(c)=length(find( abs( CTD.yday - ydaynew(c)) < THRESH));
end
bad=find(good==0);

disp 'interpolating...'

%Now we go through and for each field, excepting yday, we interpolate onto
%the uniform grid.
CTDgrid.yday=ydaynew;
CTDgrid.z=CTD.z;
fields=fieldnames(CTD);
for c=1:length(fields)
    varstr=fields{c};
    disp(['Working on ''' varstr ''': ' num2str(c) ' out of ' num2str(length(fields)) ' vars.'])
    eval(['[m,n]=size(CTD.' varstr ');'])
    if  n==length(CTD.yday) & m==length(CTD.z) %It's 2-D time series
        disp '   2-D time series... interpolating.'
        eval(['CTDgrid.' varstr '=interp2(CTD.yday,CTD.z,CTD.' varstr ',CTDgrid.yday,CTD.z,method);'])
        eval(['CTDgrid.' varstr '(:,bad)=NaN;'])
    elseif n==length(CTD.yday) & m==1  %it's 1-D time series
        if strcmp(varstr,'yday')==0
            disp '   1-D time series... interpolating.'
            eval(['CTDgrid.' varstr '=interp1(CTD.yday,CTD.' varstr ',CTDgrid.yday,method);'])
            eval(['CTDgrid.' varstr '(bad)=NaN;']) %there is something wrong w/ this line
        end
    elseif  n==length(CTD.yday) & m~=length(CTD.z) & m > 1 %It's 2-D time series of a different size
        disp '   2-D time series with size ~= CTD.z... interpolating.'
        %        eval(['CTDgrid.' varstr '=interp2(CTD.yday,CTD.z,CTD.' varstr ',CTDgrid.yday,CTD.z,method);'])
        for c=1:m
            eval(['CTDgrid.' varstr '(c,:)=interp1(CTD.yday,CTD.' varstr '(c,:),CTDgrid.yday,method);'])
            eval(['CTDgrid.' varstr '(c,bad)=NaN;'])
        end
    else        %we don't know what to do with it; just copy
        disp '   Size doesnt match... copying.'
        eval(['CTDgrid.' varstr '=CTD.' varstr ';'])

    end
end

% for c=1:length(fields)
%     varstr=fields{c};
%     eval(['[m,n]=size(CTD.' varstr ');'])
%     if  n==length(CTD.yday) & m==length(CTD.z) %It's 2-D time series
% %        eval(['CTDgrid.' varstr '=interp2(CTD.yday,CTD.z,CTD.' varstr ',CTDgrid.yday,CTD.z,method);'])
%         eval(['CTDgrid.' varstr '(:,bad)=NaN;'])
%     elseif n==length(CTD.yday) & m==1  %it's 1-D time series
% %        eval(['CTDgrid.' varstr '=interp1(CTD.yday,CTD.' varstr ',CTDgrid.yday,method);'])
%         eval(['CTDgrid.' varstr '(bad)=NaN;']) %there is something wrong w/ this line
%     else        %don't know what to do with it; just copy
% %        eval(['CTDgrid.' varstr '=CTD.' varstr ';'])
%
%     end
% end
%
% %Now repair the yday field
% CTDgrid.yday=ydaynew;
