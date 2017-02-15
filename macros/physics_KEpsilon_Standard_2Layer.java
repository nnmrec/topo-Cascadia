// STAR-CCM+ macro: physics_KEpsilon_Standard_2Layer.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.vdm.*;
import star.turbulence.*;
import star.material.*;
import star.common.*;
import star.keturb.*;
import star.base.neo.*;
import star.flow.*;
import star.segregatedflow.*;
import star.metrics.*;

public class physics_KEpsilon_Standard_2Layer extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    PhysicsContinuum physicsContinuum_0 = 
      simulation_0.getContinuumManager().createContinuum(PhysicsContinuum.class);

    physicsContinuum_0.enable(ThreeDimensionalModel.class);

    physicsContinuum_0.enable(SteadyModel.class);

    physicsContinuum_0.enable(SingleComponentLiquidModel.class);

    physicsContinuum_0.enable(SegregatedFlowModel.class);

    physicsContinuum_0.enable(ConstantDensityModel.class);

    physicsContinuum_0.enable(TurbulentModel.class);

    physicsContinuum_0.enable(RansTurbulenceModel.class);

    physicsContinuum_0.enable(KEpsilonTurbulence.class);

    physicsContinuum_0.enable(SkeTwoLayerTurbModel.class);

    physicsContinuum_0.enable(KeTwoLayerAllYplusWallTreatment.class);

    physicsContinuum_0.enable(VirtualDiskModel.class);

    SingleComponentLiquidModel singleComponentLiquidModel_0 = 
      physicsContinuum_0.getModelManager().getModel(SingleComponentLiquidModel.class);

    Liquid liquid_0 = 
      ((Liquid) singleComponentLiquidModel_0.getMaterial());

    


    ConstantMaterialPropertyMethod constantMaterialPropertyMethod_0 = 
      ((ConstantMaterialPropertyMethod) liquid_0.getMaterialProperties().getMaterialProperty(ConstantDensityProperty.class).getMethod());

    // constantMaterialPropertyMethod_0.getQuantity().setValue(1024.0);
    constantMaterialPropertyMethod_0.getQuantity().setDefinition("${__density}");

    


    ConstantMaterialPropertyMethod constantMaterialPropertyMethod_1 = 
      ((ConstantMaterialPropertyMethod) liquid_0.getMaterialProperties().getMaterialProperty(DynamicViscosityProperty.class).getMethod());

    // constantMaterialPropertyMethod_1.getQuantity().setValue(1.0E-5);
    constantMaterialPropertyMethod_1.getQuantity().setDefinition("${__dynamic_viscosity}");





  }
}
