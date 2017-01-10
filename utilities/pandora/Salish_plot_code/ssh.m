function [] = ssh(Tdir,infile,basename,tt)
%
% plots SSH: to visualize tides
% 8/19/2013  Parker MacCready

% get file info
[G,S,T]=Z_get_basic_info(infile);

% plot ssh
eta = nc_varget(infile,'zeta');
surfl(G.lon_rho,G.lat_rho,eta)
aa = axis;
axis([aa(1:4) -3 3])
shading flat
colormap copper
lighting phong
set(gca,'DataAspectRatio',[1.46628 1 15]);
%set(gca,'view',[-209 34]);
set(gca,'view',[55 34]);

% add labels
title('Sea Surface Height (m)','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')


