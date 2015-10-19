function GenericCTDplot1(CTD,PP)
%function GenericCTDplot1(CTD,PP)
%Make a semi-generic plot of variables from a CTD.  
%I'VE predefined some typical variables and labels, and the user can 
%select from these and adjust some parameters using the PP structure.
%

if nargin < 2
    PP=defaultCTDplotParams(CTD,1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Some processing
%CTD.strainEULs(find(CTD.strainEULs > PP.scut))=PP.scut;
%CTD.eps2=CTD.eps;
if isfield(CTD,'eps')
    CTD.eps(find(CTD.eps<1e-9))=NaN;
end

figure(PP.fignum)
clf
for c=1:PP.num
    DisplayProgress(c,1)
    ci=PP.plind(c);
    
    varstr=PP.PB{ci}.str;
    unit=PP.PB{ci}.units;
    labstr=PP.PB{ci}.lab;
    tvecstr=PP.PB{ci}.tvec;
    zvecstr=PP.PB{ci}.zvec;
    tlimtmp=PP.PB{ci}.tlim;
    zlimtmp=PP.PB{ci}.zlim;
    sk=PP.PB{c}.sk;
    if strcmp(tvecstr,'cum_dist')
        [d, cdo, b] = nav2(CTD.lat, CTD.lon);
        cum_dist = [0 nm2km(cdo)];
    end
    
    eval(['tv=' tvecstr ';']);
    eval(['zv=' zvecstr ';']);
    eval(['varpl=' varstr ';']);
    
    minmaxd=PP.PB{ci}.lim;
    ind=find(tv > tlimtmp(1) & tv< tlimtmp(2));
    if PP.PB{ci}.timeseriesplot==1
        %Make adummy variable to plot a panel in - then we'll plot the time
        %series over it and kill the colorbar
        dum=zeros(length(zv),length(tv));
        [ah(c),ahcb(c)] = BitchinPlot3(tv(ind(1:sk:end)),zv,dum(:,ind(1:sk:end)),minmaxd,PP.cmap,...
            unit,1,PP.num,2,0,0,1,32);
        
        killcolorbar(ahcb(c))
        plot(tv(ind(1:sk:end)),varpl(:,ind(1:sk:end)))
        ylim(minmaxd)
        %        eval(['ylabel(PP.PB{ci}.lab)']) %Should put units on
        eval(['ylabel([PP.PB{ci}.lab '' / '' PP.PB{ci}.units])'])
    else
        [ah(c),ahcb(c)] = BitchinPlot3(tv(ind(1:sk:end)),zv,varpl(:,ind(1:sk:end)),minmaxd,PP.cmap,...
            unit,1,PP.num,2,PP.PB{ci}.smooth,PP.mincolor,PP.maxcolor,PP.ncolors);
        
        if PP.PB{ci}.killcb==1
            killcolorbar(ahcb(c))
        end
        ylim(zlimtmp)
        %         if c==ceil(PP.num/2)
        %             ylabel('Depth / m')
        %         else
        %             ytloff
        %         end
        ylabel('Depth / m')
        sbl=SubplotLetter(PP.PB{ci}.lab,PP.PB{ci}.labcoords(1),PP.PB{ci}.labcoords(2));
        set(sbl,'FontWeight','Bold')
        set(sbl,'FontSize',PP.fs+6)
    end
    
    eval(PP.PB{ci}.plotcommands)
    xlim(tlimtmp)
    if c==PP.num
        xlabel(PP.xlab)
    end
    
    if c~=PP.num
        xtloff
    end
end

%Adjust positions
for c=1:PP.num
    %killcolorbar(ahcb(c))
    set(ah(c),'position',[PP.mx PP.mt-PP.by*c PP.bx PP.by]);
    set(ahcb(c),'position',[.97 PP.mt-PP.by*c+PP.by/4 .01 PP.by/2]);
    set(ahcb(c),'fontsize',PP.fs)
    axes(ahcb(c))
    ylabel(PP.PB{PP.plind(c)}.units)
end


%eval(['WriteEPS(PP.figname)'])