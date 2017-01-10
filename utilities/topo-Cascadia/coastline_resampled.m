function coast = coastline_resampled(lat,lon,z,x_coast, y_coast, OPTIONS)
%%
coast_offset = OPTIONS.coast_offset;
resample_factor = OPTIONS.resample_factor;
resample_factor_bz = OPTIONS.resample_factor_bz;
% z0 = OPTIONS.z0;
% zz_step = OPTIONS.zz_step;
aa = OPTIONS.aa;

%%

% this file works in lon/lat coordinate system to manipulate the coastline of the mesh

deg_offset = km2deg(coast_offset / 1000, 'earth');

% re-sample the "true coastline" before normal projection
coast_xy_pt = interparc(resample_factor*numel(x_coast),x_coast, y_coast,'spline');


% see here: http://blogs.mathworks.com/pick/2015/05/08/how-do-you-create-a-mask-from-a-variable-thickness-open-freehand-curve/
N       = LineNormals2D(coast_xy_pt);
N       = inpaint_nans(N,4);  % just to be safe, although should not produce any NaNs
x_neg   = coast_xy_pt(:,1) - N(:,1)*deg_offset;
y_neg   = coast_xy_pt(:,2) - N(:,2)*deg_offset;
x_pos   = coast_xy_pt(:,1) + N(:,1)*deg_offset;
y_pos   = coast_xy_pt(:,2) + N(:,2)*deg_offset;

%% figure out which coastline is land or water, then use the "water" one
% Z_o   = z0.*ones(size(x_coast));
% Z_pt  = z0.*ones(size(coast_xy_pt(:,1)));
Z_neg = interp2(lon, lat, z, x_neg, y_neg);
Z_neg = inpaint_nans(Z_neg,4);                      
Z_pos = interp2(lon, lat, z, x_pos, y_pos);
Z_pos = inpaint_nans(Z_pos,4);                        

elev_in  = sum(Z_neg);
elev_out = sum(Z_pos);
if elev_in < elev_out
    % splash splash 
    coast_newX = x_neg;
    coast_newY = y_neg;
    else
    % landlubbers
    coast_newX = x_pos;
    coast_newY = y_pos;   
end
  
%% now smooth out the "new" coastline, Bezier or Akima curve seems reasonable
[coast_xy_bez, ~] = bezier_([coast_newX, coast_newY], resample_factor_bz*numel(coast_newX), []);

% mask off the "final coastline"
coast_maskb = coast_xy_bez(:,1) >= aa(1) & coast_xy_bez(:,1) <= aa(2) & ...
              coast_xy_bez(:,2) >= aa(3) & coast_xy_bez(:,2) <= aa(4);
xb_coast    = coast_xy_bez(coast_maskb,1);
yb_coast    = coast_xy_bez(coast_maskb,2);

Z_bez = interp2(lon, lat, z, xb_coast, yb_coast);
Z_bez = inpaint_nans(Z_bez,4);

%% now we have a comparison of the original coastline file to the "smoothed"
% verions and the projected depth of the new coastline
% see if the coastlines look okay

% this plot is for debugging ... not prettyness
% figure
% hold on
% lw = 2;
% plot3(         x_coast, y_coast, Z_o, 'x-g', 'LineWidth',lw)
% plot3(coast_xy_pt(:,1), coast_xy_pt(:,2), Z_pt, '>-k', 'LineWidth',lw)
% plot3(x_neg, y_neg, Z_neg, 'o-m', 'LineWidth',lw)
% plot3(x_pos, y_pos, Z_pos, '*-y', 'LineWidth',lw)
% plot3(xb_coast, yb_coast, Z_bez, '^-b', 'LineWidth',lw)
% surf(lon,lat,z)
% shading interp;
% new_zlimits = [min(z(:)) max(z(:))];
% demcmap(new_zlimits);
% alpha(.4)
% 
% legend('original coastline file','resampled coastline file','projection negative','projection positive','Bezier interpolated coastline')


% %% make a nice plot in lat/lon coords
% OPTIONS.hfig3 = figure;
% hold on
% surf(lon,lat,z)
% shading interp;
% new_zlimits = [min(z(:)) max(z(:))];
% demcmap(new_zlimits);
% hcbar = colorbar;
% ylabel(hcbar, 'elevation (meters)')
% 
% axis vis3d
% grid on
% % axis equal
% % daspect([1 1 0.1]) % confusing in lat lon kinda
% 
% % overlay the isobaths
% [C,h] = contour3(lon,lat,z + 2,...
%                 'ShowText','on', ...
%                 'LineColor',[117 74 74]./255, ...
%                 'LevelStep',zz_step, ...
%                 'ShowText', 'on', ...
%                 'LineWidth', 2, ...
%                 'LabelSpacing', 100);
% % clabel(C,h,'FontSize',12,'Color',[117 74 74]./255, 'FontWeight','bold', 'LabelSpacing', 100,'LineStyle',':')
% clabel(C,h,'FontSize',12, 'FontWeight','bold', 'LabelSpacing', 100,'LineStyle',':')
% % overlay the new coastline
% % plot3(xb_coast,yb_coast,Z_bez,'-y','LineWidth',2)
% plot(xb_coast,yb_coast,'-y','LineWidth',2)
% 
% xlabel('lat (degrees)')
% ylabel('lon (degrees)')
% title([strrep(OPTIONS.fileTopo,'_','\_') ', contours at ' num2str(zz_step) ' meters'])
% 
% % overlay the new coastline
% set(0, 'currentfigure', OPTIONS.hfig2);  % for figures
% hold on
% plot(xb_coast,yb_coast,'-y','LineWidth',2)
% 
% % % Also add to the other figure
% figure(OPTIONS.hfig2)
% hold on
% plot(xb_coast,yb_coast,'-y','LineWidth',2)

%% adjust the lighting and releif shading
% disp('now running SHADEM.  press mouse click to adjust lighting, then press enter to continue')
% shadem('ui')  %% click click click, then press enter ... or learn all the keyboard shortcuts ;)

% figure;
% dem(lon,lat,z, ...
%     'Legend', ...
%     'LatLon', ...
%     'NoDecim');




%% finally, try to flatten out the coastline between the original coastline file and the new coastline
% how to make a vertical face at the Bezier coastline?
% I could not think of any clever way except a loop
% z_mod = z;
% for ii = 1:size(z,1)
%     for jj = 1:size(z,2)
%                       
%             d          = ipdm([xb_coast, yb_coast],[lon(jj), lat(ii)]);
%             [~, dind]  = min(d);
%             zref_coast = Z_bez(dind);
%             
%             if z(ii,jj) > zref_coast && z(ii,jj) < z0
%                 z_mod(ii,jj) = z0;
%             end   
%     end   
% end



%% collect outputs
coast.lon = xb_coast;
coast.lat = yb_coast;
% coast.x   = xb_coast;
% coast.y   = yb_coast;
coast.z   = Z_bez;

%% MISC examples, leftover stuff
%  convert meters to the corners of the bounding box in lat/lon, using: http://www.mathworks.com/matlabcentral/fileexchange/38812-latlon-distance
% [d1km, d2km] = lldistkm([aa(3),aa(1)],[aa(4),aa(2)]);
% d1m          = d1km*1000;
% d2m          = d2km*1000;
% dm           = mean([d1m, d2m]);
% % these numbers seem reasonable, think it works fine ...

