# topo-Cascadia

This is the code developed for the paper:

    D.C. Sale and A. Aliseda (2016) “Computational simulation of tidal energy generation estuary-scale scenarios” National Hydropower Association Marine Energy Technology Symposium. April 25-27, 2016, Washington, DC

## INTRO
This tutorial builds a CFD simulation for a farm of Marine Hydro-Kinetic (MHK) turbines, operating
at different times in the tidal cycle, using boundary conditions from an Ocean general circulation model (OCM), and
including effects from complex bathymetry.  In this case, the region of study is Puget Sound, Washington, USA.

![](https://github.com/nnmrec/topo-Cascadia/blob/master/docs/images/Space-Earth-PugetSound-topography-Cascadia.png?raw=true)


In this tutorial, we build a nested STAR-CCM+ simulation using information provided by the
Regional Ocean Modeling System (ROMS).  Then a farm of MHK turbines is added to the nested STAR-CCM+ simulation.
The nested domain receives boundary conditions, and is initialized, by the ROMS parent domain.

The STAR-CCM+ model can use the same mesh as ROMS, or
we can create a higher resolution mesh based upon a different source.  
The bulk of this code is within Matlab, and involves building the STAR-CCM+ mesh.  The Matlab code reads the 
gridded topography files, then identifies coastlines and refines the seabed geometry to become a suitable mesh
for STAR-CCM+.  

The ROMS method does not require mesh resolution smaller than ~ 10 meters; however, the STAR-CCM+ method requires meshes with resolution spanning down to:
* centimeters, to capture the nearfield effect of rotor wake turbulence
* microns, to capture flow separation and wakes of turbine support structures

The difference in mesh resolutions presumes the differences in many factors, including the 
* equations of motions that are solved (ROMS vs STAR-CCM+)
* turbulence closure models (ROMS vs STAR-CCM+)
* the limits of your computer (laptop vs supercomptuer)


# (1) Meshing
In this example, the source of the mesh is provided by digital elevation models (DEM) of 
"PSDEM2005" dataset available at http://www.ocean.washington.edu/data/pugetsound/psdem2005.html.

The accompanyinig Matlab code, can help create a suitable mesh.  First, adjust the user input options in topoCascadia_UserInputs.m and then run
	topoCascadia(OPTIONS);

topoCascadia.m will first load the gridded topography data (from a NetCDF *.nc file), and then prompt you to select an region of interest (by drawing a square on the map).  Next, load the subset of gridded topography, make a DEM and adjust the graphics (click the map at different points to adjust lighting/shading)

![](https://github.com/nnmrec/topo-Cascadia/blob/master/docs/images/topography_adjust_map_daycycle.gif?raw=true)
selecting the region of interest, and adjusting the graphics

Now, if there are coastlines within the region of interest the Matlab code will detect using the "coastline file" provided in folder '/inputs/bathymetry/coast/'.  The Matlab code add_Coastline.m deals with detection of the coastline, and then refinement of the shallow water regions near the coastline.  The refinement method decouples the coastline physics from the nested domain, with the assumption that water currents
are neglible within some buffer distance from the coastline file.  The buffer region is important for creating a higher quality mesh
in STAR-CCM+.  This buffer distance is set in the user input OPTIONS.mbuf

Next, the Matlab code will convert the coordinate systems from a Latitude-Longitude, to a North-East-Down (NED) coordinate system.  The NED system (units of meters) is more convenient to think about when selecting the location of MHK turbines.  The mesh is then written in the Stereolithography (STL) file format (which is easily read by STAR-CCM+).   

Next, the Matlab code will prompt you to select the MHK turbine locations, and simply click on the map where the turbines should be located.
Then you can rotate the map, to inspect bathymetry and turbine locations.

![](https://github.com/nnmrec/topo-Cascadia/blob/master/docs/images/topography_place_turbines.gif?raw=true)
selecting the turbine locations and inspecting the map



# (2) Physics Continuum
The source of the ROMS field variables is provided by 
"ainlet_2006_3" model available at http://faculty.washington.edu/pmacc/tools/run_log.html.

The ROMS code produces NetCDF files (named like *.out) that
contain the field variables and mesh information.  The accompanying Matlab code
reads the field variables from the NetCDF files and interpolates the information
to the centroids of the STAR-CCM+ mesh.

First, the ROMS field variables are read by the script get_ROMS_fields.m.  
Each field variable is converted to the RHO coordinate system of ROMS (which is the mesh cell center), this allows
variables to also exist cell centroids in the STAR-CCM+ mesh.
The following script make_CFD_mesh.m interpolates all of the ROMS variables to the STAR-CCM+ mesh.

Now, the STAR-CCM+ simulation mesh and physics continuum can be initialized, and the accompyning
Java macros can be used to create visualizations of the nested STAR=CCM+ domain.

Open STAR-CCM+ from the case/ directory.  Run the macro _main_ROMS_nesting.java, which performs several tasks:
* reads the mesh generated from the DEM in STL format, and performs Boolean operations to subtract the landmass
* creates the Trimmer Mesh, or Polyhedral mesh using the user input options specified in init_UserInputVariables.java
* creates several scenes of the mesh, and field variables to visualize the simulation

# (3) Run the Simulation
If everything looks good, you can start the Solver in STAR-CCM+ ... and expect to wait for a while (at least for a coffee, or overnight)


On a supercomputer, see the script submit-Hyak_topo-Cascadia.sh which is compatible to run in interactive, batch, or backfill jobs.  Run the command
    
    qsub ./submit-Hyak_topo-Cascadia.sh

Regarding computer requirements ... to meet the "overnight requirement" I needed to use 48 CPUs (3 nodes each with 64 GB of RAM).  This was for a very large domain, but to run on a laptop simply reduce the size of "region of interest".

# (4) Post-Processing

Now that the STAR-CCM+ simulation has finished, we should read the power output of the turbines.  The Matlab script
plot_turbine_data.m will compare the power production within the MHK turbine farm.  And, several scenes are available in STAR-CCM+ to 
visualize the flow field (see the macros named scenes_*.java).

![](https://github.com/nnmrec/topo-Cascadia/blob/master/docs/images/compare_Ebb_Flood_Tides_turbine_farm_power.png?raw=true)

# SKIP TO THE END
If you want to skip all the pre-processing and mesh generation, you can load the STAR-CCM+ simulation files directly. The starccm files in this repo have cleared the mesh and solution, but you can recreate on your own computer.

