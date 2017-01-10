// STAR-CCM+ macro: subtract_the_coast_final.java
// Written by STAR-CCM+ 11.02.009
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.vis.*;
import star.meshing.*;

public class subtract_the_coast_final extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    Units units_0 = 
      simulation_0.getUnitsManager().getPreferredUnits(new IntVector(new int[] {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));

    PartImportManager partImportManager_0 = 
      simulation_0.get(PartImportManager.class);


      // 

    SimpleAnnotation caseName = 
        ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("CASE_NAME"));

    // partImportManager_0.importStlParts(new StringVector(new String[] {resolvePath("/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/inputs/bathymetry/topo/psdem/coastline.stl"), resolvePath("/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/inputs/bathymetry/topo/psdem/psdem_extract_27m__danny-METS-2016.stl"), resolvePath("/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/inputs/bathymetry/topo/psdem/seasurface.stl")}), "OneSurfacePerPatch", "OnePartPerFile", units_0, true, 1.0E-5);
      // partImportManager_0.importStlParts(new StringVector(new String[] {resolvePath("coastline.stl"), resolvePath("seabed_ROMS.stl"), resolvePath("seasurface.stl")}), "OneSurfacePerPatch", "OnePartPerFile", units_0, true, 1.0E-5);
      // partImportManager_0.importStlParts(new StringVector(new String[] {resolvePath("coastline.stl"), resolvePath("seabed.stl"), resolvePath("seasurface.stl")}), "OneSurfacePerPatch", "OnePartPerFile", units_0, true, 1.0E-5);
      // partImportManager_0.importStlParts(new StringVector(new String[] {
      //   resolvePath("../cases/test_ROMS_nesting/coastline.stl"), 
      //   resolvePath("../cases/test_ROMS_nesting/seabed.stl"), 
      //   resolvePath("../cases/test_ROMS_nesting/seasurface.stl")}), 
      // "OneSurfacePerPatch", "OnePartPerFile", units_0, true, 1.0E-5);
      partImportManager_0.importStlParts(new StringVector(new String[] {
        resolvePath("../cases/" + caseName.getText()  + "/coastline.stl"), 
        resolvePath("../cases/" + caseName.getText()  + "/seabed.stl"), 
        resolvePath("../cases/" + caseName.getText()  + "/seasurface.stl")}), 
      "OneSurfacePerPatch", "OnePartPerFile", units_0, true, 1.0E-5);

    PartRepresentation partRepresentation_0 = 
      ((PartRepresentation) simulation_0.getRepresentationManager().getObject("Geometry"));

    PartSurfaceMeshWidget partSurfaceMeshWidget_0 = 
      partRepresentation_0.startSurfaceMeshWidget();

    MeshPart meshPart_0 = 
      // ((MeshPart) simulation_0.get(SimulationPartManager.class).getPart("psdem_extract_27m__danny-METS-2016"));
    ((MeshPart) simulation_0.get(SimulationPartManager.class).getPart("seabed"));

    RootDescriptionSource rootDescriptionSource_0 = 
      ((RootDescriptionSource) simulation_0.get(SimulationMeshPartDescriptionSourceManager.class).getObject("Root"));

    partSurfaceMeshWidget_0.setActiveParts(new NeoObjectVector(new Object[] {meshPart_0}), rootDescriptionSource_0);

    partSurfaceMeshWidget_0.startSurfaceMeshDiagnostics();

    partSurfaceMeshWidget_0.startSurfaceMeshRepair();

    partSurfaceMeshWidget_0.startMergeImprintController();

    partSurfaceMeshWidget_0.startIntersectController();

    partSurfaceMeshWidget_0.startLeakFinderController();

    partSurfaceMeshWidget_0.startSurfaceMeshQueryController();

    Units units_1 = 
      simulation_0.getUnitsManager().getPreferredUnits(new IntVector(new int[] {0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));

    SurfaceMeshWidgetDisplayController surfaceMeshWidgetDisplayController_0 = 
      partSurfaceMeshWidget_0.getControllers().getController(SurfaceMeshWidgetDisplayController.class);

    MeshPart meshPart_1 = 
      ((MeshPart) simulation_0.get(SimulationPartManager.class).getPart("coastline"));

    PartSurface partSurface_0 = 
      ((PartSurface) meshPart_1.getPartSurfaceManager().getPartSurface("openscad_model"));

    PartSurface partSurface_1 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("Surface"));

    MeshPart meshPart_2 = 
      ((MeshPart) simulation_0.get(SimulationPartManager.class).getPart("seasurface"));

    PartSurface partSurface_2 = 
      ((PartSurface) meshPart_2.getPartSurfaceManager().getPartSurface("openscad_model"));

    surfaceMeshWidgetDisplayController_0.showPartSurfaceFaces(new NeoObjectVector(new Object[] {partSurface_0, partSurface_1, partSurface_2}));

    SurfaceMeshWidgetDiagnosticsController surfaceMeshWidgetDiagnosticsController_0 = 
      partSurfaceMeshWidget_0.getControllers().getController(SurfaceMeshWidgetDiagnosticsController.class);

    surfaceMeshWidgetDiagnosticsController_0.setSoftFeatureErrorsActive(true);

    surfaceMeshWidgetDiagnosticsController_0.setHardFeatureErrorsActive(true);

    SurfaceMeshWidgetRepairController surfaceMeshWidgetRepairController_0 = 
      partSurfaceMeshWidget_0.getControllers().getController(SurfaceMeshWidgetRepairController.class);

    surfaceMeshWidgetRepairController_0.markFeatureEdges(false, 31.000000000000004, true, false, true, false, false);

    surfaceMeshWidgetDiagnosticsController_0.setCheckSoftFeatureErrors(false);

    surfaceMeshWidgetDiagnosticsController_0.setSoftFeatureErrorsActive(false);

    surfaceMeshWidgetDiagnosticsController_0.setCheckHardFeatureErrors(false);

    surfaceMeshWidgetDiagnosticsController_0.setHardFeatureErrorsActive(false);

    LabCoordinateSystem labCoordinateSystem_0 = 
      simulation_0.getCoordinateSystemManager().getLabCoordinateSystem();

    surfaceMeshWidgetRepairController_0.inflateSelectedFaces(false, 3, new DoubleVector(new double[] {0.0, 0.0, 1.0}), 200.0, labCoordinateSystem_0, true);

    surfaceMeshWidgetDiagnosticsController_0.setCheckSoftFeatureErrors(false);

    surfaceMeshWidgetDiagnosticsController_0.setSoftFeatureErrorsActive(false);

    surfaceMeshWidgetDiagnosticsController_0.setCheckHardFeatureErrors(false);

    surfaceMeshWidgetDiagnosticsController_0.setHardFeatureErrorsActive(false);

    surfaceMeshWidgetRepairController_0.markFeatureEdges(false, 31.000000000000004, true, false, true, false, false);

    surfaceMeshWidgetDiagnosticsController_0.setCheckSoftFeatureErrors(false);

    surfaceMeshWidgetDiagnosticsController_0.setSoftFeatureErrorsActive(false);

    surfaceMeshWidgetDiagnosticsController_0.setCheckHardFeatureErrors(false);

    surfaceMeshWidgetDiagnosticsController_0.setHardFeatureErrorsActive(false);

    surfaceMeshWidgetRepairController_0.holeFillSelectedEdges();

    surfaceMeshWidgetDiagnosticsController_0.setCheckSoftFeatureErrors(false);

    surfaceMeshWidgetDiagnosticsController_0.setSoftFeatureErrorsActive(false);

    surfaceMeshWidgetDiagnosticsController_0.setCheckHardFeatureErrors(false);

    surfaceMeshWidgetDiagnosticsController_0.setHardFeatureErrorsActive(false);

    partSurfaceMeshWidget_0.stop();

    MeshActionManager meshActionManager_0 = 
      simulation_0.get(MeshActionManager.class);

    MeshPart meshPart_3 = 
      meshActionManager_0.uniteParts(new NeoObjectVector(new Object[] {meshPart_1, meshPart_2}), "Discrete");

    MeshPart meshPart_4 = 
      meshActionManager_0.subtractParts(new NeoObjectVector(new Object[] {meshPart_0, meshPart_3}), meshPart_0, "Discrete");

    SimpleTransform simpleTransform_0 = 
      simulation_0.getTransformManager().createSimpleTransform("Simple Transform");

    simpleTransform_0.setPresentationName("scale_z10");

    simpleTransform_0.setScale(new DoubleVector(new double[] {0.0, 0.0, 10.0}));

    simpleTransform_0.setScale(new DoubleVector(new double[] {1.0, 1.0, 10.0}));
  }
}
