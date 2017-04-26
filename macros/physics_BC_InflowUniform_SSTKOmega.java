// STAR-CCM+ macro: physics_BC_InflowUniform_SSTKOmega.java
// Written by STAR-CCM+ 11.02.010
package macro;

import java.util.*;

import star.turbulence.*;
import star.kwturb.*;
import star.common.*;
import star.flow.*;

public class physics_BC_InflowUniform_SSTKOmega extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    PhysicsContinuum physicsContinuum_0 = 
      ((PhysicsContinuum) simulation_0.getContinuumManager().getContinuum("Physics 1"));


    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");




    InletBoundary inletBoundary_0 = 
      ((InletBoundary) simulation_0.get(ConditionTypeManager.class).get(InletBoundary.class));


    PressureBoundary pressureBoundary_0 = 
      ((PressureBoundary) simulation_0.get(ConditionTypeManager.class).get(PressureBoundary.class));


    Boundary boundary_12 = 
      region_0.getBoundaryManager().getBoundary("Inlet");

      boundary_12.setBoundaryType(inletBoundary_0);

    // Boundary boundary_1 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.north");
    //   boundary_1.setBoundaryType(inletBoundary_0);

    // Boundary boundary_2 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.west");
    //   boundary_2.setBoundaryType(inletBoundary_0);

    Boundary boundary_34 = 
      region_0.getBoundaryManager().getBoundary("Outlet");
      
      boundary_34.setBoundaryType(pressureBoundary_0);
      
    // Boundary boundary_3 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.south");
    //   boundary_3.setBoundaryType(pressureBoundary_0);

    // Boundary boundary_4 = 
    //   region_0.getBoundaryManager().getBoundary("Subtract.east");
    //   boundary_4.setBoundaryType(pressureBoundary_0);

    Boundary boundary_5 = 
      region_0.getBoundaryManager().getBoundary("Subtract.seasurface");
      boundary_5.getConditions().get(WallShearStressOption.class).setSelected(WallShearStressOption.Type.SLIP);

    Boundary boundary_6 = 
      region_0.getBoundaryManager().getBoundary("Subtract.coast");
      boundary_6.getConditions().get(WallShearStressOption.class).setSelected(WallShearStressOption.Type.SLIP);

    Boundary boundary_7 = 
      region_0.getBoundaryManager().getBoundary("Subtract.seabed");
      boundary_7.getConditions().get(WallShearStressOption.class).setSelected(WallShearStressOption.Type.NO_SLIP);
      boundary_7.getConditions().get(WallSurfaceOption.class).setSelected(WallSurfaceOption.Type.ROUGH);



      // get the user defined field functions
      UserFieldFunction userFieldFunction_init_TI = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__init_TI"));
      UserFieldFunction userFieldFunction_init_Lturb = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__init_Lturb"));
      UserFieldFunction userFieldFunction_init_Vturb = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__init_Vturb"));
      UserFieldFunction userFieldFunction_init_Vx = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__init_Vx"));
      UserFieldFunction userFieldFunction_init_Vy = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__init_Vy"));
      UserFieldFunction userFieldFunction_init_Vz = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__init_Vz"));
      UserFieldFunction userFieldFunction_inlet_Vx = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__inlet_Vx"));
      UserFieldFunction userFieldFunction_inlet_Vy = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__inlet_Vy"));
      UserFieldFunction userFieldFunction_inlet_Vz = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__inlet_Vz"));




      ///////////////////////////////////////////////////////////////////////////////
     // Set Initial Conditions
    //   

    physicsContinuum_0.getInitialConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.INTENSITY_LENGTH_SCALE);

    TurbulenceIntensityProfile turbulenceIntensityProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulenceIntensityProfile.class);

    turbulenceIntensityProfile_0.setMethod(ConstantScalarProfileMethod.class);

    // turbulenceIntensityProfile_0.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_TI);
    turbulenceIntensityProfile_0.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_TI.getDefinition()));
    

    TurbulentLengthScaleProfile turbulentLengthScaleProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulentLengthScaleProfile.class);

    turbulentLengthScaleProfile_0.setMethod(ConstantScalarProfileMethod.class);

    turbulentLengthScaleProfile_0.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_Lturb.getDefinition()));

    TurbulentVelocityScaleProfile turbulentVelocityScaleProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(TurbulentVelocityScaleProfile.class);

    turbulentVelocityScaleProfile_0.setMethod(FunctionScalarProfileMethod.class);

    turbulentVelocityScaleProfile_0.setMethod(ConstantScalarProfileMethod.class);

    // turbulentVelocityScaleProfile_0.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_Vturb);
    turbulentVelocityScaleProfile_0.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_Vturb.getDefinition()));

    VelocityProfile velocityProfile_0 = 
      physicsContinuum_0.getInitialConditions().get(VelocityProfile.class);

    velocityProfile_0.setMethod(ConstantVectorProfileMethod.class);

    // velocityProfile_0.getMethod(ConstantVectorProfileMethod.class).getQuantity().setComponents(init_Vx, init_Vy, init_Vz);
    velocityProfile_0.getMethod(ConstantVectorProfileMethod.class).getQuantity().setComponents(Double.parseDouble(userFieldFunction_init_Vx.getDefinition()), 
                                                                                               Double.parseDouble(userFieldFunction_init_Vy.getDefinition()), 
                                                                                               Double.parseDouble(userFieldFunction_init_Vz.getDefinition()));







    

    // Boundary boundary_1 = 
    //   // region_0.getBoundaryManager().getBoundary("Inlet");
    // // region_0.getBoundaryManager().getBoundary("Block.Inlet");
    // region_0.getBoundaryManager().getBoundary("Subtract.north");

    boundary_12.getConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.INTENSITY_LENGTH_SCALE);
    boundary_12.getConditions().get(InletVelocityOption.class).setSelected(InletVelocityOption.Type.COMPONENTS);

    TurbulenceIntensityProfile turbulenceIntensityProfile_1 = 
      boundary_12.getValues().get(TurbulenceIntensityProfile.class);

    turbulenceIntensityProfile_1.setMethod(FunctionScalarProfileMethod.class);

    turbulenceIntensityProfile_1.setMethod(ConstantScalarProfileMethod.class);

    // turbulenceIntensityProfile_1.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_TI);
    turbulenceIntensityProfile_1.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_TI.getDefinition()));

    TurbulentLengthScaleProfile turbulentLengthScaleProfile_1 = 
      boundary_12.getValues().get(TurbulentLengthScaleProfile.class);

    turbulentLengthScaleProfile_1.setMethod(FunctionScalarProfileMethod.class);

    turbulentLengthScaleProfile_1.setMethod(ConstantScalarProfileMethod.class);

    // turbulentLengthScaleProfile_1.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_Lturb);
    turbulentLengthScaleProfile_1.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_Lturb.getDefinition()));

    VelocityProfile velocityProfile_1 = 
      boundary_12.getValues().get(VelocityProfile.class);

    // boundary_1.getConditions().get(InletVelocityOption.class).setSelected(InletVelocityOption.Type.COMPONENTS);

    velocityProfile_1.setMethod(ConstantVectorProfileMethod.class);

    // velocityProfile_1.getMethod(ConstantVectorProfileMethod.class).getQuantity().setComponents(inlet_Vx, inlet_Vy, inlet_Vz);
    velocityProfile_1.getMethod(ConstantVectorProfileMethod.class).getQuantity().setComponents(Double.parseDouble(userFieldFunction_inlet_Vx.getDefinition()), 
                                                                                               Double.parseDouble(userFieldFunction_inlet_Vy.getDefinition()), 
                                                                                               Double.parseDouble(userFieldFunction_inlet_Vz.getDefinition()));





