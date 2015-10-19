function GenericMPplot1(MP,PP)
%function GenericMPplot1(MP,PP)
%Make a semi-generic plot of variables from a MP.  
%Use defaultMPplotparams to generate a PP structure.
%MHA, last modified 2/05

if nargin < 2
    PP=defaultMPplotParams(MP,1);
end

num=length(PP.plind);

%positions
mx=0.1;
bx=0.8;
mb=.05;
mt=.98;
by=(mt-mb)/num;
cmap='jet';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Some processing
if isfield(MP,'strainEULs')
MP.strainEULs(find(MP.strainEULs > PP.scut))=PP.scut;
end
if isfield(MP,'eps') & ~isfield(MP,'eps2') %added the ~ - appears to be a bug... mha 7/05
MP.eps2=MP.eps;
MP.eps2(find(MP.eps2<1e-9))=NaN;
end

figure(PP.fignum)
clf
for c=1:num
    DisplayProgress(c,1)
    ci=PP.plind(c);
    
    varstr=PP.strs{ci};
    unit=PP.units{ci};
    labstr=PP.labs{ci};
    tvecstr=PP.tvecs{ci};
    zvecstr=PP.zvecs{ci};
%    tlimtmp=PP.tlims{ci}; 
    tlimtmp=[PP.tmin PP.tmax];
    zlimtmp=PP.zlims{ci};
    sk=PP.sks{c};
    
    eval(['tv=' tvecstr ';']);
    eval(['zv=' zvecstr ';']);
    eval(['varpl=' varstr ';']);
    
    minmaxd=PP.lims{ci};
    ind=find(tv > tlimtmp(1) & tv< tlimtmp(2));
    if PP.timeseriesplot{ci}==1
        %Make adummy variable to plot a panel in - then we'll plot the time
        %series over it and kill the colorbar
        dum=zeros(length(zv),length(tv));
        [ah(c),ahcb(c)] = BitchinPlot3(tv(ind(1:sk:end)),zv,dum(:,ind(1:sk:end)),minmaxd,cmap,...
            unit,1,num,2,0,0,1,32);

        killcolorbar(ahcb(c))
        plot(tv(ind(1:sk:end)),varpl(:,ind(1:sk:end)))
        ylim(minmaxd)
        eval(['ylabel(PP.labs{ci})'])
    else
        [ah(c),ahcb(c)] = BitchinPlot3(tv(ind(1:sk:end)),zv,varpl(:,ind(1:sk:end)),minmaxd,cmap,...
            unit,1,num,2,PP.smooth{ci},0,1,32);
        
        if PP.killcb{ci}==1
            killcolorbar(ahcb(c))
        end
        ylim(zlimtmp)
        if c==ceil(num/2)
            ylabel('Depth / m')
        else
            ytloff
        end
    end
    
    eval(PP.plotcommands{ci})
    xlim(tlimtmp)
    if c==num
        xlabel('yearday')
    end
    
    if c~=num
        xtloff
    end
    sl=SubplotLetter(PP.labs{ci},.1,.1);
    set(sl,'FontSize',14)
    set(sl,'FontWeight','Bold')
end

%Adjust positions
for c=1:num
    %killcolorbar(ahcb(c))
    set(ah(c),'position',[mx mt-by*c bx by]);
    set(ahcb(c),'position',[.97 mt-by*c+by/4 .01 by/2]);
    set(ahcb(c),'fontsize',8)
    axes(ahcb(c))
    ylabel(PP.units{PP.plind(c)})
end


%eval(['WriteEPS(PP.figname)'])