function [Tdir] = pan_start
% 12/7/2011  Parker MacCready
% invoke this at the start of any primary code in pandora

% Assuming that it is a character array (string), like in

dirname = pwd ;

% you can use
parentdir = fileparts(dirname);

% set global paths and directories
% addpath('../alpha/'); Tdir = toolstart;
addpath('../alpha/'); Tdir = toolstart;

% add path of user plot code
addpath('../pandora_user/plot_code/');

% add pandora-specific folders to Tdir, and make sure they exist
Tdir.pan_top = [Tdir.output,'pandora_out/'];
if ~exist(Tdir.pan_top,'dir'); 
    mkdir(Tdir.pan_top); 
end;

Tdir.pan_fig = [Tdir.pan_top,'Figures/'];
if ~exist(Tdir.pan_fig,'dir'); 
    mkdir(Tdir.pan_fig); 
end;

Tdir.pan_mov = [Tdir.pan_top,'Movies/'];
if ~exist(Tdir.pan_mov,'dir'); 
    mkdir(Tdir.pan_mov); 
end;

Tdir.pan_results = [Tdir.pan_top,'Salish_results/'];
if ~exist(Tdir.pan_results,'dir'); 
    mkdir(Tdir.pan_results); 
end;
