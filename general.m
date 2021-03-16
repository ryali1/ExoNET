clc
clear all
close all

%% spring
l0=0;
k=1;

%% segment1

theta1=60;
r1=2;
r1_pos=[0 0];
R1=[r1*cosd(theta1) r1*sind(theta1) 0];%r1_pos(1)+

deg1=0:10:360;%0:5:90;
phi1=deg1;%-90+deg1;
l1=4;
l1_pos=[0 0];

%% segment2

theta2=60;
r2=2;
r2_pos=[0 -4];
R2=[r2*cosd(theta2) r2*sind(theta2) 0];%r2_pos(1)+

l2=4;
l2_pos=[0 -4];
deg2=0:10:360;%-45:5:45;
phi2=deg2;

%% segment12

theta3=80;
r3=5;
r3_pos=[0 0];
R3=[r3*cosd(theta3) r3*sind(theta3) 0];%r3_pos(1)+

%% computing torques
TAU=cell(length(phi1),length(phi2));
for i=1:length(phi1)
    for j=1:length(phi2)
        torque1 = one_joint(theta1,r1,r1_pos,R1,phi1(i),l1,l1_pos,l0,k);
        torque2= one_joint(theta2,r2,r2_pos,R2,phi2(j),l2,l2_pos,l0,k);%phi2(j)
        [torque12 torque2add]= two_joint(theta3,r3,r3_pos,R3,phi1(i),l1,l1_pos,phi2(j),l2,l2_pos,l0,k);%phi2(j)
        t=[torque1; torque2; torque12; torque2add];
        sum1z(i,j)=torque1(1,3)+torque12(1,3);
        sum2z(i,j)=torque2(1,3)+torque2add(1,3);
        %     hold on
        %     plot3(phi1(i),phi2(j),sum1z(i,j),'.r');
        %TAUz{i,j}=[sum1z(i,j);sum2z(i,j);t];
    end
    
end


%% plot phi vs torque
figure
surfc(phi1,phi2,sum1z)
xlabel('phi1')
ylabel('phi2')
zlabel('sum1z')
figure
surfc(phi1,phi2,sum2z)
xlabel('phi1')
ylabel('phi2')
zlabel('sum2z')
graph2d(phi1,'phi1',sum1z,'sum1z','phi2')
graph2d(phi2,'phi2',sum1z,'sum1z','phi1')
graph2d(phi1,'phi1',sum2z,'sum2z','phi2')
graph2d(phi2,'phi2',sum2z,'sum2z','phi1')