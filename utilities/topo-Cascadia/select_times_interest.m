clc; close all; fclose all; clear all;

%% optional: can load a mat file
% function [] = select_times_interest(OPTIONS,ROMS)
load test_select_times.mat  % note: this has ALL times 2:2880
load test_select_times_IJOME.mat  % note: this has ALL times 2:2880

%%
OPTIONS.dir_ROMS    = '/mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/ai65/OUT'; % directory with ROMS *.nc output files

dir_figures = ['cases' filesep 'figs_vertical_profiles'];
mkdir(dir_figures)

% select points of interest (NED coordinate system in STAR-CCM+)
xNorth_ccm = [-1512 -857 -684 -140];
yEast_ccm  = [  -42 -657 1540 1045];
zDown_ccm  = [    0    0    0    0];

% select the time range of interest, or only specific times
time_style = 'range';
    time_idx = [2 2880];        % begin and end time index, all times
    time_idx = [1792 1965];     % begin and end time index, subset from Kristen's paper

time_style = 'select';
    time_idx = [1812];          % flood 1
    time_idx = [568, 592, 666, 689, 1812, 1840, 1912, 1936]; % all times from IJOME paper
    
% time index    
switch time_style
    case 'range'
        n_times   = time_idx(2)-time_idx(1) + 1;
        file_time = time_idx(1):time_idx(end);
        max_time  = n_times * 15; % minutes   % time step was 5 seconds and model output saved every 15 minutes
        hours     = ( 0 : 15/60 : (max_time-15)/60 )';
        hours_range     = ( 0 : 15/60 : (max_time-15)/60 )';   
         
    case 'select'
        n_times   = numel(time_idx);
        file_time = time_idx;    
        max_time  = (time_idx(end)-time_idx(1) + 1) * 15; % minutes   % time step was 5 seconds and model output saved every 15 minutes
        hours     = ( 0 : 15/60 : (max_time-15)/60 )';
        time_idx2 = time_idx(1):time_idx(end);
        [~,~,ib]  = intersect(time_idx', time_idx2', 'rows');
        hours     = hours(ib);
end

%% Initialize
% file_ROMS = [OPTIONS.dir_ROMS filesep 'ocean_his_' sprintf('%4.4d',file_time(1)) '.nc']; 
% [~, profile_ROMS] = get_ROMS_fields(file_ROMS,OPTIONS,ROMS,false);
% [OPTIONS, ROMS] = get_ROMS_fields(ROMS_file,OPTIONS,ROMS,save_full_fields)

% transform coordinate sys of points-of-interest
spheroid    = referenceSphere('earth');
ilat0       = floor( size(ROMS.lat_aa,1)/2 ); % choose index for center of domain
ilon0       = floor( size(ROMS.lon_aa,2)/2 ); % choose index for center of domain
lat0        = ROMS.lat_aa(ilat0,ilon0);
lon0        = ROMS.lon_aa(ilat0,ilon0);   
% requires Mapping Toolbox ... last tested with R2015
[lat_ccm, lon_ccm, h_ccm] = ned2geodetic( ...
  xNorth_ccm, yEast_ccm, zDown_ccm, lat0, lon0, OPTIONS.z0, spheroid)
% work-around for academic versions of Matlab ... b/c maybe sometimes you lose support



%%
n_profiles = numel(xNorth_ccm);

point_zeta        = zeros(n_times, n_profiles);
% point_tke         = zeros(n_times, n_profiles);
% point_eps         = zeros(n_times, n_profiles);
% point_spd         = zeros(n_times, n_profiles);
% point_u           = zeros(n_times, n_profiles);
% point_v           = zeros(n_times, n_profiles);
profile_speed_avg = zeros(n_times, n_profiles);
profile_zq   = zeros(20, n_times, n_profiles); % 20 is the size of ROMS z-mesh
profile_spd  = zeros(20, n_times, n_profiles);
profile_u    = zeros(20, n_times, n_profiles);
profile_v    = zeros(20, n_times, n_profiles);
profile_tke  = zeros(20, n_times, n_profiles);
profile_eps  = zeros(20, n_times, n_profiles);
profile_omg  = zeros(20, n_times, n_profiles);
lat3D = permute( repmat(ROMS.lat_aa, 1,1,size(ROMS.z_rho_aa,1)), [3 1 2]); 
lon3D = permute( repmat(ROMS.lon_aa, 1,1,size(ROMS.z_rho_aa,1)), [3 1 2]); 
% instantaneous profiles
% profile_type = 'grid';
% profile_type = 'interp';

