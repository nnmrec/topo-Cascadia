// STAR-CCM+ macro: solver_InitSolution.java
// Written by STAR-CCM+ 11.02.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;

public class solver_InitSolution extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    Solution solution_0 = 
      simulation_0.getSolution();

    solution_0.initializeSolution();

    simulation_0.getSimulationIterator().step(1);


    // setup the AutoSave
    AutoSave autoSave_0 = 
      simulation_0.getSimulationIterator().getAutoSave();

    StarUpdate starUpdate_0 = 
      autoSave_0.getStarUpdate();

    starUpdate_0.setEnabled(true);

    IterationUpdateFrequency iterationUpdateFrequency_0 = 
      starUpdate_0.getIterationUpdateFrequency();

    iterationUpdateFrequency_0.setIterations(50);


  }
}
