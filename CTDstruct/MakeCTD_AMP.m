function CTD=MakeCTD_AMP(cruise,group,methods)
%function SWIMSgrid=MakeCTD_SWIMS(SWIMSgrid,cruise,methods)
%Turn a SWIMSgrid structure into a CTD structure (see CTD).  Specify
%cruise, and a methods structure detailing the conversion methods.  The
%main issue is which sensor pairs to use.  Default = '1' (pair 1).
%
%2/04 MHA
%
if strcmp(computer,'PCWIN') ==1
amp_procpath=fullfile('C:\amp',cruise,'\griddata');
else
amp_procpath=fullfile('~malford/Data/amp',cruise,'griddata');
end

if nargin < 3
    %Specify '1', '2' or 'mean'
    methods.whichTC='1';    %which TC pair to use
    methods.whicheps='mean';     %which epsilon estimate to use
end

%Do cruise-specific processing here.
switch cruise
    case 'ml04',
        CTD.year=2004;
    case 'home02',
        CTD.year=2002;
    case 'ps02',
        CTD.year=2002;
    case 'ps03',
        CTD.year=2003;
    case 'aeg04',
        CTD.year=2004;
end

CTD.cruise=cruise;

%LOAD IN THE gridded AMP file
fname_ts=fullfile(amp_procpath,['amp_' cruise '_gr' num2str(group) '_thetasd.mat']);
fname_eps=fullfile(amp_procpath,['amp_' cruise '_gr' num2str(group) '_eps.mat']);

%load in gr and call it CTD
load(fname_ts); %gr
CTD=gr;
load(fname_eps); %greps
%add in the depth fields
CTD.p=CTD.pr;
CTD.z=100*CTD.p;

    CTD.c=NaN*CTD.t; %no cond    
%Multiply by 1000 to get s in psu.
CTD.s=1000*CTD.s;

%Take the epsilon that is desired, if it has been computed.
if isfield(CTD,'eps1') & isfield(CTD,'krho1')
    if strcmp(methods.whicheps,'1')==1
        CTD.eps=CTD.eps1;
        CTD.krho=CTD.krho1;
    elseif strcmp(methods.whicheps,'2')==1
        CTD.eps=CTD.eps2;
        CTD.krho=CTD.krho2;
    elseif strcmp(methods.whicheps,'mean')==1
        CTD.eps=1/2*(CTD.eps1+CTD.eps2);
        CTD.krho=1/2*(CTD.krho1+CTD.krho2);
    end
end
CTD.eps=interp1(100*greps.pr,greps.eps,CTD.z);


%Water depth.  
CTD.H=NaN*CTD.yday;
CTD=AddKnudsenDepthToSWIMSgrid(CTD,cruise);

