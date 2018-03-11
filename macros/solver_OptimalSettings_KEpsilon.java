// STAR-CCM+ macro: solver_OptimalSettings_KEpsilon.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.common.*;
import star.keturb.*;
import star.base.neo.*;
import star.segregatedflow.*;

public class solver_OptimalSettings_KEpsilon extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    PhysicsContinuum physicsContinuum_0 = 
      ((PhysicsContinuum) simulation_0.getContinuumManager().getContinuum("Physics 1"));

    KeTwoLayerAllYplusWallTreatment keTwoLayerAllYplusWallTreatment_0 = 
      physicsContinuum_0.getModelManager().getModel(KeTwoLayerAllYplusWallTreatment.class);

    // keTwoLayerAllYplusWallTreatment_0.setIterativeUstarOption(true);

    keTwoLayerAllYplusWallTreatment_0.setIterativeUstarOption(false);

    SegregatedFlowModel segregatedFlowModel_0 = 
      physicsContinuum_0.getModelManager().getModel(SegregatedFlowModel.class);

    segregatedFlowModel_0.getDeltaVDissipationOption().setSelected(DeltaVDissipationOption.Type.ON);

    // segregatedFlowModel_0.getDeltaVDissipationOption().setSelected(DeltaVDissipationOption.Type.OFF);

    SegregatedFlowSolver segregatedFlowSolver_0 = 
      ((SegregatedFlowSolver) simulation_0.getSolverManager().getSolver(SegregatedFlowSolver.class));

    segregatedFlowSolver_0.setContinuityInitialization(true);

    // segregatedFlowSolver_0.setContinuityInitialization(false);

    KeTurbSolver keTurbSolver_0 = 
      ((KeTurbSolver) simulation_0.getSolverManager().getSolver(KeTurbSolver.class));

    keTurbSolver_0.setTurbulenceInitialization(true);

    // keTurbSolver_0.setTurbulenceInitialization(false);

    
    ContinuityInitializer continuityInitializer_0 = 
      segregatedFlowSolver_0.getContinuityInitializer();

    continuityInitializer_0.setTolerance(0.001);


    KeTurbViscositySolver keTurbViscositySolver_0 = 
      ((KeTurbViscositySolver) simulation_0.getSolverManager().getSolver(KeTurbViscositySolver.class));

    keTurbViscositySolver_0.setMaxTvr(1.0E10);
  }
}
