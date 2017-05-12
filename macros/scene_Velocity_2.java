// STAR-CCM+ macro: scene_Velocity_2.java
// Written by STAR-CCM+ 12.02.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.vis.*;

public class scene_Velocity_2 extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    PlaneSection planeSection_0 = 
      (PlaneSection) simulation_0.getPartManager().createImplicitPart(new NeoObjectVector(new Object[] {}), new DoubleVector(new double[] {0.0, 0.0, 1.0}), new DoubleVector(new double[] {0.0, 0.0, 0.0}), 0, 1, new DoubleVector(new double[] {0.0}));

    planeSection_0.setPresentationName("plane-hub-height");

    Coordinate coordinate_0 = 
      planeSection_0.getOriginCoordinate();

    Units units_0 = 
      ((Units) simulation_0.getUnitsManager().getObject("m"));

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {0.0, 0.0, -33.0}));

    simulation_0.getSceneManager().createScalarScene("Scalar Scene", "Outline", "Scalar");

    Scene scene_0 = 
      simulation_0.getSceneManager().getScene("Scalar Scene 1");

    scene_0.initializeAndWait();

    PartDisplayer partDisplayer_0 = 
      ((PartDisplayer) scene_0.getDisplayerManager().getDisplayer("Outline 1"));

    partDisplayer_0.initialize();

    ScalarDisplayer scalarDisplayer_0 = 
      ((ScalarDisplayer) scene_0.getDisplayerManager().getDisplayer("Scalar 1"));

    scalarDisplayer_0.initialize();

    SceneUpdate sceneUpdate_0 = 
      scene_0.getSceneUpdate();

    HardcopyProperties hardcopyProperties_1 = 
      sceneUpdate_0.getHardcopyProperties();

    hardcopyProperties_1.setCurrentResolutionWidth(1462);

    hardcopyProperties_1.setCurrentResolutionHeight(614);

    scene_0.resetCamera();

    scene_0.setPresentationName("velocity-hub-height");

    CurrentView currentView_0 = 
      scene_0.getCurrentView();

    currentView_0.setInput(new DoubleVector(new double[] {32.474365234375455, 32.73633088700126, -49.54314006879586}), new DoubleVector(new double[] {32.474365234375455, 32.73633088700126, 10977.864468154592}), new DoubleVector(new double[] {0.0, 1.0, 0.0}), 2878.73105031965, 1);

    scalarDisplayer_0.getInputParts().setQuery(null);

    scalarDisplayer_0.getInputParts().setObjects(planeSection_0);

    PrimitiveFieldFunction primitiveFieldFunction_0 = 
      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("Velocity"));

    VectorMagnitudeFieldFunction vectorMagnitudeFieldFunction_0 = 
      ((VectorMagnitudeFieldFunction) primitiveFieldFunction_0.getMagnitudeFunction());

    scalarDisplayer_0.getScalarDisplayQuantity().setFieldFunction(vectorMagnitudeFieldFunction_0);

    scalarDisplayer_0.getScalarDisplayQuantity().setClip(ClipMode.NONE);

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.4, 1.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.4, 2.6}));

    planeSection_0.getInputParts().setQuery(null);

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    Boundary boundary_0 = 
      region_0.getBoundaryManager().getBoundary("Inlet");

    Boundary boundary_1 = 
      region_0.getBoundaryManager().getBoundary("Outlet");

    Boundary boundary_2 = 
      region_0.getBoundaryManager().getBoundary("Subtract.coast");

    Boundary boundary_3 = 
      region_0.getBoundaryManager().getBoundary("Subtract.seabed");

    Boundary boundary_4 = 
      region_0.getBoundaryManager().getBoundary("Subtract.seasurface");

    planeSection_0.getInputParts().setObjects(region_0, boundary_0, boundary_1, boundary_2, boundary_3, boundary_4);

    currentView_0.setInput(new DoubleVector(new double[] {32.474365234375455, 32.73633088700126, -49.54314006879586}), new DoubleVector(new double[] {32.474365234375455, 32.73633088700126, 10977.864468154592}), new DoubleVector(new double[] {0.0, 1.0, 0.0}), 2878.73105031965, 1);

    scalarDisplayer_0.setFillMode(ScalarFillMode.NODE_FILLED);

    Legend legend_0 = 
      scalarDisplayer_0.getLegend();

    legend_0.setLevels(21);

    legend_0.setNumberOfLabels(5);

    PredefinedLookupTable predefinedLookupTable_0 = 
      ((PredefinedLookupTable) simulation_0.get(LookupTableManager.class).getObject("purple-red basic (large difference)"));

    legend_0.setLookupTable(predefinedLookupTable_0);

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.6}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.5}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.5}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.4, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.2}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.6}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.25, 2.6}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.25, 2.55}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.55}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.4}));

    ScalarDisplayer scalarDisplayer_1 = 
      scene_0.getDisplayerManager().createScalarDisplayer("Scalar");

    scalarDisplayer_1.initialize();

    scalarDisplayer_1.getInputParts().setQuery(null);

    scalarDisplayer_1.getInputParts().setObjects(boundary_3);

    PrimitiveFieldFunction primitiveFieldFunction_1 = 
      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("Centroid"));

    VectorComponentFieldFunction vectorComponentFieldFunction_0 = 
      ((VectorComponentFieldFunction) primitiveFieldFunction_1.getComponentFunction(2));

    scalarDisplayer_1.getScalarDisplayQuantity().setFieldFunction(vectorComponentFieldFunction_0);

    scalarDisplayer_1.getScalarDisplayQuantity().setClip(ClipMode.NONE);

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-120.0, -4.494919631394392}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-120.0, -30.0}));

    scalarDisplayer_1.setFillMode(ScalarFillMode.NODE_LINES);

    Legend legend_1 = 
      scalarDisplayer_1.getLegend();

    legend_1.setVisible(false);

    ContourLabel contourLabel_0 = 
      scalarDisplayer_1.getContourLabel();

    contourLabel_0.setVisible(true);

    contourLabel_0.setLabelPrecision(2);

    contourLabel_0.setLabelPrecision(1);

    contourLabel_0.setLabelPrecision(2);

    scalarDisplayer_1.setOpacity(0.533);

    scalarDisplayer_0.setVisibilityOverrideMode(DisplayerVisibilityOverride.HIDE_ALL_PARTS);

    scalarDisplayer_1.setPointSize(2);

    scalarDisplayer_1.setPointSize(1);

    scalarDisplayer_1.setOpacity(0.243);

    scalarDisplayer_1.setOpacity(0.07305);

    scalarDisplayer_1.setOpacity(0.0);

    scalarDisplayer_1.setOpacity(0.489);

    scalarDisplayer_1.setLineWidth(0.5);

    scalarDisplayer_1.setLineWidth(0.2);

    scalarDisplayer_1.setLineWidth(0.1);

    scalarDisplayer_1.setLineWidth(0.01);

    scalarDisplayer_1.setLineWidth(0.001);

    scalarDisplayer_1.setPointSize(0);

    scalarDisplayer_1.setOpacity(0.107);

    scalarDisplayer_1.setOpacity(0.02248);

    contourLabel_0.setLabelSize(0.01);

    contourLabel_0.setLabelSize(0.03);

    contourLabel_0.setLabelSize(0.02);

    contourLabel_0.setPointSize(1);

    contourLabel_0.setPointSize(0);

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-120.0, -20.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-120.0, -50.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-120.0, -20.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-100.0, -20.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-120.0, -20.0}));

    scalarDisplayer_1.setOpacity(0.467);

    BlackWhiteLookupTable blackWhiteLookupTable_0 = 
      ((BlackWhiteLookupTable) simulation_0.get(LookupTableManager.class).getObject("grayscale"));

    legend_1.setLookupTable(blackWhiteLookupTable_0);

    legend_1.setLevels(11);

    scalarDisplayer_1.setOpacity(0.695);

    scalarDisplayer_0.setVisibilityOverrideMode(DisplayerVisibilityOverride.USE_PART_PROPERTY);

    scalarDisplayer_1.setOpacity(1.0);

    scalarDisplayer_1.setOpacity(0.528);

    scalarDisplayer_0.setVisibilityOverrideMode(DisplayerVisibilityOverride.HIDE_ALL_PARTS);

    scalarDisplayer_1.setLineWidth(0.1);

    scalarDisplayer_1.setLineWidth(1.0);

    scalarDisplayer_1.setLineWidth(2.0);

    scalarDisplayer_1.setLineWidth(4.0);

    scalarDisplayer_0.setVisibilityOverrideMode(DisplayerVisibilityOverride.USE_PART_PROPERTY);

    scalarDisplayer_0.setOpacity(0.887);

    scalarDisplayer_0.setOpacity(0.316);

    scalarDisplayer_0.setOpacity(1.0);

    SimpleTransform simpleTransform_0 = 
      ((SimpleTransform) simulation_0.getTransformManager().getObject("scale_z10"));

    scalarDisplayer_0.setVisTransform(simpleTransform_0);

    scalarDisplayer_1.setOpacity(0.528);

    scalarDisplayer_1.setOpacity(0.627);

    contourLabel_0.setLabelSize(0.1);

    contourLabel_0.setLabelSize(0.03);

    contourLabel_0.setLabelSize(0.02);

    legend_1.setLevels(16);

    legend_1.setLevels(7);

    scalarDisplayer_1.setOpacity(0.495);

    legend_1.setLevels(9);

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.3}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.4, 2.3}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.4, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.3}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.3}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.2}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-120.0, -30.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-150.0, -30.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-100.0, -30.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-100.0, -20.0}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.2}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.4, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.4, 2.5}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.35, 2.5}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.35, 2.45}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.25, 2.45}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.25, 2.5}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.25, 2.55}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-80.0, -20.0}));

    legend_1.setLevels(11);

    legend_1.setLevels(5);

    legend_1.setLevels(9);

    legend_1.setLevels(11);

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-120.0, -20.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-120.0, -50.0}));

    scalarDisplayer_1.setOpacity(0.6);

    scalarDisplayer_1.setOpacity(0.5);

    scalarDisplayer_1.setOpacity(0.405);

    legend_1.setLevels(9);

    scalarDisplayer_1.setOpacity(0.495);

    scalarDisplayer_1.setOpacity(0.587);

    scalarDisplayer_1.setOpacity(0.354);

    scalarDisplayer_1.setOpacity(0.214);

    scalarDisplayer_1.setOpacity(0.413);

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-150.0, -50.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-130.0, -50.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-100.0, -50.0}));

    legend_1.setLevels(7);

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-100.0, -20.0}));

    scalarDisplayer_1.setOpacity(0.362);

    ScalarDisplayer scalarDisplayer_2 = 
      scene_0.getDisplayerManager().createScalarDisplayer("Scalar");

    scalarDisplayer_2.initialize();

    scene_0.getDisplayerManager().deleteDisplayers(new NeoObjectVector(new Object[] {scalarDisplayer_2}));

    PartDisplayer partDisplayer_1 = 
      scene_0.getDisplayerManager().createPartDisplayer("Geometry", -1, 4);

    partDisplayer_1.initialize();

    scene_0.getDisplayerManager().deleteDisplayers(new NeoObjectVector(new Object[] {partDisplayer_1}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-100.0, 0.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-90.0, 0.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-90.0, -10.0}));

    scalarDisplayer_1.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {-100.0, -10.0}));

    legend_1.setLevels(9);

    legend_1.setLevels(10);

    scalarDisplayer_1.setOpacity(0.511);

    scalarDisplayer_1.setOpacity(0.444);

    scalarDisplayer_1.setOpacity(0.511);

    scalarDisplayer_1.setOpacity(0.539);

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.55}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.5}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.3, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.4}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.3}));

    legend_1.setNumberOfLabels(8);

    legend_0.setNumberOfLabels(7);

    legend_0.setNumberOfLabels(8);

    legend_0.setNumberOfLabels(7);

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.25, 2.3}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.25, 2.35}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.35}));

    scalarDisplayer_0.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {1.2, 2.4}));
  }
}
