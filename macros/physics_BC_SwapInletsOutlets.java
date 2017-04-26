// STAR-CCM+ macro: physics_BC_SwapInletsOutlets.java
// Written by STAR-CCM+ 12.02.010
package macro;

import java.util.*;

import star.kwturb.*;
import star.common.*;
import star.base.neo.*;

public class physics_BC_SwapInletsOutlets extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");




    Boundary boundary_0 = 
      region_0.getBoundaryManager().getBoundary("Inlet");

    PressureBoundary pressureBoundary_0 = 
      ((PressureBoundary) simulation_0.get(ConditionTypeManager.class).get(PressureBoundary.class));

    boundary_0.setBoundaryType(pressureBoundary_0);

    boundary_0.getConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.INTENSITY_LENGTH_SCALE);

    boundary_0.setPresentationName("out-let");




    Boundary boundary_1 = 
      region_0.getBoundaryManager().getBoundary("Outlet");

    InletBoundary inletBoundary_0 = 
      ((InletBoundary) simulation_0.get(ConditionTypeManager.class).get(InletBoundary.class));

    boundary_1.setBoundaryType(inletBoundary_0);

    boundary_1.getConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.K_OMEGA);

    boundary_1.setPresentationName("in-let");

    boundary_0.setPresentationName("Outlet");

    boundary_1.setPresentationName("Inlet");
  }
}
