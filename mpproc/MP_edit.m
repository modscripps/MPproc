function x = MP_edit(xbounds,npts,x)

% x = MP_edit(xbounds,npts,x)
%
%  x = input vector, xbounds is a 2-element vector holding the
%  min and max are allowable data values, 
%  npts==bin width for spike check  must be odd number
%  routine first checks for data out of range, then does a spike check
%  on the high pass series, interpolating over spikes it detects%
%
% 09/2015 GV output nans if no good data input

xmin = xbounds(1);
xmax = xbounds(2);

ibad  = find(x < xmin | x > xmax);
igood = find(x >=xmin & x <=xmax);

if ~isempty(igood)

if ~isempty(ibad)
  if ibad(1) == 1
    x(1)  = x(min(igood));
    ibad  = find(x<xmin | x>xmax);
    igood = find(x>=xmin & x<=xmax);
  end
end


if ~isempty(ibad)
  if(ibad(end) == length(x));
    x(end) = x(max(igood));
    ibad   = find(x<xmin | x>xmax);
    igood  = find(x>=xmin & x<=xmax);
  end
end


if ~isempty(ibad)
  for i = 1:length(ibad);
    ipast = find(igood<ibad(i));
    ifut  = find(igood>ibad(i));

    past    = x(igood(ipast));
    future  = x(igood(ifut));
    npast   = igood(ipast);
    nfuture = igood(ifut);

    beg = length(past)-npts+1;
    if(beg<1)
      beg = 1;
    end

    past = past(beg:end);
    npast = npast(beg:end);

    thend = npts;
    if(length(future)<npts);
      thend = length(future);
    end

    future  = future(1:thend);
    nfuture = nfuture(1:thend);

    xpast = median(past);
    xfut  = median(future);

    jpast = median(npast);
    jfut  = median(nfuture);

    x(ibad(i)) = ((xfut-xpast)/(jfut-jpast))*(ibad(i)-jpast) + xpast;
  end
end


[b,a] = mybutter(2,.05,2);
lowp = myfiltfilt(b,a,x)'; 
highp = x-lowp;   
highp = MP_clean(highp,npts);

x = lowp+highp;

else
  x = nan(1,length(x));
end
