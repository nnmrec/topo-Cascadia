// STAR-CCM+ macro: _main_ROMS_nesting_step5_PostProcessing_ebb.java
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
public class _main_ROMS_nesting_step5_PostProcessing_ebb extends StarMacro {


  public void execute() {
    execute0();
  }

  private void execute0() {
    // 
    // as of Feb 14, 2017, try this:
    // 
    Simulation simulation_0 = getActiveSimulation();

    // 
    // POST-PROCESSING
    // 
    // export important data here    
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_Velocity_2_ebb.java"))).play(); 
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("export_PointProbes.java"))).play(); 
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("export_VirtualDisks.java"))).play(); 
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_SaveHardcopies.java"))).play();
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("save_ClearedMeshAndSolution.java"))).play();

    // simulation_0.saveState(getSimulation().getPresentationName()+".sim");

  }
}
