function [MP,MPOverturns,MPout,o]=AddMPoverturns_raw2(MP,PP)
%function MP=AddMPoverturns_raw2(MP,PP)
%Add overturn-inferred epsilon to a MP structure.
%Use the raw instead of the gridded profile data.
%MHA 5/2005
%
%2/06 change: only compute o if all four output arguments are needed - this
%is not needed to compute epsilon and is very time consuming.  This will
%also not plot anything.
%
%5/06 change: Use the new ProcessMPrawdata2 function which should produce
%better densities.
%
%3/2010 change: MHA: overturns are computed on pressure, which is
%confusingly called Z by the overturn routines, so these were interpolated onto MPeps.z.  We now do the
%interpolation correctly by interpolating onto MPeps.p.

disp 'Computing overturns'

if nargin < 2
    PP=DefaultOverturnPP_MPraw(MP);
end

MP=ProcessMPRawData2(MP,PP);

%Now do the overturn calculation
disp '   finding overturns'

[MPOverturns,MPout]=FindOverturnsFCN2(MP,PP);
%[MPOverturns, MPout]=EpsFromOverturns2(MPOverturns, MPout);
[MPOverturns, MPout,Keepers]=EpsFromOverturns2(MPOverturns, MPout);

if nargout > 1
    disp '   extracting structure... this can take a while.'
    %Compute the structure
    o=ExtractStructureData(MPOverturns);
    disp '   interpolating'
end

%Interpolate these onto the grid
MP.eps=zeros(length(MP.z),length(MP.yday))*NaN;

for c=1:length(PP.wh)
    DisplayProgress(c,100);
    %Now get the high-res overturns
%    MP.eps(:,c)=nonmoninterp1(MPout.Z(:,c),MPout.eps(:,c),MP.z); %bug fix: 4/06

%    MP.eps(:,PP.wh(c))=nonmoninterp1(MPout.Z(:,c),MPout.eps(:,c),MP.z);
%    %3/27/2010- fix mistake: MPout Z field is pressure, not depth.  So
%    interpolate onto pressure for MP - not depth. Last line is the old
%    code, following line is the fix.
    MP.eps(:,PP.wh(c))=nonmoninterp1(MPout.Z(:,c),MPout.eps(:,c),MP.p);
end

n2mat=MP.n2m*ones(size(MP.yday));
MP.k = 0.2* MP.eps ./ n2mat;

%1-day averages
[MP.epsavg,MP.ydayavg]=SimpleBoxCar(MP.eps,1,MP.yday);
[MP.kavg,MP.ydayavg]=SimpleBoxCar(MP.k,1,MP.yday);

if nargout > 1
    PP.plotit=1;

    if PP.plotit==1
        figure(1)
        OverturnDiagnostic1(o,1);
        figure(2)
        PlotP.wh=1:length(PP.wh);%PP.wh;
        PlotP.zmin=0;
        PlotP.zmax=max(MPout.Z(:,1));
        PlotP.plotcoast=1;
        PlotP.plotk=0;
        PlotP.plotThT=0;

        ax=ProfileOverturnPlot2(MPout,MPOverturns,PlotP,o);

    end

end
