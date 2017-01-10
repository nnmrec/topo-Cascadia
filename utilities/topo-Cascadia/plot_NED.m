% function OPTIONS = plot_NED(NED, Coast, OPTIONS)
function OPTIONS = plot_NED(yEast,xNorth,zDown, Coast, OPTIONS)
%plot_NED plots the topography in pretty plot fashion

% yEast  = NED.Topo.yEast;
% xNorth = NED.Topo.xNorth;
% zDown  = NED.Topo.zDown;

%% plot it all up in the NED system
OPTIONS.hfig_NED = figure;
hold on

% NOTE: using shadem seems to not work in kilometers, as opposed to dem



% % put into kilometers:
% km_yEast  = yEast./1000;
% km_xNorth = xNorth./1000;


% switch typeDEM
%     case 'dem'
%         
%         
%         dem(km_yEast(1,:), km_xNorth(:,1), zDown, ...
%             'Legend', ...
%             'km', ...
%             'NoDecim');
%         % dem(yEast(1,:)./1000, xNorth(:,1)./1000, zDown, ...
%         %     'Legend', ...
%         %     'LatLon', ...
%         %     'NoDecim');
%         
%     case 'shadem'
% %         turb.x1 = turb.x1./1000;
%         surf(km_yEast, km_xNorth, zDown)
%         shading interp;
% %         new_zlimits = [min(zDown(:)) max(zDown(:))];
% %         demcmap(new_zlimits);
% %         cmapsea  = [.8  0 .8;  0 0 .8];
%        
% % OPTIONS.hfig_NED = figure;
% % hold on
% 
% % typeDEM = 'dem';
% % typeDEM = 'shadem';
% 
% 
% % % put into kilometers:
% % km_yEast  = yEast./1000;
% % km_xNorth = xNorth./1000;
% 

switch OPTIONS.typeDEM
    case 'dem'
        % put into kilometers:
        km_yEast  = yEast./1000;
        km_xNorth = xNorth./1000;

        
        dem(km_yEast(1,:), km_xNorth(:,1), zDown, ...
            'Legend', ...
            'km', ...
            'NoDecim');
        % dem(yEast(1,:)./1000, xNorth(:,1)./1000, zDown, ...
        %     'Legend', ...
        %     'LatLon', ...
        %     'NoDecim');
        
        xlabel('Easting (kilometers)')
        ylabel('Northing (kilometers)')
        
    case 'shadem'
%         turb.x1 = turb.x1./1000;
%         surf(km_yEast, km_xNorth, zDown)
        surf(yEast, xNorth, zDown)        
        shading interp;
%         new_zlimits = [min(zDown(:)) max(zDown(:))];
%         demcmap(new_zlimits);
%         cmapsea  = [.8  0 .8;  0 0 .8];
%         cmapland = [255 228 188; 76 153  0; 102 51 0 ]./255;
%         cmapland = [102 51 0; 76 153  0; 255 228 188 ]./255;
%         demcmap(zDown,11,cmapsea,cmapland)
%         demcmap(zDown,32,[],cmapland)
%         demcmap('inc',[max(zDown(:)) min(zDown(:))],10,[],cmapland);
%         hcbar = colorbar;
%         ylabel(hcbar, 'elevation (meters)')
        cmapland = [255 228 188; 76 153  0; 102 51 0 ]./255;
%         cmapland = [102 51 0; 76 153  0; 255 228 188 ]./255;
%         demcmap(zDown,11,cmapsea,cmapland)
        demcmap(zDown,42,[],cmapland)
%         demcmap('inc',[max(zDown(:)) min(zDown(:))],10,[],cmapland);
        hcbar = colorbar;
        ylabel(hcbar, 'elevation (meters)')
        
%         axis equal
%         axis([min(km_yEast(:)),max(km_yEast(:)),min(km_xNorth(:)),max(km_xNorth(:))]);
        axis([min(yEast(:)),max(yEast(:)),min(xNorth(:)),max(xNorth(:))]);
        axis equal
        axis tight
        box on
        grid on
       
        
        axis vis3d
        
        xlabel('Easting (meters)')
        ylabel('Northing (meters)')
        
        % adjust the lighting and releif shading
        daspect([1 1 0.1])
        
        
        disp('now running SHADEM.  press mouse click to adjust lighting, then press enter to continue')
        shadem('ui')  %% click click click, then press enter ... or learn all the keyboard shortcuts ;)
        
%         
        
%         
        hold on
        offset = 2;
        [C,h] = contour3(yEast, xNorth, zDown + offset,...
                'ShowText','on', ...
                'LineColor',[117 74 74]./255, ...
                'LevelStep',OPTIONS.zz_step, ...
                'ShowText', 'on', ...
                'LineWidth', 2);
        clabel(C,h,'FontSize',12,'Color',[117 74 74]./255, 'FontWeight','bold', 'LabelSpacing', 300,'LineStyle',':')
        % overlay the new coastline
%         plot3(NED.Coast.yEast, NED.Coast.xNorth, NED.Coast.zDown,'-y','LineWidth',2)
        zbuff = 5;
        plot3(Coast.yEast, Coast.xNorth, Coast.zDown + zbuff,'-y','LineWidth',2)
%         hold on
%         plot(Coast.yEast ./ 1000, Coast.xNorth ./ 1000, '-y','LineWidth',2)
        
        
        
end




% overlay the isobaths
% [C,h] = contour3(yEast, xNorth, zDown,...
%                 'ShowText','on', ...
%                 'LineColor',[117 74 74]./255, ...
%                 'LevelStep',OPTIONS.zz_step, ...
%                 'ShowText', 'on', ...
%                 'LineWidth', 2);
% [C,h] = contour3(km_yEast, km_xNorth, -1.*zDown,...
%                 'ShowText','on', ...
%                 'LineColor',[117 74 74]./255, ...
%                 'LevelStep',OPTIONS.zz_step, ...
%                 'ShowText', 'on', ...
%                 'LineWidth', 2);
% clabel(C,h,'FontSize',12,'Color',[117 74 74]./255, 'FontWeight','bold', 'LabelSpacing', 100,'LineStyle',':')
% % overlay the new coastline
% % plot3(Coast.yEast ./ 1000, Coast.xNorth ./ 1000, Coast.zDown,'-y','LineWidth',2)
% hold on
% plot(Coast.yEast ./ 1000, Coast.xNorth ./ 1000, '-y','LineWidth',2)

% xlabel('Easting (kilometers)')
% ylabel('Northing (kilometers)')



switch OPTIONS.Seabed_Source
    case 'PSDEM'
        title([strrep(OPTIONS.fileTopo,'_','\_') ', North-East-Down (NED), contours at ' num2str(OPTIONS.zz_step) ' meters'])
    case 'ROMS'
        title([strrep(OPTIONS.fileTopo_ROMS,'_','\_') ', North-East-Down (NED), contours at ' num2str(OPTIONS.zz_step) ' meters'])
end

% axis vis3d
box on
% grid on
% axis equal
% axis tight
% daspect([1 1 0.1])

% set(gca,'FontSize', 20)

%%


%%


end

