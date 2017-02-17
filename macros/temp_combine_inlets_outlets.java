// STAR-CCM+ macro: temp_combine_inlets_outlets.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;

public class temp_combine_inlets_outlets extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    MeshManager meshManager_0 = 
      simulation_0.getMeshManager();

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    Boundary boundary_0 = 
      region_0.getBoundaryManager().getBoundary("Subtract.north");

    Boundary boundary_1 = 
      region_0.getBoundaryManager().getBoundary("Subtract.west");

    meshManager_0.combineBoundaries(new NeoObjectVector(new Object[] {boundary_0, boundary_1}));

    boundary_0.setPresentationName("Inlet");

    Boundary boundary_2 = 
      region_0.getBoundaryManager().getBoundary("Subtract.east");

    Boundary boundary_3 = 
      region_0.getBoundaryManager().getBoundary("Subtract.south");

    meshManager_0.combineBoundaries(new NeoObjectVector(new Object[] {boundary_2, boundary_3}));

    boundary_2.setPresentationName("Outlet");
  }
}
