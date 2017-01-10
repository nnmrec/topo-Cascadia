function [] = strat(Tdir,infile,basename,tt)
%
% Plots Salish simulations, making maps of the stratification
% this is done by finding the depth at which the potential density is
% a specified amount (say 1 kg m-3) greater than the value closest to the
% surface.
%
% I chose this method for defining stratification as being the one most
% likely to correlate with patterns of Chl that are influenced by surface
% stratification or mixed layer thickness.
%
% 9/6/2012  Parker MacCready

%% get file info
[G,S,T]=Z_get_basic_info(infile);

% get fields
temp = nc_varget(infile,'temp'); % potential temperature
salt = nc_varget(infile,'salt'); % salinity
z = roms_z(G.h,0*G.h,S.Cs_r); % z (assuming a flat free surface)
sig = Z_make_potdens(salt,temp) - 1000; % sigma0 (kg m-3)

% make a mask to define stratified waters
Dsig = squeeze(sig(end,:,:)-sig(1,:,:));
% top to bottom density difference (negative = stable)
strat_mask = G.mask_rho; % make a new mask (1=stratified, 0=not, or land)
% mask begins as all water = 1
strat_mask(Dsig > -0.1) = 0; % cutoff = -0.1 kg m-3
strat_mask = logical(strat_mask);
% now only "stratified" water is 1

%% initialize results matrix
DD = NaN * G.h; % Depth of "surface layer"

% calculate the depth DD
DRcrit = 0.5; % potential density difference from the topmost value used to
            % define the "surface layer" (kg m-3)
for ii = 1:G.L
    for jj = 1:G.M
        if strat_mask(jj,ii)
            this_sig = squeeze(sig(:,jj,ii));
            this_sigp = this_sig-this_sig(end); % density anomaly (positive)
            nz = [];
            nz = find(this_sigp>=DRcrit,1,'last');
            if ~isempty(nz)
                DD(jj,ii) = -squeeze(z(nz,jj,ii)); % surface layer depth
            else
                continue % skip the point - it is not stratified enough
            end
        end
    end
end

%% plot results
aa = [-125.5 -122 46 49.5];
aa1 = [-123.3 -122.1 47 48.3];

% plot ZZ
subplot(121)
pcolorcen(G.lon_rho,G.lat_rho,DD);
axis(aa);
cvec = [0 50]; caxis(cvec);
colorbar('Eastoutside');
% fix scaling
Z_dar;
% add labels
title('(a) Surface Layer Depth (SLD) (m)','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
% add file info
Z_info(basename,tt,T,'lr');
% add coastline
Z_addcoast('combined',Tdir.coast);

% plot ZZ close up
subplot(122)
pcolorcen(G.lon_rho,G.lat_rho,DD);
axis(aa1);
caxis(cvec);
% fix scaling
Z_dar;
% add labels
title('(b) SLD in Puget Sound (m)','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
% add coastline
Z_addcoast('combined',Tdir.coast);
[xt,yt] = Z_lab('lr');
text(xt,yt,['\Delta\rho = ',num2str(DRcrit),' (kg m^{-3})'], ...
    'horizontalalignment','r');
