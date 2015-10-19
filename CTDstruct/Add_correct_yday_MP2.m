function MP=Add_correct_yday_MP2(MP)
%function MP=Add_correct_yday_MP2(MP)
%
% Compute correct yearday matrix from the engineering pressure and time
% 
%KIM 03/07

MP.ydayc=NaN*MP.t;

%Find the engineering pressure
epres = MP.epres;
zero_p_i = find( MP.epres == 0 );
epres( zero_p_i )=nan;

% Find the electronic time
etime = MP.engtime;
etime( zero_p_i ) = nan;

% make the bins and binsum matrix (bins are centered about MP.p values)
z = [ 2* MP.p(1) - MP.p( 2 ) ; MP.p; 2*MP.p( end ) - MP.p( end-1 ) ];
z_bins =  ( z( 2:end ) + z( 1:end-1 ) )./ 2;


for c=1:length(MP.yday)-1
    if ~isnan(MP.yday(c)) %MHA change: don't do if no data
    % make the time and pressure vectors
    et = etime( :, c );
    ep = epres(:, c );
    binsum = MP.p*nan;
    
    % bin average the 
    [ N, bins ] = histc( ep, z_bins );
    bin_i = bins( find ( bins ) );
    et = et( find ( bins ) );
    binsum = accumarray( bin_i , et, [ length(binsum) , 1 ] );
    et_binned = binsum./ N( 1:end-1 ); % remove the last bin
    warning off
   
    % Now convert to yearday
    et_out = datevec( et_binned );
    % remove the nans
    not_nan_i = find( ~isnan( nanmean( et_out , 2 ) ) );
    
    MP.ydayc(not_nan_i, c ) = yearday(et_out( not_nan_i,3 )', et_out( not_nan_i, 2 )',...
        et_out( not_nan_i, 1 )', et_out( not_nan_i, 4 )', et_out( not_nan_i, 5 )', et_out( not_nan_i, 6 )' );
    
    clear et ep N bins bin_i binsum et_binned et_out non_nan_i
    end
end

% MHA addition 3/10: interpolate to remove nans
for c=1:length(MP.yday)
    MP.ydayc(:,c)=NANinterp(MP.ydayc(:,c),1); 
end
