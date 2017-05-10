function [] = select_times_interest(OPTIONS,ROMS)

OPTIONS.dir_ROMS = '/mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/ai65/OUT'; % directory with ROMS *.nc output files

% load the sea-surface elevation data
time_idx = [2 2880]; % begin and end time index
% time_idx = [1 100]; % begin and end time index
% time_idx = [1792 1965]; % begin and end time index, from Kristen's paper
% time_idx = [4 10]; % begin and end time index, from Kristen's paper

% time index
n_times   = time_idx(2)-time_idx(1) + 1;
file_time = time_idx(1):time_idx(end);

      
point_zeta        = zeros(n_times, OPTIONS.n_points);
point_tke         = zeros(n_times, OPTIONS.n_points);
point_spd         = zeros(n_times, OPTIONS.n_points);
point_u           = zeros(n_times, OPTIONS.n_points);
point_v           = zeros(n_times, OPTIONS.n_points);
profile_speed_avg = zeros(n_times, OPTIONS.n_points);
for m = 1:numel(ROMS.point_x1)

        ind_lon = findClosest(ROMS.lon_aa(1,:), ROMS.point_x1(m));
        ind_lat = findClosest(ROMS.lat_aa(:,1), ROMS.point_y1(m));
        
%     for n = 1:n_times
    parfor n = 1:n_times

        n
        
        % read variables, these files only 1 time step per file
        nc_file = file_time(n);
        file_ROMS = [OPTIONS.dir_ROMS filesep 'ocean_his_' sprintf('%4.4d',nc_file) '.nc'];
        [~, profile_ROMS] = get_ROMS_fields(file_ROMS,OPTIONS,ROMS,false);
        
        % instantaneous profiles
        profile_tke = profile_ROMS.tke_aa(:,ind_lat,ind_lon);
        profile_spd = profile_ROMS.spd_rho_aa(:,ind_lat,ind_lon);
        profile_u   = profile_ROMS.u_rho_aa(:,ind_lat,ind_lon);
        profile_v   = profile_ROMS.v_rho_aa(:,ind_lat,ind_lon);

        % depth averaged profiles at a given elevation (or hub height)
%         OPTIONS.hubHeight = 8.1
        depth = -1*profile_ROMS.zDown_aa(:,ind_lat,ind_lon);
        elev  = max(depth) - OPTIONS.hubHeight;
        [~, mind] = min(abs(depth - elev));
        
        d_max = abs( min(profile_ROMS.z_rho_aa(:,ind_lat,ind_lon)) ); % max depth at given point
        zq    = linspace(0, d_max, profile_ROMS.S.N);                 % depth values at given point
        profile_speed_avg(n,m) = trapz(zq, profile_spd) / d_max; 
        
        % point values at a given elevation
        point_zeta(n,m) = profile_ROMS.zeta_aa(ind_lat,ind_lon);
        point_tke(n,m)  = profile_tke(mind); 
        point_spd(n,m)  = profile_spd(mind);
        point_u(n,m)    = profile_u(mind);
        point_v(n,m)    = profile_v(mind);
          
    end
end

% save the data ... it takes a long time to read ALL the netcdf files
% save(['cases' filesep OPTIONS.casename filesep 'ROMS_TimeSeries.mat'], ...
%      'OPTIONS','ROMS')

% profile viewer
%%
% time step was 5 seconds and model output saved every 15 minutes
max_time = n_times * 15; % minutes
hours    = ( 0 : 15/60 : (max_time-15)/60 )';

figure
subplot(3,1,1)
    hold on
    plot(hours, point_zeta(:,1), '-r')
    plot(hours, point_zeta(:,2), '-b')
    legend('point 1', 'point 2')
    title('free surface')
    xlabel('time (hours)')
    ylabel('elevation (meters)')
    grid on
    box on
    xlim([0 ceil(max(hours))])
    
% subplot(4,1,2)
%     hold on
%     plot(hours, profile_speed_avg(:,1), '-r')
%     plot(hours, profile_speed_avg(:,2), '-b')
%     legend('point 1', 'point 2')
%     title('depth averaged speed')
%     xlabel('time (hours)')
%     ylabel('speed (m/s)')
%     grid on
%     box on
%     xlim([0 ceil(max(hours))])
    
    % speed at hub-height / ADV height
