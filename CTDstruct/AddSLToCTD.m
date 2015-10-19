function MP=AddSLToCTD(MP)
%function MP=AddSLToCTD(MP)
%MHA 6/09
%beginning of a function for transformation to s-L
%
disp ' warning: superseded by AddSLToCTD2.m'

%% Now begin s-L!
%code adapted from ProcessMP_IWAP1
MP.uzI=zeros(length(MP.dvals),length(MP.yday))*NaN;
MP.vzI=MP.uzI;
MP.usI=MP.uzI;
MP.vsI=MP.uzI;
if isfield(MP,'eps')
    MP.epsI=MP.uzI;
end
if isfield(MP,'ubc')
    MP.ubcI=MP.uzI;
    MP.vbcI=MP.vzI;
end

for c=1:length(MP.yday)
    ind=find(~isnan(MP.sgth(:,c)));
    if length(ind)>1
        MP.uzI(:,c)=interp1(MP.sgth(ind,c),MP.uzs(ind,c),MP.dvals)';
        MP.vzI(:,c)=interp1(MP.sgth(ind,c),MP.vzs(ind,c),MP.dvals)';
        MP.uI(:,c)=interp1(MP.sgth(ind,c),MP.u(ind,c),MP.dvals)';
        MP.vI(:,c)=interp1(MP.sgth(ind,c),MP.v(ind,c),MP.dvals)';
        if isfield(MP,'eps')
            MP.epsI(:,c)=interp1(MP.sgth(ind,c),MP.eps(ind,c),MP.dvals)';
        end
        if isfield(MP,'ubc')
            MP.ubcI(:,c)=interp1(MP.sgth(ind,c),MP.ubc(ind,c),MP.dvals)';
            MP.vbcI(:,c)=interp1(MP.sgth(ind,c),MP.vbc(ind,c),MP.dvals)';
        end
    end
end

