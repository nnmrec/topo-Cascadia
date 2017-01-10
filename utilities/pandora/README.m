% README.m 8/20/2013 Parker MacCready
%
% about the files and folders in "pandora"
%
% This code is meant for plotting of ROMS history files,
% and was developed mainly for the RISE, MoSSea, and PNWTOX runs.  However
% I hope that many of the tools are more general, or are easily adapted to
% other regions.
%
% Quirks:
%
% 1. We generaly store our ROMS output with one time step per history
% file.  This is because our domains are usually huge and so a single time
% snapshot can be very big.  The downside is that forming time series, or
% filtering in time, can be slow.  Our current default is one save per
% hour.
%
% 2. You need various toolboxes and paths, all defined by alpha/toolstart
% (called by pan_start.m).
%
% 3. Generally the code should work on raw history files (in OUT/) or on
% things of similar structure.
%
% ** pan_plot.m **
% This is a driver for the plotting code.  It allows you to interactively
% choose the history file (or sequence of files so you can make a movie),
% and then interactively choose the code to plot it with.  Depending on
% which plotting code you use you may also be prompted to select a mooring
% file.  By minor editing it can also be run with the choices hardwired,
% which may be better when runnning on a remote linux machine.  After it
% makes a plot the user can choose to save it or not (by default as a tiff
% file in ../pandora_data/Salish_figures).
% If you chose a sequence of files then it
% automatically creates a directory inside ../pandora_data/Salish_movies
% and saves a sequence of numbered jpeg images there).
%
% ** zslice_preprocess.m **
% This needs to be run before you can use the plotting code
% "basic_zslice.m"  It creates interpolation matrices to speed up the
% creation of sections at a given depth.  Note that it assumes the surface
% height to be zero when figuring out this interpolation matrix.  Thus the
% same matrix can be used at any time.  Caveat: the resulting field won't
% be exactly at the specified depth, because of tidal oscillations.  In my
% opinion this reference frame is often better than a strict Eulerian
% average, especially in shallower water.
%
% *** PLOTTING CODE (in Salish_plot_code, but run using pan_plot.m) ***
%
% 0. basic.m
% Makes maps of surface fields of salinity and temperature.  Good for a
% quick look.  Has a nice overlay of velocity vectors and a velocity scale
% arrow.
%
% 1. PS_JdF_sect.m
% Makes a map of surface salinity, and then a section of salinity and
% velocity down the thalweg of JdF and PS (uses Z_make_sect.m).  Best to
% use with tidally-averaged (lp) field.
%
% 2. basic_zslice.m
% Makes maps of a property at different depth (uses the results of
% zslice_preprocess.m).
%
% 3. basic_mooring.m
% Makes some maps and then panels of time series (uses the results of
% mooring_extractor.m).
% 
% 4. ...anything else you make will be available...