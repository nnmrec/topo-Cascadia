function [dens] = Z_make_dens(salt,temp,z,lat)
% 3/8/2011 Parker MacCready
%
% this calculates the in situ density from 3D arrays of salinity and
% temperature and depth

% assuming salt, temp, and z_rho are all of size [N,M,L] then
% lat (deg) is a matrix of size [M,L]

dens = NaN * z;
[N,M,L] = size(z);

for ii = 1:N
    this_depth = -squeeze(z(ii,:,:));
    this_salt = squeeze(salt(ii,:,:));
    this_temp = squeeze(temp(ii,:,:));
    this_pres = sw_pres(this_depth,lat);
    dens(ii,:,:) = sw_dens(this_salt,this_temp,this_pres);
end
