// STAR-CCM+ macro: scene_TKE.java
// Written by STAR-CCM+ 12.02.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.vis.*;

public class scene_TKE extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    Scene scene_1 = 
      simulation_0.getSceneManager().createScene("Copy of velocity-hub-height");

    scene_1.setPresentationName("Copy of velocity-hub-height");

    Scene scene_0 = 
      simulation_0.getSceneManager().getScene("velocity-hub-height");

    scene_1.copyProperties(scene_0);

    scene_1.initializeAndWait();

    scene_1.open();

    PartDisplayer partDisplayer_2 = 
      ((PartDisplayer) scene_1.getDisplayerManager().getDisplayer("Outline 1"));

    partDisplayer_2.initialize();

    ScalarDisplayer scalarDisplayer_3 = 
      ((ScalarDisplayer) scene_1.getDisplayerManager().getDisplayer("Scalar 1"));

    scalarDisplayer_3.initialize();

    ScalarDisplayer scalarDisplayer_4 = 
      ((ScalarDisplayer) scene_1.getDisplayerManager().getDisplayer("Scalar 2"));

    scalarDisplayer_4.initialize();

    scene_1.setPresentationName("TKE-hub-height");

    PrimitiveFieldFunction primitiveFieldFunction_2 = 
      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("TurbulentKineticEnergy"));

    scalarDisplayer_3.getScalarDisplayQuantity().setFieldFunction(primitiveFieldFunction_2);

    scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.01, 0.04094487551504988}));

    scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.01, 0.03}));

    scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.001, 0.03}));

    scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.001, 0.01}));

    scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.001, 0.005}));

    scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.001, 0.002}));

    new StarScript(getActiveRootObject(),

                   new java.io.File(resolvePath("fieldFunction_TurbulenceIntensity.java"))).play();


    new StarScript(getActiveRootObject(),

                   new java.io.File(resolvePath("fieldFunction_TurbulenceIntensity.java"))).play();


    UserFieldFunction userFieldFunction_0 = 
      ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("local_TI"));

    scalarDisplayer_3.getScalarDisplayQuantity().setFieldFunction(userFieldFunction_0);

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.05, 1.211527066311844}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.05, 0.15}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.01, 0.15}));

    scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.01, 0.03}));

    // UserFieldFunction userFieldFunction_1 = 
    //   ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("Turbulence_Intensity_Ratio"));

    // scalarDisplayer_3.getScalarDisplayQuantity().setFieldFunction(userFieldFunction_1);

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.0, 59.12505040129376}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.0, 15.0}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.05, 15.0}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.05, 0.15}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setFieldFunction(userFieldFunction_0);

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.01, 1.211527066311844}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.01, 0.021}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setFieldFunction(primitiveFieldFunction_2);

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.001, 0.04094487551504988}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.001, 0.002}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.0E-4, 0.002}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.0E-4, 1.0E-4}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.0E-4, 2.0E-4}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.0E-4, 0.002}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.0E-4, 0.004}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.002, 0.004}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.003, 0.004}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.003, 0.005}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.002, 0.005}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.002, 0.05}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.02, 0.05}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setFieldFunction(userFieldFunction_0);

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.08, 1.211527066311844}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.08, 0.12}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.1, 0.12}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.1, 0.5}));

    // CurrentView currentView_1 = 
    //   scene_1.getCurrentView();

    // currentView_1.setInput(new DoubleVector(new double[] {-2225.3976379705605, -2604.448878794975, 1899.7261642383887}), new DoubleVector(new double[] {-7484.6109778943355, -8747.188420683107, -6361.556460854391}), new DoubleVector(new double[] {-0.7255179851597089, 0.1848191392120475, 0.6629219705144145}), 2878.73105031965, 1);

    // currentView_1.setInput(new DoubleVector(new double[] {-5136.809771335397, -2396.292981496107, 1527.6619003540036}), new DoubleVector(new double[] {-4011.273280623216, 5353.556122098951, 8869.1420792744}), new DoubleVector(new double[] {0.8487333605490137, -0.41317416180020566, 0.33005877463245137}), 2878.73105031965, 1);

    // scene_1.setViewOrientation(new DoubleVector(new double[] {0.0, 0.0, 1.0}), new DoubleVector(new double[] {0.0, 1.0, 0.0}));

    // scene_1.resetCamera();

    // scalarDisplayer_3.getScalarDisplayQuantity().setAutoRange(AutoRangeMode.BOTH);

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.5, 1.211527066311844}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.8, 1.211527066311844}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.8, 1.1}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.95, 1.1}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.05, 1.1}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.05, 1.2}));

    // scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.1, 1.2}));
  }
}
