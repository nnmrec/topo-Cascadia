// STAR-CCM+ macro: load_ROMS_BoundaryConditions.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.flow.*;
import star.vis.*;


public class load_ROMS_BoundaryConditions extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    // FileTable fileTable_2 = 
    //   (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("/home/danny/RECOVER/GitHub-NNMREC-topo-Cascadia/test/topo-Cascadia/cases/topo-Cascadia-ROMS-nesting/ROMS_xyzuvw_area_interest.csv"));

    SimpleAnnotation caseName = 
        ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("CASE_NAME"));

    FileTable fileTable_2 = 
      // (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("ROMS_xyzuvw_area_interest.csv"));
      (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("../cases/" + caseName.getText()  + "/STARCCM_xyzuvw_area_interest.csv"));  

    PhysicsContinuum physicsContinuum_0 = 
      ((PhysicsContinuum) simulation_0.getContinuumManager().getContinuum("Physics 1"));

    VelocityProfile velocityProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(VelocityProfile.class);

    velocityProfile_0.setMethod(XyzTabularVectorProfileMethod.class);

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setTable(fileTable_2);

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    Boundary boundary_2 = 
      region_0.getBoundaryManager().getBoundary("Subtract.north");

    VelocityProfile velocityProfile_1 = 
      boundary_2.getValues().get(VelocityProfile.class);

    velocityProfile_1.setMethod(XyzTabularVectorProfileMethod.class);

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setTable(fileTable_2);

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setXData("u");

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setYData("v");

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setZData("w");

    Boundary boundary_4 = 
      region_0.getBoundaryManager().getBoundary("Subtract.west");

    VelocityProfile velocityProfile_2 = 
      boundary_4.getValues().get(VelocityProfile.class);

    velocityProfile_2.setMethod(XyzTabularVectorProfileMethod.class);

    velocityProfile_2.getMethod(XyzTabularVectorProfileMethod.class).setTable(fileTable_2);

    velocityProfile_2.getMethod(XyzTabularVectorProfileMethod.class).setXData("u");

    velocityProfile_2.getMethod(XyzTabularVectorProfileMethod.class).setYData("v");

    velocityProfile_2.getMethod(XyzTabularVectorProfileMethod.class).setZData("w");

    Solution solution_0 = 
      simulation_0.getSolution();

    solution_0.clearSolution(Solution.Clear.History, Solution.Clear.Fields);

    solution_0.initializeSolution();
  }
}
