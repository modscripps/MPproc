function [MP,MPOverturns,MPout,o]=AddMPoverturns(MP,PP)
%function MP=AddMPoverturns(MP,PP)
%Add overturn-inferred epsilon to a MP structure.
%Use the raw instead of the gridded profile data.
%MHA 5/2005
%
%2/06 change: only compute o if all four output arguments are needed - this
%is not needed to compute epsilon and is very time consuming.  This will
%also not plot anything.


disp 'Computing overturns'

if nargin < 2
    PP=DefaultPverturnPP_MPraw(MP);
end

MP=ProcessMPRawData(MP,PP);

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
    MP.eps(:,PP.wh(c))=nonmoninterp1(MPout.Z(:,c),MPout.eps(:,c),MP.z);
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
