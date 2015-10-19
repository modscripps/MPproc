function Ha=multiaxis2(S,column,propertyfile);
%MULTIAXIS1 Create a graph with multiple X axes.
%
%MULTIAXIS(S,column) A default file is automatically loaded, pp1default.mat. 
%To change any variable or property values, load the structure pp.mat 
%into the workspace and make changes there.
%
%MULTIAXIS(S,column,Propertyfile) where 'S' is the structure that contains
%the data to be plotted, 'column' is the column within the data structure to
%be plotted and 'propertyfile' the stucture from which the axes
%property values are taken.  An error message will occur if either
%structure that 'S' and 'propertyfile' represent are not in base workspace.
%
%PP1DEFAULT Structure:
%	pp.xaxes: 		{'.t1'; '.c1'; '.s1'; 'th1'} 		{4x1 cell}
%	pp.yaxes: 		['.z_ctd']  							[1x6 char]
%	pp.position:	[ 0.2000 0.3000 0.6000 0.6000] 	[4x1 double]
%	pp.limits: 		{[];[];[];[]} 							{4x1 cell}  
%	pp.reverse: 	[0;0;0;0;1] 							[5x1 double]
%	pp.log: 			[0;0;0;0;0] 							[5x1 double]
%	pp.ticks: 		[1;1;1;1;1]  							[5x1 double]
%	pp.linecolor:	[ 0 0 1; 1 0 0; 0 1 0; 1 0 1] 	[4x3 double]
%	pp.linestyle:	{'-';'-';'-';'-'} 					{4x1 cell}
%	pp.marker: 		{'none';'none';'none';'none'}		{4x1 cell}
%	pp.stair			[0;0;0;0]								[4x1 double]
%	pp.fontsize		[12;12;12]								[3x1 double]
%	pp.titletext	[' ']										[1x1 char]
%	pp.dy				[0.600]									[1x1 double]
%	pp.xlabels		{[];[];[];[]}							{4x1 cell}
%	pp.ylabel		[' ']										[1x1 char]
%	pp.linethick	[1;1;1;1]								[4x1 double]
%
%PP Structure Syntax:
%	pp.xaxes: 		{'x1 axes field'; 'x2...'; 'x3...'; 'x4...'} 		
%	pp.yaxes: 		['y axes field in S']  							
%	pp.position:	[left bottom width height]
%	pp.limits: 		{[x1 limits];[x2 limits];...} 			[xmin xmax ymin ymax]						  
%	pp.reverse: 	[x1 reverse; x2; x3; x4; y] 				0=normal; 1=reverse							
%	pp.log: 			[x1 log; x2; x3; x4; y] 					0=scalar; 1=log
%	pp.ticks: 		[x1 ticks; x2; x3; x4; y]  				0=ticks off; 1=ticks on
%	pp.linecolor:	[ plot1 color; plot 2; ...] 				colorspec values
%	pp.linestyle:	{['plot1 linestyle']; ['plot2']; ...} 	linestyle character
%	pp.marker: 		{['plot1 marker'];['plot2'];....}		marker character
%	pp.stair			[plot1 stair;plot2;...]						0=off; 1=on
%	pp.fontsize		[XAxes Size;YAxes Size;Title Size]		Fontsize	Number					
%	pp.titletext	['Title Text ']								Title String
%	pp.dy				[Distance between X axes]					Number						
%	pp.xlabels		{['x1 Label Text'];['x2'];...}			X Label Strings		
%	pp.ylabel		['Y Axes Label Text ']						Y Label String
%	pp.linethick	[Plot1 thickness; Plot2;...]				Plot line thicknesses

%Adapted from the original multixaxis of RC Lien, M. Gregg 1nov96%Modified for Matlab 5.1, 18aug97, M.Gregg
%Modified for Matlab, 9/15/2003 K. Martini

% load property value structure or load defaults
nin=nargin;
if nin==2
   load pp1default
else
   [pp]=propertyfile
end

% check number of inputs
[nseries,nnpts]=size(pp.xaxes); 
if nseries>4 error('too many input pairs'); end

% match inputed Y-axis strings to respective matrices in the SWIMS structure 
axY=['S' pp.yaxes];
[axY]=eval(axY);
 
for i=1:nseries
   
   % match inputed X-axis strings to respective matrices in the SWIMS structure
   axX=['S' pp.xaxes{i}];
   [axX]=eval(axX);
   
   % set default x limits
   if isempty(pp.limits{i})==1      igy=find(~isnan(axY));   	ymin=min(axY(igy)); ymax=max(axY(igy));
		igx=find(~isnan(axX(:,column)));      xmin=min(axX(igx)); xmax=max(axX(igx));      xspan=xmax-xmin;      xmin=xmin-.05*xspan; xmax=xmax+.05*xspan;      pp.limits{i}=[xmin xmax ymin ymax];
   end
   
   %create initial axis
	Ha(i)=axes('position',pp.position,'box','on','ticklength',[0 .025]);
   hold on
   set(gca,'XColor',pp.linecolor(1,:),'XTickLabel',[])
   
   % define bottom position vector to use in bottomaxis.m
	bottomposition = pp.position;
	bottomposition(4) = pp.dy/4;

   % set upper axes layers background colors to none
   if i~=1  set(gca,'Color','none'); end
     
   % suppress x and y axes ticks
   set(gca,'visible','on');
   if pp.ticks(i,:)==0 set(gca,'xticklabel',' '); end
   if pp.ticks(5,:)==0	set(gca,'yticklabel',' '); end
  
   % plot data	if pp.stair(i)==1    	ha=stair_plot(axX(:,column),axY,'y','y');	else   	ha=plot(axX(:,column),axY);	end
   
   % set line properties
	set(ha,'LineWidth',pp.linethick(i),'linestyle',pp.linestyle{i},'color',pp.linecolor(i,:),'marker',pp.marker{i})
   
   % reverse x and y axis
   if pp.reverse(i)==1 set(gca,'XDir','reverse');end
	if pp.reverse(5)==1 set(gca,'YDir','reverse'); end
   
   % set limits
   if ~isempty(pp.limits(i)) axis([pp.limits{i}]); end
   
	% set x and y axis scale   if pp.log(i)==1 set(gca,'XScale','log'); end
   if pp.log(5)==1 set(gca,'YScale','log'); end
   
	% set title and titlesize	hti=title(pp.titletext);
	set(hti,'fontsize',pp.fontsize(3))
   
   % set y label and ylabelsize
   if isempty(pp.ylabel) pp.ylabel=pp.yaxes; end
	hyli=ylabel(pp.ylabel);   set(hyli,'fontsize',pp.fontsize(2))
     
   % moves x axis down by dy
   bottomaxis(bottomposition,(i-1)*pp.dy)
   
   % defines x labels 
   if isempty(pp.xlabels{i}) pp.xlabels{i}=pp.xaxes{i}; end
   hxli=xlabel(pp.xlabels{i});
   set(hxli,'fontsize',pp.fontsize(1))
   
   %Move the axes label up some. (was 0.7)   ScootLabel2(hxli,4)
      
  	% set x axis color 
   set(gca,'FontSize',pp.fontsize(1),'xcolor',pp.linecolor(i,:))
   
end
hold off
