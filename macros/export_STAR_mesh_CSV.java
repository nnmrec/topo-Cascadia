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

    xyzInternalTable_1.setPresentationName("mesh_centroids");

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    // Boundary boundary_0 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.coast");

    // Boundary boundary_1 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.east");

    // Boundary boundary_2 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.north");

    // Boundary boundary_3 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.seabed");

    // Boundary boundary_6 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.seasurface");

    // Boundary boundary_4 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.south");

    // Boundary boundary_5 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.west");

    // xyzInternalTable_1.getParts().setObjects(boundary_0, boundary_1, boundary_2, boundary_3, boundary_6, boundary_4, boundary_5);

    // xyzInternalTable_1.setPresentationName("mesh_centroids_BC");

    XyzInternalTable xyzInternalTable_2 = 
      simulation_0.getTableManager().createTable(XyzInternalTable.class);

    xyzInternalTable_2.setPresentationName("mesh_centroids_domain");

    xyzInternalTable_2.setFieldFunctions(new NeoObjectVector(new Object[] {vectorComponentFieldFunction_0, vectorComponentFieldFunction_1, vectorComponentFieldFunction_2}));

    xyzInternalTable_2.getParts().setObjects(region_0);

    

    xyzInternalTable_2.extract();


    // xyzInternalTable_1.extract();
    // xyzInternalTable_1.setPresentationName("mesh_centroids_boundaries");

    // // xyzInternalTable_1.export("/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/cases/test_ROMS_nesting/mesh_centroids_boundaries.csv", ",");
    // xyzInternalTable_1.export("mesh_centroids_boundaries.csv", ",");

    // xyzInternalTable_2.export("/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/cases/test_ROMS_nesting/mesh_centroids_domain.csv", ",");
    xyzInternalTable_2.export("mesh_centroids_domain.csv", ",");
  }
}