% preallocate interpolant functions
% build the scattered interpolation functions
zzz     = -1 .* squeeze(ROMS.z_rho_aa(1,:,:)); % getting creative with variable names, eh?
F_d_max = scatteredInterpolant(ROMS.lat_aa(:), ROMS.lon_aa(:), zzz(:),'linear','nearest'); 
F_tke   = scatteredInterpolant(lat3D(:), lon3D(:), ROMS.tke_aa(:),'linear','nearest'); 

for m = 1:n_profiles

        ind_lon = findClosest(ROMS.lon_aa(1,:), lon_ccm(m));
        ind_lat = findClosest(ROMS.lat_aa(:,1), lat_ccm(m));
        
%     for n = 1:n_times
    parfor n = 1:n_times

        n
        
        % read variables, these files only 1 time step per file
        file_ROMS = [OPTIONS.dir_ROMS filesep 'ocean_his_' sprintf('%4.4d',file_time(n)) '.nc']; 
        [~, profile_ROMS] = get_ROMS_fields(file_ROMS,OPTIONS,ROMS,false);

%         switch profile_type
%             case 'grid'
                %
                % using the closest lat/lon index
                d_max              = abs( min(profile_ROMS.z_rho_aa(:,ind_lat,ind_lon)) ); % max depth at given point
                profile_zq(:,n,m)  = linspace(0, d_max, profile_ROMS.S.N)';                % depth values at given point
                profile_spd(:,n,m) = profile_ROMS.spd_rho_aa(:,ind_lat,ind_lon);
                profile_u(:,n,m)   = profile_ROMS.u_rho_aa(:,ind_lat,ind_lon);
                profile_v(:,n,m)   = profile_ROMS.v_rho_aa(:,ind_lat,ind_lon);   
                profile_tke(:,n,m) = profile_ROMS.tke_aa(:,ind_lat,ind_lon);
                profile_eps(:,n,m) = profile_ROMS.eps_aa(:,ind_lat,ind_lon);
                profile_omg(:,n,m) = profile_ROMS.omg_aa(:,ind_lat,ind_lon);
%             case 'interp'
%                 % using interpolation
%                 d_max              = F_d_max(lat_ccm(m), lon_ccm(m));  %mesh_vel_x(n) = F_vel_x(mesh_x(n), mesh_y(n), mesh_z(n));
%                 profile_lat        = asdf;
%                 profile_lon        = asdf;
%                 for k = 1:size(ROMS.z_rho_aa,1)
%                     z3D                = linspace(0, d_max, profile_ROMS.S.N)';
%                     profile_tke(:,n,m) = F_tke(lat_ccm(m), lon_ccm(m));
%                     
%                                     
%                     profile_tke(:,n,m) = interp3(lat3D, lon3D, profile_ROMS.zeta_aa, profile_ROMS.tke_aa, lat_ccm(m), lon_ccm(m), );
%                     profile_eps(:,n,m) = profile_ROMS.eps_aa(:,ind_lat,ind_lon);
%                     profile_spd(:,n,m) = profile_ROMS.spd_rho_aa(:,ind_lat,ind_lon);
%                     profile_u(:,n,m)   = profile_ROMS.u_rho_aa(:,ind_lat,ind_lon);
%                     profile_v(:,n,m)   = profile_ROMS.v_rho_aa(:,ind_lat,ind_lon);
%                 end       
%         end
        
        
        
        

