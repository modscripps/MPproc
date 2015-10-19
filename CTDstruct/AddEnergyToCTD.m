function CTD=AddEnergyToCTD(CTD,tsm);
%Compute kinetic energy KE=1/2*rho*(u^2+v^2) and 
%potential energy PE=1/2*rho*N^2*eta^2.
%
%We require the fields sgth, n2, etaEUL, ubc and vbc
%Fields added: KE and PE in J/m^3 and KEint and PEint in J/m^2
%

if nargin < 2
    tsm=25;
end


%Now compute a mean density profile
if isfield(CTD,'sgth')
mdens=nanmean(CTD.sgth')';

rhoo=1000+nanmean(mdens);
else
    rhoo=1026;
end

%Not needed as of 1/11/04 since this is done in AddN2ToCTD
if ~isfield(CTD,'n2m')
    CTD.n2m=nanmean(CTD.n2')';
end

dz=mean(diff(CTD.z));

CTD.KE=1/2*rhoo.*(CTD.ubc.^2+CTD.vbc.^2);
CTD.PE=1/2*rhoo.*(CTD.n2m*ones(size(CTD.yday))).*CTD.etaEUL.^2;

%Put dz's in where the data are good.
%dzmKE=0*CTD.KE+dz;
%dzmPE=0*CTD.KE+dz;

%Wrong:
%CTD.KEint=nansum(CTD.KE).*(max(CTD.z)-min(CTD.z));
%CTD.PEint=nansum(CTD.PE).*(max(CTD.z)-min(CTD.z));

%right:
CTD.KEint=nansum(CTD.KE)*dz;
CTD.PEint=nansum(CTD.PE)*dz;
%If there are all NaN's, nansum returns 0 so remove them
CTD.KEint(find(CTD.KEint==0))=NaN;
CTD.PEint(find(CTD.PEint==0))=NaN;
if tsm > 0 & length(CTD.yday) > tsm %1/12/06: fixed a bug that caused smoothing when there was nothing to smooth
%if tsm > 0
    ind=find(~isnan(CTD.KEint));
    CTD.KEint(ind)=CenteredConv(CTD.KEint(ind),tsm,1);
    ind=find(~isnan(CTD.PEint));
    CTD.PEint(ind)=CenteredConv(CTD.PEint(ind),tsm,1);
end