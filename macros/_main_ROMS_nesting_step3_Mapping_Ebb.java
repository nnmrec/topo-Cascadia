// STAR-CCM+ macro: _main_ROMS_nesting_step3_Mapping_Ebb.java
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
public class _main_ROMS_nesting_step3_Mapping_Ebb extends StarMacro {


  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = getActiveSimulation();

    // SWAP the inlets and outlets
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_BC_SwapInletsOutlets.java"))).play();

    // change direction of the turbines
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_VirtualDisks_ChangeHeading.java"))).play();

    // re-apply the simlified boundary conditions before adding ROMS
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("physics_BC_InflowUniform_SSTKOmega.java"))).play();

    // READ the file tables, and apply ROMS BC on inlet, outlets, and initial conditions
    // new StarScript(getActiveSimulation(), new java.io.File(resolvePath("load_ROMS_BoundaryConditions_SSTKOmega.java"))).play();
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("load_ROMS_BoundaryConditions_KEpsilon.java"))).play();
    
    // save
    simulation_0.saveState(getSimulation().getPresentationName()+".sim");   

  }
}
