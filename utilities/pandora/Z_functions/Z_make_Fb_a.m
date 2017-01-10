function [Fb_a] = Z_make_Fb_a(infile)
% 12/16/2011 Parker MacCready
%
% this makes a lat,lon array of turbulent buoyancy flux per unit area
% (units W m-2) for a given infile
%
% uses new Z_make_potdens as of 12/16/2011

salt =  nc_varget(infile,'salt');
temp =  nc_varget(infile,'temp');
[rho] = Z_make_potdens(salt,temp);

% form drhodz
Drho = diff(rho); % on the w grid (no top and bottom)
% then get the diffusivity
K = nc_varget(infile,'AKs'); % also on the w grid
% form Fb
g = 9.8;

% vertical integration
Fb_a = -g * squeeze(sum(K(2:end-1,:,:).*Drho));
