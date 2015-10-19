function bf=barneyfilt(wrkspace,dz,rows,col)
% FUNCTION bf=barneyfilt(workspace,dz,rows,col)
%
% Filtering the barnes data into a digestable product since 2003!!
% Since the barnes data is so large, grids the data over depth bins that have a height of 
% dz.  The data is then put into an output CTD-format structure. 
%
% I would eventually like to figure out how to vectorize the loops....but
% it will take to long to do right now.

eval(['load ' wrkspace]);

% here i would would like to put in some code that can tell where the last
% row of data points are...filter out the all nan rows.

% make the z grid, the p is in decibars
z=p(1:rows,1:col);
zmax=max(max(z));    
zgrid=(0:dz:zmax)';
    
% define the input and corresponding output variables.
varsin={'t';'s';'th';'sgth';'con';'dox';'trans'};
varsout={'t';'s';'th';'sgth';'c';'dox';'trans'};

% loop for each variable
for i=1:length(varsin)
    [varin]=eval(varsin{i});
    varin=varin(1:rows,1:col);
    % neg values can stay in
    % need to take out any negative p values (p in decibars)
    %if varsin{i}==['p']
    %    for j=1:col
    %        for i=1:rows
    %            if barnes.p(i,j)<0
    %            barnes.p(i,j)=0;
    %            end
    %         end
    %     end 
    %end
    for n=1:col
        str=['barnes.' varsout{i} '(:,n)=nonmoninterp1(z(:,n),varin(:,n),zgrid);'];
        eval(str); 
    end
    
end


% other output variables that do not need to be averaged
barnes.z=zgrid;
barnes.p=barnes.z/100; %p in bars
barnes.n2=[];
barnes.lat=lat(1,1:col);
barnes.long=lon(1,1:col);
barnes.yday=yday(1,1:col);
barnes.year=year(1,1:col);

assignin('caller','barnes',barnes);

