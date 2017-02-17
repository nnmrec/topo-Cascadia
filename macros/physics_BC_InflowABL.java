// STAR-CCM+ macro: physics_BC_InflowABL.java
// Written by STAR-CCM+ 11.02.010
package macro;

import java.util.*;

import star.turbulence.*;
// import star.kwturb.*;
import star.keturb.*;
import star.common.*;
import star.flow.*;

public class physics_BC_InflowABL extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    PhysicsContinuum physicsContinuum_0 = 
      ((PhysicsContinuum) simulation_0.getContinuumManager().getContinuum("Physics 1"));

    VelocityProfile velocityProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(VelocityProfile.class);

    UserFieldFunction userFieldFunction_32 = 
      ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("VelocityProfile"));

    velocityProfile_0.getMethod(FunctionVectorProfileMethod.class).setFieldFunction(userFieldFunction_32);

    TurbulenceIntensityProfile turbulenceIntensityProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulenceIntensityProfile.class);

    turbulenceIntensityProfile_0.setMethod(FunctionScalarProfileMethod.class);

    UserFieldFunction userFieldFunction_33 = 
      ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("TI"));

    turbulenceIntensityProfile_0.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_33);

    TurbulentLengthScaleProfile turbulentLengthScaleProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulentLengthScaleProfile.class);

    turbulentLengthScaleProfile_0.setMethod(FunctionScalarProfileMethod.class);

    // physicsContinuum_0.getInitialConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.K_OMEGA);
    physicsContinuum_0.getInitialConditions().get(KeTurbSpecOption.class).setSelected(KeTurbSpecOption.Type.K_EPSILON);

    // SpecificDissipationRateProfile specificDissipationRateProfile_0 = 
    //   physicsContinuum_0.getInitialConditions().get(SpecificDissipationRateProfile.class);
    TurbulentDissipationRateProfile turbulentDissipationRateProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulentDissipationRateProfile.class);

    // specificDissipationRateProfile_0.setMethod(FunctionScalarProfileMethod.class);
    turbulentDissipationRateProfile_0.setMethod(FunctionScalarProfileMethod.class);






    UserFieldFunction userFieldFunction_34 = 
      ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("tdr"));

    // specificDissipationRateProfile_0.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_34);
    turbulentDissipationRateProfile_0.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_34);



    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_0.setMethod(FunctionScalarProfileMethod.class);



    UserFieldFunction userFieldFunction_35 = 
      ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("tke"));

    turbulentKineticEnergyProfile_0.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_35);



    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    Boundary boundary_0 = 
      // region_0.getBoundaryManager().getBoundary("Inlet");
    region_0.getBoundaryManager().getBoundary("Inlet");

    // boundary_0.getConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.K_OMEGA);
    boundary_0.getConditions().get(KeTurbSpecOption.class).setSelected(KeTurbSpecOption.Type.K_EPSILON);

    boundary_0.getConditions().get(InletVelocityOption.class).setSelected(InletVelocityOption.Type.COMPONENTS);

    VelocityProfile velocityProfile_1 = 
      boundary_0.getValues().get(VelocityProfile.class);

    velocityProfile_1.getMethod(FunctionVectorProfileMethod.class).setFieldFunction(userFieldFunction_32);



    // SpecificDissipationRateProfile specificDissipationRateProfile_1 = 
    //   boundary_0.getValues().get(SpecificDissipationRateProfile.class);
    // specificDissipationRateProfile_1.setMethod(FunctionScalarProfileMethod.class);
    // specificDissipationRateProfile_1.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_34);

    TurbulentDissipationRateProfile turbulentDissipationRateProfile_1 = 
      boundary_0.getValues().get(TurbulentDissipationRateProfile.class);
    turbulentDissipationRateProfile_1.setMethod(FunctionScalarProfileMethod.class);
    turbulentDissipationRateProfile_1.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_34);



    TurbulentKineticEnergyProfile turbulentKineticEnergyProfile_1 = 
      boundary_0.getValues().get(TurbulentKineticEnergyProfile.class);

    turbulentKineticEnergyProfile_1.setMethod(FunctionScalarProfileMethod.class);

    turbulentKineticEnergyProfile_1.getMethod(FunctionScalarProfileMethod.class).setFieldFunction(userFieldFunction_35);

    // Solution solution_0 = 
    //   simulation_0.getSolution();

    // solution_0.initializeSolution();
  }
}
