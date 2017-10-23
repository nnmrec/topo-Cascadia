%%
clear all; clc;

addpath([pwd filesep 'utilities' filesep 'plotBarStackGroups']);

rpm      = 11.5;
turbine.ID = 1:10;

dir_data = '/mnt/data-RAID-1/Dropboxes/danny/Dropbox/uw/DISSERTATION/2017/shared_with_Alberto/2017_papers_Sale_Aliseda/paper2_nesting_in_ROMS/figures';

file_torque1 = [dir_data '/time-0568/rotors-torque.csv'];
file_torque2 = [dir_data '/time-0592/rotors-torque.csv'];
file_torque3 = [dir_data '/time-0666/rotors-torque.csv'];
file_torque4 = [dir_data '/time-0689/rotors-torque.csv'];
file_torque5 = [dir_data '/time-1812/rotors-torque.csv'];
file_torque6 = [dir_data '/time-1840/rotors-torque.csv'];
file_torque7 = [dir_data '/time-1912/rotors-torque.csv'];
file_torque8 = [dir_data '/time-1936/rotors-torque.csv'];
torque1 = csvread(file_torque1, 1, 1);
torque2 = csvread(file_torque2, 1, 1);
torque3 = csvread(file_torque3, 1, 1);
torque4 = csvread(file_torque4, 1, 1);
torque5 = csvread(file_torque5, 1, 1);
torque6 = csvread(file_torque6, 1, 1);
torque7 = csvread(file_torque7, 1, 1);
torque8 = csvread(file_torque8, 1, 1);
torque1 = torque1(end,:)';% only use the final iteration
torque2 = torque2(end,:)';
torque3 = torque3(end,:)';
torque4 = torque4(end,:)';
torque5 = torque5(end,:)';
torque6 = torque6(end,:)';
torque7 = torque7(end,:)';
torque8 = torque8(end,:)';

file_velocity1 = [dir_data '/time-0568/rotors-velocity.csv'];
file_velocity2 = [dir_data '/time-0592/rotors-velocity.csv'];
file_velocity3 = [dir_data '/time-0666/rotors-velocity.csv'];
file_velocity4 = [dir_data '/time-0689/rotors-velocity.csv'];
file_velocity5 = [dir_data '/time-1812/rotors-velocity.csv'];
file_velocity6 = [dir_data '/time-1840/rotors-velocity.csv'];
file_velocity7 = [dir_data '/time-1912/rotors-velocity.csv'];
file_velocity8 = [dir_data '/time-1936/rotors-velocity.csv'];
velocity1 = csvread(file_velocity1, 1, 1);
velocity2 = csvread(file_velocity2, 1, 1);
velocity3 = csvread(file_velocity3, 1, 1);
velocity4 = csvread(file_velocity4, 1, 1);
velocity5 = csvread(file_velocity5, 1, 1);
velocity6 = csvread(file_velocity6, 1, 1);
velocity7 = csvread(file_velocity7, 1, 1);
velocity8 = csvread(file_velocity8, 1, 1);
v1 = velocity1(end,:)';% only use the final iteration
v2 = velocity2(end,:)';
v3 = velocity3(end,:)';
v4 = velocity4(end,:)';
v5 = velocity5(end,:)';
v6 = velocity6(end,:)';
v7 = velocity7(end,:)';
v8 = velocity8(end,:)';


p1 = torque1 .* rpm .* (pi/30);
p2 = torque2 .* rpm .* (pi/30);
p3 = torque3 .* rpm .* (pi/30);
p4 = torque4 .* rpm .* (pi/30);
p5 = torque5 .* rpm .* (pi/30);
p6 = torque6 .* rpm .* (pi/30);
p7 = torque7 .* rpm .* (pi/30);
p8 = torque8 .* rpm .* (pi/30);


% power  = [power1, power2, power3, power4];
power  = [p1,p2,p3,p4,p5,p6,p7,p8];
inflow = [v1,v2,v3,v4,v5,v6,v7,v8];

figure;
sum_power = power(1:10,:) + power(11:20,:);
bar(sum_power ./ 1000) % plot in kilo Watts
% bar(specs, turbine.power ./ 1000) % plot in kilo Watts
title('turbine power', 'FontSize', 16); 
xlabel('turbine ID', 'FontSize', 16)
ylabel('combined rotor power [kW]', 'FontSize', 16)
legend('flood 1','ebb 1','flood 2','ebb 2', ...
       'flood 3','ebb 3','flood 4','ebb 4')
grid on
box on

figure;
avg_inflow = (inflow(1:10,:) + inflow(11:20,:))./2;
bar(avg_inflow) 
title('averaged turbine inflow speed', 'FontSize', 16); 
xlabel('rotor ID', 'FontSize', 16)
ylabel('inflow speed (m/s)', 'FontSize', 16)
legend('flood 1','ebb 1','flood 2','ebb 2', ...
       'flood 3','ebb 3','flood 4','ebb 4')
