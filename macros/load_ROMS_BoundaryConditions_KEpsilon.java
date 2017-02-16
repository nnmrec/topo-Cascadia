// STAR-CCM+ macro: load_ROMS_BoundaryConditions_KEpsilon.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.turbulence.*;
import star.common.*;
import star.keturb.*;
import star.base.neo.*;
import star.flow.*;
import star.vis.*;

public class load_ROMS_BoundaryConditions_KEpsilon extends StarMacro {

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
      (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("../cases/" + caseName.getText()  + "/STARCCM_xyzuvw_area_interest.csv"));  

    // FileTable fileTable_0 = 
    //   (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("STARCCM_xyzuvw_area_interest.csv"));


    


    // INITIAL CONDITIONS

    PhysicsContinuum physicsContinuum_0 = 
      ((PhysicsContinuum) simulation_0.getContinuumManager().getContinuum("Physics 1"));

    physicsContinuum_0.getInitialConditions().get(KeTurbSpecOption.class).setSelected(KeTurbSpecOption.Type.K_EPSILON);

    VelocityProfile velocityProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(VelocityProfile.class);

    velocityProfile_0.setMethod(XyzTabularVectorProfileMethod.class);

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setTable(fileTable_0);

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setXData("u");

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setYData("v");

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setZData("w");

    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_0.setMethod(XyzTabularScalarProfileMethod.class);

    turbulentKineticEnergyProfile_0.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentKineticEnergyProfile_0.getMethod(XyzTabularScalarProfileMethod.class).setData("tke");

    TurbulentDissipationRateProfile turbulentDissipationRateProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulentDissipationRateProfile.class);

    turbulentDissipationRateProfile_0.setMethod(XyzTabularScalarProfileMethod.class);

    turbulentDissipationRateProfile_0.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentDissipationRateProfile_0.getMethod(XyzTabularScalarProfileMethod.class).setData("eps");

    



    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    




    // INLETS

    Boundary boundary_0 = 
      region_0.getBoundaryManager().getBoundary("Subtract.north");

    boundary_0.getConditions().get(KeTurbSpecOption.class).setSelected(KeTurbSpecOption.Type.K_EPSILON);

    Boundary boundary_1 = 
      region_0.getBoundaryManager().getBoundary("Subtract.west");

    boundary_1.getConditions().get(KeTurbSpecOption.class).setSelected(KeTurbSpecOption.Type.K_EPSILON);

    VelocityProfile velocityProfile_1 = 
      boundary_0.getValues().get(VelocityProfile.class);

    velocityProfile_1.setMethod(XyzTabularVectorProfileMethod.class);

    VelocityProfile velocityProfile_2 = 
      boundary_1.getValues().get(VelocityProfile.class);

    velocityProfile_2.setMethod(XyzTabularVectorProfileMethod.class);

    velocityProfile_2.getMethod(XyzTabularVectorProfileMethod.class).setTable(fileTable_0);

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setTable(fileTable_0);

    velocityProfile_2.getMethod(XyzTabularVectorProfileMethod.class).setXData("u");

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setXData("u");

    velocityProfile_2.getMethod(XyzTabularVectorProfileMethod.class).setYData("v");

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setYData("v");

    velocityProfile_2.getMethod(XyzTabularVectorProfileMethod.class).setZData("w");

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setZData("w");

    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_1 = 
      boundary_0.getValues().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_1.setMethod(TimeXyzTabularScalarProfileMethod.class);

    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_2 = 
      boundary_1.getValues().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_2.setMethod(TimeXyzTabularScalarProfileMethod.class);

    turbulentKineticEnergyProfile_1.getMethod(TimeXyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentKineticEnergyProfile_2.getMethod(TimeXyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentKineticEnergyProfile_1.setMethod(XyzTabularScalarProfileMethod.class);

    turbulentKineticEnergyProfile_2.setMethod(XyzTabularScalarProfileMethod.class);

    turbulentKineticEnergyProfile_2.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentKineticEnergyProfile_1.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentKineticEnergyProfile_2.getMethod(XyzTabularScalarProfileMethod.class).setData("tke");

    turbulentKineticEnergyProfile_1.getMethod(XyzTabularScalarProfileMethod.class).setData("tke");

    TurbulentDissipationRateProfile turbulentDissipationRateProfile_1 = 
      boundary_0.getValues().get(TurbulentDissipationRateProfile.class);

    turbulentDissipationRateProfile_1.setMethod(XyzTabularScalarProfileMethod.class);

    TurbulentDissipationRateProfile turbulentDissipationRateProfile_2 = 
      boundary_1.getValues().get(TurbulentDissipationRateProfile.class);

    turbulentDissipationRateProfile_2.setMethod(XyzTabularScalarProfileMethod.class);

    turbulentDissipationRateProfile_2.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentDissipationRateProfile_1.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentDissipationRateProfile_2.getMethod(XyzTabularScalarProfileMethod.class).setData("eps");

    turbulentDissipationRateProfile_1.getMethod(XyzTabularScalarProfileMethod.class).setData("eps");

    






    // OUTLETS

    Boundary boundary_2 = 
      region_0.getBoundaryManager().getBoundary("Subtract.east");

    boundary_2.getConditions().get(KeTurbSpecOption.class).setSelected(KeTurbSpecOption.Type.K_EPSILON);

    Boundary boundary_3 = 
      region_0.getBoundaryManager().getBoundary("Subtract.south");

    boundary_3.getConditions().get(KeTurbSpecOption.class).setSelected(KeTurbSpecOption.Type.K_EPSILON);

    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_3 = 
      boundary_2.getValues().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_3.setMethod(XyzTabularScalarProfileMethod.class);

    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_4 = 
      boundary_3.getValues().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_4.setMethod(XyzTabularScalarProfileMethod.class);

    turbulentKineticEnergyProfile_3.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentKineticEnergyProfile_4.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentKineticEnergyProfile_3.getMethod(XyzTabularScalarProfileMethod.class).setData("tke");

    turbulentKineticEnergyProfile_4.getMethod(XyzTabularScalarProfileMethod.class).setData("tke");

    TurbulentDissipationRateProfile turbulentDissipationRateProfile_3 = 
      boundary_2.getValues().get(TurbulentDissipationRateProfile.class);

    turbulentDissipationRateProfile_3.setMethod(XyzTabularScalarProfileMethod.class);

    TurbulentDissipationRateProfile turbulentDissipationRateProfile_4 = 
      boundary_3.getValues().get(TurbulentDissipationRateProfile.class);

    turbulentDissipationRateProfile_4.setMethod(XyzTabularScalarProfileMethod.class);

    turbulentDissipationRateProfile_3.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentDissipationRateProfile_4.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentDissipationRateProfile_3.getMethod(XyzTabularScalarProfileMethod.class).setData("eps");

    turbulentDissipationRateProfile_4.getMethod(XyzTabularScalarProfileMethod.class).setData("eps");



    Solution solution_0 = 
      simulation_0.getSolution();

    solution_0.clearSolution(Solution.Clear.History, Solution.Clear.Fields);

    solution_0.initializeSolution();


  }
}