%         
        profile_speed_avg(n,m) = trapz(profile_zq(:,n,m), profile_spd(:,n,m)) / d_max; % depth averaged speed
             
        % point values at a given elevation
        %         OPTIONS.hubHeight = 8.1
        depth     = -1*profile_ROMS.zDown_aa(:,ind_lat,ind_lon);
        elev      = max(depth) - OPTIONS.hubHeight;
        [~, mind] = min(abs(depth - elev));    
        point_zeta(n,m) = profile_ROMS.zeta_aa(ind_lat,ind_lon);
%         point_tke(n,m)  = profile_ROMS.tke_aa(:,n,mind);
%         point_eps(n,m)  = profile_eps(:,n,mind);
%         point_spd(n,m)  = profile_spd(:,n,mind);
%         point_u(n,m)    = profile_u(:,n,mind);
%         point_v(n,m)    = profile_v(:,n,mind);
%         
            
    end
end

% save the data ... it takes a long time to read ALL the netcdf files
% save(['cases' filesep OPTIONS.casename filesep 'ROMS_TimeSeries.mat'], ...
%      'OPTIONS','ROMS')
save 'test_select_times_IJOME.mat'

% profile viewer

%% plot the vertical profiles and save for making a movie

for m = 1:numel(OPTIONS.point_x1)
    %parfor n = 1:n_times
    for n = 1:n_times
        
        % rename things for notation convenience
        zq  = profile_zq (:,n,m);
        tke = profile_tke(:,n,m);
        eps = profile_eps(:,n,m);
        spd = profile_spd(:,n,m);
        u   = profile_u  (:,n,m);
        v   = profile_v  (:,n,m);

        % note: ffmpeg expects filenames to start at 0001
        movie_time = file_time(n)-file_time(1)+1;
        
        
        % subplot style, elevation, and profiles of TKE,EPS,SPD ... and
        % read in STARCCM data and overlay plots
        
        % tidal elevation and turbine power
        hFig = init_figure([12 10]);
        % figure
        subplot(4,3,1:3)
        hold on
        plot(hours_range, point_zeta(:,1), '-r')
        plot(hours_range, point_zeta(:,2), '-b')
        legend('Mid-Channel', 'Nearshore')
        title({['[lat, lon] = ' num2str(OPTIONS.point_x1(m)) ',' num2str(OPTIONS.point_y1(m)) ', ocean__his__' sprintf('%4.4d',file_time(n)) '.nc'], ...
               'free surface'})
%         xlabel('time (hours)')
        ylabel('elevation (meters)')
        vline(hours(n),'k')
        grid on
        box on
        xlim([0 ceil(max(hours))])
        
        % plot SPEED at hub-height / ADV height
        subplot(4,3,4:6)
        hold on
%         plot(hours, profile_spd(10,:,m), '-r', 'LineWidth', 1)
        feather(profile_u(10,:,m), profile_v(10,:,m))
        title('current speed and direction at hub-height')
