function CTD=MakeCTD_Levitus(lat,lon,H,whichLev,plotit,quiet);
%function CTD=MakeCTD_Levitus(lat,lon,whichLev,plotit);
%Return a CTD structure containing climatological T, S data from the
%Levitus database at the specified location.
%
%In the case of 1994, Nitrate is returned as well.
%In the case of 2001, Levitus N is returned as well.
%
%MHA 03/04
%
%MHA 06/06: changed to allow specification of water depth.  Calling inputs
%changed since H is inserted third.  Smith/Sand is only used if H is not
%passed in.

if nargin < 6
    quiet=0;
end

if nargin < 5
    plotit=0;
end

if nargin < 4
    whichLev='2001';
end

%CUTOFF values for good data
TCUT=-2;
SCUT=10;

if quiet == 1
    warning off
end

%'c', 'T', 'S', or 'N'
if strcmp(whichLev,'1994')==1
    if length(lat) > 1 | length(lon) > 1
        error('1994 only supported for sinlge locations.  Sorry - use 2001 database.')
    end

    disp 'Getting Levitus 1994 profiles...'
    [depthWOA,TWOA,SWOA,NO3WOA]=GetWOAProfiles(lat,lon);

    %Screen for bad vals
    TWOA(find(TWOA < TCUT))=NaN;
    SWOA(find(SWOA < SCUT))=NaN;

    if ~exist('H')
        disp 'Getting water depth...'
        H=SmithSandwellDepthFCN(lat,lon);
    end

    disp 'Making CTD structure...'
    year=1994*ones(size(H));
    yday=ones(size(H));
    CTD=MakeCTD(TWOA,SWOA,depthWOA,lat,lon,H,year,yday,'Levitus94');

    %Store NO3 too
    CTD.NO3=NO3WOA;

