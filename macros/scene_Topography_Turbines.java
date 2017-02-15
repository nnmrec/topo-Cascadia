// STAR-CCM+ macro: scene_Topography_Turbines.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.vis.*;
import star.meshing.*;

public class scene_Topography_Turbines extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    simulation_0.getSceneManager().createScalarScene("Scalar Scene", "Outline", "Scalar");

    Scene scene_6 = 
      simulation_0.getSceneManager().getScene("Scalar Scene 1");

    scene_6.initializeAndWait();

    PartDisplayer partDisplayer_6 = 
      ((PartDisplayer) scene_6.getDisplayerManager().getDisplayer("Outline 1"));

    partDisplayer_6.initialize();

    ScalarDisplayer scalarDisplayer_3 = 
      ((ScalarDisplayer) scene_6.getDisplayerManager().getDisplayer("Scalar 1"));

    scalarDisplayer_3.initialize();

    scene_6.open(true);

    SceneUpdate sceneUpdate_2 = 
      scene_6.getSceneUpdate();

    HardcopyProperties hardcopyProperties_7 = 
      sceneUpdate_2.getHardcopyProperties();

    hardcopyProperties_7.setCurrentResolutionWidth(1566);

    hardcopyProperties_7.setCurrentResolutionHeight(578);

    scene_6.resetCamera();

    scene_6.setPresentationName("turbines_topo");

    scalarDisplayer_3.setPresentationName("BC");

    scalarDisplayer_3.setPresentationName("BC velocity");

    scalarDisplayer_3.getInputParts().setQuery(null);

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    Boundary boundary_0 = 
      region_0.getBoundaryManager().getBoundary("Subtract.coast");

    Boundary boundary_1 = 
      region_0.getBoundaryManager().getBoundary("Subtract.east");

    Boundary boundary_2 = 
      region_0.getBoundaryManager().getBoundary("Subtract.north");

    Boundary boundary_3 = 
      region_0.getBoundaryManager().getBoundary("Subtract.south");

    Boundary boundary_4 = 
      region_0.getBoundaryManager().getBoundary("Subtract.west");

    scalarDisplayer_3.getInputParts().setObjects(boundary_0, boundary_1, boundary_2, boundary_3, boundary_4);

    CurrentView currentView_1 = 
      scene_6.getCurrentView();

    currentView_1.setInput(new DoubleVector(new double[] {32.471466064453125, 65.0969573461697, -32.41184616088867}), new DoubleVector(new double[] {32.471466064453125, 65.0969573461697, 1679.967414349855}), new DoubleVector(new double[] {0.0, 1.0, 0.0}), 443.19636505875127, 0);

    currentView_1.setInput(new DoubleVector(new double[] {19.134291013262708, 99.03241307142508, -92.99655761270915}), new DoubleVector(new double[] {522.0083047307552, -1180.4933307530382, 949.2209344653335}), new DoubleVector(new double[] {0.13481212770756257, 0.6569797490261344, 0.7417569006032351}), 443.19636505875127, 0);

    PrimitiveFieldFunction primitiveFieldFunction_0 = 
      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("Velocity"));

    VectorMagnitudeFieldFunction vectorMagnitudeFieldFunction_0 = 
      ((VectorMagnitudeFieldFunction) primitiveFieldFunction_0.getMagnitudeFunction());

    scalarDisplayer_3.getScalarDisplayQuantity().setFieldFunction(vectorMagnitudeFieldFunction_0);

    scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.5, 1.8870208917146647}));

    scalarDisplayer_3.getScalarDisplayQuantity().setRange(new DoubleVector(new double[] {0.5, 1.5}));

    scalarDisplayer_3.getScalarDisplayQuantity().setClip(ClipMode.NONE);

    scalarDisplayer_3.setFillMode(ScalarFillMode.NODE_FILLED);

    Legend legend_0 = 
      scalarDisplayer_3.getLegend();

    PredefinedLookupTable predefinedLookupTable_0 = 
      ((PredefinedLookupTable) simulation_0.get(LookupTableManager.class).getObject("Kelvin temperature"));

    legend_0.setLookupTable(predefinedLookupTable_0);

    legend_0.setReverse(true);

    legend_0.setLevels(11);

    legend_0.setNumberOfLabels(5);

    scalarDisplayer_3.setFillMode(ScalarFillMode.NODE_FILLED_WITH_LINES);

    PartDisplayer partDisplayer_7 = 
      scene_6.getDisplayerManager().createPartDisplayer("Geometry", -1, 4);

    partDisplayer_7.initialize();

    partDisplayer_7.setPresentationName("turbines");

    partDisplayer_7.getInputParts().setQuery(null);

    ThresholdPart thresholdPart_0 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-1"));

    ThresholdPart thresholdPart_1 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-2"));

    ThresholdPart thresholdPart_2 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-3"));

    ThresholdPart thresholdPart_3 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-4"));

    ThresholdPart thresholdPart_4 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-5"));

    ThresholdPart thresholdPart_5 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-6"));

    ThresholdPart thresholdPart_6 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-7"));

    ThresholdPart thresholdPart_7 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-8"));

    ThresholdPart thresholdPart_8 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-9"));

    ThresholdPart thresholdPart_9 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("ccw_turbine-10"));

    ThresholdPart thresholdPart_10 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-1"));

    ThresholdPart thresholdPart_11 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-2"));

    ThresholdPart thresholdPart_12 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-3"));

    ThresholdPart thresholdPart_13 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-4"));

    ThresholdPart thresholdPart_14 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-5"));

    ThresholdPart thresholdPart_15 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-6"));

    ThresholdPart thresholdPart_16 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-7"));

    ThresholdPart thresholdPart_17 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-8"));

    ThresholdPart thresholdPart_18 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-9"));

    ThresholdPart thresholdPart_19 = 
      ((ThresholdPart) simulation_0.getPartManager().getObject("cw_turbine-10"));

    partDisplayer_7.getInputParts().setObjects(thresholdPart_0, thresholdPart_1, thresholdPart_2, thresholdPart_3, thresholdPart_4, thresholdPart_5, thresholdPart_6, thresholdPart_7, thresholdPart_8, thresholdPart_9, thresholdPart_10, thresholdPart_11, thresholdPart_12, thresholdPart_13, thresholdPart_14, thresholdPart_15, thresholdPart_16, thresholdPart_17, thresholdPart_18, thresholdPart_19);

    partDisplayer_7.setMesh(true);

    partDisplayer_7.setSurface(true);

    currentView_1.setInput(new DoubleVector(new double[] {-221.35940232077823, 41.410473046264855, -37.85711579684124}), new DoubleVector(new double[] {-179.3198391128639, -65.55608699929162, 49.270806783034104}), new DoubleVector(new double[] {0.13481212770756257, 0.6569797490261344, 0.7417569006032351}), 443.19636505875127, 0);

    partDisplayer_7.setOpacity(0.282);

    currentView_1.setInput(new DoubleVector(new double[] {-135.23492188822996, 37.49791583670742, -93.971873941068}), new DoubleVector(new double[] {149.61736781410508, -687.2876724403579, 496.39078328113976}), new DoubleVector(new double[] {0.13481212770756257, 0.6569797490261344, 0.7417569006032351}), 443.19636505875127, 0);

    currentView_1.setInput(new DoubleVector(new double[] {-135.23492188822996, 37.49791583670742, -93.971873941068}), new DoubleVector(new double[] {149.61736781410508, -687.2876724403579, 496.39078328113976}), new DoubleVector(new double[] {0.13481212770756257, 0.6569797490261344, 0.7417569006032351}), 443.19636505875127, 0);

    currentView_1.setInput(new DoubleVector(new double[] {-135.6432561547051, 37.711996533234554, -93.31504371755177}), new DoubleVector(new double[] {176.11315106829116, -701.8217096481834, 454.9961347638713}), new DoubleVector(new double[] {0.1464149597153987, 0.6284985759487693, 0.76390588399482}), 443.19636505875127, 0);

    PartDisplayer partDisplayer_8 = 
      scene_6.getDisplayerManager().createPartDisplayer("Geometry", -1, 4);

    partDisplayer_8.initialize();

    partDisplayer_8.setPresentationName("seabed");

    partDisplayer_8.getInputParts().setQuery(null);

    MeshPart meshPart_0 = 
      ((MeshPart) simulation_0.get(SimulationPartManager.class).getPart("seabed"));

    PartSurface partSurface_0 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("Surface"));

    partDisplayer_8.getInputParts().setObjects(partSurface_0);

    partDisplayer_8.setSurface(true);

    partDisplayer_8.setMesh(true);

    partDisplayer_8.setMesh(false);

    partDisplayer_8.getInputParts().setQuery(null);

    Boundary boundary_5 = 
      region_0.getBoundaryManager().getBoundary("Subtract.seabed");

    partDisplayer_8.getInputParts().setObjects(boundary_5);

    partDisplayer_8.setOpacity(0.294);

    partDisplayer_8.setOpacity(0.478);

    SimpleTransform simpleTransform_0 = 
      ((SimpleTransform) simulation_0.getTransformManager().getObject("scale_z10"));

    scalarDisplayer_3.setVisTransform(simpleTransform_0);

    partDisplayer_8.setVisTransform(simpleTransform_0);

    partDisplayer_6.setVisTransform(simpleTransform_0);

    partDisplayer_7.setVisTransform(simpleTransform_0);
  }
}
