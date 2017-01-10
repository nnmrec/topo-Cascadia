function [] = Z_velvec(infile,G,S,poschar)
% 3/2/2011 Parker MacCready
%
% This adds surface velocity vectors to an existing plot.  It takes care to
% account for scaling of Cartesian lat/lon grids, so that a current to the
% NE actually points with an angle of 45 degrees on the plot.
%
% infile is the character string of the ROMS history file
% G and S are structures created by Z_get_basic_info
% poschar is the location of the SCALE ARROWS
%   'ul','ur','ll','lr' for the corners, or
%   'none' for none

hold on

u = nc_varget(infile,'u',[0 S.N-1 0 0],[1 1 -1 -1]);
v = nc_varget(infile,'v',[0 S.N-1 0 0],[1 1 -1 -1]);
aa = axis; Dlat = aa(4)-aa(3); Dlon = aa(2)-aa(1);
% this code makes an evenly spaced grid, with 100 points in the y-direction
dlat = Dlat/100; % lat spacing of regular grid
darscale = 1/cos(pi*mean(aa(3:4))/180);
[LON,LAT] = meshgrid([aa(1):dlat*darscale:aa(2)],[aa(3):dlat:aa(4)]);
uu = interp2(G.lon_u,G.lat_u,u,LON,LAT);
vv = interp2(G.lon_v,G.lat_v,v,LON,LAT);
% and plot them

ufact = Dlat/30; % automatic scaling of arrow size;
quiver(LON,LAT,ufact*uu*darscale,ufact*vv,0,'k');

% add veocity scale arrows
uscale = 1; % the velocity of the scale arrows
switch poschar
    case 'none'
        % do nothing
    otherwise
        [xt,yt] = Z_lab(poschar);
end
switch poschar
    case {'ul'}
        deltax = 0; deltay = -Dlat/20;
        quiver(xt+deltax,yt,ufact*uscale*darscale,ufact*0,0,'k');
        quiver(xt+deltax,yt,ufact*0*darscale,ufact*uscale,0,'k');
        text(xt+deltax,yt+deltay,[num2str(uscale),' m s^{-1}'],'color','k');
    case {'ur'}
        deltax = -Dlon/4; deltay = -Dlat/20;
        quiver(xt+deltax,yt,ufact*uscale*darscale,ufact*0,0,'k');
        quiver(xt+deltax,yt,ufact*0*darscale,ufact*uscale,0,'k');
        text(xt+deltax,yt+deltay,[num2str(uscale),' m s^{-1}'],'color','k');
    case {'ll'}
        deltax = 0; deltay = Dlat/20;
        quiver(xt+deltax,yt+deltay,ufact*uscale*darscale,ufact*0,0,'k');
        quiver(xt+deltax,yt+deltay,ufact*0*darscale,ufact*uscale,0,'k');
        text(xt+deltax,yt,[num2str(uscale),' m s^{-1}'],'color','k');
    case {'lr'}
        deltax = -Dlon/4; deltay = Dlat/20;
        quiver(xt+deltax,yt+deltay,ufact*uscale*darscale,ufact*0,0,'k');
        quiver(xt+deltax,yt+deltay,ufact*0*darscale,ufact*uscale,0,'k');
        text(xt+deltax,yt,[num2str(uscale),' m s^{-1}'],'color','k');
    case 'none'
        % do nothing
end
