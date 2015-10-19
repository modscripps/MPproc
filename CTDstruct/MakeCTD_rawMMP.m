function MMP=MakeCTD_rawMMP(drops,zmaxg);
%function MMP=MakeCTD_rawMMP(drops,zmaxg);
%This function is not yet completed.

drops=drops(1:3);
warning off MATLAB:break_outside_of_loop
rmax = (zmaxg + 40) * 50;
MMP.t=zeros(rmax,length(drops))*NaN;
MMP.s=MMP.t;
MMP.p=MMP.t;

MMP.eps=zeros(3*zmaxg,length(drops))*NaN;
MMP.pr_eps=eps;

for c=1:3%n_prof%length(drops)
    drop=drops(c);
[p,t,th,s,sgth]=get_thetasd2_mmp(drop,'t','th','s','sgth',0);
[eps_this,pr_eps_this]=get_epsilon2_mmp(drop);
%[n2,pout,dthetadz,dsdz]=nsqfcn(s,t,p,p0,dp);
i1=find(~isnan(p) & ~isnan(s));
dp=mean(diff(pr_eps_this));
dp=.05;
%[n2,p_n2]=nsqfcn(s(i1),t(i1),p(i1),dp,dp);
%MMP.n2(1:length(eps_this),c)=real(interp1(p_n2,n2,pr_eps_this));

MMP.p(1:length(p),c)=p*100;
MMP.t(1:length(p),c)=t;
MMP.s(1:length(p),c)=s*1000;
MMP.eps(1:length(eps_this),c)=eps_this;
MMP.pr_eps(1:length(eps_this),c)=pr_eps_this*100;

end

