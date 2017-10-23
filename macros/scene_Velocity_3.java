// STAR-CCM+ macro: scene_Velocity_3.java
// Written by STAR-CCM+ 12.02.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.vis.*;

public class scene_Velocity_3 extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    Scene scene_0 = 
      simulation_0.getSceneManager().createScene("Copy of velocity-hub-height");

    scene_0.setPresentationName("Copy of velocity-hub-height");

    Scene scene_1 = 
      simulation_0.getSceneManager().getScene("velocity-hub-height");

    scene_0.copyProperties(scene_1);

    scene_0.initializeAndWait();

    scene_0.setPresentationName("velocity-transect");

    PartDisplayer partDisplayer_0 = 
      ((PartDisplayer) scene_0.getDisplayerManager().getDisplayer("Outline 1"));

    partDisplayer_0.initialize();

    ScalarDisplayer scalarDisplayer_0 = 
      ((ScalarDisplayer) scene_0.getDisplayerManager().getDisplayer("Scalar 1"));

    scalarDisplayer_0.initialize();

    ScalarDisplayer scalarDisplayer_1 = 
      ((ScalarDisplayer) scene_0.getDisplayerManager().getDisplayer("Scalar 2"));

    scalarDisplayer_1.initialize();

    scene_0.open();

    SceneUpdate sceneUpdate_0 = 
      scene_0.getSceneUpdate();

    HardcopyProperties hardcopyProperties_0 = 
      sceneUpdate_0.getHardcopyProperties();

    hardcopyProperties_0.setCurrentResolutionHeight(652);

    CurrentView currentView_0 = 
      scene_0.getCurrentView();

    currentView_0.setInput(new DoubleVector(new double[] {74.76553814177136, 164.20633166180247, -11.075169768089815}), new DoubleVector(new double[] {-1446.4309004081929, -4564.716590213655, 10565.164716206571}), new DoubleVector(new double[] {-0.02756976662566474, 0.9143217619706134, 0.4040490360775032}), 2878.73105031965, 1);

    currentView_0.setInput(new DoubleVector(new double[] {74.76553814177136, 164.20633166180247, -11.075169768089815}), new DoubleVector(new double[] {-1446.4309004081929, -4564.716590213655, 10565.164716206571}), new DoubleVector(new double[] {-0.02756976662566474, 0.9143217619706134, 0.4040490360775032}), 2878.73105031965, 1);

    currentView_0.setInput(new DoubleVector(new double[] {74.76553814177136, 164.20633166180247, -11.075169768089815}), new DoubleVector(new double[] {-1446.4309004081929, -4564.716590213655, 10565.164716206571}), new DoubleVector(new double[] {-0.02756976662566474, 0.9143217619706134, 0.4040490360775032}), 2878.73105031965, 1);

    scene_0.setViewOrientation(new DoubleVector(new double[] {0.0, 0.0, 1.0}), new DoubleVector(new double[] {0.0, 1.0, 0.0}));

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    FvRepresentation fvRepresentation_0 = 
      ((FvRepresentation) simulation_0.getRepresentationManager().getObject("Volume Mesh"));

    simulation_0.getDataSourceManager().getPartExtents(new NeoObjectVector(new Object[] {region_0}), fvRepresentation_0);

    PlaneSection planeSection_0 = 
      ((PlaneSection) simulation_0.getPartManager().getObject("plane-xy"));

    Coordinate coordinate_0 = 
      planeSection_0.getOriginCoordinate();

    Units units_0 = 
      ((Units) simulation_0.getUnitsManager().getObject("m"));

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-200.0, 0.0, 0.0}));

    currentView_0.setInput(new DoubleVector(new double[] {84.85252098544346, 198.13386751483014, -506.58026159280683}), new DoubleVector(new double[] {-138.72224910247118, -553.8591858636987, 11766.16957574104}), new DoubleVector(new double[] {-5.557149393567238E-4, 0.9981302495047205, 0.061120341986534245}), 2878.73105031965, 1);

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-400.0, 0.0, 0.0}));

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {0.0, 0.0, 0.0}));

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-20.0, 0.0, 0.0}));

    scalarDisplayer_0.getInputParts().setQuery(null);

    scalarDisplayer_0.getInputParts().setObjects(planeSection_0);

    currentView_0.setInput(new DoubleVector(new double[] {-40.364512801845386, -266.62761554681595, 862.3787566338304}), new DoubleVector(new double[] {-2719.594427548076, -10384.467530398944, 8345.5628611517}), new DoubleVector(new double[] {-0.10449584255026842, 0.6092245593685753, 0.7860827279312749}), 2878.73105031965, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-829.7601313720891, -1596.0087452889538, 1372.7509679937225}), new DoubleVector(new double[] {-10292.587845780603, -11696.389757733694, 1500.1120210696474}), new DoubleVector(new double[] {-0.295000033604891, 0.28600715017169526, 0.9116879346705091}), 2878.73105031965, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-829.7601313720891, -1596.0087452889538, 1372.7509679937225}), new DoubleVector(new double[] {-10292.587845780603, -11696.389757733694, 1500.1120210696474}), new DoubleVector(new double[] {-0.295000033604891, 0.28600715017169526, 0.9116879346705091}), 2878.73105031965, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-829.7601313720891, -1596.0087452889538, 1372.7509679937225}), new DoubleVector(new double[] {-10292.587845780603, -11696.389757733694, 1500.1120210696474}), new DoubleVector(new double[] {-0.295000033604891, 0.28600715017169526, 0.9116879346705091}), 2878.73105031965, 1);

    scene_0.alignViewToNormal(new DoubleVector(new double[] {0.7071067811865475, 0.7071067811865475, -4.842498758159451E-16}));

    scene_0.setViewOrientation(new DoubleVector(new double[] {-0.0, -0.0, -1.0}), new DoubleVector(new double[] {0.0, 1.0, 0.0}));

    scene_0.setViewOrientation(new DoubleVector(new double[] {0.0, 0.0, 1.0}), new DoubleVector(new double[] {0.0, 1.0, 0.0}));

    scene_0.setViewOrientation(new DoubleVector(new double[] {-1.0, 0.0, 0.0}), new DoubleVector(new double[] {0.0, 0.0, 1.0}));

    currentView_0.setInput(new DoubleVector(new double[] {-829.7601313720891, -1596.0087452889538, 1372.7509679937225}), new DoubleVector(new double[] {-14670.96765770348, -1596.0087452889538, 1372.7509679937225}), new DoubleVector(new double[] {0.0, 0.0, 1.0}), 2878.73105031965, 1);

    scene_0.alignViewToNormal(new DoubleVector(new double[] {0.7071067811865475, 0.7071067811865475, 1.130466602016054E-16}));

    SimpleTransform simpleTransform_0 = 
      ((SimpleTransform) simulation_0.getTransformManager().getObject("scale_z10"));

    partDisplayer_0.setVisTransform(simpleTransform_0);

    scalarDisplayer_1.setVisTransform(simpleTransform_0);

    partDisplayer_0.getInputParts().setQuery(null);

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

    partDisplayer_0.getInputParts().setObjects(boundary_0, boundary_1, boundary_2, boundary_3, boundary_4, planeSection_0);

    currentView_0.setInput(new DoubleVector(new double[] {-1999.9875903886746, -343.5329656717954, 560.3483402961529}), new DoubleVector(new double[] {-11828.323452368168, -10171.868827651291, 560.3483402961513}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 2878.73105031965, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-1999.9875903886746, -343.5329656717954, 560.3483402961529}), new DoubleVector(new double[] {-11828.323452368168, -10171.868827651291, 560.3483402961513}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 2878.73105031965, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-2842.1997820238357, 699.9671572997158, -516.9681877375813}), new DoubleVector(new double[] {-12771.179609671504, -9229.012670347955, -516.9681877375829}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 2878.73105031965, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-1224.1532729501291, -117.17773328420185, 224.79073320367837}), new DoubleVector(new double[] {-11553.583909842697, -10446.60837017677, 224.79073320367667}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 2878.73105031965, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-934.3152562953798, -150.7830871480803, 255.6973549095642}), new DoubleVector(new double[] {-11391.862224583383, -10608.330055436083, 255.69735490956248}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 3163.3963862249116, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-1112.2091100806251, 27.110766637164943, 221.7000710330898}), new DoubleVector(new double[] {-11569.756078368628, -10430.436201650838, 221.70007103308808}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 2851.4493500438803, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-1272.3135784873461, 187.21523504388574, 191.10251554426284}), new DoubleVector(new double[] {-11729.860546775348, -10270.331733244118, 191.1025155442611}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 2570.17530307081, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-1416.407600053395, 331.30925660993444, 163.56471560431856}), new DoubleVector(new double[] {-11873.954568341396, -10126.23771167807, 163.56471560431686}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 2316.582171814729, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-1546.092219462839, 460.99387601937815, 138.78069565836873}), new DoubleVector(new double[] {-12003.63918775084, -9996.553092268627, 138.78069565836702}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 2087.9632718703865, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-736.5847168879432, -214.9693582088712, 190.0190581582557}), new DoubleVector(new double[] {-11260.903819349267, -10739.2884606702, 190.01905815825398}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 2087.9632718703865, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-739.0691109243575, 201.91999844974748, 177.8499470645326}), new DoubleVector(new double[] {-11470.590694696784, -10529.601585322682, 177.84994706453088}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 1883.6409583526452, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-927.7872987371226, 390.6381862625126, 166.89774708018183}), new DoubleVector(new double[] {-11659.30888250955, -10340.883397509917, 166.89774708018007}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 1699.2372026348764, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-553.726101638345, 174.9854452864056, -83.29668766360379}), new DoubleVector(new double[] {-11364.451913472107, -10635.74036654736, -83.29668766360555}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 1699.2372026348764, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-578.9885002361584, 507.2371216464942, -29.08789346911692}), new DoubleVector(new double[] {-11543.208950951057, -10456.98332906841, -29.08789346911871}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 1531.954383432082, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-595.4739224385539, -678.8982306590783, 32.00231200516836}), new DoubleVector(new double[] {-10958.383985899463, -11041.808294119997, 32.00231200516667}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 1531.954383432082, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-562.2575641648777, -625.7446576677366, 32.00231200516837}), new DoubleVector(new double[] {-10968.352593258298, -11031.839686761163, 32.00231200516667}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 1531.954383432082, 1);

    Legend legend_0 = 
      scalarDisplayer_0.getLegend();

    legend_0.updateLayout(new DoubleVector(new double[] {0.1904859685147171, 0.05153609831029182}), 0.5999999999999999, 0.04400000000000004, 0);

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {0.0, 0.0, 0.0}));

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-40.0, 0.0, 0.0}));

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {20.0, 0.0, 0.0}));

    currentView_0.setInput(new DoubleVector(new double[] {-562.2575641648777, -625.7446576677366, 32.00231200516837}), new DoubleVector(new double[] {-10968.352593258298, -11031.839686761163, 32.00231200516667}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 1531.954383432082, 1);

    scene_0.saveCurrentView();

    currentView_0.setInput(new DoubleVector(new double[] {-950.1336526935328, -1108.6341753692868, 315.31466703064416}), new DoubleVector(new double[] {-5433.2231903592165, -9393.10276503351, 11650.31921261354}), new DoubleVector(new double[] {0.4758670904754825, 0.5936792256908213, 0.648918707686522}), 1531.954383432082, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-933.8391860887687, -1088.608400192814, 323.71706336730296}), new DoubleVector(new double[] {301.408633843434, -1581.5760115270457, 15425.445491701528}), new DoubleVector(new double[] {0.5625079104664997, 0.8265748225896841, -0.01894500787661252}), 1531.954383432082, 1);

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-1205.76, -62.2497, -38.0036}));

    LabCoordinateSystem labCoordinateSystem_0 = 
      simulation_0.getCoordinateSystemManager().getLabCoordinateSystem();

    planeSection_0.setCoordinateSystem(labCoordinateSystem_0);

    Coordinate coordinate_1 = 
      planeSection_0.getOrientationCoordinate();

    coordinate_1.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {1.0, 1.0, 0.0}));

    VisView visView_0 = 
      ((VisView) simulation_0.getViewManager().getObject("View 1"));

    currentView_0.setView(visView_0);

    currentView_0.setInput(new DoubleVector(new double[] {-562.2575641648777, -625.7446576677366, 32.00231200516837}), new DoubleVector(new double[] {-10968.352593258298, -11031.839686761163, 32.00231200516667}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 1531.954383432082, 1);

    currentView_0.setInput(new DoubleVector(new double[] {-562.2575641648777, -625.7446576677366, 32.00231200516837}), new DoubleVector(new double[] {-10968.352593258298, -11031.839686761163, 32.00231200516667}), new DoubleVector(new double[] {-8.131098910579142E-17, -8.131098910579144E-17, 1.0}), 1531.954383432082, 1);

    scene_0.printAndWait(resolvePath("/mnt/data-RAID-1/danny/GitHub-NNMREC/topo-Cascadia-Hyak/time-0568_velocity-transect.png"), 1, 1462, 652, true, false);
  }
}
