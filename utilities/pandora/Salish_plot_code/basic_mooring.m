function [] = basic_mooring(Tdir,infile,basename,tt,riv,mod_moor)
% 12/7/2011  Parker MacCready
%
% plots Salish simulations, a generic plot of the full domain, with time
% series for context

% get file info
[G,S,T]=Z_get_basic_info(infile);

% plot salinity
s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);
subplot(131)
pcolor(G.lon_rho,G.lat_rho,s0);
shading interp
cvec = [26 32]; caxis(cvec);
colorbar('Northoutside');
% fix scaling
Z_dar;
% add labels
title('(a) Surface Salinity','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
% add file info
Z_info(basename,tt,T,'lr');
% add coastline
Z_addcoast('combined',Tdir.coast);
% plot moring location
hold on
plot(mod_moor.p_lon,mod_moor.p_lat,'pk','markersize',15, ...
    'markerfacecolor','w')

% plot temperature
t0 = nc_varget(infile,'temp',[0 S.N-1 0 0],[1 1 -1 -1]);
subplot(132)
pcolor(G.lon_rho,G.lat_rho,t0);
shading interp
cvec = [10 18]; caxis(cvec);
colorbar('Northoutside');
% fix scaling
Z_dar;
% add labels
title('(b) Surface Temperature','fontweight','bold')
xlabel('Longitude (deg)')
% add coastline
Z_addcoast('combined',Tdir.coast);

% useful for time plottting
year = datestr(T.time_datenum,'yyyy'); % char
td0 = datenum(str2num(year),1,1,0,0,0);

% plot a river time series
rname = 'fraser';
iriv = strmatch(rname,riv.rname,'exact');
riv_name = riv.rname{iriv};
riv_qr = riv.Qr_flow(iriv,:)/1e3;
subplot(3,3,3)
plot(riv.Qr_yearday,riv_qr,'-b','linewidth',2);
xlim([0 365]);
ylim([0 ceil(max(riv_qr))]);
hold on; aa = axis;
plot((T.time_datenum - td0)*[1 1],[aa(3) aa(4)],'-r','linewidth',2)
[xt,yt] = Z_lab('ul');
text(xt,yt,'(c) Q_{R} (10^3 m^{3} s^{-1})','verticalalignment','top');
datetick('x','m','keeplimits');
rname(1) = upper(rname(1));
title([rname,' River'])
box on

% plot a windstress time series
svs = Z_dasfilt(mod_moor.svstr,'godin');
subplot(3,3,6)
plot(mod_moor.td-td0,svs,'-k','linewidth',2);
xlim([0 365]);
ylim([-.3 .6]);
hold on; plot([0 365],[0 0],'-k');
hold on; aa = axis;
plot((T.time_datenum - td0)*[1 1],[aa(3) aa(4)],'-r','linewidth',2)
[xt,yt] = Z_lab('ul');
text(xt,yt,'(d) \tau^{y} (Pa)','verticalalignment','top');
datetick('x','m','keeplimits');
box on

% plot tidal state
zeta = mod_moor.zeta;
zrms = sqrt(Z_dasfilt(zeta.^2,'godin'));
subplot(3,3,9)
plot(mod_moor.td-td0,zrms,'-b','linewidth',2);
xlim([0 365]);
ylim([0 2]);
hold on; aa = axis;
plot((T.time_datenum - td0)*[1 1],[aa(3) aa(4)],'-r','linewidth',2)
xlabel(['Date ',year]);
[xt,yt] = Z_lab('ul');
text(xt,yt,'(e) \eta_{RMS} (m)','verticalalignment','top');
datetick('x','m','keeplimits');
box on



