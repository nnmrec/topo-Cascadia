// STAR-CCM+ macro: save_ClearedMeshAndSolution.java
// Written by STAR-CCM+ 11.06.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.meshing.*;

public class save_ClearedMeshAndSolution extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    Solution solution_0 = 
      simulation_0.getSolution();

    solution_0.clearSolution(Solution.Clear.History, Solution.Clear.Fields);

    MeshPipelineController meshPipelineController_0 = 
      simulation_0.get(MeshPipelineController.class);

    meshPipelineController_0.clearGeneratedMeshes();


    // SimpleAnnotation caseName = 
    //     ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("CASE_NAME"));

    simulation_0.saveState("CLEARED_"+getSimulation().getPresentationName()+".sim");

  }
}