elseif strcmp(whichLev,'2001')==1
    disp 'Getting Levitus 2001 profiles...'

    warning off MATLAB:break_outside_of_loop
    [TWOA,depthWOA]=getlev(lat,lon,'T');
    [SWOA,depthWOA]=getlev(lat,lon,'S');
    [N_WOA,depthWOA]=getlev(lat,lon,'N');
    depthWOA=depthWOA';

    %Now remove the temporary file the routines create
    disp 'removing templev.ssp...'

    delete templev.ssp

    warning on MATLAB:break_outside_of_loop

    %Screen for bad vals
    TWOA(find(TWOA < TCUT))=NaN;
    SWOA(find(SWOA < SCUT))=NaN;
    if ~exist('H')
        disp 'Getting water depth...'
        H=SmithSandwellDepthFCN(lat,lon,0.5,'max');
    end
    disp 'Making CTD structure...'
    %CTD=MakeCTD(TWOA,SWOA,depthWOA,lat,lon,H,NaN,NaN,'Levitus2001');
    year=2001*ones(size(H));
    yday=ones(size(H));
    CTD=MakeCTD(TWOA,SWOA,depthWOA,lat,lon,H,year,yday,'Levitus2001');

    isea=find(CTD.H > 0);
    iland=find(CTD.H < 0);

    %Store N too
    CTD.n2_WOA=(N_WOA*2*pi/3600).^2;
    CTD.n2m_WOA=nanmean(CTD.n2_WOA(:,isea)')';

    for c=1:length(CTD.H)
        ib=find(CTD.z > CTD.H(c));
        CTD.t(ib,c)=NaN;
        CTD.s(ib,c)=NaN;
        CTD.th(ib,c)=NaN;
        CTD.sgth(ib,c)=NaN;
        CTD.n2(ib,c)=NaN;
        CTD.n2_WOA(ib,c)=NaN;
    end

    %     CTD.t(:,iland)=NaN;
    %     CTD.th(:,iland)=NaN;
    %     CTD.s(:,iland)=NaN;
    %     CTD.sgth(:,iland)=NaN;
    %     CTD.n2(:,iland)=NaN;
    %     CTD.s(:,iland)=NaN;

else
    error('Unsupported Levitus set.')
end

grid=1;
MLD=0;

disp 'interpolating to the denser grid...'
if grid==1
    %Now interpolate onto the denser grid that goes all the way to the bottom
    dz=2; %changed from 10
    z1=CTD.z; %The uneven values
    CTD.z=(0:dz:max(H))'; %The new values

    %Put T, S onto the new grid
    CTD.t=interp1(z1,CTD.t,CTD.z);
    CTD.p=interp1(z1,CTD.p,CTD.z);
    CTD.s=interp1(z1,CTD.s,CTD.z);
    CTD.th=interp1(z1,CTD.th,CTD.z);
    CTD.sgth=interp1(z1,CTD.sgth,CTD.z);

end

%Now, the WOA n2 values at times increase near the bottom which I do not
%think is real.  Take out values of N2 that are increasing with depth below
%the minimum.
if isfield(CTD,'n2_WOA')
    for c=1:length(CTD.lat)
        ideep=find(z1 > 500);
        minval=min(CTD.n2_WOA(ideep,c)); %The min N2 value deeper than 500 m
        imin=find(CTD.n2_WOA(:,c) == minval); %Find this value
        if imin ~= max(find(~isnan(CTD.n2_WOA(:,c))) ) %if there are values deeper than this, NaN them.
            CTD.n2_WOA(imin+1:end,c)=NaN;
            if quiet==0
                disp(['WARNING: NaNing increasing N2_WOA values deeper than depth ' num2str(z1(imin)) ' m.'])
            end
        end
    end
    %    for c=1:length(CTD.lat)
    %        CTD.n2_spl(:,c)=spline(z1,CTD.n2_WOA(:,c),CTD.z);
    %    end
    CTD.n2_WOA=interp1(z1,CTD.n2_WOA,CTD.z);
end

CTD.n2=NaN*CTD.t;
for d=1:length(isea)
    c=isea(d);
    ind=find(CTD.t(:,c)>TCUT & ~isnan(CTD.t(:,c)) & ~isnan(CTD.s(:,c)));
    dp=1.1*dz;%smoothing interval in MPa.  This needs to be greater than the sampl,e interval, even if only by 1%.
    %dp=1;
    DATAMIN=10;
    if length(ind)> DATAMIN
        %[n2,pout,dthetadz,dsdz]=nsqfcn(CTD.s(ind,c)/1000,CTD.t(ind,c),CTD.z(ind)/100,dp,dp);
        [n2,pout,dthetadz,dsdz]=nsqfcn(CTD.s(ind,c),CTD.t(ind,c),CTD.z(ind),dp,dp);
        if ~isempty(find(n2<0))
            if quiet ==0
                disp 'WARNING: N^2 profile has negative values!!'
            end
            n2(find(n2<0))=0;
        end
        %plot(n2,pout);axis ij
        %Now interp back onto the z grid
        N=interp1(pout,sqrt(n2),CTD.z);

        %Get rid of Nans at top
        i1=min(find(~isnan(N)));
        if ~isempty(i1)
            N(1:i1-1)=0;
        end
        %Now put on a ML
        i1=min(find(CTD.z>MLD));
        if ~isempty(i1)
            N(1:i1-1)=0;
        end

        %Now extend N to the bottom
        i1=max(find(~isnan(N)));
        if ~isempty(i1)
            N(i1+1:length(CTD.z))=N(i1);
        end


        CTD.n2(:,c)=N.^2;
    else %not enough good data
        CTD.n2(:,c)=NaN*CTD.t(:,c);
        %CTD.n2m=NaN;
    end

end

%end
if length(CTD.H)>1
    CTD.n2m=nanmean(CTD.n2(:,isea)')';
else
    CTD.n2m=CTD.n2; %We know it is only one profile so it is its own mean
end

disp 'done.'

%Plot if requested
if plotit==1
    PlotCTD(CTD);
end
