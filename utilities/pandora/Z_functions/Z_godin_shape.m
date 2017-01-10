function [filter] = Z_godin_shape
% 4/8/2013  Parker MacCready
%
% Returns a 71 element column vector that is the weights
% for the Godin 24-24-25 tildal averaging filter.
%
% ** use ONLY with hourly data! **
    
% This is the shape given in Emery and Thomson (1997) Eqn. (5.10.37)
k = [0:11];
filter = NaN * ones(71,1);
filter(36:47) = (0.5/(24*24*25))*(1200-(12-k).*(13-k)-(12+k).*(13+k));
k = [12:35];
filter(48:71) = (0.5/(24*24*25))*(36-k).*(37-k);
filter(1:35) = flipud(filter(37:71));
