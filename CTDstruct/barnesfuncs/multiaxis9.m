function Ha=multiaxis5(S,column,propertyfile);
%MULTIAXIS1 Create a graph with multiple X axes.
%
%MULTIAXIS(S,column) A default file is automatically loaded, pp3default.mat. 
%To change any variable or property values, load the structure pp3.mat 
%into the workspace and make changes there.
%
%MULTIAXIS(S,column,Propertyfile) where 'S' is the structure that contains
%the data to be plotted, 'column' is the column within the data structure to
%be plotted and 'propertyfile' the stucture from which the axes
%property values are taken.  An error message will occur if either
%structure that 'S' and 'propertyfile' represent are not in base workspace.
%

%Adapted from the original multixaxis of RC Lien, M. Gregg 1nov96%Modified for Matlab 5.1, 18aug97, M.Gregg
%Modified for Matlab, 9/22/2003 K. Martini

% load property value structure or load defaults
nin=nargin;
if nin==2
   load pp4default
else
   [pp]=propertyfile;
end

% check number of inputs
[nseries,nnpts]=size(pp.xaxes); 
%if nseries>4 error('too many input pairs'); end

% match inputed Y-axis strings to respective matrices in the SWIMS structure 
axY=['S.' pp.yaxes];
[axY]=eval(axY);
% set default y limits    if isempty(pp.ylimits)==1        igy=find(~isnan(S.t(:,column)));        ymin=min(axY(igy)); ymax=max(axY(igy));        pp.ylimits=[ymin ymax];    end    %if isempty(pp.ylimits)==1    %    igy=find(~isnan(axY));   	%    ymin=min(axY(igy)); ymax=max(axY(igy));    %    pp.ylimits=[ymin ymax];    %end   
for i=1:nseries
   
   % match inputed X-axis strings to respective matrices in the SWIMS structure
   axX=['S.' pp.xaxes{i}];
   [axX]=eval(axX);
   
   % set default x limits
   if isempty(pp.xlimits{i})==1
		%igx=find(~isnan(axX(:,column)));        %xmin=min(axX(igx)); xmax=max(axX(igx));        xmin=min(axX(:,column)); xmax=max(axX(:,column));        xspan=xmax-xmin;        xmin=xmin-.05*xspan; xmax=xmax+.05*xspan;        pp.xlimits{i,1}=[xmin xmax];
   end        
   %create initial axis
    Ha(i)=axes('position',pp.position,'box','off');
   
   % define bottom position vector to use in bottomaxis.m
	bottomposition = pp.position;
	bottomposition(4) = pp.dy/4;  
   % plot data	if pp.stair(i)==1    	ha=stair_plot(axX(:,column),axY,'y','y');	else   	ha=plot(axX(:,column),axY);	end   set(gca,'XColor',pp.linecolor(1,:),'XTickLabel',[],'YColor',pp.linecolor(1,:),'ticklength',[0 .025])       % set upper axes layers background colors to none   if i~=1  set(gca,'Color','none'); end       % suppress x and y axes ticks   set(gca,'visible','on');   if pp.ticks(i,:)==0 set(gca,'xticklabel',' '); end   if pp.ticks(6,:)==0	set(gca,'yticklabel',' '); end   if i>1        set(gca,'yticklabel',' ');   end
      % set line properties
	set(ha,'LineWidth',pp.linethick(i),'linestyle',pp.linestyle{i},'color',pp.linecolor(i,:),'marker',pp.marker{i})    % set limits   limits{i,1}=[pp.xlimits{i}, pp.ylimits];   axis(limits{i});   
   % reverse x and y axis
   if pp.reverse(i)==1 set(gca,'XDir','reverse');end
   if pp.reverse(6)==1 set(gca,'YDir','reverse'); end  
	% set x and y axis scale   if pp.log(i)==1 set(gca,'XScale','log'); end
   if pp.log(6)==1 set(gca,'YScale','log'); end
   
	% set title and titlesize	hti=title(pp.titletext);
	set(hti,'fontsize',pp.fontsize(3))
   
   % set y label and ylabelsize
   if isempty(pp.ylabel) pp.ylabel=pp.yaxes; end
   hyli=ylabel(pp.ylabel);   set(hyli,'fontsize',pp.fontsize(2),'fontweight','bold')   if i>1 set(hyli,'String',' '); end
     
   % moves x axis down by dy
   bottomaxis(bottomposition,(i-1)*pp.dy)
   
   % defines x labels 
   if isempty(pp.xlabels{i}) pp.xlabels{i}=pp.xaxes{i}; end
   hxli=xlabel(pp.xlabels{i});
   set(hxli,'fontsize',pp.fontsize(1),'fontweight','bold')
   
   %Move the axes label up some. (was 0.7)   ScootLabel2(hxli,4)
      
  	% set x axis color 
   set(gca,'FontSize',pp.fontsize(1),'xcolor',pp.linecolor(i,:),'view',[0,90])
   
end
hold off
