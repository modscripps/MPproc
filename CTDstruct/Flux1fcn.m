function [prof,PP]=Flux1(prof,PP)
%function prof=Flux1(prof)
%Comptute the energy flux from a profile.
%Warning: no 'idiot-proofing' is done.  The user is responsible
%for making sure the data adequately cover the water column so that
%the barotropic component is given by the simple depth-mean of the data.
%
%Required fields:
%z: depth vector
%H: water depth
%ubc,vbc: bc velocity in m/s
%eta: displacement in m
%n2: buoyancy frequency squared in (rad/s)^2.
%
%This routine computes phat via Kunze's methods.
%Then the flux is given by u'p'.
%Units:
%phat*rho has units of pressure.
%rho*up has units of W/m^2.
%rho*upm has units of W/m.
%
%MHA 6/03
%
%NOT FINISHED!!

if nargin < 2
    PP.plotit=0;
    %     PP.umin=-.2;
    %     PP.umax=.2;
    %     PP.upmin=-.05;
    %     PP.upmax=.05;
    %     PP.rho=1026;
    %     PP.nmin=1e-7;
    %     PP.nmax=1e-3;
    %     PP.pmin=-.5;
    %     PP.pmax=.5;
    %     PP.etamin=-80;
    %     PP.etamax=80;
    %     PP.zmax=prof.H(c);

end

disp 'Do not attempt this on non-uniformly spaced data!'
dz=mean(diff(prof.z));

[m,n]=size(prof.eta);
if ~isfield(prof,'ubc')
    for c=1:n
        prof.ubc(:,c)=prof.u(:,c)-nanmean(prof.u(:,c));
        prof.vbc(:,c)=prof.v(:,c)-nanmean(prof.v(:,c));
    end
end

for c=1:n
    prof.phat1(:,c)=nancumsum(prof.n2(:,c).*prof.eta(:,c))*dz;
    prof.phatm(c)=nanmean(prof.phat1(:,c));

    prof.phat(:,c)=prof.phat1(:,c)-prof.phatm(c);

    prof.up(:,c)=prof.phat(:,c).*prof.ubc(:,c);
    prof.vp(:,c)=prof.phat(:,c).*prof.vbc(:,c);
    prof.upm(c)=nanmean(prof.up(:,c)).*prof.H(c);
    prof.vpm(c)=nanmean(prof.vp(:,c)).*prof.H(c);

    if PP.plotit==1
        PP.rho=1026;

        if ~isfield(PP,'umin')
            PP.umin=min([min(prof.ubc(:,c)) min(prof.vbc(:,c))]);
        end
        if ~isfield(PP,'umax')
            PP.umax=max([max(prof.ubc(:,c)) max(prof.vbc(:,c))]);
        end
        if ~isfield(PP,'upmin')
            PP.upmin=min([min(prof.up(:,c)) min(prof.vp(:,c))]);
        end
        if ~isfield(PP,'upmax')
            PP.upmax=max([max(prof.up(:,c)) max(prof.vp(:,c))]);
        end
        if ~isfield(PP,'nmin')
            PP.nmin=0;%min(prof.n2(:,c));
        end
        if ~isfield(PP,'nmax')
            PP.nmax=max(prof.n2(:,c));
        end
        if ~isfield(PP,'pmin')
            PP.pmin=PP.rho*min(prof.phat(:,c));
        end
        if ~isfield(PP,'pmax')
            PP.pmax=PP.rho*max(prof.phat(:,c));
        end
        if ~isfield(PP,'etamin')
            PP.etamin=min(prof.eta(:,c));
        end
        if ~isfield(PP,'etamax')
            PP.etamax=max(prof.eta(:,c));
        end
        if ~isfield(PP,'zmax')
            PP.zmax=prof.H(c);
        end

        %    PP.umin=-.2;
        %    PP.umax=.2;
        %    PP.upmin=-.05;
        %    PP.upmax=.05;
        %    PP.nmin=1e-7;
        %    PP.nmax=1e-3;
        %    PP.pmin=-.5;
        %    PP.pmax=.5;
        %    PP.etamin=-80;
        %    PP.etamax=80;

        clf
        ax=MySubplot(.1,.1,0.02,.1,.1,0,5,1);
        axes(ax(1))
        semilogx(prof.n2(:,c),prof.z)
        axis ij
        ylim([0 PP.zmax])
        xlim([PP.nmin PP.nmax])
        xlabel('N')
        %ZapTick('r')
        yl=get(gca,'xlim');
        hold on
        h=plot(yl,[prof.H(c) prof.H(c)]);
        hold off
        lw(h,2)

        axes(ax(2))
        plot(prof.eta(:,c),prof.z)
        axis ij
        ylim([0 PP.zmax])
        xlim([PP.etamin PP.etamax])
        ytloff
        yl=get(gca,'xlim');
        hold on
        h=plot(yl,[prof.H(c) prof.H(c)]);
        hold off
        lw(h,2)
        xlabel('\eta')
        %zaptick('r')

        axes(ax(3))
        h=plot(PP.rho*prof.phat(:,c),prof.z,PP.rho*prof.phat1(:,c),prof.z,'k-');
        lw(h(1),2)
        axis ij
        ylim([0 PP.zmax])
        xlim([PP.pmin PP.pmax])
        ytloff
        xlabel('p'' / Pa')
        %ZapTick('r')
        title(['yday ' num2str(prof.yday(c))])
        grid
        yl=get(gca,'xlim');
        hold on
        h=plot(yl,[prof.H(c) prof.H(c)]);
        hold off
        lw(h,2)

        axes(ax(4))
        h=plot(prof.u(:,c),prof.z,prof.v(:,c),prof.z,...
            prof.ubc(:,c),prof.z,'k-',prof.vbc(:,c),prof.z,'r-');
        lw(h(3:4),2)
        axis ij
        ylim([0 PP.zmax])
        xlim([PP.umin PP.umax])
        ytloff
        grid
        xlabel('u,v')
        %ZapTick('r')
        yl=get(gca,'xlim');
        hold on
        h=plot(yl,[prof.H(c) prof.H(c)]);
        hold off
        lw(h,2)

        axes(ax(5))
        plot(prof.up(:,c),prof.z,prof.vp(:,c),prof.z)
        axis ij
        ylim([0 PP.zmax])
        xlim([PP.upmin PP.upmax])
        ytloff
        yl=get(gca,'xlim');
        hold on
        h=plot(yl,[prof.H(c) prof.H(c)]);
        hold off
        lw(h,2)

        xlabel('Fu,Fv')
        grid
        a=SubplotLetter(['Fu=' num2str(prof.upm(c)*PP.rho/1000) ' kW/m'],.05,.9);
        b=SubplotLetter(['Fv=' num2str(prof.vpm(c)*PP.rho/1000) ' kW/m'],.05,.95);
        pause

    end


end