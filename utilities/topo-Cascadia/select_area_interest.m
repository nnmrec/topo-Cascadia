% modified 4/5/2016 Danny Sale
%
% use this function to extract lat/lon area of interest from a 
% higher resolution dataset without loading the entire dataset (and filling up all the RAM)
%
% this plots either lon-lat (irregular) or plaid bathy files
%
% note: by default, this assumes the lat/lon resolution of the topography files, not
% the ROMS files
%
function [OPTIONS, ROMS, Topo] = select_area_interest(OPTIONS)


% ROMS mesh grid information

% uses Pandora toolbox to read (could also use snc_roms_get_grid to get
% similar information, but would need to now change variable names)

% fields are packed as (t,k,j,i) with k increasing upwards
%   G has horizontal grid info including bathymetry
%   S has vertical S-coordinate information
%   T has time information
[ROMS.G, ROMS.S, ROMS.T] = Z_get_basic_info(OPTIONS.fileTopo_ROMS);

        
% grd = roms_get_grid(grd_file,scoord,tindex,~)
% GRD = roms_get_grid(OPTIONS.fileTopo_ROMS);

% nc_dump(OPTIONS.fileTopo_ROMS)
% ncdisp(OPTIONS.fileTopo_ROMS)

% Seabed_Source = 'PSDEM';
% Seabed_Source = 'ROMS';
switch OPTIONS.Seabed_Source
    case 'PSDEM'
        
        % select the source nc file with gridded topography
        if ~isfield(OPTIONS,'aa') || ~isfield(OPTIONS,'fileTopo')

            disp('either OPTIONS.aa or OPTIONS.fileTopo is missing. Select a new file and area of interest')

            list_1 = dir(['inputs' filesep 'bathymetry' filesep 'topo' filesep OPTIONS.dirTopo filesep '*.nc']);
            for ii = 1:length(list_1); 
                disp([num2str(ii),' = ',list_1(ii).name]); 
            end
            nn = input('Input number of gridded topography file to plot: ');

            OPTIONS.fileTopo = ['inputs' filesep 'bathymetry' filesep 'topo' filesep OPTIONS.dirTopo filesep list_1(nn).name];  

        end

        zz  = nc_varget(OPTIONS.fileTopo,'elev');
        lon = nc_varget(OPTIONS.fileTopo,'lon');
        lat = nc_varget(OPTIONS.fileTopo,'lat');
        
        
    case 'ROMS'
               
        
        global nctbx_options
        % nctbx_options.theAutoNaN=0;
        % nctbx_options.theAutoscale=0;
        nctbx_options.theAutoNaN=1;
        nctbx_options.theAutoscale=1;


        tindex = 1;
        
        % Rutgers version
        nc      = netcdf(OPTIONS.fileTopo_ROMS);
%         h       = nc{'h'}(:);
        zeta    = squeeze(nc{'zeta'}(tindex,:,:));
