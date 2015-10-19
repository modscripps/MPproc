function MP=Add_correct_yday_MP(MP)
%function MP=Add_correct_yday_MP(MP)
%
% Compute correct yearday matrix assuming MP crawls at a constant rate
%MHA 06/06

MP.zmp=NaN*MP.t;
MP.ydayc=NaN*MP.t;

for c=1:length(MP.yday)-1
    imin=min(find(~isnan(MP.u(:,c))));
    imax=max(find(~isnan(MP.u(:,c))));

    zmin=MP.z(imin);
    zmax=MP.z(imax);
    if ~isempty(imin:imax)
    MP.ydayc(imin:imax,c)=MP.yday(c)+(0:(imax-imin))/(imax-imin+1)*(MP.yday(c+1)-MP.yday(c));
    %     if rem(c,2)==0 %even; down
    %     MP.zmp(imin:imax,c)=zmin+(0:(imax-imin))/(imax-imin+1)*(zmax-zmin);
    %     else
    %     MP.zmp(imin:imax,c)=zmax-(0:(imax-imin))/(imax-imin+1)*(zmax-zmin);
    %     end
    MP.zmp(imin:imax,c)=zmin+(0:(imax-imin))/(imax-imin+1)*(zmax-zmin);
    if rem(c,2)==0
        %        MP.ydayc(:,c)=flipud(MP.ydayc(:,c)); fix a bug
        MP.ydayc(imin:imax,c)=flipud(MP.ydayc(imin:imax,c));
    end
    end
end
