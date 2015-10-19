function SWIMSgrid=MakeCTD_SWIMS(SWIMSgrid,cruise,methods)
%function SWIMSgrid=MakeCTD_SWIMS(SWIMSgrid,cruise,methods)
%Turn a SWIMSgrid structure into a CTD structure (see CTD).  Specify
%cruise, and a methods structure detailing the conversion methods.  The
%main issue is which sensor pairs to use.  Default = '1' (pair 1).
%
%2/04 MHA
%

if nargin < 3
    %Specify '1', '2' or 'mean'
    methods.whichTC='1';    %which TC pair to use
    methods.whicheps='mean';     %which epsilon estimate to use
end

%Do cruise-specific processing here.
switch cruise
    case 'ml04',
        SWIMSgrid.year=2004;
    case 'home02',
        SWIMSgrid.year=2002;
    case 'ps02',
        SWIMSgrid.year=2002;
    case 'ps03',
        SWIMSgrid.year=2003;
end

SWIMSgrid.cruise=cruise;

%add in the depth fields
SWIMSgrid.z=SWIMSgrid.z_ctd;
SWIMSgrid.p=SWIMSgrid.p_ctd;

if strcmp(methods.whichTC,'1')==1
    SWIMSgrid.t=SWIMSgrid.t1;
    SWIMSgrid.th=SWIMSgrid.th1;
    SWIMSgrid.c=SWIMSgrid.c1;
    SWIMSgrid.s=SWIMSgrid.s1;
    SWIMSgrid.sgth=SWIMSgrid.sgth1;
elseif strcmp(methods.whichTC,'2')==1
    
    SWIMSgrid.t=SWIMSgrid.t2;
    SWIMSgrid.th=SWIMSgrid.th2;
    SWIMSgrid.c=SWIMSgrid.c2;
    SWIMSgrid.s=SWIMSgrid.s2;
    SWIMSgrid.sgth=SWIMSgrid.sgth2;
elseif strcmp(methods.whichTC,'mean')==1
    SWIMSgrid.t=1/2*(SWIMSgrid.t1+SWIMSgrid.t2);
    SWIMSgrid.th=1/2*(SWIMSgrid.th1+SWIMSgrid.th2);       
    SWIMSgrid.c=1/2*(SWIMSgrid.c1+SWIMSgrid.c2);
    SWIMSgrid.s=1/2*(SWIMSgrid.s1+SWIMSgrid.s2);       
    SWIMSgrid.sgth=1/2*(SWIMSgrid.sgth1+SWIMSgrid.sgth2);
end

%Multiply by 1000 to get s in psu.
SWIMSgrid.s=1000*SWIMSgrid.s;

%Take the epsilon that is desired, if it has been computed.
if isfield(SWIMSgrid,'eps1') & isfield(SWIMSgrid,'krho1')
    if strcmp(methods.whicheps,'1')==1
        SWIMSgrid.eps=SWIMSgrid.eps1;
        SWIMSgrid.krho=SWIMSgrid.krho1;
    elseif strcmp(methods.whicheps,'2')==1
        SWIMSgrid.eps=SWIMSgrid.eps2;
        SWIMSgrid.krho=SWIMSgrid.krho2;
    elseif strcmp(methods.whicheps,'mean')==1
        SWIMSgrid.eps=1/2*(SWIMSgrid.eps1+SWIMSgrid.eps2);
        SWIMSgrid.krho=1/2*(SWIMSgrid.krho1+SWIMSgrid.krho2);
    end
end


%Water depth.  
SWIMSgrid.H=NaN*SWIMSgrid.yday;
