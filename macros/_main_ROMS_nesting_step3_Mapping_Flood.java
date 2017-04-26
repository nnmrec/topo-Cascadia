// STAR-CCM+ macro: _main_ROMS_nesting_step3_Mapping_Flood.java
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
public class _main_ROMS_nesting_step3_Mapping_Flood extends StarMacro {


  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = getActiveSimulation();

    





    // 
    // READ the file tables, and apply ROMS BC on inlet, outlets, and initial conditions
    // 
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("load_ROMS_BoundaryConditions_SSTKOmega.java"))).play();
    
    simulation_0.saveState(getSimulation().getPresentationName()+".sim");   

  }
}
