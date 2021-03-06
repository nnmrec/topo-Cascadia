// STAR-CCM+ macro: export_STAR_mesh_CSV.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;

public class export_STAR_mesh_CSV extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    XyzInternalTable xyzInternalTable_1 = 
      simulation_0.getTableManager().createTable(XyzInternalTable.class);

    PrimitiveFieldFunction primitiveFieldFunction_0 = 
      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("Centroid"));

    VectorComponentFieldFunction vectorComponentFieldFunction_0 = 
      ((VectorComponentFieldFunction) primitiveFieldFunction_0.getComponentFunction(0));

    VectorComponentFieldFunction vectorComponentFieldFunction_1 = 
      ((VectorComponentFieldFunction) primitiveFieldFunction_0.getComponentFunction(1));

    VectorComponentFieldFunction vectorComponentFieldFunction_2 = 
      ((VectorComponentFieldFunction) primitiveFieldFunction_0.getComponentFunction(2));

    xyzInternalTable_1.setFieldFunctions(new NeoObjectVector(new Object[] {vectorComponentFieldFunction_0, vectorComponentFieldFunction_1, vectorComponentFieldFunction_2}));

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    Boundary boundary_0 = 
      region_0.getBoundaryManager().getBoundary("Inlet");

    Boundary boundary_1 = 
      region_0.getBoundaryManager().getBoundary("Outlet");

    xyzInternalTable_1.getParts().setObjects(boundary_0, boundary_1);

    xyzInternalTable_1.setPresentationName("mesh_centroids_BC");

    xyzInternalTable_1.extract();

    xyzInternalTable_1.export("mesh_centroids_BC.csv", ",");


    XyzInternalTable xyzInternalTable_2 = 
      simulation_0.getTableManager().createTable(XyzInternalTable.class);

    xyzInternalTable_2.setPresentationName("mesh_centroids_domain");

    xyzInternalTable_2.setFieldFunctions(new NeoObjectVector(new Object[] {vectorComponentFieldFunction_0, vectorComponentFieldFunction_1, vectorComponentFieldFunction_2}));

    xyzInternalTable_2.getParts().setObjects(region_0);

    xyzInternalTable_2.extract();

    xyzInternalTable_2.export("mesh_centroids_domain.csv", ",");

    
  }
}
