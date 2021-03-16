% ***********************************************************************
% MAIN SCRIPT TO DO THE ExoNET:
% The torque generated by the ExoNET is given by the sum of all the
% torques generated by each one of the MARIONETs
% ***********************************************************************

% BEGIN
fprintf('\n\n\n\n MAIN SCRIPT~~\n')

disp('Choose from the menu...')
fieldType = menu('Choose a field to approximate:', ...
                 'GaitTorques', ...
                 'EXIT');        

setUpLeg % set variables and plots
close all

switch fieldType
    case 1 % Gait Torques
    [p,c,TAUs,costs] = robustOptoLeg(PHIs,BODY,Position,EXONET,nTries);  % optimization
    e = TAUsDESIRED - TAUs;
    AveragePercentError = 100*(1-(norm(e)/norm(TAUsDESIRED)));
    showGraphTorquesLeg(percentageGaitCycle,TAUsDESIRED,TAUs)

    otherwise
    disp('exiting...');
    close all
    
end % end switch


pp = p;
fprintf('\n\n\n\n The Optimal Parameters for each Element are~~\n')
n = 1;
for i = 1:3:length(pp)  % for loop to print the values of the optimal parameters
    if abs(pp(i+1))>360 % to adjust the angle theta if it's higher than 360 degrees
        while abs(pp(i+1))>360
            pp(i+1) = sign(pp(i+1))*(abs(pp(i+1))-360);
        end
    end
    if pp(i)<0          % if r is negative
        pp(i) = pp(i)*(-1);
        pp(i+1) = pp(i+1)+180;
    end
    fprintf('\n Element %d\n',n)
    fprintf('\n r = %4.3f m   theta = %4.2f deg   L0 = %4.3f m\n',pp(i),pp(i+1),pp(i+2))
    n = n+1;
end


fprintf('\n\n\n\n END MAIN SCRIPT~~\n')

