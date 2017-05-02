%-----------------------------------------------------------------------------%
% topo-Cascadia
% 
% Purpose of this code:
%   to facilitate extraction of topography data for meshing in CFD software
%
% last modified by danny in May 2016
%-----------------------------------------------------------------------------%
%                         
% 
% Here is some information about the bathymetry set used in this 
% 'minimal working example' of the 'topo-Cascadia' repository:
%
% The only working example at the moment is related to Puget Sound, and
% here is some info about the example bathymetry set:
% 
% Title:
%     Combined bathymetry and topography of the Puget Lowlands, 
%     Washington State (tile: g1230485) 
% Abstract:
%     This dataset represents a composite of the best-available bathymetry and 
%      topography for Puget Sound, Hood Canal, Lake Washington and the surrounding 
%      lowlands as of January 2005. 
% Supplemental_Information:
%     Although a large percentage of the data is derived from state-of-the-art 
%     mapping systems collected as recently as 2004 (including laser altimetry and 
%     swath bathymetry) it was sometimes necessary to rely on very old datasets such as 
%     lead-line from the 1930's to complete the model. Care was taken to ensure that each 
%     dataset was properly projected, resampled and adjusted into a common vertical and 
%     horizontal datum (NAVD88 and NAD83 respectively). Obvious artifacts in the data were 
%     removed where this was easily done, and an effort was made to smooth the transition 
%     between datasets to minimize the number of spurious artifacts along data set margins. 
% How should this data set be cited?
%         David Finlayson, School of Oceanography, University of , 20050124, Combined bathymetry and 
%         topography of the Puget Lowlands, Washington State (tile: g1230485).
%         Online Links:
%             <http://www.ocean.washington.edu/data/pugetsound/> 
%            
% 
%-----------------------------------------------------------------------------%

%% TO_DO LIST
% * interpolate/extrapolate the boundaries of ROMS onto the PSDEM different resolutions
% * compute TKE and Specific Dissipation from ROMS GLS turbulence model
% * read only the area-of-interest boundaries from ROMS, at all time steps,
%   calculate flow rates across boundaries and verify as inlet/outlets
% * write the CSV boundaries, and internal domains, at the chosen ROMS timesteps
%   must include: velocity, TKE, specific dissipation
% * change coastlines to no-slip smooth, like in ROMS
% * add output for vfplot, by converting ROMS into GMT data
% * add VTK output for the RHO point variables, so can visualize in VisIt/Paraview/VAPOR


