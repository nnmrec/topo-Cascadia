%-----------------------------------------------------------------------------%
% topo-Cascadia
% 
% Purpose of this code:
%   to facilitate extraction of topography data for meshing in CFD software
%
% last modified by danny in May 2016
%-----------------------------------------------------------------------------%
%                         

%% some various user inputs
%  _   _ _____ ___________   _____ _   _ ______ _   _ _____ _____ 
% | | | /  ___|  ___| ___ \ |_   _| \ | || ___ \ | | |_   _/  ___|
% | | | \ `--.| |__ | |_/ /   | | |  \| || |_/ / | | | | | \ `--. 
% | | | |`--. \  __||    /    | | | . ` ||  __/| | | | | |  `--. \
% | |_| /\__/ / |___| |\ \   _| |_| |\  || |   | |_| | | | /\__/ /
%  \___/\____/\____/\_| \_|  \___/\_| \_/\_|    \___/  \_/ \____/ 
%                                                                                                                                  
%
% Some inputs related to coastline
OPTIONS.resample_factor     = 4;               	% resample the original coastline file with this factor of points
OPTIONS.resample_factor_bz  = 4;          	    % resample the normal projected Bezier interpolated coastline file with this factor of points
OPTIONS.mbuf                = 1000;           	% buffer around the specified refinment box (distance in meters) ... only because the normal projection of coastline might be inside the bounding box
OPTIONS.coast_offset        = 250;              % offset from the coastline [meters] may need to increase for lower resolutions
OPTIONS.zz_step             = 10;               % for isobath plots (meters)
OPTIONS.z0                  = 0;               	% zero?  NOTE: this should probably be set by the ROMS data, and it changes each time step

% turbine parameters (user inputs)
% OPTIONS.turbineFile         = [];               % name of turbine input file, can be [] if want to place turbines manually
OPTIONS.turbineFile         = 'rotors.csv';     % name of turbine input file, can be [] if want to place turbines manually
OPTIONS.nRotors             = 20;               % note: each turbine has two rotors
OPTIONS.nRpT                = 2;                % rotors per turbine
OPTIONS.diaRotor            = 20;               % rotor diamter
OPTIONS.spacingRot          = 28;               % spacing between rotor centerlines
OPTIONS.hubHeight           = 30;               % elevation of the rotor centerline from the seabed
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

OPTIONS.runOnHPC = true;        % if true, modifies the STARCCM license server and commands
OPTIONS.runHeadless = true;     % if true, does not open any figures, does not open any interactive prompts (reads input files for all probe, turbine, figure inputs)
OPTIONS.nCPUs    = 28;          % number of CPUs to run on local computer, ignored if running on supercomputer (set CPUs within a PBS script)
OPTIONS.SLURM    = true;        % run on Hyak-Mox using SLURM (if you delete this variable than everything runs with PBS ... this affects how STAR-CCM+ is called)
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
OPTIONS.casename = 'time-1812-test-small-domain-flood';
OPTIONS.turbineFile = 'rotors-TEST-SMALL-DOMAIN.csv';
OPTIONS.aa = [-122.69 -122.68 48.152 48.1569];         % ULTRA TINY smaller ~3 million cells test domain
OPTIONS.fileTopo_ROMS = 'inputs/ROMS/OUT/ocean_his_1812.nc';
OPTIONS.nesting_times = [1812];
OPTIONS.nesting_tide  = {'flood'};
topoCascadia(OPTIONS);

OPTIONS.casename = 'time-1840-test-small-domain-ebb';
OPTIONS.turbineFile = 'rotors-TEST-SMALL-DOMAIN.csv';
OPTIONS.aa = [-122.69 -122.68 48.152 48.1569];         % ULTRA TINY smaller ~3 million cells test domain
OPTIONS.fileTopo_ROMS = 'inputs/ROMS/OUT/ocean_his_1840.nc';
OPTIONS.nesting_times = [1840];
OPTIONS.nesting_tide  = {'ebb'};
topoCascadia(OPTIONS);




