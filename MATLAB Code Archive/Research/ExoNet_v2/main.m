% main: main script to do exoNet
% patton's main program. use the other main to do carella's
% this entire directory was modified from gravityProcess_mixedDevice code

%% begin
clear; close all; clc; 
fprintf('\n ~ MAIN script:  ~ \n')
setUp % set most variables and plots; 
global XX DXX
%% gravity comp
% fprintf('\n _____  Weight-comp : ____ \n')
% figure(1);
% TAUsDesired=weightEffect(Bod,Pos)                 % set torques2cancelGrav
% plotVectField_1(PHIs,Bod,Pos,TAUsDesired,'r');        % plot desired field 
% [p,c,TAUs]=robustOpto(p0,PHIs,Bod,Pos,options.nTries); % <-- ! global optim
% figure(1);                                        
% plotVectField_1(PHIs,Bod,Pos,TAUsDesired,'r');        % weight- see it again 
% plotVectField(PHIs,Bod,Pos,TAUs,'b');               % plot solution
% subplot(1,2,1); drawBody2(phiPose, Bod);            % draw again 
% drawExonets(p,phiPose);                             % exonets as lineSegs
% suptitle('Gravity Compensating Field');               
% drawnow; pause(.1);                                 % updates display
% save gravity

%% EA
% fprintf('\n _____  EA field :  _____ \n')
%  figure(2);
% PHIsWorkspace=PHIs;  
% [TAUsDesired,PHIs,Pos]=eaField(Bod);                % set torques2cancelGrav
% plotVectField(PHIs,Bod,Pos,TAUsDesired,'r');        % plot desired field 
% [p,c,TAUs]=robustOpto(p0,PHIs,Bod,Pos,options.nTries); % <-- ! global optim 
% figure(2);    subplot(1,2,1);                                    
% plotVectField(PHIs,Bod,Pos,TAUsDesired,'r');        % weight again to see it
% plotVectField(PHIs,Bod,Pos,TAUs,'b');               % plot solution
% PHIs=PHIsWorkspace;                                 % PHIS of fullWorkspace
% Pos=forwardKin(PHIs,Bod);                           % positions assoc w/ 
% TAUs=exoNetTorques(p,PHIs);                         % torques @these points
% plotVectField(PHIs,Bod,Pos,TAUs,'b');               % plot these  
% subplot(1,2,1); drawBody2(phiPose, Bod);            % draw body again at one posture
% drawExonets(p,phiPose)                              % exonets as lineSegs
% suptitle('Error Augmenting Field'); 
% drawnow; pause(.1);   % updates display
% save EAField

%% Attractor Field
fprintf('\n _____  Attractor field :  _____ \n')
figure(3);
PHIsWorkspace=PHIs;
[TAUs,PHIs,Pos]=AttractorField(Bod);           % set torques2cancelGrav
plotVectField(PHIs,Bod,Pos,TAUs,'r');        % plot desired field 
[p,c,TAUs]=robustOpto(p0,PHIs,Bod,Pos,options.nTries); % <-- ! global optim 
figure(2);    subplot(1,2,1);             1                       
plotVectField(PHIs,Bod,Pos,TAUsDesired,'r');        % weight again to see it
plotVectField(PHIs,Bod,Pos,TAUs,'b');               % plot solution
PHIs=PHIsWorkspace;                                 % PHIS of fullWorkspace
Pos=forwardKin(PHIs,Bod);                           % positions assoc w/ 
TAUs=exoNetTorques(p,PHIs);                         % torques @these points
plotVectField(PHIs,Bod,Pos,TAUs,'b');               % plot these  
subplot(1,2,1); drawBody2(phiPose, Bod);            % draw body again at one posture
drawExonets(p,phiPose)                              % exonets as lineSegs
suptitle('Error Augmenting Field'); 
drawnow; pause(.1);   % updates display
save EAField

%%
fprintf(' end MAIN script. \n')
