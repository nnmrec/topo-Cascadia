// STAR-CCM+ macro: mesh_Background_Trimmer.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.resurfacer.*;
import star.trimmer.*;
import star.prismmesher.*;
import star.meshing.*;

public class mesh_Background_Trimmer extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    MeshPart meshPart_0 = 
      ((MeshPart) simulation_0.get(SimulationPartManager.class).getPart("Subtract"));

    AutoMeshOperation autoMeshOperation_1 = 
      simulation_0.get(MeshOperationManager.class).createAutoMeshOperation(new StringVector(new String[] {"star.trimmer.TrimmerAutoMesher", "star.prismmesher.PrismAutoMesher", "star.resurfacer.ResurfacerAutoMesher"}), new NeoObjectVector(new Object[] {meshPart_0}));

    autoMeshOperation_1.getMesherParallelModeOption().setSelected(MesherParallelModeOption.Type.PARALLEL);

    PrismAutoMesher prismAutoMesher_0 = 
      ((PrismAutoMesher) autoMeshOperation_1.getMeshers().getObject("Prism Layer Mesher"));

    prismAutoMesher_0.getPrismStretchingFunction().setSelected(PrismStretchingFunction.Type.HYPERBOLIC_TANGENT);

    prismAutoMesher_0.getPrismStretchingOption().setSelected(PrismStretchingOption.Type.WALL_THICKNESS);

    autoMeshOperation_1.getDefaultValues().get(BaseSize.class).setValue(10.0);

    PartsTargetSurfaceSize partsTargetSurfaceSize_0 = 
      autoMeshOperation_1.getDefaultValues().get(PartsTargetSurfaceSize.class);

    partsTargetSurfaceSize_0.getRelativeOrAbsoluteOption().setSelected(RelativeOrAbsoluteOption.Type.ABSOLUTE);

    GenericAbsoluteSize genericAbsoluteSize_0 = 
      ((GenericAbsoluteSize) partsTargetSurfaceSize_0.getAbsoluteSize());

    genericAbsoluteSize_0.getValue().setValue(5.0);

    PartsMinimumSurfaceSize partsMinimumSurfaceSize_0 = 
      autoMeshOperation_1.getDefaultValues().get(PartsMinimumSurfaceSize.class);

    partsMinimumSurfaceSize_0.getRelativeOrAbsoluteOption().setSelected(RelativeOrAbsoluteOption.Type.ABSOLUTE);

    SurfaceGrowthRate surfaceGrowthRate_0 = 
      autoMeshOperation_1.getDefaultValues().get(SurfaceGrowthRate.class);

    surfaceGrowthRate_0.setGrowthRate(1.2);

    NumPrismLayers numPrismLayers_0 = 
      autoMeshOperation_1.getDefaultValues().get(NumPrismLayers.class);

    numPrismLayers_0.setNumLayers(10);

    autoMeshOperation_1.getDefaultValues().get(PrismWallThickness.class).setValue(0.0136);

    PrismThickness prismThickness_0 = 
      autoMeshOperation_1.getDefaultValues().get(PrismThickness.class);

    prismThickness_0.getRelativeOrAbsoluteOption().setSelected(RelativeOrAbsoluteOption.Type.ABSOLUTE);

    GenericAbsoluteSize genericAbsoluteSize_1 = 
      ((GenericAbsoluteSize) prismThickness_0.getAbsoluteSize());

    genericAbsoluteSize_1.getValue().setValue(5.0);

    MaxTrimmerSizeToPrismThicknessRatio maxTrimmerSizeToPrismThicknessRatio_0 = 
      autoMeshOperation_1.getDefaultValues().get(MaxTrimmerSizeToPrismThicknessRatio.class);

    maxTrimmerSizeToPrismThicknessRatio_0.setLimitCellSizeByPrismThickness(true);

    PartsSimpleTemplateGrowthRate partsSimpleTemplateGrowthRate_0 = 
      autoMeshOperation_1.getDefaultValues().get(PartsSimpleTemplateGrowthRate.class);

    partsSimpleTemplateGrowthRate_0.getGrowthRateOption().setSelected(PartsGrowthRateOption.Type.MEDIUM);

    partsSimpleTemplateGrowthRate_0.getSurfaceGrowthRateOption().setSelected(PartsSurfaceGrowthRateOption.Type.MEDIUM);

    MaximumCellSize maximumCellSize_0 = 
      autoMeshOperation_1.getDefaultValues().get(MaximumCellSize.class);

    maximumCellSize_0.getRelativeOrAbsoluteOption().setSelected(RelativeOrAbsoluteOption.Type.ABSOLUTE);

    GenericAbsoluteSize genericAbsoluteSize_2 = 
      ((GenericAbsoluteSize) maximumCellSize_0.getAbsoluteSize());

    genericAbsoluteSize_2.getValue().setValue(100.0);

    SurfaceCustomMeshControl surfaceCustomMeshControl_2 = 
      autoMeshOperation_1.getCustomMeshControls().createSurfaceControl();

    surfaceCustomMeshControl_2.setPresentationName("disable_prisms");

    surfaceCustomMeshControl_2.getGeometryObjects().setQuery(null);

    PartSurface partSurface_0 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("east"));

    PartSurface partSurface_1 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("north"));

    PartSurface partSurface_2 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("seasurface"));

    PartSurface partSurface_3 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("south"));

    PartSurface partSurface_4 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("west"));

    surfaceCustomMeshControl_2.getGeometryObjects().setObjects(partSurface_0, partSurface_1, partSurface_2, partSurface_3, partSurface_4);

    PartsCustomizePrismMesh partsCustomizePrismMesh_0 = 
      surfaceCustomMeshControl_2.getCustomConditions().get(PartsCustomizePrismMesh.class);

    partsCustomizePrismMesh_0.getCustomPrismOptions().setSelected(PartsCustomPrismsOption.Type.DISABLE);

    SurfaceCustomMeshControl surfaceCustomMeshControl_3 = 
      autoMeshOperation_1.getCustomMeshControls().createSurfaceControl();

    surfaceCustomMeshControl_3.setPresentationName("seabed");

    surfaceCustomMeshControl_3.getGeometryObjects().setQuery(null);

    PartSurface partSurface_5 = 
      ((PartSurface) meshPart_0.getPartSurfaceManager().getPartSurface("seabed"));

    surfaceCustomMeshControl_3.getGeometryObjects().setObjects(partSurface_5);

    surfaceCustomMeshControl_3.getCustomConditions().get(PartsTargetSurfaceSizeOption.class).setSelected(PartsTargetSurfaceSizeOption.Type.CUSTOM);

    PartsTargetSurfaceSize partsTargetSurfaceSize_1 = 
      surfaceCustomMeshControl_3.getCustomValues().get(PartsTargetSurfaceSize.class);

    partsTargetSurfaceSize_1.getRelativeOrAbsoluteOption().setSelected(RelativeOrAbsoluteOption.Type.ABSOLUTE);

    GenericAbsoluteSize genericAbsoluteSize_3 = 
      ((GenericAbsoluteSize) partsTargetSurfaceSize_1.getAbsoluteSize());

    genericAbsoluteSize_3.getValue().setValue(3.0);
  }
}
