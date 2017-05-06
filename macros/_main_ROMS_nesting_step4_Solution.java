// STAR-CCM+ macro: _main_ROMS_nesting_step4_Solution.java
// Written by STAR-CCM+ 10.06.010
// 
// license: ?
// 

package macro;

import java.util.*;
import star.common.*;

public class _main_ROMS_nesting_step4_Solution extends StarMacro {


  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = getActiveSimulation();

    // // re-mesh with the new mesh refinements around the turbines
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("mesh_MeshAll.java"))).play();
    // continue the solver from last state
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_Run.java"))).play();
    
    // NOTE: the post-processing is unlikely to ever run in this macro, because usually the solver times out because of the PBS walltime limit
    // 
    // POST-PROCESSING
    // 
    // export important data here    
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("export_PointProbes.java"))).play(); 
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("export_VirtualDisks.java"))).play(); 
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_SaveHardcopies.java"))).play();
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("save_ClearedMeshAndSolution.java"))).play();

    simulation_0.saveState(getSimulation().getPresentationName()+".sim");

  }
}
