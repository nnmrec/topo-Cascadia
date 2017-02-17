// STAR-CCM+ macro: physics_BC_OutletABL.java
// Written by STAR-CCM+ 11.02.010
package macro;

import java.util.*;

import star.turbulence.*;
// import star.kwturb.*;
import star.keturb.*;
import star.common.*;

public class physics_BC_OutletABL extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    Region region_0 = 
    simulation_0.getRegionManager().getRegion("Region");

    Boundary boundary_0 = 
      // region_0.getBoundaryManager().getBoundary("Outlet");
    region_0.getBoundaryManager().getBoundary("Outlet");

    // boundary_0.getConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.K_OMEGA);
    boundary_0.getConditions().get(KeTurbSpecOption.class).setSelected(KeTurbSpecOption.Type.K_EPSILON);


    // SpecificDissipationRateProfile specificDissipationRateProfile_0 = 
    //   boundary_0.getValues().get(SpecificDissipationRateProfile.class);
    // specificDissipationRateProfile_0.setMethod(FunctionScalarProfileMethod.class);
    TurbulentDissipationRateProfile turbulentDissipationRateProfile_0 = 
      boundary_0.getValues().get(TurbulentDissipationRateProfile.class);
    turbulentDissipationRateProfile_0.setMethod(FunctionScalarProfileMethod.class);


    UserFieldFunction userFieldFunction_0 = 
      ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("tdr"));

    // specificDissipationRateProfile_0.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_0);
      turbulentDissipationRateProfile_0.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_0);

    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_0 = 
      boundary_0.getValues().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_0.setMethod(FunctionScalarProfileMethod.class);

    UserFieldFunction userFieldFunction_1 = 
      ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("tke"));

    turbulentKineticEnergyProfile_0.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_1);
  }
}
