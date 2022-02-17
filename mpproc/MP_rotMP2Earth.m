function [VE,Head,Headcor]=MP_rotMP2Earth(aTx,aTy,aHx,aHy,aHz,compass_bias,mag_dev,VI)

% [VE,Head,HeadTot,Pc] = MP_ROTMP2EARTH(aTx,aTy,aHx,aHy,aHz,compass_bias,mag_dev,VI)
%
% Rotate FSI ACM velocity vector VI (in MMP instrument
% coordinate frame) into Earth coordinates (VE=u,v,w), using
% tilt and compass measurements from ACM.
%
% *INPUTS*
%
% VI : Velocity vector in instrument coordinate frame
%      size is 3 X N , VI=[Vx
%                          Vy
%                          Vz]
%      N is number of samples
%
% aTx,aTy : tilt from MP (ie pitch and roll) / deg
% aHx,aHy,aHz : MP compass data
% compass_bias: MP compass bias / deg (determined from spin test).
% mag_dev : magnetic deviation / deg
%
%
% *OUTPUTS*
% VE:  Velocity VI rotated to earth coordinates (east;north;up).  Same size
% as VI.
%
% *NOTE*: 'z' velocity still includes velocity of profiler. This is removed
% later in mag_pgrid... to get actual vertical velocity of water.
%
% Head: (magnetic) heading from compass (in horizontal plane) (ccw from E)
% Headcor: Head + compass bias + mag. dev. (true heading)
%
% From the McLane Moored Profiler manual rev E (Appendix D-4):
% The Cartesian co-ordinate frame of the MMP is defined to have the +x-axis
% pointing forward, the direction in which the sting of the ACM points. The
% +y-axis points to port, the left side of the profiler. The +z-axis points
% up, completing a right-handed Cartesian system. The first two numbers in
% each ACM scan are TX and TY, the tilt angles of the x- and y-axes about
% the y- and x-axes. When the ACM pressure housing, which contains the tilt
% and compass modules, is properly oriented in the profiler, TX is the
% pitch angle and TY is the roll angle. TX measures rotation about the
% y-axis and is positive when the ACM sting tips up, that is when the
% profiler tips backwards. (Note that this is backwards with respect to the
% usual "right-hand rule" for rotations - thumb of right hand points in the
% positive direction along the axis of rotation, fingers of right hand
% indicated the positive direction of rotation.) Similarly, TY measures
% rotation about the x- axis and is positive when the profiler tips to
% starboard. (Note that this rotation is consistent with the "right-hand
% rule".) The units of tilt are degrees. Full scale for both pitch and roll
% is ±45°. Tilt values near zero indicate that the profiler is vertical.
%
% ~~~
% Info on MMP Coordinate Frame:
% +x is in direction of sting
% +y is 90 deg to left of x (portside of instrument)
% + z is up through MMP (perpendicular to x and y, forming a right handed
% coordinate system)
%
% AP Original 6 Feb 2012
% Updated:
% 15 Aug 2012
% 31 Jan 2013 - talked with S. Webster, think correct order is heading X
% pitch X roll.  Now output results for both orders, to do comparison and
% testing.
% 17 May 2013 (AP) - Streamlined, fixed some bugs.
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% PITCH==aTx;
% ROLL ==aTy;
% Same definition as for RDI ADCPs.

[nr,nc]=size(VI);

if nr~=3
    error('VI is wrong size- shouldbe 3xN ')
end

Np=nc;

% Compass bias (from 8 point calibration) should already have been
% interpolated onto direction vector.
if length(compass_bias)==1
    compass_bias=compass_bias*ones(1,Np);
end

% make empty arrays
VE=nan*ones(size(VI));
Pc=nan*ones(size(aTx));
Head=Pc;
% HeadTot=Pc;
Headcor=Pc;
% heading2=Pc;

textprogressbar('Tilt Correction:         ');

% Loop through all data points
% (need to recalculate transformation matrix for each sample)
for jj=1:Np
    textprogressbar(jj/Np*100);

    clear R Rroll Rpitch Rz atx aty head pitch roll H Hr Rh P Pc
    clear aty atx hx hy hz vi heading
    
    % get heading and compass for this sample
    atx=aTx(jj); % pitch
    aty=aTy(jj); % roll
    hx =aHx(jj);
    hy =aHy(jj);
    hz =aHz(jj);
    
    % get instrument-frame velocityy
    vi=VI(:,jj);
    
    %~~~~ Roll (aTy) ~~~~
    % aTy is + if MP tips to starboard. We want to rotate the
    % MP coordinate system CW to align with vertical, so we use -aTy
    roll=-aty;
    
    % Rotation about x-axis (roll)
%     Rroll=[1 0 0 ;
%         0 cosd(roll) sind(roll) ;
%         0 -sind(roll) cosd(roll) ];
    Rroll=[cosd(roll) 0 sind(roll) ;
        0 1 0;
        -sind(roll) 0 cosd(roll) ];
    
    %~~~~ Pitch (aTx) ~~~~~
    %
    % aTx is + if sting is tilted up.  We want to rotate the
    % MP coordinate system CCW to align with vertical, so we use aTx
    % Note the sign seems flipped here; that is because pitch convention is
    % opposite right-handed convention
    pitch=atx;
    
    % Correct pitch for fixed sensor??
    pitchc=atand(tand(atx)*cosd(roll)); % from adcp coord. trans. pdf   
    % For angles less than ~10deg, this correction is very small.
    % At larger angles, the order of rotation and angle convention
    % used becomes important.
    
    % NOTE I think this gives same result as formula from RDI book (JM) F-7
    %   KA=sqrt(1 - (sind(atx)*sind(roll))^2 ) %
    %   pitch=asind( sind(atx)*cosd(roll)/KA)
    
    % Rotation about y-axis (pitch)
%     Rpitch=[cosd(pitch) 0 -sind(pitch) ;
%         0 1 0;
%         sind(pitch) 0 cosd(pitch) ];
    Rpitch=[1 0 0 ;
        0 cosd(pitch) -sind(pitch) ;
        0 sind(pitch) cosd(pitch) ];
    
    % using 'corrected' pitch
    %     Rpitchc=[cosd(pitchc) 0 -sind(pitchc) ;
    %         0 1 0;
    %         sind(pitchc) 0 cosd(pitchc) ];
    
    
    %~~~ Heading ~~~~
    
    %    H=[hx;hy;hz]; % magntetic field measured in MP coordinates
    % rotate so that Zmp is aligned with vertical
    %    Rh=Rroll*Rpitch;
    %   Rh=Rpitch*Rroll;
    %  Hr=Rh*H;
    
    % Now Hx and Hy are in horizontal plane, compute heading
    
    % *atan2(y,x) gives dir in CCW from E (E==0)
    %    heading=atan2(Hr(1,:),Hr(2,:)) *180/pi;
    %heading=atan2(Hr(2,:),Hr(1,:)) *180/pi;
    
    % Heading assuming 2D (old method)
    %head2=atan2(hy,hx)*180/pi;
    heading=atan2(hx,hy)*180/pi;
    
    % ** This heading is the direction of sting in deg CCW from E **
    
    % Correct for compass bias and magnetic deviation
    HeadTot=heading+compass_bias(jj)-mag_dev;
    
    % We want to rotate MP coordinate system CW to align
    % X_I with East, so we use -Head
    head=-HeadTot;
    
    % Rotation about z-axis (heading/yaw)
    Rz=[ cosd(head) sind(head) 0 ;
        -sind(head) cosd(head) 0;
        0 0 1];
    
    %~~ Rotate velocities from instrument to Earth frame ~~
    
    % So we are doing Xfrom in order: (1) Pitch (2) roll (3) heading
    % (is this the right order?)
    clear R1 R2
    
    % Rz * Ry * Rx = Heading X Pitch X Roll
    R2=Rz*Rpitch*Rroll;
    VE(:,jj)=R2*vi;
    
    Head(jj)=heading;
    Headcor(jj)=HeadTot;
    %    heading2(jj)=head2;
    
end

clear R Rroll Rpitch Rx Ry Rz atx aty head pitch roll H Hr Rh P
clear aty atx hx hy hz vi heading

% delete(hb)
textprogressbar(' Done');

return
%%

% Rotation matrices - here the sign convention is such that
% the coordinate system is rotated by theta degrees CCW.  This is
% equivalent to rotating a vector by theta deg. CW around a fixed
% coordinate system.
%~~~~~~~~~~~~~~
%  % Rotation about x-axis (theta)
%     Rx=[1      0           0        ;
%         0 cosd(theta) sind(theta)   ;
%         0 -sind(theta) cosd(theta) ];
%
%  % Rotation about y-axis (pitch)
%     Ry=[cosd(theta) 0 -sind(theta) ;
%         0           1        0     ;
%         sind(theta) 0 cosd(theta) ];
%
%  % Rotation about z-axis (heading/yaw)
%     Rz=[ cosd(theta) sind(theta) 0  ;
%         -sind(theta) cosd(theta) 0  ;
%             0             0      1] ;
%~~~~~~~~~~~~~~
%
%%
