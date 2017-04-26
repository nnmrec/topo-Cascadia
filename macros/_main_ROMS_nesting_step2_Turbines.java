// STAR-CCM+ macro: _main_ROMS_nesting_step2_Turbines.java
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
public class _main_ROMS_nesting_step2_Turbines extends StarMacro {


  public void execute() {
    execute0();
  }

  private void execute0() {
    
    Simulation simulation_0 = getActiveSimulation();

    // 
    // ADD MORE PHYSICS MODELS, RE-RUN MESHING, AND RESTART SOLVER
    // 
    // add turbines via virtual disk model
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_VirtualDisks_Trimmer.java"))).play();        // for the Trimmer Mesh
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_VirtualDisks_Polyhedral.java"))).play();     // for the PolyHedral Mesh
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_VirtualDisks_Reports.java"))).play();   
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("parts_SectionPlanesTurbines.java"))).play(); 
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_Topography_Turbines.java"))).play(); 
    
    
    // re-mesh with the new mesh refinements around the turbines
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_MeshAll.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_InitSolution.java"))).play();
    
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

    simulation_0.saveState(getSimulation().getPresentationName()+".sim");

  }
}
