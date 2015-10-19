function [MP,MPOverturns,MPout,o]=AddMPoverturns(MP,PP)
%function MP=AddMPoverturns(MP,PP)
%Add overturn-inferred epsilon to a MP structure.
%
%MHA 1/2004

disp 'Computing overturns'

if nargin < 2
    PP=DefaultOverturnPP_MP(MP);
end

%Now do the overturn calculation
disp '   finding overturns'

[MPOverturns,MPout]=FindOverturnsFCN2(MP,PP);
[MPOverturns, MPout]=EpsFromOverturns2(MPOverturns, MPout);
disp '   extracting structure... this can take a while.'

%Compute the structure - 4/06 change we only compute this if needed
%o=ExtractStructureData(MPOverturns);
%disp '   interpolating'

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
    %Now get the high-res overturns -- ** NOTE THIS IS ONLY VALID FOR
    %GRIDDED DATA - otherwise use MPout.Z(:,c)
%   old line: MP.eps(:,c)=nonmoninterp1(MPout.Z(:,1),MPout.eps(:,c),MP.z);
    %4/2010: fix an apparent bug wherein output are not stored in the right
    %location, and also fix the pressure/depth bug.
    MP.eps(:,PP.wh(c))=nonmoninterp1(MPout.Z(:,1),MPout.eps(:,c),MP.p);
end

n2mat=MP.n2m*ones(size(MP.yday));
MP.k = 0.2* MP.eps ./ n2mat;

%1-day averages
[MP.epsavg,MP.ydayavg]=SimpleBoxCar(MP.eps,1,MP.yday);

PP.plotit=1;

if PP.plotit==1 & nargout > 1
    figure(1)
    OverturnDiagnostic1(o,1);
    figure(2)
    PlotP.wh=1:10;%PP.wh;
    PlotP.zmin=0;
    PlotP.zmax=max(MPout.Z(:,1));
    PlotP.plotcoast=1;
    PlotP.plotk=0;
    PlotP.plotThT=0;
    
    ax=ProfileOverturnPlot2(MPout,MPOverturns,PlotP,o);    
    
end
