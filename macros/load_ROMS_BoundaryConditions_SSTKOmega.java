// STAR-CCM+ macro: load_ROMS_BoundaryConditions_SSTKOmega.java
// Written by STAR-CCM+ 12.02.010
package macro;

import java.util.*;

import star.turbulence.*;
import star.kwturb.*;
import star.common.*;
import star.base.neo.*;
import star.flow.*;
import star.vis.*;

public class load_ROMS_BoundaryConditions_SSTKOmega extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    // FileTable fileTable_0 = 
    //   (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("/mnt/data-RAID-1/danny/GitHub-NNMREC/topo-Cascadia-fix-LargeFilesError/cases/topo-Cascadia-ROMS-nesting/STARCCM_tables_ROMS_area_interest.csv"));

    SimpleAnnotation caseName = 
        ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("CASE_NAME"));

    FileTable fileTable_0 = 
      // (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("ROMS_xyzuvw_area_interest.csv"));
      (FileTable) simulation_0.getTableManager().createFromFile(resolvePath("../cases/" + caseName.getText()  + "/STARCCM_tables_ROMS.csv"));  





    PhysicsContinuum physicsContinuum_0 = 
      ((PhysicsContinuum) simulation_0.getContinuumManager().getContinuum("Physics 1"));

    physicsContinuum_0.getInitialConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.K_OMEGA);

    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_0.setMethod(XyzTabularScalarProfileMethod.class);

    turbulentKineticEnergyProfile_0.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentKineticEnergyProfile_0.getMethod(XyzTabularScalarProfileMethod.class).setData("tke");

    SpecificDissipationRateProfile specificDissipationRateProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(SpecificDissipationRateProfile.class);

    specificDissipationRateProfile_0.setMethod(XyzTabularScalarProfileMethod.class);

    specificDissipationRateProfile_0.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    specificDissipationRateProfile_0.getMethod(XyzTabularScalarProfileMethod.class).setData("omg");

    VelocityProfile velocityProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(VelocityProfile.class);

    velocityProfile_0.setMethod(XyzTabularVectorProfileMethod.class);

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setTable(fileTable_0);

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setXData("u");

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setYData("v");

    velocityProfile_0.getMethod(XyzTabularVectorProfileMethod.class).setZData("w");




    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    Boundary boundary_0 = 
      region_0.getBoundaryManager().getBoundary("Inlet");

    boundary_0.getConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.K_OMEGA);

    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_1 = 
      boundary_0.getValues().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_1.setMethod(XyzTabularScalarProfileMethod.class);

    turbulentKineticEnergyProfile_1.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    turbulentKineticEnergyProfile_1.getMethod(XyzTabularScalarProfileMethod.class).setData("tke");

    SpecificDissipationRateProfile specificDissipationRateProfile_1 = 
      boundary_0.getValues().get(SpecificDissipationRateProfile.class);

    specificDissipationRateProfile_1.setMethod(XyzTabularScalarProfileMethod.class);

    specificDissipationRateProfile_1.getMethod(XyzTabularScalarProfileMethod.class).setTable(fileTable_0);

    specificDissipationRateProfile_1.getMethod(XyzTabularScalarProfileMethod.class).setData("omg");

    VelocityProfile velocityProfile_1 = 
      boundary_0.getValues().get(VelocityProfile.class);

    velocityProfile_1.setMethod(XyzTabularVectorProfileMethod.class);

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setTable(fileTable_0);

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setXData("u");

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setYData("v");

    velocityProfile_1.getMethod(XyzTabularVectorProfileMethod.class).setZData("w");

    region_0.getConditions().get(TwoEquationTurbulenceUserSourceOption.class).setSelected(TwoEquationTurbulenceUserSourceOption.Type.AMBIENT);

    AmbientTurbulenceSpecification ambientTurbulenceSpecification_0 = 
      region_0.getValues().get(AmbientTurbulenceSpecification.class);

    ambientTurbulenceSpecification_0.setInflowBoundary(boundary_0);





    simulation_0.saveState(getSimulation().getPresentationName()+".sim");


    
  }
}