%         xlabel('time (hours)')
        set(gca,'xtick',[])
        xlim([0 numel(hours_range)])
        ylabel('speed (m/s)')
        vline(n,'k')
        grid on
        box on
    
        
        % plot SPEED vertical profile
        subplot(4,3,10)
        plot(flipud(spd), -1*zq, '-k', 'LineWidth', 3);
        grid on
        xlabel('horizontal speed [m/s]')
        ylabel('depth [m]')
        ylim([-70 0]);
        xlim([0 2]); 
        
        % plot TKE
        subplot(4,3,11)
        plot(flipud(tke), -1*zq, '-k', 'LineWidth', 3);
        grid on      
        xlabel('turbulent kinetic energy [m^2/s^2]')
        ylim([-70 0]);
        xlim([0 .05]); 
        
        % plot EPSILON
        subplot(4,3,12)
        plot(flipud(eps), -1*zq, '-k', 'LineWidth', 3);
        grid on        
        xlabel('turbulent dissipation rate (m^2/s^3)')
        ylim([-70 0]);
        xlim([0 .0002]); 
        
        % if STARCCM+ data is available at this timestamp, read and plot
        file_ccm_profiles = [pwd filesep 'cases' filesep 'time-' sprintf('%4.4d',file_time(n)) filesep 'vertical_profiles.csv'];
        if exist(file_ccm_profiles, 'file')
            % read the STARCCM vertical line probes
            all_vert_profiles = csvread(file_ccm_profiles, 1, 0);
            % now pick out the unique x-y coordinates
            [~,ia_str,~] = unique(all_vert_profiles(:,4),'first');
            [~,ia_end,~] = unique(all_vert_profiles(:,4),'last');
            ia_str       = sort(ia_str);
            ia_end       = sort(ia_end);
            line_probe(numel(ia_str)) = struct('spd',[],'tke',[],'omg',[],'x',[],'y',[],'z',[]); 
            % note: each vertical profile may have different number of points, due to different water depths
            for k = 1:numel(ia_str)
                a = ia_str(k);
                b = ia_end(k);
                line_probe(k).spd = all_vert_profiles(a:b, 1);
                line_probe(k).tke = all_vert_profiles(a:b, 2);
                line_probe(k).omg = all_vert_profiles(a:b, 3);
                line_probe(k).x   = all_vert_profiles(a:b, 4);
                line_probe(k).y   = all_vert_profiles(a:b, 5);
                line_probe(k).z   = all_vert_profiles(a:b, 6);
                
                % plot SPEED
                subplot(4,3,10)
                hold on
                plot(line_probe(k).spd, line_probe(k).z);

                % plot TKE
                subplot(4,3,11)
                hold on
                plot(line_probe(k).tke, line_probe(k).z);

                % plot EPSILON
                subplot(4,3,12)
                hold on
                starccm_eps = 0.5477^4 .* line_probe(k).tke .* line_probe(k).omg;
                plot(starccm_eps, line_probe(k).z);
            end

        end
        
        %file_ccm_rotors       = [pwd filesep 'cases' filesep 'time- 'sprintf('%4.4d',file_time(n)) filesep 'rotors.csv']; % if need positions of turbines can read this file
        file_ccm_rotors_power = [pwd filesep 'cases' filesep 'time-' sprintf('%4.4d',file_time(n)) filesep 'rotors-power.csv'];
        if exist(file_ccm_rotors_power, 'file')
            % read the STARCCM turbine data
            all_power = csvread(file_ccm_rotors_power, 1, 1);
            all_power = all_power(end,:)';% only use the final iteration
            
            subplot(4,3,7:9)
            hold on
            plot(hours(n)*ones(10,1), all_power( 1:10)./1000, 'or')
            plot(hours(n)*ones(10,1), all_power(11:20)./1000, '+b')
            legend('Mid-Channel', 'Nearshore')
            title('rotor power')
            xlabel('time (hours)')
            ylabel('power (kW)')
            grid on
            box on
            ylim([0 600])
            xlim([0 ceil(max(hours))])
        else
            % keep this placeholder axis
            subplot(4,3,7:9)
            plot(0,0)
            title('rotor power')
            xlabel('time (hours)')
            ylabel('power (kW)')
            grid on
            box on
            ylim([0 600])
            xlim([0 ceil(max(hours))])
            
        end
        
        % save figures
%         hFig.PaperUnits = 'inches';
%         hFig.PaperPosition = [0 0 10 10];

            saveas(hFig, [dir_figures filesep 'spd-tke-eps__ocean_his_' sprintf('%4.4d',movie_time)], 'png')
        if exist(file_ccm_profiles, 'file') % only save if STARCCM data exists at this time
            hgsave(hFig,[pwd filesep dir_figures filesep 'spd-tke-eps__ocean_his_' sprintf('%4.4d',movie_time) '.fig'])
        end

    end
end

