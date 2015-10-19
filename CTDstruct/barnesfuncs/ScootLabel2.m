function ScootLabel2(ht,pos)
%function ScootLabel(ht,pos)
%Move the specified xlabel up or down the indicated amount,
%in normalized coords.
%
%ht=get(ax,'XLabel');
set(ht,'Units','Normalized')
pt=get(ht,'Position');
%if reverse==0
pt(1)=1.07;
pt(2)=pt(2)+pos;
%else
%	pt(2)=1.03;
%end
set(ht,'Position',pt);
