% psdem_nc_plot.m  5/4/2011  Parker MacCready
% modified 4/5/2016 Danny Sale
%
% this plots either latlon (irregular) or plaid bathy files

function OPTIONS = select_area_interest(OPTIONS)


if ~exist('OPTIONS.aa', 'var')
    
    
    data_dir = '/mnt/data-RAID-1/danny/bathymetry_Puget-Sound/bathymetry/psdem';
    list_1 = dir([data_dir filesep '*.nc']);
    % list_1 = dir([data_dir 'psdem_2005_*.nc']);
    for ii = 1:length(list_1); 
        disp([num2str(ii),' = ',list_1(ii).name]); 
    end
    nn = input('Input number of file to plot: ');
    ncfile = list_1(nn).name;

    end

% clear all
% close all
% clc


% addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/pandora')
% addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/pandora/Z_functions')
% addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/mexcdf/snctools/')
% addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/haxby/')
% addpath('/mnt/data-RAID-10/danny/ROMS/pandora')
% addpath('/mnt/data-RAID-10/danny/ROMS/pandora/Z_functions')
% addpath('/mnt/data-RAID-10/danny/ROMS/snctools')


% Z_fig;

% choose an output file to look at
% data_dir = '/mnt/data-RAID-1/danny/bathymetry_Puget-Sound/bathymetry/psdem';
% list_1 = dir([data_dir filesep '*.nc']);
% % list_1 = dir([data_dir 'psdem_2005_*.nc']);
% for ii = 1:length(list_1); 
%     disp([num2str(ii),' = ',list_1(ii).name]); 
% end
% nn = input('Input number of file to plot: ');
% ncfile = list_1(nn).name;

% haxby_map = haxby(m);
% colormap(flipud(haxby))
% colormap(jet(14));





zz = nc_varget(ncfile,'elev');
lon = nc_varget(ncfile,'lon');
lat = nc_varget(ncfile,'lat');


figure
pcolor(lon,lat,zz);
Z_dar
shading flat


zlimits = [min(zz(:)) max(zz(:))];
demcmap(zlimits);
colorbar
% caxis([-200 200]);

% Z_addcoast('detailed');
coastdir = '/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/inputs/bathymetry/coast/1_Cascadia/';
Z_addcoast('detailed',coastdir);

title(strrep(ncfile,'_','\_'))
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')

dem(lon,lat,zz, ...
    'ZLim',[-100,100], ...
    'Legend', ...
    'LatLon', ...
    'NoDecim');

%% define the refinement zone
fprintf(1, 'Select a box (2 clicks) from the NW corner to the SE corner \n');
% [x,y] = ginput(2);
x = [-122.7355 -122.6783];
y = [48.1821 48.1473];
% x = [-122.7353 -122.6740];
% y = [48.1814 48.1485];

% round to the nearest neighbor in the topo resolution
nn_lat = interp1(lat,lat,y,'nearest','extrap');
nn_lon = interp1(lon,lon,x,'nearest','extrap');
idx_lat_1 = find(lat==nn_lat(1),1);
idx_lat_2 = find(lat==nn_lat(2),1);
idx_lon_1 = find(lon==nn_lon(1),1);
idx_lon_2 = find(lon==nn_lon(2),1);

% draw a rectangle about the refinement zone
hold on;
plot([x(1) x(2)],[y(1) y(1)], '-r', 'LineWidth', 2)
plot([x(1) x(2)],[y(2) y(2)], '-r', 'LineWidth', 2)
plot([x(1) x(1)],[y(1) y(2)], '-r', 'LineWidth', 2)
plot([x(2) x(2)],[y(1) y(2)], '-r', 'LineWidth', 2)

%% extract the refinement zone
a_lat = min(idx_lat_1,idx_lat_2);
b_lat = max(idx_lat_1,idx_lat_2);
a_lon = min(idx_lon_1,idx_lon_2);
b_lon = max(idx_lon_1,idx_lon_2);
new_lat = lat(a_lat:b_lat);
new_lon = lon(a_lon:b_lon);
new_zz  = zz(a_lat:b_lat, a_lon:b_lon);

% plot the refinement region
figure
pcolor(new_lon,new_lat,new_zz);
Z_dar
shading flat


new_zlimits = [min(new_zz(:)) max(new_zz(:))];
demcmap(new_zlimits);
colorbar
% caxis([-200 200]);

% now add the coastline to mask anything else
[coast_handle] = Z_addcoast('detailed',coastdir);

title(strrep(ncfile,'_','\_'))
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')


%% now make it really pretty with releif shading and 3D
% figure
dem(new_lon,new_lat,new_zz, ...
    'Legend', ...
    'LatLon', ...
    'NoDecim');

% figure
% surf(new_lon,new_lat,new_zz)
% shading interp
% shadem('ui')
% shadem

% %% Example 3: Mapping Toolbox, 3D demcmap
% The shadem function can also be nice for creating 3D data displays.
% Using the San Francisco data from the example above, we make a surfm
% image:
% 
%    figure
%    worldmap([min(new_lat(:)) max(new_lat(:))],[min(new_lon(:)) max(new_lon(:))])
%    cla % gets rid of distracting lines
%    surfm(new_lat,new_lon,new_zz)
%    view(90,30)
%    demcmap(new_zz,256)
%    zoom(1.5) 

% Now apply shadem. To get the LightAngle values I'm entering
% below, I first used shadem('ui') and clicked around until the map
% looked the way I wanted it to look. 

%    shadem([-30 50])
%    shadem('ui')
%    
% now that we have plotted and figured out where the refinement region is
% we can extract this lat/lon from a higher resolution dataset without
% loading the entire dataset (and filling up all the RAM)
