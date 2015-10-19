function v = g_matlab_version

% G_MATLAB_VERSION get current Matlab version number as float
%
%   V = g_matlab_version 
%       
%   OUTPUT  v - current Matlab version number
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 02/12/2015


[ver,~] = version;
pp = strfind(ver,'.');
v = str2num(ver(1:pp(2)-1));