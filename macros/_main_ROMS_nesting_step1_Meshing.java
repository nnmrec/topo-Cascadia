// STAR-CCM+ macro: _main_ROMS_nesting_step1_Meshing.java
// Written by STAR-CCM+ 10.06.010
// 
// license: ?
// 

package macro;

import java.util.*;
import star.common.*;

///////////////////////////////////////////////////////////////////////////////
// This is the MAIN driver, which calls all the other macros
//
public class _main_ROMS_nesting_step1_Meshing extends StarMacro {


  public void execute() {
    execute0();
  }

  private void execute0() {
    // 
    // as of Feb 14, 2017, try this:
    // 
    Simulation simulation_0 = getActiveSimulation();

    // 
    // READ USER INPUTS
    // 
    // read the user inputs (to-do: add options to set inlet/outlet planes individuallty)
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("init_UserInputVariables.java"))).play();
    

    // 
    // GEOMETRY AND MESHING
    // 
    // make the geometry ( first create physics then mesh)
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("subtract_the_coast_final.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("subtract_the_coast_final_part2.java"))).play();
    
    // 
    // PHYSICS MODELS
    // 
    // setup the physics models
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_SST_KOmega.java"))).play();
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_KEpsilon_Standard_2Layer.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_KEpsilon_Realizable.java"))).play();
    
    // Assign the BC values to inlet and outlet regions (to-do: combine the inlets to specify ambient turbulence)
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_BC_InflowUniform_SSTKOmega.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_BC_InflowUniform_KEpsilon.java"))).play();

    // Assign BC values to the seabed regions
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_BC_RoughSurface.java"))).play();

    // 
    // MESHING
    // 
    // setup the meshing
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_Background_Polyhedral.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_Background_Trimmer.java"))).play();
    // run the meshing
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_MeshAll.java"))).play();

    // 
    // RUN THE SOLVER
    // 
    // initialize the solver
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_OptimalSettings_SSTKOmega.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_OptimalSettings_KEpsilon.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_InitSolution.java"))).play();    
    // run the solver
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_Run.java"))).play();

    // 
    // POST-PROCESSING
    // 
    // created some derived parts, for visualization
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("parts_Create_PointProbes.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("parts_Create_LineProbes.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("parts_SectionPlanes.java"))).play(); 
    // scene of the mesh
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_Mesh.java"))).play(); 
    // scene of the velocity field
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_Velocity.java"))).play(); 


    // 
    // IMPORT THE ROMS MESH AND SOLUTION FIELDS
    // 
    // export the mesh cell centroids
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("export_STAR_mesh_CSV.java"))).play();
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("run_Matlab_mapping.java"))).play();
    // // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("load_ROMS_tables.java"))).play();
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("load_ROMS_BoundaryConditions.java"))).play();
    
    simulation_0.saveState(getSimulation().getPresentationName()+".sim");

    // // continue the solver from last state
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_Run.java"))).play();


    // // 
    // // ADD MORE PHYSICS MODELS, RE-RUNESHING, AND RESTART SOLVER
    // // 
    // // add turbines via virtual disk model
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_VirtualDisks_Trimmer.java"))).play();        // for the Trimmer Mesh
    // // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_VirtualDisks_Polyhedral.java"))).play();     // for the PolyHedral Mesh
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_VirtualDisks_Reports.java"))).play();          
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("parts_SectionPlanesTurbines.java"))).play(); 
    // // re-mesh with the new mesh refinements around the turbines
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_MeshAll.java"))).play();
    // // continue the solver from last state
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_Run.java"))).play();
    
    // // 
    // // POST-PROCESSING
    // // 
    // // export important data here    
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("export_PointProbes.java"))).play(); 
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("export_VirtualDisks.java"))).play(); 
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_SaveHardcopies.java"))).play();
    // // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("save_ClearedMeshAndSolution.java"))).play();

    

  }
}
