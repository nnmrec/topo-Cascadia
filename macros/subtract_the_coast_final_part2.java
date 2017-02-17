// STAR-CCM+ macro: subtract_the_coast_final_part2.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.meshing.*;
import star.turbulence.*;
import star.flow.*;

public class subtract_the_coast_final_part2 extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    MeshPart meshPart_0 = 
      ((MeshPart) simulation_0.get(SimulationPartManager.class).getPart("Subtract"));

    PartSurface partSurface_0 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("openscad_model"));

    PartSurface partSurface_1 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("openscad_model 2"));

    PartSurface partSurface_2 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("Surface"));

    meshPart_0.combinePartSurfaces(new NeoObjectVector(new Object[] {partSurface_0, partSurface_1, partSurface_2}));

    PartCurve partCurve_0 = 
      meshPart_0.getPartCurveManager().getPartCurve("Intersection");

    PartCurve partCurve_1 = 
      meshPart_0.getPartCurveManager().getPartCurve("Intersection 2");

    PartCurve partCurve_2 = 
      meshPart_0.getPartCurveManager().getPartCurve("Surface Repair Edges");

    meshPart_0.getPartSurfaceManager().splitPartSurfacesByPartCurves(new NeoObjectVector(new Object[] {partSurface_0}), new NeoObjectVector(new Object[] {partCurve_0, partCurve_1, partCurve_2}));

    meshPart_0.getPartSurfaceManager().splitPartSurfacesByAngle(new NeoObjectVector(new Object[] {partSurface_0}), 89.0);

    partSurface_0.setPresentationName("west");

    PartSurface partSurface_3 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("openscad_model 2"));

    partSurface_3.setPresentationName("seasurface");

    PartSurface partSurface_4 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("openscad_model 3"));

    partSurface_4.setPresentationName("seabed");

    PartSurface partSurface_5 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("openscad_model 4"));

    partSurface_5.setPresentationName("coast");

    PartSurface partSurface_6 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("openscad_model 5"));

    partSurface_6.setPresentationName("south");

    PartSurface partSurface_7 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("openscad_model 6"));

    partSurface_7.setPresentationName("north");

    PartSurface partSurface_8 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("openscad_model 7"));

    partSurface_8.setPresentationName("east");

    Region region_0 = 
      simulation_0.getRegionManager().createEmptyRegion();

    region_0.setPresentationName("Region");

    Boundary boundary_0 = 
      region_0.getBoundaryManager().getBoundary("Default");

    region_0.getBoundaryManager().removeBoundaries(new NeoObjectVector(new Object[] {boundary_0}));

    FeatureCurve featureCurve_0 = 
      ((FeatureCurve) region_0.getFeatureCurveManager().getObject("Default"));

    region_0.getFeatureCurveManager().removeObjects(featureCurve_0);

    FeatureCurve featureCurve_1 = 
      region_0.getFeatureCurveManager().createEmptyFeatureCurveWithName("Feature Curve");

    simulation_0.getRegionManager().newRegionsFromParts(new NeoObjectVector(new Object[] {meshPart_0}), "OneRegion", region_0, "OneBoundaryPerPartSurface", null, "OneFeatureCurve", featureCurve_1, RegionManager.CreateInterfaceMode.BOUNDARY);







    
    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("temp_combine_inlets_outlets.java"))).play();




    // TO-DO
    // // assign Region types, inlet/outlet, from user inputs

    // // for the north
    // // switch North_BC
    // // case inlet

    // // boundary_1.setBoundaryType(inletBoundary_0);
    // // case outlet

    // // boundary_1.setBoundaryType(pressureBoundary_0);
    // // end



  }
}
