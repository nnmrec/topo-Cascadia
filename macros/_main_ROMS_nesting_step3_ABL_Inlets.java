// STAR-CCM+ macro: _main_ROMS_nesting_step3_ABL_Inlets.java
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
public class _main_ROMS_nesting_step3_ABL_Inlets extends StarMacro {


  public void execute() {
    execute0();
  }

  private void execute0() {
    // 
    // as of Feb 14, 2017, try this:
    // 
    Simulation simulation_0 = getActiveSimulation();

    
    // add the ABL inlet/outlet conditions
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("fieldFunction_ABL_inlet.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_BC_InflowABL.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_BC_OutletABL.java"))).play();
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("scene_VerticalProfilesABL.java"))).play();
    
    simulation_0.saveState(getSimulation().getPresentationName()+".sim");

    // continue the solver from last state
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_Run.java"))).play();

    simulation_0.saveState(getSimulation().getPresentationName()+".sim");

  }
}
