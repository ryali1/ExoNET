% 2 joint Marionet torque element calculation
%  Using vector algebra. 
% VERSIONS:  2019-Jan-31 Patton Created from tauMARIONET
%            2019-Feb-10 Patton fixed (small!) L2 bug in elbow position,
%                        and (bigger!) r bug in rVect
%           
%                                                  endpoint: wr>  
%                                            .  X  
%                                      .     X  elbow2wr>
%                        < TVect  .       X   
%                           .          X              . 
%                     .             X    phi2   . 
%                .               X        . 
%           .                 X     . 
%    _   o                 X  .         
%    r  /               O
%      / theta     X    
%     /       X       
%    /   X      phi1
%   o  .  .  .  .  .  .  .  .  .  .  .  . 
%
%
% ~~ BEGIN PROGRAM: ~~



function T=tau2jMARIONET(phis,Ls,r,theta,L0)

global tension

rVect=[r*cos(theta)       r*sin(theta)       0];  % vect to rotatorPin
%norm_r = norm(rVect);
elbow=[Ls(1)*cos(phis(1)) Ls(1)*sin(phis(1)) 0];  % elbow pos
wrist=[elbow(1)+Ls(2)*cos(phis(1)+phis(2)), ...   % wrist pos
       elbow(2)+Ls(2)*sin(phis(1)+phis(2)), ...
       0];
elbow2wr=wrist-elbow;                             % elbow to wrist vect
Tdir=rVect-wrist;                                 % tension element vector 
Tdist=norm(Tdir);                                 % length, rotator2endpt
Tdir=Tdir./Tdist;    % direction vector 

T = tension(L0, Tdist);
%T = tension(L0,Tdist);
%T=tension(L0,Tdist);   
% map stretch2tension 
%if (L0 < Tdist)
%    T = tension(L0,Tdist);
%else
%    T = 0;
%end
% 
% if (L0 > 0)
%     T = tension(L0,Tdist);
% else
%     T = 0;
% end


% if (norm_r < .02) && (norm_r > .1)
%     T = 0;
%     rVect = [0 0 0];
% else
%     T = T;
%     rVect = rVect;
% end

%plot3(L0,Tdist,T);


end % end function