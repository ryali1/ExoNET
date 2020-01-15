% evaluate cost function for desired torques TAUs at positions PHIs
% REVISIONS:    initiated by patton January 2019
%               2020 revised to take systematic contraints
% ~~ BEGIN PROGRAM: ~~
% Small Edit to See if Git Works
function [c,meanErr]=cost(p)
global PHIs TAUsDesired Exo
lamda=10; 
e=TAUsDesired-exoNetTorques(p,PHIs); % torques errors at each operating point
c=mean(sum(e.^2));     % !! Sum squares of errors at all positons
meanErr=norm(mean(e));    % avg vect error (I know it isnot really a vect)

%% enforce soft constraints on the paramters (if preSet in setup)
if ~exist('pConstraint','var') % default
  for i=1:length(p) % loop thru each parameter constraint
    isLow=p(i)<Exo.pConstraint(i,1); lowBy=(Exo.pConstraint(i,1)-p(i))*isLow; % howLow
    isHi =p(i)>Exo.pConstraint(i,2); hiBy =(p(i)-Exo.pConstraint(i,2))*isHi;  % howhi
    c=c+lamda*lowBy;                        % quadratic punnishment
    c=c+lamda*hiBy;                         % quadratic punnishment
  end
end

%% penalize R to drive to zero
for i=1:3:length(p) % loop thru each R parameter 
  c=c+p(i); 
end

% %% REGULARIZARION: soft contraint: all L0 if less than realistic amount %
% loL0Limit= .05;           % realistic amount 
% for i=3:3:length(p)       % L0 is every third
%  L0=p(i);
%  ifShorter=L0<loL0Limit; shorterBy=(loL0Limit-L0)*ifShorter;
%  cost=cost+lamda*shorterBy;
% end
% 
% %% REGULARIZARION: soft contraint: all r less than realistic amount %
% R_max= .1;                % practical max 
% for i=1:3:length(p)       % R0 is fist and every third
%   R=p(i);
%   isLarger=abs(R)>R_max;
%   LargerBy=(abs(R)-R_max)*isLarger;
%   cost=cost+lamda*LargerBy^3;  % keep it short
% end

end % END function
