function MooringData=ModeFit2FCN(MooringData,FP)
%ModeFit1FCN.m
%10/05
%MHA
%
%Do a modal fit to velocity and displacement data in a CTD structure.  
%Please note several important changes from previous conventions in the ComputeFluxes function family.
%Now the BT mode for u is stored at the END of the matrix, so that
%multiplications are simpler.  Errors are stored for both u and eta at the
%end.
%
%
%We require a set of modes, defined over the whole water
%depth:
%
%The modes:
% MooringData.z_full
% MooringData.vert_full, hori_full
% MooringData.H should be the max value of z_full
%
%The data:
% MooringData.u, v, eta (if one or more are not present, the fit will be performed for what is present)
% MooringData.z : depths of the measurements

%Parameters:
%Need to specify: 
%FP.Nmd which is the number of displacement modes to solve for
%FP.wh - the profiles to do (default = do all)
%FP.plotit - 1 for plotting on.  Default = off.
%FP.reqperc - depth range is selected requiring < reqperc of points to be
%bad.  Default = 0.25
%
%Output: fields un, vn and dn are added to the structure, as is the param struct FP.
%The former three are the modal amplitudes for each profile.  un and vn are
%FP.Nmd+2 x length(yday), and contain the amplitude for each mode, followed
%by the barotropic amplitude, followed by the residual.  dn is 
%FP.Nmd+1 x length(yday), and is the same except it does not contain the BT
%amplitude (since it is meaningless).
%
%Modified 5/06 from ModeFit1fcn to handle weights. MHA

%%
if nargin < 2
    FP=struct;
end

if ~isfield(FP,'wh')
    FP.wh=1:length(MooringData.yday);
end

if ~isfield(FP,'Nmd')
    FP.Nmd=3; %# of modes to solve for.
end

if ~isfield(FP,'plotit')
    FP.plotit=1;
end

if ~isfield(FP,'reqperc')
    FP.reqperc=.25;
end

FP.plotsvd=1;

%% Select good data.
%We compute the number of bad points in the timeseries at each depth, and 
%choose the widest depth range that has fewer than (say) 5% of the record
%bad.
clear ubad dbad
for c=1:length(MooringData.z)
    ubad(c)=length(find(isnan(MooringData.u(c,:))));
    dbad(c)=length(find(isnan(MooringData.etaEUL(c,:))));
end

%FP.gooddepth=find(~isnan(MooringData.u(:,FP.wh(1))));
%FP.gooddepthd=find(~isnan(MooringData.etaEUL(:,FP.wh(1))));

%5/06 change: specify these if not passed in... otherwise user can specify
if ~isfield(FP,'gooddepth')
FP.gooddepth=find(ubad < FP.reqperc*length(MooringData.yday));
end
if ~isfield(FP,'gooddepthd')
FP.gooddepthd=find(dbad < FP.reqperc*length(MooringData.yday));
end
%%

% Hardwire... we always have one more hori mode than vert mode.
FP.Nm=FP.Nmd+1;

%% Make matrices for G.
Gu=zeros(length(FP.gooddepth),FP.Nm);
Gd=zeros(length(FP.gooddepthd),FP.Nmd);
Guplot=zeros(length(MooringData.z_full),FP.Nm);
Gdplot=zeros(length(MooringData.z_full),FP.Nmd);