// Boundary boundary_2 = 
//       // region_0.getBoundaryManager().getBoundary("Inlet");
//     // region_0.getBoundaryManager().getBoundary("Block.Inlet");
//     region_0.getBoundaryManager().getBoundary("Subtract.west");

    boundary_12.getConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.INTENSITY_LENGTH_SCALE);
    boundary_12.getConditions().get(InletVelocityOption.class).setSelected(InletVelocityOption.Type.COMPONENTS);

    TurbulenceIntensityProfile turbulenceIntensityProfile_2 = 
      boundary_12.getValues().get(TurbulenceIntensityProfile.class);

    turbulenceIntensityProfile_2.setMethod(FunctionScalarProfileMethod.class);

    turbulenceIntensityProfile_2.setMethod(ConstantScalarProfileMethod.class);

    // turbulenceIntensityProfile_2.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_TI);
    turbulenceIntensityProfile_2.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_TI.getDefinition()));

    TurbulentLengthScaleProfile turbulentLengthScaleProfile_2 = 
      boundary_12.getValues().get(TurbulentLengthScaleProfile.class);

    turbulentLengthScaleProfile_2.setMethod(FunctionScalarProfileMethod.class);

    turbulentLengthScaleProfile_2.setMethod(ConstantScalarProfileMethod.class);

    // turbulentLengthScaleProfile_2.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_Lturb);
    turbulentLengthScaleProfile_2.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_Lturb.getDefinition()));

    VelocityProfile velocityProfile_2 = 
      boundary_12.getValues().get(VelocityProfile.class);

    // boundary_2.getConditions().get(InletVelocityOption.class).setSelected(InletVelocityOption.Type.COMPONENTS);

    velocityProfile_2.setMethod(ConstantVectorProfileMethod.class);

    // velocityProfile_2.getMethod(ConstantVectorProfileMethod.class).getQuantity().setComponents(inlet_Vx, inlet_Vy, inlet_Vz);
    velocityProfile_2.getMethod(ConstantVectorProfileMethod.class).getQuantity().setComponents(Double.parseDouble(userFieldFunction_inlet_Vx.getDefinition()), 
                                                                                               Double.parseDouble(userFieldFunction_inlet_Vy.getDefinition()), 
                                                                                               Double.parseDouble(userFieldFunction_inlet_Vz.getDefinition()));



    // Boundary boundary_3 = 
    //   // region_0.getBoundaryManager().getBoundary("Block.Outlet");
    //   region_0.getBoundaryManager().getBoundary("Subtract.south");

    boundary_34.getConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.INTENSITY_LENGTH_SCALE);

    TurbulenceIntensityProfile turbulenceIntensityProfile_3 = 
      boundary_34.getValues().get(TurbulenceIntensityProfile.class);

    turbulenceIntensityProfile_3.setMethod(FunctionScalarProfileMethod.class);

    turbulenceIntensityProfile_3.setMethod(ConstantScalarProfileMethod.class);

    // turbulenceIntensityProfile_3.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_TI);
    turbulenceIntensityProfile_3.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_TI.getDefinition()));

    TurbulentLengthScaleProfile turbulentLengthScaleProfile_3 = 
      boundary_34.getValues().get(TurbulentLengthScaleProfile.class);

    turbulentLengthScaleProfile_3.setMethod(FunctionScalarProfileMethod.class);

    turbulentLengthScaleProfile_3.setMethod(ConstantScalarProfileMethod.class);

    // turbulentLengthScaleProfile_3.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_Lturb);
    turbulentLengthScaleProfile_3.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_Lturb.getDefinition()));


    // Boundary boundary_4 = 
    //   // region_0.getBoundaryManager().getBoundary("Block.Outlet");
    //   region_0.getBoundaryManager().getBoundary("Subtract.east");

    boundary_34.getConditions().get(KwTurbSpecOption.class).setSelected(KwTurbSpecOption.Type.INTENSITY_LENGTH_SCALE);

    TurbulenceIntensityProfile turbulenceIntensityProfile_4 = 
      boundary_34.getValues().get(TurbulenceIntensityProfile.class);

    turbulenceIntensityProfile_4.setMethod(FunctionScalarProfileMethod.class);

    turbulenceIntensityProfile_4.setMethod(ConstantScalarProfileMethod.class);

    // turbulenceIntensityProfile_4.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_TI);
    turbulenceIntensityProfile_4.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_TI.getDefinition()));

    TurbulentLengthScaleProfile turbulentLengthScaleProfile_4 = 
      boundary_34.getValues().get(TurbulentLengthScaleProfile.class);

    turbulentLengthScaleProfile_4.setMethod(FunctionScalarProfileMethod.class);

    turbulentLengthScaleProfile_4.setMethod(ConstantScalarProfileMethod.class);

    // turbulentLengthScaleProfile_4.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(init_Lturb);
    turbulentLengthScaleProfile_4.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValue(Double.parseDouble(userFieldFunction_init_Lturb.getDefinition()));



  }
}
