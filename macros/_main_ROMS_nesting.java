// STAR-CCM+ macro: _main_ROMS_nesting.java
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
public class _main_ROMS_nesting extends StarMacro {


  public void execute() {
    execute0();
  }

  private void execute0() {
    // 
    // as of Dec 21, 2016 try this:
    // 

    // 
    // READ USER INPUTS
    // 
    // read the user inputs (to-do: add options to set inlet/outlet planes individuallty)
    new StarScript(getActiveSimulation(),  new java.io.File(resolvePath("init_UserInputVariables.java"))).play();
    

    // 
    // GEOMETRY AND MESHING
    // 
    // make the geometry ( first create physics then mesh)
    new StarScript(getActiveSimulation(),  new java.io.File(resolvePath("subtract_the_coast_final.java"))).play();
    new StarScript(getActiveSimulation(),  new java.io.File(resolvePath("subtract_the_coast_final_part2.java"))).play();
    
    // 
    // PHYSICS MODELS
    // 
    // setup the physics models
    new StarScript(getActiveSimulation(),  new java.io.File(resolvePath("physics_SST_KOmega.java"))).play();
    // Assign the BC values to inlet and outlet regions (to-do: combine the inlets to specify ambient turbulence)
    new StarScript(getActiveSimulation(),  new java.io.File(resolvePath("physics_BC_InflowUniform.java"))).play();
    // Assign BC values to the seabed regions
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_BC_RoughSurface.java"))).play();
  
    // 
    // MESHING
    // 
    // setup the meshing
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_Background_Polyhedral.java"))).play();
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_Background_Trimmer.java"))).play();
    // run the meshing
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_MeshAll.java"))).play();
    
    // 
    // RUN THE SOLVER
    // 
    // initialize the solver
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_OptimalSettings.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_InitSolution.java"))).play();    
    // run the solver
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_Run.java"))).play();

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
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("load_ROMS_tables.java"))).play(); 
    
    // continue the solver from last state
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_Run.java"))).play();


    // 
    // ADD MORE PHYSICS MODELS, RE-RUN MESHING, AND RESTART SOLVER
    // 
    // add turbines via virtual disk model
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("createVirtualDisks.java"))).play();        // for the Trimmer Mesh
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_VirtualDisks.java"))).play();         // for the PolyHedral Mesh
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_VirtualDisks_Reports.java"))).play();   // for the PolyHedral Mesh 
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("parts_SectionPlanesTurbines.java"))).play(); 
    // re-mesh with the new mesh refinements around the turbines
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_MeshAll.java"))).play();
    // continue the solver from last state
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_Run.java"))).play();
    
    // 
    // POST-PROCESSING
    // 
    // export important data here    
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("export_PointProbes.java"))).play(); 
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("export_VirtualDisks.java"))).play(); 
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_SaveHardcopies.java"))).play();
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("save_ClearedMeshAndSolution.java"))).play();

    

  }
}
