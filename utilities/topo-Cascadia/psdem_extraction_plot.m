% psdem_extraction_plot.m  5/4/2011  Parker MacCready
% modified: 4/5/2016 Danny Sale
% this plots extracted bathy files

clear all
close all
clc

% add the Pandora functions to search path
addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/pandora')
addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/pandora/Z_functions')
addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/haxby/')
% addpath('/mnt/data-RAID-10/danny/ROMS/pandora')
% addpath('/mnt/data-RAID-10/danny/ROMS/pandora/Z_functions')

% choose an output file to look at
list_1 = dir('*.mat');
for ii = 1:length(list_1); 
    disp([num2str(ii),' = ',list_1(ii).name]); 
end
nn = input('Input number of file to plot: ');
infile = list_1(nn).name;

load(infile);

Z_fig
colormap(jet(14));

%figure
pcolor(lon,lat,z);
Z_dar
shading flat
caxis([-200 200]);
colorbar
aa = axis;

Z_addcoast('detailed')

title(strrep(infile,'_','\_'))
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')