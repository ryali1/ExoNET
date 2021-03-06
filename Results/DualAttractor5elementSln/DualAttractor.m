%% Dual Attractor Field
function [TAUs,PHIs,Pos]=DualAttractor(Bod);  

global ProjectName
ProjectName='DualAttractor';
title(ProjectName);

Magn=3.9; % force scaler
Spc=.04; % spacing of positions 

%% Initialize Range of Attractor 1
x1range =  .1 :Spc:  .25;
y1range = -.4 :Spc: -.25;
[X Y ] = meshgrid(x1range,y1range);% All combinations X & Y in x matrix
c=cat(2,X',Y');
newmatrix = reshape(c,[],2);
x1 = newmatrix(:,1:2);
center1 = [mean(x1range) mean(y1range)];%Center of Attractor

%% Initialize Range of Attractor 2
x2range = .1  :Spc: .25;
y2range = .05 :Spc: .2;
[X2 Y2 ] = meshgrid(x2range,y2range);% All combinations X & Y in x matrix
c=cat(2,X2',Y2');
newmatrix2 = reshape(c,[],2);
x2 = newmatrix2(:,1:2);
center2 = [mean(x2range) mean(y2range)]; %Center of Attractor 2

%% X Matrix of Positions for both Attractors
x = [x1;x2];

%% Define Mean and Sigma of Gaussian Distribution
for i = 1:size(x1,1)
    r1(i,:) = center1-x1(i,:);
    R1(i,:) = norm(r1(i,:))
end
meanr1 = mean(R1);
s1 = std(R1);
for i = 1:size(x2,1)
    r2(i,:) = center2-x2(i,:);
    R2(i,:) = norm(r2(i,:));
end
meanr2 = mean(R2);
s2 = std(R2);

meanR1 = (max(R1)-min(R1))/2;
meanR2 = (max(R2)-min(R2))/2;

%% Calculate Sigmoid/Gaussian/Triangle Function for Both Attractors

Fx1 = zeros(size(r1));
Fx2 = zeros(size(r2));
for i = 1:size(r1,1)
    %%Calculating Force Using Different Function
    %Gaussian
        %F1x1(i,:) = (1/(sqrt(2*pi*s1.^2)))*exp(-(R1(i)-meanr1).^2/(2*s1.^2));
    %Sigmoid     
        %F1x1(i) = 1/(1+exp((-(R1(i)-meanr1)/(s1^2*pi^2/3))));
        %if F1x1(i) > 0.0000001
        %F1x1(i) = F1x1(i)+1;
        %else
        %F1x1(i) = 0;
        %end
        
     %Triangle
        if R1(i) <= meanr1
            F1x1(i) = R1(i);
            
        else
            F1x1(i) = 2*meanr1-R1(i);
        end
        
     F1x1(i) = 20*F1x1(i);

 
     Fx1(i,:) =Magn*transpose( F1x1(i).*(r1(i,:)./R1(i))');
    
         %Fx1(i,:) = transpose(F1x1(i).*r1(i,:)');
     end



for i = 1:size(r2,1)
   %%Calculating Force Using Different Function
    %Gaussian
        %F1x2(i,:) = (1/(sqrt(2*pi*s2.^2)))*exp(-(R2(i)-meanr2).^2/(2*s2.^2));
    %Sigmoid     
        
        
     if R2(i) == 0
         F1x2(i) = 0
     else 
         F1x2(i) = 1/(1+exp((-(R2(i)-meanr2)/(s2^2*pi^2/3))));
     end
     if F1x2(i) > 0.0000001
        F1x2(i) = F1x2(i)+1;
        else
        F1x2(i) = 0;
        end
         
        
     %Triangle
%         if R2(i) == 0
%             F1x2(i) = 0
%         elseif R2(i)<=meanr2
%             
%             F1x2(i) = R2(i);
%         else
%             F1x2(i) = 2*meanr2-R2(i);
%         end
%          F1x2(i) = 20*F1x2(i);
    
    
         %Fx1(i,:) = transpose(F1x1(i).*r1(i,:)');
end
for i = 1:size(r2,1)
    if  F1x2(i) == 0
        Fx2(i,:) = [0,0];
    else
        Fx2(i,:) =Magn*transpose( F1x2(i).*(r2(i,:)./R2(i))');
     end
end




%% Initialize Force Matrix (F1(i,1) = Fx and F1(i,2) = Fy)
F = [Fx1;Fx2];



%% Connect to Main

plot(x(:,1),x(:,2),'.','color',.8*[1 1 1]); % plot positions grey
PHIs=inverseKin(x,Bod.L); % 
Pos=forwardKin(PHIs,Bod);   % positions assoc w/ these angle combinations

TAUs = zeros(size(x));
for i=1:size(x,1), TAUs(i,:)=((jacobian(PHIs(i,:),Bod.L)')*F(i,:)'); end; %  tau=JT*F

end