%         theta_s = nc{'theta_s'}(:);
%         theta_b = nc{'theta_b'}(:);
%         Tcline  = nc{'Tcline'}(:);
%         hc      = min(min(h(:)), Tcline);
%         u       = nc{'u'}(tindex,:,:,:);
%         v       = nc{'v'}(tindex,:,:,:);
%         w       = nc{'w'}(tindex,:,:,:);
        close(nc)

        % %% mesh grid information
        % 
        % % uses Pandora toolbox to read (could also use snc_roms_get_grid to get
        % % similar information, but would need to now change variable names)
        % 
        % % fields are packed as (t,k,j,i) with k increasing upwards
        % %   G has horizontal grid info including bathymetry
        % %   S has vertical S-coordinate information
        % %   T has time information
        % [ROMS.G, ROMS.S, ROMS.T] = Z_get_basic_info(OPTIONS.fileTopo_ROMS);

        %% RHO points
        
        % (update Feb 2017, rewrite this section using Pandora toolbox, and
        % deal with the case when theta_s = theta_b = 0 for a uniform
        % spacing mesh

        % I think I want RHO points in horizontal and W points in vertical
        % compute the depth of rho or w points for ROMS
        % get the depth at each lat lon index
%         z_rho = squeeze(zlevs(h,zeta,theta_s,theta_b,hc,ROMS.S.N,'r',ROMS.S.Vtransform));
%         z_w   = squeeze(zlevs(h,zeta,theta_s,theta_b,hc,ROMS.S.N,'w',ROMS.S.Vtransform));

        % 1st index means at the seabed, compare the RHO and W grid points
%         zz_rho = squeeze( z_rho(1,:,:) );       % first RHO point off the seabed
%         zz_w   = squeeze( z_w(1,:,:) );         % first W point on the seabed
        
        % the PSI points should be on the actual seabed
        
        
        % reshape into column vectors
%         rho_zz  = zz_rho(:);       
%         rho_lon = ROMS.G.lon_rho(:);
%         rho_lat = ROMS.G.lat_rho(:);
%         w_zz    = zz_w(:);       
%         w_lon   = ROMS.G.lon_psi(:);
%         w_lat   = ROMS.G.lat_psi(:);
        
        % choose from the RHO points (and reshape into column vectors)
%         zz     = zz_w(:);       
%         zz     = zz_w;              % ROMS_AGRIF method
%         zz     = -1 .* ROMS.G.h;    % Pandora method
        
        [z_rho,z_w] = Z_s2z(ROMS.G.h, zeta, ROMS.S);
        zz     = squeeze( z_w(1,:,:) );
        lon    = ROMS.G.lon_rho(1,:);
        lat    = ROMS.G.lat_rho(:,1);
%         zz     = zz_rho(:);       
%         lon    = ROMS.G.lon_rho(:);
%         lat    = ROMS.G.lat_rho(:);
        
%         zz  = nc_varget(OPTIONS.fileTopo,'elev');
%         lon = nc_varget(OPTIONS.fileTopo,'lon');
%         lat = nc_varget(OPTIONS.fileTopo,'lat');
        
        
end

%% load a coastline if available
if ~isfield(OPTIONS,'fileCoast') && isfield(OPTIONS,'dirCoast')

    disp('either OPTIONS.coastFile or OPTIONS.coastDir is not set, select a new file or skip.')

    list_2 = dir(['inputs' filesep 'bathymetry' filesep 'coast' filesep OPTIONS.dirCoast filesep '*.mat']);
    for ii = 1:length(list_2); 
        disp([num2str(ii),' = ',list_2(ii).name]); 
    end
    disp('0 = skip the coastline file');

    mm = input('Input number of coastline file to plot: ');

    OPTIONS.fileCoast = ['inputs' filesep 'bathymetry' filesep 'coast' filesep OPTIONS.dirCoast filesep list_2(mm).name];

%     % coastline is available, add to the plot
%     Coast = load(OPTIONS.fileCoast);

%     hold on
%     plot(Coast.lon, Coast.lat, '-k', 'LineWidth', 2)      

end

% coastline is available, add to the plot
Topo.Coast = load(['inputs' filesep 'bathymetry' filesep 'coast' filesep OPTIONS.dirCoast filesep OPTIONS.fileCoast]);
    



%% define the refinement zone

if ~isfield(OPTIONS,'aa')
    
    if ~OPTIONS.runHeadless

        % plot the topography data so user can draw a new bounding box, area of interest
        OPTIONS.hfig1 = figure;
        pcolor(lon,lat,zz);
        % Z_dar
        shading flat


        zlimits = [min(zz(:)) max(zz(:))];
        demcmap(zlimits);
        colorbar
        % caxis([-200 200]);

        title(strrep(list_1(nn).name,'_','\_'))
        xlabel('Longitude (deg)')
        ylabel('Latitude (deg)')

        % add coastline if available
        if isfield(OPTIONS,'fileCoast')
           hold on
           plot(Topo.Coast.lon, Topo.Coast.lat, '-k', 'LineWidth', 2)
        end

    %     % plot coastline if available
    %     % select the source nc file with gridded topography
    %     if ~isfield(OPTIONS,'fileCoast') && isfield(OPTIONS,'dirCoast')
    % 
    %         disp('either OPTIONS.coastFile or OPTIONS.coastDir is not set, select a new file or skip.')
    % 
    %         list_2 = dir(['inputs' filesep 'bathymetry' filesep 'coast' filesep OPTIONS.dirCoast filesep '*.mat']);
    %         for ii = 1:length(list_2); 
    %             disp([num2str(ii),' = ',list_2(ii).name]); 
    %         end
    %         disp('0 = skip the coastline file');
    % 
    %         mm = input('Input number of coastline file to plot: ');
    % 
    %         OPTIONS.fileCoast = ['inputs' filesep 'bathymetry' filesep 'coast' filesep OPTIONS.dirCoast filesep list_2(mm).name];
    % 
    %         % coastline is available, add to the plot
    %         Coast = load(OPTIONS.fileCoast);
    % 
    %         hold on
    %         plot(Coast.lon, Coast.lat, '-k', 'LineWidth', 2)      
    % 
    %     end

    %     fprintf(1, 'Select a box (2 clicks) from the NW corner to the SE corner \n');
        fprintf(1, '\n Select a box by 2 corners (2 mouse clicks) \n');
        [x,y] = ginput(2);
        
    end
    
    
    
else
    % area of interest is already determined
    x = [OPTIONS.aa(1) OPTIONS.aa(2)];
    y = [OPTIONS.aa(3) OPTIONS.aa(4)];
end

% some error checking (3 possible cases), to give correct orientation (NW to SE corners)
if     x(1) < x(2) && y(1) < y(2)
    a = x(2);
    b = x(1);
    c = y(2);
    d = y(1);
elseif x(1) > x(2) && y(1) < y(2)
    a = x(2);
    b = x(1);
    c = y(1);
    d = y(2);
elseif x(1) > x(2) && y(1) > y(2)
    a = x(2);
    b = x(1);
    c = y(2);
    d = y(1);
else
    a = x(1);
    b = x(2);
    c = y(1);
    d = y(2);
end
x = [a b];
y = [c d];
% OPTIONS.aa = [a b c d];

if ~isfield(OPTIONS, 'aa')
    
    OPTIONS.aa = [a b c d];
    
    if ~OPTIONS.runHeadless

        % draw a rectangle about the refinement zone
        hold on;
        plot([x(1) x(2)],[y(1) y(1)], '-r', 'LineWidth', 2)
        plot([x(1) x(2)],[y(2) y(2)], '-r', 'LineWidth', 2)
        plot([x(1) x(1)],[y(1) y(2)], '-r', 'LineWidth', 2)
        plot([x(2) x(2)],[y(1) y(2)], '-r', 'LineWidth', 2)

    %     % add coastline if available
    %     if isfield(OPTIONS,'fileCoast')
    %        hold on
    %        plot(Coast.lon, Coast.lat, '-k', 'LineWidth', 2)
    %     end 
        
    end
    

    
end



%% extract the refinement zone
% round to the nearest neighbor in the topo/ROMS resolution
nn_lat    = interp1(lat,lat,y,'nearest','extrap');
nn_lon    = interp1(lon,lon,x,'nearest','extrap');
% nn_lat    = interp1(lat,lat,y,'previous') % try floor instead of nearest
% nn_lon    = interp1(lon,lon,x,'previous')
% nn_lat    = interp1(lat,lat,y,'next') % try floor instead of nearest
% nn_lon    = interp1(lon,lon,x,'next')
idx_lat_1 = find(lat==nn_lat(1),1);
idx_lat_2 = find(lat==nn_lat(2),1);
idx_lon_1 = find(lon==nn_lon(1),1);
idx_lon_2 = find(lon==nn_lon(2),1);

% idx_lat_1 = find(lat==y(1),1);
% idx_lat_2 = find(lat==y(2),1);
% idx_lon_1 = find(lon==x(1),1);
% idx_lon_2 = find(lon==x(2),1);

a_lat = min(idx_lat_1,idx_lat_2);
b_lat = max(idx_lat_1,idx_lat_2);
a_lon = min(idx_lon_1,idx_lon_2);
b_lon = max(idx_lon_1,idx_lon_2);
lat   = lat(a_lat:b_lat);
lon   = lon(a_lon:b_lon);
z     = zz(a_lat:b_lat, a_lon:b_lon);

fprintf(1, '\n Area of Interest: [lon1 lon2 lat1 lat2] = [%g %g %g %g] \n',min(lon),max(lon),min(lat),max(lat));


%% now write the extracted dataset to the case directory
%  save as .mat file or .nc ?
% lon = lon;
% lat = lat;
% z   = zz;
% save(['cases' filesep OPTIONS.casename filesep OPTIONS.casename '_extracted_topography.mat'],'lon','lat','z')

% this subset is defined by the area of interest
save(['cases' filesep OPTIONS.casename filesep 'extracted_topography.mat'],'lon','lat','z')



%% Collect the output (include the topo and coast coordinates)
Topo.lon = lon;
Topo.lat = lat;
Topo.z   = z;


%%

% get the new coastline at higher resolution
% now can resample the coastline
% Create the new higher resolution coastline from the coastline file

% add the coastline raw and resampled
% [OPTIONS, Coast] = add_Coastline(OPTIONS);
% here lon, lat, z should be 2D arrays
% [LON, LAT] = meshgrid(ROMS.G.lon_rho(1,:), ROMS.G.lat_rho(:,1));
% [LON, LAT] = meshgrid(lon, lat);
% [OPTIONS, Topo] = add_Coastline(OPTIONS,LON,LAT,z);
[OPTIONS, Topo] = add_Coastline(OPTIONS,Topo);

% coast = coastline_resampled(lat,lon,z,Topo.Coast.lat, Topo.Coast.lon, OPTIONS)


% coast = coastline_resampled(lat,lon,z,x_coast, y_coast, OPTIONS)











%% PLOTS ONLY BELOW HERE


%% plot the refinement region, makie it pretty with releif shading or 3D, and coastlines/landmarks

if ~OPTIONS.runHeadless
    
    OPTIONS.hfig2 = figure;
    dem(lon,lat,z, ...
        'Legend', ...
        'LatLon', ...
        'NoDecim');
    axis([min(lon),max(lon),min(lat),max(lat)]);


    % 
    % figure
    % pcolor(new_lon,new_lat,new_zz);
    % shading flat
    % new_zlimits = [min(new_zz(:)) max(new_zz(:))];
    % demcmap(new_zlimits);
    % colorbar

    get(gca,'OuterPosition');

    % add coastline if available
    if isfield(OPTIONS,'fileCoast')
       hold on
       plot(Topo.Coast.lon, Topo.Coast.lat, '-y', 'LineWidth', 2)
    end


    switch OPTIONS.Seabed_Source
        case 'PSDEM'
            title(strrep(OPTIONS.fileTopo,'_','\_'))
        case 'ROMS'
            title(strrep(OPTIONS.fileTopo_ROMS,'_','\_'))
    end


    % title(strrep(list_1(nn).name,'_','\_'))
    xlabel('Longitude (deg)')
    ylabel('Latitude (deg)')

    % overlay the coastline
    hold on
    plot(Topo.Coast.lon_aa,Topo.Coast.lat_aa,'-y','LineWidth',2)


    %% PLOTS
    OPTIONS.hfig3 = figure;
    hold on
    % surf(lon,lat,z)
    surf(lon,lat,z)
    shading interp;
    new_zlimits = [min(z(:)) max(z(:))];
    demcmap(new_zlimits);
    hcbar = colorbar;
    ylabel(hcbar, 'elevation (meters)')

    axis vis3d
    grid on
    % axis equal
    % daspect([1 1 0.1]) % confusing in lat lon kinda

    % overlay the isobaths
    [C,h] = contour3(lon,lat,z + 2,...
                    'ShowText','on', ...
                    'LineColor',[117 74 74]./255, ...
                    'LevelStep',OPTIONS.zz_step, ...
                    'ShowText', 'on', ...
                    'LineWidth', 2, ...
                    'LabelSpacing', 100);
    % clabel(C,h,'FontSize',12,'Color',[117 74 74]./255, 'FontWeight','bold', 'LabelSpacing', 100,'LineStyle',':')
    clabel(C,h,'FontSize',12, 'FontWeight','bold', 'LabelSpacing', 100,'LineStyle',':')
    % overlay the new coastline
    % plot3(xb_coast,yb_coast,Z_bez,'-y','LineWidth',2)
    hold on
    plot(Topo.Coast.lon_aa,Topo.Coast.lat_aa,'-y','LineWidth',2)
    % plot(xb_coast,yb_coast,'-y','LineWidth',2)

    xlabel('lat (degrees)')
    ylabel('lon (degrees)')

    switch OPTIONS.Seabed_Source
        case 'PSDEM'
            title([strrep(OPTIONS.fileTopo,'_','\_') ', contours at ' num2str(OPTIONS.zz_step) ' meters'])
        case 'ROMS'
            title([strrep(OPTIONS.fileTopo_ROMS,'_','\_') ', contours at ' num2str(OPTIONS.zz_step) ' meters'])
    end


    if isempty(OPTIONS.point_x1) || isempty(OPTIONS.point_y1) 
        % now pick a single point to compute time series from ALL the ROMS files
        disp('Now click a single point on the map, to compute time series from the ROMS history files ')
        [ROMS.point_x1, ROMS.point_y1] = ginput(OPTIONS.n_points);
        
    else
        ROMS.point_x1 = OPTIONS.point_x1;
        ROMS.point_y1 = OPTIONS.point_y1;  
    end

    
    
end






% % 
% % %% create a suitable coastline
% % 
% % 
% % %% extract the variables from the NetCDF file within the specified lat/lon refinement
% % lon1        = nc_varget(OPTIONS.fileTopo,'lon');
% % lat1        = nc_varget(OPTIONS.fileTopo,'lat');
% % lonmask     = lon1>=OPTIONS.aa(1) & lon1<=OPTIONS.aa(2);
% % latmask     = lat1>=OPTIONS.aa(3) & lat1<=OPTIONS.aa(4);
% % lon         = lon1(lonmask);
% % lat         = lat1(latmask);
% % lon_nstart  = find(lon1 == lon(1));
% % lat_nstart  = find(lat1 == lat(1));
% % z           = nc_varget(OPTIONS.fileTopo,'elev',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% % % should also get the variables: velocity u,v,w (mex_cdf cannot read for some reason)
% % % u           = nc_varget(OPTIONS.fileTopo_ROMS,'u',Inf);
% % % v           = nc_varget(OPTIONS.fileTopo_ROMS,'v',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% % % w           = nc_varget(OPTIONS.fileTopo_ROMS,'w',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% % % maybe nc_varget only works on the topography files, but the ROMS version
% % % of NetCDF is different?
% % 
% % % nc_dump(OPTIONS.fileTopo)
% % 
% % % save(OPTIONS.outname,'z','lon','lat');
% % save([OPTIONS.dir_case filesep 'extracted_ROMS'],'z','lon','lat');
% % 
% % 
% % %% load the coastline file, and mask it
% % coastfile = load(['inputs' filesep 'bathymetry' filesep 'coast' filesep OPTIONS.dirCoast filesep 'pnw_coast_detailed.mat']);
% % 
% % % this works fine to remove all NaNs (I think, but also causes some
% % % problems with plotting sometimes?)
% % coastfile.lon = inpaint_nans(coastfile.lon,4);
% % coastfile.lat = inpaint_nans(coastfile.lat,4);
% % 
% % % use a buffer around the domain, to ensure that the new coastlines fall entirely within the refinement box
% % dbuf = km2deg(OPTIONS.mbuf / 1000, 'earth');
% % 
% % coast_xy   = [coastfile.lon, coastfile.lat];
% % coast_mask = coast_xy(:,1) >= OPTIONS.aa(1)-dbuf & coast_xy(:,1) <= OPTIONS.aa(2)+dbuf & ...
% %              coast_xy(:,2) >= OPTIONS.aa(3)-dbuf & coast_xy(:,2) <= OPTIONS.aa(4)+dbuf;
% % x_coast    = coast_xy(coast_mask,1);
% % y_coast    = coast_xy(coast_mask,2);
% % 
% % 
% % %% create a new coastline suitable for the CFD meshing
% % % cut-off the coastline at a specified distance (requires a coastline file)
% % % NOTE: coastline files do not change in time, meaning that a
% % % drying/wetting model is not active.  Therefore, maybe you should read
% % % the tidal elevation directly from the ROMS netcdf output (this could provide
% % % an inconvencience if somebody wants to mesh independent of the ocean model, so in 
% % % this case should provide user option to use ROMS code or just elevation data, the zero datum)
% % % Coast_Resample = plot_coastline_resampled(lat, lon, z, x_coast, y_coast, OPTIONS);
% % Coast_Resample = coastline_resampled(lat, lon, z, x_coast, y_coast, OPTIONS);
% % 
% % % Collect the output on the resampled coastline
% % Topo.Coast.x_resample = Coast_Resample.x;
% % Topo.Coast.y_resample = Coast_Resample.y;
% % Topo.Coast.z_resample = Coast_Resample.z;