grid on
box on

figure;
subplot(211)
bar(power( 1:10,:) ./1000); % only the CCW rotors
title('CCW rotor')
subplot(212)
bar(power(11:20,:) ./1000); % only the CW  rotors
title('CW rotors')

%      stackData is a 3D matrix (i.e., stackData(i, j, k) => (Group, Stack, StackElement)) 
%      groupLabels is a CELL type (i.e., { 'a', 1 , 20, 'because' };)
stackData = zeros(10,8,2);
stackData(:,:,1) = power(1:10,:);  % CCW rotors
stackData(:,:,2) = power(11:20,:); % CW rotors
stackData = stackData ./ 1000; % units of kilo Watts
groupLabels = { 1; 2; 3; 4; 5; 6; 7; 8; 9; 10};
plotBarStackGroups(stackData, groupLabels)
title('turbine power during tidal cycle', 'FontSize', 16); 
xlabel('turbine ID', 'FontSize', 16)
ylabel('combined rotor power [kW]', 'FontSize', 16)
legend('CCW rotors','CW rotors')
set(gca,'FontSize',18)
grid on
box on
set(gca,'Layer','top') % put grid lines on top of stacks


%%
clear all
close all
clc

addpath([pwd filesep 'utilities' filesep 'xticklabel_rotate']);

 
%% from casr: smooth seabed segregated solver
U_bulk         = 1;
turbine.ID     = 1:7;
turbine.rotSpd = [11.5 11.5 11.5 11.5 11.5 11.5 11.5];
turbine.torque = [3.187963e+05                3.506795e+05                3.716944e+05                3.882443e+05                4.006441e+05                4.093185e+05                4.134846e+05];
turbine.inflow = [1.741981e+00           1.800208e+00           1.835678e+00           1.863480e+00           1.884234e+00           1.898711e+00           1.907829e+00 ];
turbine.thrust = [3.686588e+05             3.887513e+05             4.000466e+05             4.089090e+05             4.155357e+05             4.201635e+05             4.195241e+05 ];





turbine.torque = [94053.964610, ...
                    95855.776925; ...
                    89654.798216, ...
                    87943.917231; ...
                    84758.778970, ...
                    84735.756633; ...
                    70230.960153, ...
                    46765.286279; ...
                    80048.143742, ...
                    50161.460969; ...
                    35001.779963, ...
                    56216.965703; ...
                    37486.241031, ...
                    27102.265796; ...
                    63798.662392, ...
                    68540.414264; ...
                    40466.583080, ...
                    34797.740277; ...
                    68409.881725, ...
                    37658.739317];

turbine.rotSpd = 11.5; %.* ones(1,20);
turbine.ID = 1:20;



specs = ['1: ccw', ...
        ' 1: cw', ...
		' 2: ccw', ...
        ' 2: cw', ...
        ' 3: ccw', ...
        ' 3: cw', ...
        ' 4: ccw', ...
        ' 4: cw', ...
        ' 5: ccw', ...
        ' 5: cw', ...
        ' 6: ccw', ...
        ' 6: cw', ...
        ' 7: ccw', ...
        ' 7: cw', ...
        ' 8: ccw', ...
        ' 8: cw', ...
        ' 9: ccw', ...
        ' 9: cw', ...
        '10: ccw', ...
        '10: cw'];



turbine.power = turbine.torque .* turbine.rotSpd.* (pi/30);

%%
figure

bar(turbine.power ./ 1000) % plot in kilo Watts
% bar(specs, turbine.power ./ 1000) % plot in kilo Watts

title('rotor power', 'FontSize', 16); 
xlabel('turbine ID', 'FontSize', 16)
ylabel('rotor power [kW]', 'FontSize', 16)

grid on
box on




%%
c



		
    
%  set(gca,'xticklabel',specs)

xticklabel_rotate([],45,[],'Fontsize',14)



%%
figure

bar(turbine.torque ./ 1000) % plot in kilo Newton-meters

title('rotor torque', 'FontSize', 16); 
xlabel('turbine ID', 'FontSize', 16)
ylabel('rotor torque [kN-m]', 'FontSize', 16)

grid on
box on

%%
figure

bar(turbine.thrust ./ 1000) % plot in kilo Newtons

title('rotor thrust', 'FontSize', 16); 
xlabel('turbine ID', 'FontSize', 16)
ylabel('rotor thrust [kN]', 'FontSize', 16)

grid on
box on

%%
figure

bar(turbine.inflow)

title('turbine inflow speed', 'FontSize', 16); 
xlabel('turbine ID', 'FontSize', 16)
ylabel('inflow speed [m/s]', 'FontSize', 16)

grid on
box on