%% Plotting torque field with respect to angles phis - 2joint 

clear all 
close all
clc

% input variables 
phi1=0:10:360;
phi2=0:10:360;  % phi2 � phi1+angolo rotazione rispetto a l1                         % angle of rotation of forearm [deg]
theta=30;                                                                            % angle of rotation of elastic attach site with respect to elbow [deg]
l1=0.3;                                                                              % average length of forearm [m]
l2=0.38;                                                                              % average length of shoulder-elbow (0.395 man and 360 women) [m]
r=0.2;
%r=input('Insert distance between shoulder and elastic element attachment site [m]: ')   % distance between elbow and elastic element attachment site [m]
k=1;
%k=input('Insert elastic coefficient[N/m]: ')                                        % coefficient of elastic element [N/m]
x0=0;
% x=input('Insert final length of elastic element [m]: ')                            % final length of elastic element [m]
% x0=input('Insert initial length of elastic element [m]: ')                         % initial length of elastic element [m]

for i=1:length(phi1)
    for j=1:length(phi2)
        [tau1,tau2,F,t_dist] = twojoints(phi1(i),phi2(j),l1,l2,r,theta,k,x0);
        f(i,j)=tau1;
        g(i,:)=tau2;
    end
end

figure
surfc(phi1,phi2,f);
title('Torque generated vs Angular position of upper arm and forearm');
xlabel('Angle phi1 [deg]');
ylabel('Angle phi2 [deg]');
zlabel('Torque tau1 [Nm]')

figure
plot(phi2,g,'-o')
title('Torque generated vs Angular position of forearm');
xlabel('Angle phi2 [deg]');
ylabel('Torque tau2 [Nm]');

