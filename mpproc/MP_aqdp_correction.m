function ac = MP_aqdp_correction(fname)

% MP_AQDP_CORRECTION Calculate compass corrections from Aquadopp spintest
%
%   AC = MP_aqdp_correction(FNAME)
%
%   INPUT   fname - spintest file name (should have 8 values for headings)
%       
%   OUTPUT  ac - structure with heading corrections
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 10/07/2015

a = load(fname);

if a(1)>200
  a(1) = a(1)-360;
end

ac.bias_angles = a(:)'-[0:45:315];