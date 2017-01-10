clear all
close all
clc

addpath([pwd filesep 'xticklabel_rotate']);
 
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








%%
turbine.power = turbine.torque .* turbine.rotSpd .* (pi/30);


%%
figure

bar(turbine.power ./ 1000) % plot in kilo Watts
% bar(specs, turbine.power ./ 1000) % plot in kilo Watts

title('rotor power', 'FontSize', 16); 
xlabel('turbine ID', 'FontSize', 16)
ylabel('rotor power [kW]', 'FontSize', 16)

grid on
box on



		
    
 set(gca,'xticklabel',specs)

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