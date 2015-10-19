function [Veast,Vnorth,Vvert,Head,HeadTot] = MP_acm_calcs(Vx,Vy,Vz,...
          aHx,aHy,aHz,aTx,aTy,dir_sign,compass_bias,mag_dev,TiltCorrection)

% MP_ACM_CALCS Calculate velocities in earth coordinates from FSI ACM sting
%              data. Do this for 2D or 3D (tilt correction).
%
%   [Veast,Vnorth,Vvert,Head,HeadTot] = MP_acm_calcs(Vx,Vy,Vz,...
%       aHx,aHy,aHz,aTx,aTy,dir_sign,compass_bias,mag_dev,TiltCorrection)
%
%   INPUT   x - 
%       
%   OUTPUT  y - 
%
%   Mostly based on code written by Andy Pickering.
%
%   Gunnar Voet  [gvoet@ucsd.edu]
%
%
%   Created: 10/01/2015
%
%
% TODO: include dir_sign in 3D



%% 3D
if TiltCorrection

  % VI == Instrument frame velocity
  VI = [Vx(:)' ; Vy(:)' ; Vz(:)'];
  [VE,Head,HeadTot] = MP_rotMP2Earth3D(aTx,aTy,aHx,aHy,aHz,compass_bias,mag_dev,VI);
  % VE == Earth velocities including MP velocity.
  Veast=VE(1,:);
  Vnorth=VE(2,:);
  Vvert=VE(3,:); % note this is different from Vz (instrument frame)

%% 2D
else
  
  mvpdir = dir_sign*atan2(aHx,aHy)+compass_bias/180*pi-mag_dev/180*pi;
  Head   = atan2(aHx,aHy);
  speed  = sqrt(Vx.*Vx+Vy.*Vy);
  reldir = atan2(Vy,Vx);
  trudir = mvpdir+reldir;
  HeadTot = trudir;
  Veast  = speed.*cos(trudir);
  Vnorth = speed.*sin(trudir);
  Vvert  = Vz;
  %         HeadTot = mvpdir

end