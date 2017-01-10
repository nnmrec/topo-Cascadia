function [] = rst(Tdir,infile,basename,tt)
%
% plots fields from a ROMS restart file
% 10/8/2012  Parker MacCready

% get file info
G = Z_get_grid_info(infile);
cbl = 'Eastoutside';

zeta = nc_varget(infile,'zeta');
ubar = nc_varget(infile,'ubar');
vbar = nc_varget(infile,'vbar');

% NOTES on variable sizes in the restart file
% 2D variables have 4 dimensions:
% Dimension 1: time, generally 3 levels (last two restart save times,
% and the time of the crash)
% Dimension 2: this is "two" or "three" with unknown meaning, e.g. zeta
% uses "three" while "rzeta" uses "two"
% Dimensions 3 & 4: eta & xi (y and x)
%
% 3D variables also have a 5th dimension (before eta) for vertical level

% always get the third time (the crash)
z1 = squeeze(zeta(3,1,:,:));
z2 = squeeze(zeta(3,2,:,:));
z3 = squeeze(zeta(3,3,:,:));
ub1 = squeeze(ubar(3,1,:,:));
vb2 = squeeze(vbar(3,1,:,:));

z3 = z3-z2;
z2 = z2-z1;


varlist = {'z1','z2','z3'};
for ii = 1:length(varlist)
    varname = varlist{ii};
    var = [];
    eval(['var = ',varname,';']);
    switch varname % get the right lon and lat
        case {'z1','z2','z3'}
            lon = G.lon_rho; lat = G.lat_rho;
        case {'u3'}
            lon = G.lon_u; lat = G.lat_u;
        case {'v3'}
            lon = G.lon_v; lat = G.lat_v;
    end
    subplot(1,length(varlist),ii)
    if 1
        pcolor(lon,lat,var);
        Z_dar;
    else
        pcolor(lon,lat,var);
    end
    shading flat
    % caxis([-1 2]);
    colorbar(cbl);
    title(varname)
    hold on
    imax = find(var(:)==max(var(:)))
    imin = find(var(:)==min(var(:)))
    llon = lon(:); llat = lat(:);
    plot(llon(imax),llat(imax),'*k');
    plot(llon(imin),llat(imin),'ok');
    plot(lon(143,109),lat(143,109),'pk')
end
