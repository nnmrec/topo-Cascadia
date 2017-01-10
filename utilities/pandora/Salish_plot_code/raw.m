function [] = raw(Tdir,infile,basename,tt)
%
% plots Salish simulations, plots some fields for debugging
% 10/8/2012  Parker MacCready

% get file info
[G,S,T]=Z_get_basic_info(infile);
cbl = 'Eastoutside';

%varlist = {'salt','temp','zeta','u','v','svstr'};
varlist = {'shflux','latent','sensible','lwrad','swrad','svstr'};
for ii = 1:length(varlist)
    var = varlist{ii};
    switch var % get the right lon and lat
        case {'salt','temp','zeta', ...
                'shflux','latent','sensible','lwrad','swrad'}
            lon = G.lon_rho; lat = G.lat_rho;
        case {'u','ubar','sustr'}
            lon = G.lon_u; lat = G.lat_u;
        case {'v','vbar','svstr'}
            lon = G.lon_v; lat = G.lat_v;
    end
    switch(var) % account for 3D or 2D
        case {'salt','temp','u','v'}
            v0 = nc_varget(infile,var,[0 S.N-1 0 0],[1 1 -1 -1]);
        case {'zeta','ubar','vbar','sustr','svstr', ...
                'shflux','latent','sensible','lwrad','swrad'}
            v0 = nc_varget(infile,var,[0 0 0],[1 -1 -1]);
    end
    switch var % set the color limits
        case 'salt'; cvec = [23 33];
        case 'temp'; cvec = [8 18];
        case 'zeta'; cvec = [-2 2];
        case {'u','v','ubar','vbar'}; cvec = [-1 1];
        case {'sustr','svstr'}; cvec = [-1 1];
        case {'shflux','latent','sensible','lwrad','swrad'}
            cvec = [-100 500];
    end
    subplot(2,3,ii)
    Z_pcolorcen(lon,lat,v0);
    colorbar(cbl);
    caxis(cvec);
    Z_dar;
    title(var)
end
