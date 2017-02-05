// STAR-CCM+ macro: load_ROMS_tables.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.flow.*;
import star.vis.*;

public class load_ROMS_tables extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    SimpleAnnotation caseName = 
        ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("CASE_NAME"));

    FileTable fileTable_0 = 
      // (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("ROMS_xyzuvw_area_interest.csv"));
      (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("../cases/" + caseName.getText()  + "/ROMS_xyzuvw_area_interest.csv"));
      

    PhysicsContinuum physicsContinuum_0 = 
      ((PhysicsContinuum) simulation_0.getContinuumManager().getContinuum("Physics 1"));

    VelocityProfile velocityProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(VelocityProfile.class);

    velocityProfile_0.setMethod(XyzTabularVectorProfileMethod.class);

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setTable(fileTable_0);

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setXData("u");

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setYData("v");

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setZData("w");

    Solution solution_0 = 
      simulation_0.getSolution();

    solution_0.clearSolution(Solution.Clear.History, Solution.Clear.Fields);

    solution_0.initializeSolution();

    solution_0.initializeSolution();

    solution_0.clearSolution(Solution.Clear.History, Solution.Clear.Fields);

    solution_0.initializeSolution();

    fileTable_0.extract();

    solution_0.initializeSolution();

    solution_0.clearSolution(Solution.Clear.History, Solution.Clear.Fields);

    solution_0.initializeSolution();
  }
}