%% some various user inputs
%  _   _ _____ ___________   _____ _   _ ______ _   _ _____ _____ 
% | | | /  ___|  ___| ___ \ |_   _| \ | || ___ \ | | |_   _/  ___|
% | | | \ `--.| |__ | |_/ /   | | |  \| || |_/ / | | | | | \ `--. 
% | | | |`--. \  __||    /    | | | . ` ||  __/| | | | | |  `--. \
% | |_| /\__/ / |___| |\ \   _| |_| |\  || |   | |_| | | | /\__/ /
%  \___/\____/\____/\_| \_|  \___/\_| \_/\_|    \___/  \_/ \____/ 
%                                                                                                                                  
% OPTIONS.casename            = '1_testCase_v2';     % the most importatnt thing ... to help keep track of things ...
% OPTIONS.casename            = 'topo-Cascadia-ROMS-nesting';     % the most importatnt thing ... to help keep track of things ...
OPTIONS.casename            = 'Feb2';     % the most importatnt thing ... to help keep track of things ...

OPTIONS.resample_factor     = 4;               	% resample the original coastline file with this factor of points
OPTIONS.resample_factor_bz  = 4;          	    % resample the normal projected Bezier interpolated coastline file with this factor of points
OPTIONS.mbuf                = 1000;           	% buffer around the specified refinment box (distance in meters) ... only because the normal projection of coastline might be inside the bounding box
OPTIONS.coast_offset        = 250;              % offset from the coastline [meters] may need to increase for lower resolutions
OPTIONS.zz_step             = 10;               % for isobath plots (meters)
OPTIONS.z0                  = 0;               	% zero?  NOTE: this should probably be set by the ROMS data, and it changes each time step

% turbine parameters (user inputs)
% OPTIONS.turbineFile         = [];               % name of turbine input file, can be [] if want to place turbines manually
OPTIONS.turbineFile         = 'rotors.csv';               % name of turbine input file, can be [] if want to place turbines manually
OPTIONS.nRotors             = 20;               % note: each turbine has two rotors
OPTIONS.nRpT                = 2;                % rotors per turbine
OPTIONS.diaRotor            = 20;               % rotor diamter
OPTIONS.spacingRot          = 28;
OPTIONS.hubHeight           = 30;
OPTIONS.heading             = 135;              % direction that turbine is facing, 0/360 deg is East , counterclockwise 

OPTIONS.Seabed_Source       = 'ROMS';  % can be 'ROMS' or the higher resolution 'PSDEM' dataset
OPTIONS.dirTopo             = '1_psdem';                       
OPTIONS.fileTopo            = 'inputs/bathymetry/topo/1_psdem/psdem_2005_plaid_27m.nc';
% OPTIONS.fileTopo            = 'inputs/bathymetry/coast/1_Cascadia/psdem_2005_plaid_91m.nc';
% OPTIONS.fileTopo            = 'inputs/bathymetry/coast/1_Cascadia/psdem_2005_plaid_9m.nc';

OPTIONS.dirCoast            = '1_Cascadia';                             % can be empty if coastFile is also empty
OPTIONS.fileCoast         	= 'pnw_coast_detailed.mat';                 % if empty, will be prompted for a new file

OPTIONS.aa                  = [-122.7355 -122.6783 48.1473 48.1821];    % area of interest. specify a box of lon, lat. (this was the METS 2016 PAPER ~6 mill cells?) % Area of interest, if it does not exist then user will be prompted to select by viewing a map

% this is probably going to have to be a relative path because datasets are large
% OPTIONS.fileTopo_ROMS       = '/mnt/data-RAID-1/danny/ainlet_2006_3/OUT/ocean_his_0290.nc';
OPTIONS.fileTopo_ROMS       = 'inputs/ROMS/OUT/ocean_his_1812.nc';

% OPTIONS.typeDEM = 'dem';
OPTIONS.typeDEM = 'shadem';
OPTIONS.runOnHPC = false;       % if true, modifies the STARCCM license server and commands
OPTIONS.runHeadless = true;     % if true, does not open any figures, does not open any interactive prompts (reads input files for all probe, turbine, figure inputs)
OPTIONS.nCPUs    = 16;

% OPTIONS.casename            = 'mets2016_psdem9m_domainBig';
% OPTIONS.aa                  = [-122.7355 -122.6783 48.1473 48.1821];    % Alberto's choice ~6 milld?
% OPTIONS.casename            = 'mets2016_psdem9m_domainSmall';
OPTIONS.aa                  = [-122.69 -122.68 48.152 48.1569];         % ULTRA TINY smaller ~3 million cells test domain (try and keep correct aspect ratio for 'ccm+ masters') 

% OPTIONS.n_points = 2; % number of single-point comparisons
% OPTIONS.point_x1 = [];  % x-coordinate NED, point probe to plot ROMS tidal cycles, can be empty or a vector
% OPTIONS.point_y1 = [];  % y-coordinate NED, point probe to plot ROMS tidal cycles, can be empty or a vector
OPTIONS.point_x1 = [-122.7268, -122.7129];   % x-coordinate LON-LAT, point probe to plot ROMS tidal cycles, can be empty or a vector
OPTIONS.point_y1 = [48.1638,     48.1781];   % y-coordinate LON-LAT, point probe to plot ROMS tidal cycles, can be empty or a vector

OPTIONS.DEBUG_LEVEL = 0;

% OPTIONS.dir_ROMS = '/mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/ai65/OUT'; % directory with ROMS *.nc output files
OPTIONS.dir_ROMS = 'inputs/ROMS/OUT'; % directory with ROMS *.nc output files


%% END OF USER INPUTS %%

%% run the main topo_Cascadia program

OPTIONS.casename = 'topo-Cascadia-ROMS-nesting';
% OPTIONS.aa = [-122.69 -122.68 48.152 48.1569];         % ULTRA TINY smaller ~3 million cells test domain
OPTIONS.aa = [-122.7355 -122.6783 48.1473 48.1821];    % Alberto's choice ~6 milld?
OPTIONS.fileTopo_ROMS = 'inputs/ROMS/OUT/ocean_his_1812.nc'; % hour 5, flood
OPTIONS.Seabed_Source = 'ROMS';
OPTIONS.nesting_times = [1812];
OPTIONS.nesting_tide  = {'flood'};
topoCascadia(OPTIONS);




