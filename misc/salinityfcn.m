function s = salinityfcn(c,t,p)
% salinity
%   Usage: s = salinityfcn(c,t,p)
%      c is conductivity in S/m
%      t is temperature in deg C
%      p is sea pressure in MPa
%      s is salinity in concentration units
%              
%
%*	modified from "sal.c"
%*
%*	Parameter	:	salinity
%*	Source		:	IEEE Journal of Oceanic Engineering, Jan. 1980
%*	Units		:	"concentration units"
%*	Input		:	p (MPa), t (deg. C), c (S/m)
%*	Range		:	throughout the world's oceans
%*	Ck value	:	sal (4.29140,15.0,0.0) = 0.035000
%*	Coded		:	Matt Nicholas, June 1982
%*
%*	Calculate salinity (concentration) from pressure (MPa), temperature
%*	(deg. C), and conductivity (S/m).  This routine is based upon "The
%*	Practical Salinity Scale 1978:  Fitting the Data" by Ronald G. Perkin
%*	and Edward Lyn Lewis which appeared in the January 1980 edition of
%*	the IEEE Journal of Oceanic Engineering.  The values of the 
%*	defined constants are taken from the article.  (For C1535 see page 23.)
%*	The names of defined constants and variables correspond to those used
%*	in the article (page 14).
%------------------------------------------------------------------------

 C1535=	4.29140;

 A1=2.070E-5;
 A2=-6.370E-10;
 A3=3.989E-15;

 B1=3.426E-2;
 B2=4.464E-4;
 B3=4.215E-1;
 B4=-3.107E-3;

 c0=6.766097E-1;
 c1=2.00564E-2;
 c2=1.104259E-4;
 c3=-6.9698E-7;
 c4=1.0031E-9;

 a0=0.0080;
 a1=-0.1692;
 a2=25.3851;
 a3=14.0941;
 a4=-7.0261;
 a5=2.7081;

 b0=0.0005;
 b1=-0.0056;
 b2=-0.0066;
 b3=-0.0375;
 b4=0.0636;
 b5=-0.0144;

 k=0.0162;

 EPSILON=5.0e-4;

s = NaN .* c .* t .* p;
ic = find(c < EPSILON);
if ~isempty(ic)
    warning([num2str(length(ic)) ' bad conductivities.'])
    c(ic) = NaN;
end
% if (c < EPSILON) 
%    !echo bad conductivity
%    break
% end

% convert pressure from MPa to decibars */
	p = p * 100.0;
%
% calculate 'big r' */
        br = c/C1535;
%
% calculate 'big r sub p' */
        brsp1 = p.*(A1+p.*(A2+p*A3));
        brsp2 = 1.0 + t.*(B1+t*B2) + br.*(B3+B4*t);
        brsp = 1.0 + brsp1./brsp2;

% calculate 'little r sub t' */
	lrst = c0 + t.*(c1 + t.*(c2+t.*(c3+t*c4)));

% calculate the square root of 'big r sub t' */
	x = sqrt (br./(brsp.*lrst));

% calculate salinity */
	s1 = a0 + x.*(a1 + x.*(a2 + x.*(a3 + x.*(a4 + x*a5))));
	s2 = ((t-15.0)./(1.0 + k * (t-15.0)));
	s2 = s2.* (b0 + x.*(b1 + x.*(b2 + x.*(b3 + x.*(b4 + x * b5)))));
	s = s1 + s2;

%  convert salinity from ppt to concentration units */
	s = s*0.001;
%  force NaNs for any results with imaginary part
    if ~isreal(s)
        ii = find(imag(s));
        s = real(s);
        s(ii) = NaN;
    end