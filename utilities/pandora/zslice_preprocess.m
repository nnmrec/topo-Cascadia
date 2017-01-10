% zslice_preprocess.m  11/6/2011  Parker MacCready
%
% creates "interpmat" files for a given run at specified depths on all
% three grids

clear
close all

Tdir = pan_start;

% choose files to plot
disp('********* zslice_proprocess.m ********************************')
disp(' ')
% indir = '/Users/PM/Documents/Salish/runs/';
indir = '/mnt/data-RAID-1/danny/ROMS/ainlet_2006_3/';

slicedir = [Tdir.pan_results,'zslice/'];
if ~exist(slicedir,'dir'); mkdir(slicedir); end;

% choose which run to use, and set the basename
[fn,pth]=uigetfile([indir,'*.nc'], 'Select a NetCDF file...');
% assume that "pth" is something like:
% /Users/PM/Documents/Salish/runs/ptx_med_2005_1/OUT/
% then this finds the string right before "OUT"
ind = strfind(pth,'/');
basename = pth(ind(end-2)+1:ind(end-1)-1);
disp(' '); disp(['basename = ',basename]); disp(' ')

infile = [pth,fn];

% make the interpolation matrices, if needed
zlev_vec = [-25 -50 -75];
whichgrid_vec = {'rho';'u';'v'};
for gg = 1:length(whichgrid_vec)
    whichgrid = whichgrid_vec{gg};
    for ii = 1:length(zlev_vec)
        zlev = zlev_vec(ii);
        disp(['Making interpmat for zlev = ',num2str(zlev), ...
            ' on the ',whichgrid,' grid']);
        [interpmat] = Z_zslice(infile,zlev,whichgrid);
        save([slicedir,'zslice_',basename,'_',num2str(-zlev), ...
            '_',whichgrid,'.mat'],'interpmat');
    end
end

disp('DONE')