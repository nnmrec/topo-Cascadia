function [] = basic_zslice(Tdir,infile,basename,tt)
%
% plots Salish simulations, focused on the JdF eddy
% 11/6/2011  Parker MacCready
%


figh = gca...; % the handle of the newly created figure

if isunix()
    set(figh, 'Units', 'pixels');
    posn = get(figh, 'Position');

    % This attempts to work around the Matlab bug where an exception is
    % throw when exporting graphics if the figure window is not on the
    % primary monitor. The exception is:
    %
    % java.lang.IllegalArgumentException: adding a container to a container on a different GraphicsDevice
    %   at java.awt.Component.checkGD(Unknown Source)
    % 	at java.awt.Container.addImpl(Unknown Source)
    % 	at java.awt.Container.add(Unknown Source)
    % 	at com.mathworks.hg.peer.FigurePanel.doAdd(FigurePanel.java:215)
    % 	at com.mathworks.hg.peer.FigurePanel.assembleFigurePanel(FigurePanel.java:203)
    % 	at com.mathworks.hg.peer.FigurePanel.reconstructFigurePanel(FigurePanel.java:131)
    % 	at com.mathworks.hg.peer.FigurePanel.handleNotification(FigurePanel.java:88)
    %   ... [trimmed]
    %
    % The workaround is to identify the "primary monitor" according to
    % Java AWT, and then place the figure on that monitor.

    % Find the primary monitor
    screens = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices();
    primary = screens(1); % assume primary monitor is first in the array
    bounds = primary.getDefaultConfiguration().getBounds();

    % bounds is a java.awt.Rectangle object
    x = bounds.x;
    y = bounds.y;
    width = bounds.width;
    height = bounds.height;

    % Center the figure on this same window
    posn(1:2) = [(x + width/2 - posn(3)/2), (y + height/2 - posn(4)/2)];
    set(figh, 'Position', posn);
end


% uses stored results of zslice_preprocess, which are here
slicedir = [Tdir.pan_results,'zslice/'];

[G,S,T]=Z_get_basic_info(infile);
hh = G.h;
hh(~G.mask_rho) = -10;

var = 'salt';
% var = 'u';
% var = 'v';
switch var
    case {'salt';'temp'}
        whichgrid = 'rho';
    case {'u'}
        whichgrid = 'u';
    case {'v'}
        whichgrid = 'v';
end

s = squeeze(nc_varget(infile,'salt'));
% s = squeeze(nc_varget(infile,'u'));
% s = squeeze(nc_varget(infile,'v'));
sbot = s(1,:,:);
stop = s(end,:,:);
sfull = cat(1,sbot,s,stop);
s0 = squeeze(stop);

cvec = [30 34];
subplot(131)
% pcolorcen(G.lon_rho,G.lat_rho,s0);
Z_pcolorcen(G.lon_rho,G.lat_rho,s0);
shading flat
caxis(cvec);
colorbar('North');
title('Surface Salinity','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
Z_dar;
Z_info(basename,tt,T,'lr')
hold on
contour(G.lon_rho,G.lat_rho,hh,[0 0],'-k');
contour(G.lon_rho,G.lat_rho,hh,[200 200],'-k');

zlev_vec = [-30 -50 -250];
for ii = 1:length(zlev_vec)
    zlev = zlev_vec(ii);
    load([slicedir,'zslice_',basename,'_',num2str(-zlev), ...
        '_',whichgrid,'.mat']);
    s1 = squeeze(sum(sfull.*interpmat));
    %
    subplot(1,3,ii+1)
%     pcolorcen(G.lon_rho,G.lat_rho,s1);
    Z_pcolorcen(G.lon_rho,G.lat_rho,s1);
    shading flat
    caxis(cvec);
    title([num2str(-zlev),' m Salinity'],'fontweight','bold')
    xlabel('Longitude (deg)')
    Z_dar;
    hold on
    contour(G.lon_rho,G.lat_rho,hh,[0 0],'-k');
    contour(G.lon_rho,G.lat_rho,hh,[200 200],'-k');
end