subplot(3,1,2)
    hold on
    plot(hours, point_spd(:,1), '-r', 'LineWidth', 2)
    plot(hours, point_spd(:,2), '-b', 'LineWidth', 2)
    legend('point 1', 'point 2')
    title('current speed and direction at hub-height')
    xlabel('time (hours)')
    ylabel('speed (m/s)')
    grid on
    box on
    
    sf = 0.5;
    quiver(hours, point_spd(:,1), ...
       sf.*point_u(:,1), sf.*point_v(:,1), ...
       'AutoScale','off', ...
       'ShowArrowHead','off', ...
       'Color', 'r');
    quiver(hours, point_spd(:,2), ...
       sf.*point_u(:,2), sf.*point_v(:,2), ...
       'AutoScale','off', ...
       'ShowArrowHead','off', ...
       'Color', 'b');
   
    xlim([0 ceil(max(hours))])
    
    % TKE at hub-height / ADV height
subplot(3,1,3)
    hold on
    plot(hours, point_tke(:,1), '-r')
    plot(hours, point_tke(:,2), '-b')
    legend('point 1', 'point 2')
    title('Turbulent Kinetic Energy at hub-height')
    xlabel('time (hours)')
    ylabel('TKE (m^2/s^2)')
    grid on
    box on
    xlim([0 ceil(max(hours))])
%%

figure
subplot(3,1,1)
    hold on
    plot(file_time, point_zeta(:,1), '-r')
    plot(file_time, point_zeta(:,2), '-b')
    legend('point 1', 'point 2')
    title('free surface')
    xlabel('timestamp')
    ylabel('elevation (meters)')
    grid on
    box on
    xlim([0 ceil(max(file_time))])
        
    % speed at hub-height / ADV height
subplot(3,1,2)
    hold on
    plot(file_time, point_spd(:,1), '-r', 'LineWidth', 2)
    plot(file_time, point_spd(:,2), '-b', 'LineWidth', 2)
    legend('point 1', 'point 2')
    title('current speed and direction at hub-height')
    xlabel('timestamp')
    ylabel('speed (m/s)')
    grid on
    box on
    
%     sf = 0.5;
%     quiver(file_time', point_spd(:,1), ...
%        sf.*point_u(:,1), sf.*point_v(:,1), ...
%        'AutoScale','off', ...
%        'ShowArrowHead','off', ...
%        'Color', 'r');
%     quiver(file_time', point_spd(:,2), ...
%        sf.*point_u(:,2), sf.*point_v(:,2), ...
%        'AutoScale','off', ...
%        'ShowArrowHead','off', ...
%        'Color', 'b');
   
    xlim([0 ceil(max(file_time))])
    
    % TKE at hub-height / ADV height
subplot(3,1,3)
    hold on
    plot(file_time, point_tke(:,1), '-r')
    plot(file_time, point_tke(:,2), '-b')
    legend('point 1', 'point 2')
    title('Turbulent Kinetic Energy at hub-height')
    xlabel('timestamp')
    ylabel('TKE (m^2/s^2)')
    grid on
    box on
    xlim([0 ceil(max(file_time))])
    
    %%
% figure
% sf = 0.5;
% % quiver(hours, zeros(size(hours)), point_u(:,1), point_v(:,1)); %quiver(x,y,u,v), where y = zeros(size(u))
% % quiver(hours, point_spd(:,1), point_u(:,1), point_v(:,1));
% quiver(hours, point_spd(:,1), ...
%        sf.*point_u(:,1), sf.*point_v(:,1), 'AutoScale','off');
% hold on
% plot(hours, point_spd(:,1), '-r')
% ylim([0 2])
% 
% 
% hold on
% arrow([5 0],[0 0],36,'BaseAn% figure
% sf = 0.5;
% % quiver(hours, zeros(size(hours)), point_u(:,1), point_v(:,1)); %quiver(x,y,u,v), where y = zeros(size(u))
% % quiver(hours, point_spd(:,1), point_u(:,1), point_v(:,1));
% quiver(hours, point_spd(:,1), ...
%        sf.*point_u(:,1), sf.*point_v(:,1), 'AutoScale','off');
% hold on
% plot(hours, point_spd(:,1), '-r')
% ylim([0 2])
% 
% 
% hold on
% arrow([5 0],[0 0],36,'BaseAngle',60)
% gle',60)
% now can loop through each time, and compute the flow angle, the give
% arrow start/stop locations (from a local origin that is conincident with
% the 2D plot line)

% 
% figure
% du = point_u(:,1);
% dv = point_v(:,1);
% dmag = sqrt(du.^2+dv.^2);
%  un=du./dmag;
%  vn=dv./dmag;
% %  quiver(hours, point_spd(:,1),un,vn)
% quiver(hours, point_spd(:,1), ...
%        sf.*un, sf.*vn, 'AutoScale','off');
% % axis equal
% ylim([0 2])
% 
% % I think I want a custom solution to draw the arrows manually, decimate in time, like on
% % Weather Underground
%    open arrow

save(['cases' filesep OPTIONS.casename filesep 'ROMS_tidal_cycles_all_time_series.mat']);
