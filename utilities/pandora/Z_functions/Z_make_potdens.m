function [potdens] = Z_make_potdens(salt,temp)
% 12/16/2011 Parker MacCready
%
% this calculates the potential density from 3D arrays of salinity and
% temperature and depth

[N,M,L] = size(salt);

% new version 12/16/2011 realizing (duh) that the "temp" variable stored by
% ROMS history files IS the potential temperature - according to its long
% name (also this runs twice as fast as the old version)
for ii = 1:N
    this_salt = squeeze(salt(ii,:,:));
    this_temp = squeeze(temp(ii,:,:));
    potdens(ii,:,:) = sw_dens(this_salt,this_temp,0);
end
