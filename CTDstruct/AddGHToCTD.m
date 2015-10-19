function MPt=AddGHToCTD(MPt)
%function MPt=AddGHToCTD(MPt)
%A first function to add K_GH and N_GH to a CTD structure.
%Must have the fields n2, lat, u and v.
%We are still experimenting in this version before making it really usable
%- for example I've been just modifying the window lengths etc here rather
%than passing them in.
%specify dzwin
%6/09 MHA
%12/12 MHA: playing around with PAPA.  Fixed bug where response correction
%was not applied even when specified. Added K and N to plot if requested.
%

%zmin=200;
%zmax=zmin+100;
plotit=0;
pauseit=0;
dzwin=300;
zvals_gh=(min(MPt.z)+dzwin/2) : dzwin/2 : (max(MPt.z)- dzwin/2);
%kluge for Aegean
%zvals_gh=95;
%dzwin=(160-30);
%kluge for PAPA
dzwin=300;
zvals_gh=(20+dzwin/2) : dzwin/10 : (max(MPt.z)- dzwin/2);
kc=.03; %cutoff k for integration, cpm

frsm=1/40; %smoothing for spectrum

MPt.z_gh=zvals_gh';

if ~isfield(MPt,'n2') & isfield(MPt,'n2m')
    MPt.n2=MPt.n2m;
end

wkbscale=0;
i_gh=24:24:1000;%length(MPt.yday);
MPt.yday_gh=MPt.yday(i_gh);
MPt.K_gh=NaN*zeros(length(zvals_gh),length(i_gh));
MPt.N_gh=MPt.K_gh;

response_corr=1;

if response_corr
    MPt.K_gh_corr=MPt.K_gh;
end

%for it=1:24:length(MPt.yday) %kluge for PAPA
for d=1:length(i_gh)
    it=i_gh(d);
    DisplayProgress(d,10)
    for c=1:length(zvals_gh)
        %it=43+(1:1);
        z=zvals_gh(c);
        iz=find(MPt.z > z-dzwin/2 & MPt.z < z+dzwin/2);
        dz=abs(nanmean(diff(MPt.z)));
        if size(MPt.n2,2)==1 %if we only have one N2 profile
            N=nanmean(sqrt(MPt.n2(iz,1)));
        else
            N=nanmean(sqrt(nanmean(MPt.n2(iz,:))));
        end
        nfft=floor(length(iz)/2); %use half the length of the record to all three chunks
        %nfft=128;
        if wkbscale==0
            [k,Pu,Pus]=myspectrum(MPt.u(iz,it),nfft,dz,frsm);
            %
            [k,Pv,Pvs]=myspectrum(MPt.v(iz,it),nfft,dz,frsm);
        else
            %first compute a wkb scaling factor from the mean N2 profile
            if size(MPt.n2,2)==1 %if we only have one N2 profile
                Nz=real(sqrt(MPt.n2(iz,1)));
            else
                Nz=nanmean(real(sqrt(MPt.n2(iz,:))),2); %use the time-mean
            end
            ig=find(~isnan(Nz));
            if ~isempty(find(isnan(Nz)))
                Nz=interp1(ig,Nz(ig),1:length(iz),'linear','extrap')';
            end
            
            %N is now size iz by 1.
            Nfac=repmat(sqrt(N./Nz),1,length(it));
            [k,Pu,Pus]=myspectrum(MPt.u(iz,it).*Nfac,nfft,dz,frsm);
            %
            [k,Pv,Pvs]=myspectrum(MPt.v(iz,it).*Nfac,nfft,dz,frsm);
        end
        
        %prewhiten
        %[k,Puz,Puzs]=myspectrum(MPt.uz(iz,it),nfft,dz,frsm);
        %
        %[k,Pvz,Pvzs]=myspectrum(MPt.vz(iz,it),nfft,dz,frsm);
        
        %
        shspec_gm=N.^2*gmfrspec(N,k);
        %
        % To compute GH, do it with phi_vel since there are no transfer fcns to
        % worry about and leakage does not appear to be an issue since they look
        % the same.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Now code up Kunze's implementation of GH
        Ko=.05e-4;
        No=5.2e-3;
        Rw=10; %for now assume GM frequency content
        h1=3*(Rw+1)./(2*sqrt(2)*Rw*sqrt(Rw-1));
        fi_rads=sw_f(MPt.lat(1));
        fi30_rads=sw_f(30);
        jfN=fi_rads.*acosh(N/fi_rads)./fi30_rads./acosh(No./fi30_rads);
        %
        ik=find(k<kc);
        dk=mean(diff(k));
        shspec_obs=(2*pi.*k).^2.*Pus+(2*pi.*k).^2.*Pvs;
        %        if response_corr
        zb=16;
        Tk=sinc(zb.*k).^4; %16m
        shspec_corr=shspec_obs./Tk;
        %        end
        
        vz2_gm=sum(shspec_gm(ik))*dk;
        vz2_obs=sum(shspec_obs(ik))*dk;
        
        
        MPt.K_gh(c,d)=Ko*vz2_obs.^2./vz2_gm.^2.*h1.*jfN;
        MPt.N_gh(c,d)=N;
        
        if response_corr
            vz2_corr=sum(shspec_corr(ik))*dk;
            MPt.K_gh_corr(c,d)=Ko*vz2_corr.^2./vz2_gm.^2.*h1.*jfN;
        end
        
        plot_corr=1;
        if plotit
            figure(2)
            clf
            h=plot(MPt.u(:,it),MPt.z,'b-',...
                MPt.u(iz,it),MPt.z(iz),'r-',...
                MPt.v(:,it),MPt.z,'g-',...
                MPt.v(iz,it),MPt.z(iz),'r-');axis ij;%lw(h([2 4]),2)
            title(['yday ' num2str(MPt.yday_gh(d)) ', K=' num2str(MPt.K_gh(c,d)) ' m^2/s'])
            figure(3)
            %loglog(k,(2*pi.*k).^2.*Pu,k,(2*pi.*k).^2.*Pus)
            loglog(k,shspec_obs,k,shspec_corr,k,shspec_gm,'k--')
            %            loglog(k,(2*pi.*k).^2.*Pus+(2*pi.*k).^2.*Pvs,...
            %                k,Puzs+Pvzs,...
            %                k,shspec_gm,'k--')
            if plot_corr
                hold on
                loglog(k,Tk.*shspec_obs(1),'k--')
                hold off
            end
            
            ylim([1e-6 1e-2])
            freqline(kc)
            title([num2str(length(iz)) ' points, nfft=' num2str(nfft)])
            ax=SubplotLetter([MPt.info.cruise ...
                '; # ' num2str(it) ';z=' num2str(fix(MPt.z(min(iz)))) '-' num2str(fix(MPt.z(max(iz)))) ' m'],.01,.02)
            ax=SubplotLetter(['N=' num2str(N) ', K=' num2str(MPt.K_gh(c,d))],.01,.1);
            if response_corr
                ax=SubplotLetter(['N=' num2str(N) ', K_corr=' num2str(MPt.K_gh_corr(c,d))],.01,.15);
            end
            legend('(2\pi k)^2 \Phi_{vel}','GM')
            if pauseit
                pause
            end
        end
        
    end
end