% now copy the movie script to the output directory, and run it
copyfile('utilities/topo-Cascadia/make-movies.sh', [pwd filesep dir_figures])
cwd = pwd;
cd([pwd filesep dir_figures])
system('./make-movies.sh')
cd(cwd)

%%

for m = 1:numel(OPTIONS.point_x1)
    parfor n = 1:n_times
        % rename things for notation convenience
        zq  = profile_zq (:,n,m);
        tke = profile_tke(:,n,m);
        eps = profile_eps(:,n,m);
        spd = profile_spd(:,n,m);
        u   = profile_u  (:,n,m);
        v   = profile_v  (:,n,m);
        
        % note: ffmpeg expects filenames to start at 0001
        movie_time = file_time(n)-file_time(1)+1;
        
        
        
        
        
        % save a plot SPEED
        % figure
        hFig = init_figure([]);
        
        subplot(1,3,1)
        plot(flipud(spd), -1*zq, '-r');
        grid on
        title({['[lat, lon] = ' num2str(OPTIONS.point_x1(m)) ',' num2str(OPTIONS.point_y1(m))], ...
               ['ocean__his__' sprintf('%4.4d',file_time(n)) '.nc']})
        xlabel('horizontal speed [m/s]')
        ylabel('depth [m]')
        ylim([-70 0]);
        xlim([0 3]); 
%         saveas(hFig, [dir_figures filesep 'horizontal-speed__ocean_his_' sprintf('%4.4d',movie_time)], 'png')
        % hgsave(hFig,[pwd filesep dir_figures filesep 'horizontal-speed__' sprintf('%5.5d',n) '.fig'])
        
        
        % save a plot TKE
        % figure 
        %hFig = init_figure([]);
        subplot(1,3,2)
        plot(flipud(tke), -1*zq, '-b');
        grid on
%         title({['vertical profiles at [lat, lon] = ' num2str(OPTIONS.point_x1(m)) ',' num2str(OPTIONS.point_y1(m))], ...
%                ['ocean__his__' sprintf('%4.4d',file_time(n)) '.nc']})        
        xlabel('turbulent kinetic energy [m^2/s^2]')
%         ylabel('depth [m]')
        ylim([-70 0]);
        xlim([0 .05]); 
%         saveas(hFig, [dir_figures filesep 'tke__ocean_his_' sprintf('%4.4d',movie_time)], 'png')
        % hgsave(hFig,[pwd filesep dir_figures filesep 'tke__' sprintf('%5.5d',n) '.fig'])
        
        
        % save a plot EPSILON
        % figure
        %hFig = init_figure([]);
        subplot(1,3,3)
        plot(flipud(eps), -1*zq, '-g');
        grid on
%         title({['vertical profiles at [lat, lon] = ' num2str(OPTIONS.point_x1(m)) ',' num2str(OPTIONS.point_y1(m))], ...
%                ['ocean__his__' sprintf('%4.4d',file_time(n)) '.nc']})        
        xlabel('turbulent dissipation rate (m^2/s^3)')
%         ylabel('depth [m]')
        ylim([-70 0]);
        xlim([0 .0002]); 
%         saveas(hFig, [dir_figures filesep 'eps__ocean_his_' sprintf('%4.4d',movie_time)], 'png')
        % hgsave(hFig,[pwd filesep dir_figures filesep 'eps__' sprintf('%5.5d',n) '.fig'])
        
        saveas(hFig, [dir_figures filesep 'spd-tke-eps__ocean_his_' sprintf('%4.4d',movie_time)], 'png')
        
        % par_save([pwd dir_figures filesep 'vertical-profiles__ocean_his_' sprintf('%5.5d',file_time(n))], ...
        %          zq, tke, eps, spd, u, v)
    end
end

        
% now copy the movie script to the output directory, and run it
copyfile('utilities/topo-Cascadia/make-movies.sh', [pwd filesep dir_figures])
cwd = pwd;
cd([pwd filesep dir_figures])
system('./make-movies.sh')
cd(cwd)


%%


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
save 'ROMS_tidal_cycles_all_time_series.mat'
