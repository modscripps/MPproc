function MP=AddSLToCTD2(MP,fields)
%function MP=AddSLToCTD2(MP,fields)
%MHA 6/09
%Specify a CTD structure with yday, sgth and dvals.
%This function will transform variables in 'fields' into s-L coords by
%interpolating onto the specified density surfaces, dvals.
%


if ~isfield(MP,'yday') | ~isfield(MP,'dvals') | ~isfield(MP,'sgth')
    error('Structure must contain yday and dvals.')
end

[mo,no]=size(MP.yday);

%fields=fieldnames(MP);

for d=1:length(fields)
    nameo=[fields{d} 'I'];
    MP.(nameo)=zeros(length(MP.dvals),length(MP.yday))*NaN;
    
    for c=1:length(MP.yday)
        ind=find(~isnan(MP.sgth(:,c)));
%        sgths=NaN*MP.sgth(:,c);
%        sgths(ind)=sort(MP.sgth(ind,c));
        if length(ind)>1
            MP.(nameo)(:,c)=interp1(MP.sgth(ind,c),MP.(fields{d})(ind,c),MP.dvals)';
        end
    end

    
end

