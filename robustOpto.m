% robustOpto:  Make a roboust effort to find the global optimization
% bestP=robustOpto(p0,PHIs,Bod,Pos,nTries)
% returns the best choice of several random initial guesses
% REVISIONS:    patton init january, 2019
%               2020-01 Patton altered signifcantly, including input args 
% ~~ BEGIN: ~~

function [bestP,bestCost,TAUs]=robustOpto(PHIs,Bod,Pos,Exo,nTries)

%% setup 
fprintf('~robustOpto:~'); drawnow; pause(.1);       % update display
global TAUsDesired ProjectName
%p0=randn(1,length(p0));                             % RANDOM init
p0=mean(Exo.pConstraint');                          % init constraint @mid
%p0=randn(1,length(Exo.pConstraint)); 

bestP=p0; bestCost=1e5;                             % init high
TAUs=exoNetTorques(bestP,PHIs);                     % init Guess Solution
A = [];
b = [];
Aeq = [];
beq = [];


%% set plot
clf; subplot(1,2,1);    title(ProjectName);         % reset fig
drawBody2(Bod.pose,Bod);                            % cartoon man, posed
plotVectField(PHIs,Bod,Pos,TAUsDesired,'r');        % PLOT desired field
subplot(1,2,1);ax1=axis();subplot(1,2,2);ax2=axis();% get axes zoom frame
plotVectField(PHIs,Bod,Pos,TAUs,.9*[1 1 1]);        % initial guess ltGrey
plotVectField(PHIs,Bod,Pos,TAUsDesired,'r');        % PLOT desired field
subplot(1,2,1); drawBody2(Bod.pose,Bod);            % cartoon man, posed
drawExonets(bestP,Bod.pose);                        % exonet lineSegs
subplot(1,2,2);axis(ax2);subplot(1,2,1);axis(ax1);  % reframe window
title(ProjectName); drawnow; pause(.1);             % show 

%% loop multiple optimization tries with Simmulated annealing
fprintf('\n\n Begin optimizations:  ');
for TRY=1:nTries
  fprintf('Opt#%d of %d..',TRY,nTries);
%% Trying Two Kinds of Optimization
%fminsearch
      [p,c]=fminsearch('cost',p0);                      % ! OPTIMIZATION !
      [p,c]=fminsearch('cost',p);                      % ! OPTIMIZATION !
%fmincon with lower and upper bounds of parameters
     %  [p,c] = fmincon('cost',p0,A,b,Aeq,beq,Exo.pConstraint(:,1),Exo.pConstraint(:,2));
      % [p,c] = fmincon('cost',p,A,b,Aeq,beq,Exo.pConstraint(:,1),Exo.pConstraint(:,2));

%[p,c]=fminunc('cost',p0); 
%[p,c]=fminunc('cost',p); 
  if c<bestCost                                     % if lower cost
    fprintf(' c=%g, ',c); p'%fprintf(' p=%g ',p);     % display
    bestCost=c; bestP=p;                            % update best 
    TAUs=exoNetTorques(p,PHIs);                     % calc improvedSolution
    
    % update plots
    clf; subplot(1,2,1);    % reset fig
    drawBody2(Bod.pose,Bod);                        % cartoon man, posed
    drawExonets(p,Bod.pose);                        % exonet lineSegs
    plotVectField(PHIs,Bod,Pos,TAUsDesired,'r');    % PLOT desired field
    plotVectField(PHIs,Bod,Pos,TAUs,[.8 .9 .9]);    % improvedSolution Grey
    fprintf('\n'); drawnow; pause(.1);              % updates display
    title([ProjectName ', cost=' num2str(c)]);
    size(Exo.T)
    size(Exo.Tdist)
    drawnow; pause(.1);      
    
  else
    fprintf(' (not an improvement) \n ');
  end
  pKick=range(Exo.pConstraint').*(nTries/TRY);      % simmu Aneal perturb 
  p0=bestP+ 1*randn(1,length(p0)).*(.5*pKick);      % kick p away from best
end

%% WRAP UP OPTO with one last run starting at best location
fprintf('Final Opt..');
 [p,c]=fminsearch('cost',bestP);                       % last OPTIM @ best %fminsearch optimization
 %[p,c] = fmincon('cost',bestP,A,b,Aeq,beq,Exo.pConstraint(:,1),Exo.pConstraint(:,2));
 %[p,c]=fminunc('cost',bestP); 
% fmincon optimization
if c<bestCost
  bestCost=c; bestP=p;                                % updateW/better cost
  fprintf(' c=%g, ',c);  p'                           % display
else
  fprintf(' (not an improvement) \n ');
end 
[c,meanErr]=cost(bestP); meanErr

%% update PLOTS
clf; subplot(1,2,1); drawBody2(Bod.pose,Bod);              % cartoon man, posed
drawExonets(bestP,Bod.pose);                          % exonet lineSegs
TAUs=exoNetTorques(bestP,PHIs, 'plotIt');             % solution calc
plotVectField(PHIs,Bod,Pos,TAUsDesired,'r');          % desired again
plotVectField(PHIs,Bod,Pos,TAUs,'b');                 % plot solution 

% PHIs=PHIsWorkspace; Pos=PosWorkspace;               % add fullWorkspace
% TAUs=exoNetTorques(p,PHIs);                         % field @these 
% plotVectField(PHIs,Bod,Pos,TAUs,'b');               % also plot these
subplot(1,2,2); axis(ax2); subplot(1,2,1); axis(ax1); % zoom frame
title([ProjectName ',  AvgError=' num2str(meanErr)]); % show the goods
drawnow; pause(.1);                                   % update

eval(['save ' ProjectName]);
orient landscape
eval(['print -dpdf ' ProjectName]);

