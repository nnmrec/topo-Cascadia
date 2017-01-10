function [] = basicPS_Fb_a(Tdir,infile,basename,tt)
%
% plots buoyancy flux per unit area over
% the full domain, andin Puget Sound
%
% 11/6/2011  Parker MacCready

% get file info
[G,S,T]=Z_get_basic_info(infile);

% plot Fb_a
Fb_a = Z_make_Fb_a(infile);
Fb10 = Fb_a;
Fb10(Fb10<=0) = 1.e-6;
Fb10 = log10(Fb10);

Fb10 = double(Fb10); %needed for the PNWTOX output

% Full domain
subplot(121)
pcolor(G.lon_rho,G.lat_rho,Fb10);
shading interp
cvec = [-3 -1.3]; caxis(cvec);
Z_dar;
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
Z_addcoast('regional',Tdir.coast);

% Puget Sound
subplot(122)
pcolor(G.lon_rho,G.lat_rho,Fb10);
axis([-123.8 -122 47 48.9]);
shading interp
caxis(cvec);
colorbar('Eastoutside');
Z_dar;
title('log10(Fb) (W m^{-2}) ','fontweight','bold')
xlabel('Longitude (deg)')
Z_info(basename,tt,T,'ll');
Z_addcoast('combined',Tdir.coast);
