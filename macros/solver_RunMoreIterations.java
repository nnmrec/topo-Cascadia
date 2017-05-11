// STAR-CCM+ macro: solver_RunMoreIterations.java
// Written by STAR-CCM+ 12.02.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;

public class solver_RunMoreIterations extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    StepStoppingCriterion stepStoppingCriterion_0 = 
      ((StepStoppingCriterion) simulation_0.getSolverStoppingCriterionManager().getSolverStoppingCriterion("Maximum Steps"));

    stepStoppingCriterion_0.setMaximumNumberSteps(2000);

    new StarScript(getActiveSimulation(), new java.io.File(resolvePath("solver_Run.java"))).play();

    simulation_0.saveState(getSimulation().getPresentationName()+".sim");

  }
}