%Put the mean vel mode into the last column
Gu(:,end)=ones(length(FP.gooddepth'),1);
Guplot(:,end)=ones(size(MooringData.z_full));
%populate the rest of the matrix
for ci=1:FP.Nmd
    Gu(:,ci)=interp1(MooringData.z_full,MooringData.hori_full(:,ci),MooringData.z(FP.gooddepth)');
    Guplot(:,ci)=MooringData.hori_full(:,ci);
end

for ci=1:FP.Nmd
    Gd(:,ci)=interp1(MooringData.z_full,MooringData.vert_full(:,ci),MooringData.z(FP.gooddepthd)');
    Gdplot(:,ci)=MooringData.vert_full(:,ci);
end

% Compute SVD
[U,S,V]=svd(Gu);
[Ud,Sd,Vd]=svd(Gd);

%% Weights.  If weights are not specified, use ones (generalized least squares).
lambda=1;
if ~isfield(FP,'useweights')
    FP.useweights=0;
    FP.umodelweights=[1 1:FP.Nmd].^2;
    FP.umodelweights=lambda*FP.umodelweights./sum(FP.umodelweights); 
    FP.dmodelweights=[1:FP.Nmd].^2;
    FP.dmodelweights=lambda*FP.dmodelweights./sum(FP.dmodelweights);
end

if FP.useweights==1

    if ~isfield(FP,'udataweights')
        FP.udataweights=ones(size(FP.gooddepth));
    end
    if ~isfield(FP,'umodelweights')
        %FP.umodelweights=1e10*ones(1,FP.Nm);
        FP.umodelweights=[1 1:FP.Nmd].^2;
        FP.umodelweights=lambda*FP.umodelweights./sum(FP.umodelweights); 
    end
    if ~isfield(FP,'ddataweights')
        FP.ddataweights=ones(size(FP.gooddepthd));
    end
    if ~isfield(FP,'dmodelweights')
        %FP.dmodelweights=1e10*ones(1,FP.Nmd);
        FP.dmodelweights=[1:FP.Nmd].^2;
        FP.dmodelweights=lambda*FP.dmodelweights./sum(FP.dmodelweights);
    end

    %WEIGHTS - please specify the inverses and diagnonals only.
    Ree_u=diag(FP.udataweights);
    Raa_u=diag(FP.umodelweights);
    Ree_d=diag(FP.ddataweights);
    Raa_d=diag(FP.dmodelweights);

end

%% Now loop and do each profile requested.
for wh=FP.wh
    DisplayProgress(wh,100)
    %% u
    %
    d=MooringData.u(FP.gooddepth,wh);
    G=Gu;
    %invert
    if FP.useweights==0
        m=inv(G'*G)*G'*d;
    else
        %        m=inv(G'*inv(Ree_u)*G + inv(Raa_u))*G'*inv(Ree_u)*d;
        %As long as diagonal-only matrixes are specified, we let the user invert them since it is numerically costly.
        m=inv(G'*Ree_u*G + Raa_u)*G'*Ree_u*d;
    end
    %store answers and errors
    uno(1:FP.Nm,wh)=m;
    uno(FP.Nm+1,wh)=sqrt(mean((G*m-d).^2));

    %% v
    d=MooringData.v(FP.gooddepth,wh);
    G=Gu;
    %invert
    if FP.useweights==0
        m=inv(G'*G)*G'*d;
    else
        %        m=inv(G'*inv(Ree_u)*G + inv(Raa_u))*G'*inv(Ree_u)*d;
        m=inv(G'*Ree_u*G + Raa_u)*G'*Ree_u*d;
    end
    %store answers and errors
    vno(1:FP.Nm,wh)=m;
    vno(FP.Nm+1,wh)=sqrt(mean((G*m-d).^2));

    %% eta
    %d=-MooringData.d_Iso(FP.gooddepthd,wh);
    d=MooringData.etaEUL(FP.gooddepthd,wh);
    G=Gd;
    %invert
    if FP.useweights==0
        m=inv(G'*G)*G'*d;
    else
        %        m=inv(G'*inv(Ree_d)*G + inv(Raa_d))*G'*inv(Ree_d)*d;
        m=inv(G'*Ree_d*G + Raa_d)*G'*Ree_d*d;
    end

    %store answers and errors
    dno(1:FP.Nmd,wh)=m;
    dno(FP.Nmd+1,wh)=sqrt(mean((G*m-d).^2));

    %plot if requested
    if FP.plotit
        figure(FP.plotit)
        subplot(331)
        %plot(Guplot*m,z,G*m,MooringData.depth(FP.gooddepth),d,MooringData.depth(FP.gooddepth),'k*')
        plot(Guplot*uno(1:FP.Nm,wh),MooringData.z_full,...
            Gu*uno(1:FP.Nm,wh),MooringData.z(FP.gooddepth),...
            MooringData.u(FP.gooddepth,wh),MooringData.z(FP.gooddepth),'k*',...
            MooringData.u(:,wh),MooringData.z,'b-')
        axis ij
        xlim([-.1 .1])
        ylim([0 MooringData.H(1)])
        title(['#' num2str(wh) ', u'])
        disp('u')
        disp(['parameters:' num2str(m')])
        disp(['resid=' num2str(uno(FP.Nm+1,wh))])
        subplot(332)
        h=plot(Guplot,MooringData.z_full);
        ylim([0 MooringData.H(1)])  
        axis ij
        strs=num2str(uno(1:FP.Nm,wh));
        lg=legend(h,strs,3);set(lg,'fontsize',8)
        subplot(333)
%        plot((1:FP.Nm),diag(S),'k*')
        plot((1:FP.Nm),abs(uno(1:FP.Nm,wh)))
        xlim([0 FP.Nm])
        xlabel('mode #')
        
        subplot(334)
        plot(Guplot*vno(1:FP.Nm,wh),MooringData.z_full,...
            Gu*vno(1:FP.Nm,wh),MooringData.z(FP.gooddepth),...
            MooringData.v(FP.gooddepth,wh),MooringData.z(FP.gooddepth),'k*',...
            MooringData.v(:,wh),MooringData.z,'b-')
        axis ij
        xlim([-.1 .1])
        ylim([0 MooringData.H(1)])
        title(['#' num2str(wh) ', v'])
        disp('v')
        disp(['parameters:' num2str(m')])
        disp(['resid=' num2str(vno(FP.Nm+1,wh))])
        subplot(335)
        h=plot(Guplot,MooringData.z_full);
        ylim([0 MooringData.H(1)])  
        axis ij
        strs=num2str(vno(1:FP.Nm,wh));
        lg=legend(h,strs,3);set(lg,'fontsize',8)
        subplot(336)
%        plot((1:FP.Nm),diag(S),'k*')
        plot((1:FP.Nm),abs(vno(1:FP.Nm,wh)))
        xlim([0 FP.Nm])
        xlabel('mode #')

        subplot(337)
        plot(Gdplot*dno(1:FP.Nmd,wh),MooringData.z_full,...
            Gd*dno(1:FP.Nmd,wh),MooringData.z(FP.gooddepthd),...
            MooringData.etaEUL(FP.gooddepthd,wh),MooringData.z(FP.gooddepthd),'k*',...
            MooringData.etaEUL(:,wh),MooringData.z,'b-')
        axis ij
        ylim([0 MooringData.H(1)])
        title(['#' num2str(wh) ', d'])
        disp('eta')
        disp(['parameters:' num2str(m')])
        disp(['resid=' num2str(dno(FP.Nmd+1,wh))])
        subplot(338)
        h=plot(Gdplot,MooringData.z_full);
        ylim([0 MooringData.H(1)])  
        axis ij
        strs=num2str(dno(1:FP.Nmd,wh));
        lg=legend(h,strs,3);set(lg,'fontsize',8)
        subplot(339)
        if FP.Nmd > 1
%        plot((1:FP.Nmd),diag(Sd),'k*')
        plot((1:FP.Nmd),abs(dno(1:FP.Nmd,wh)))
        end
        xlim([0 FP.Nm])
        xlabel('mode #')

        pause
    end
end

%Output fields


MooringData.un=uno;
MooringData.vn=vno;
MooringData.dn=dno;

MooringData.FP=FP;