function y=nancumsum(x)
%function y=nancumsum(x)
%cumsum, ignoring NaN's.  NaN's are stored in the answer where they were in
%the summand.
%MHA 10/02
%
%MHA 5/6/03 Fixed a bug that caused zeros instead of NaN's to be put in
%answer where summand had nans.
y=zeros(size(x))*NaN;
tmp=x;
ind=find(isnan(tmp));
if ~isempty(ind)
    tmp(ind)=0;
end    

y=cumsum(tmp);

if ~isempty(ind)
%    tmp(ind)=NaN;
%5/6/03 change.
    y(ind)=NaN;
end    

