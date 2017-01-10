// STAR-CCM+ macro: export_PointProbes.java
// tested on STAR-CCM+ v10 and v11
// 
// by Danny Clay Sale (dsale@uw.edu)
// 
// license: ?
// 

package macro;
import java.util.*;
import star.common.*;
import star.base.neo.*;
import star.vis.*;


public class export_PointProbes extends StarMacro {

    // gives the 3 velocities at each probe, and wrties into a CSV file



    ///////////////////////////////////////////////////////////////////////////////
    // USER INPUTS
    //
    // String pathX = "../outputs/probes-velocity-x.csv";
    // String pathY = "../outputs/probes-velocity-y.csv";
    // String pathZ = "../outputs/probes-velocity-z.csv";
    // String pathX = "probes-velocity-x.csv";
    // String pathY = "probes-velocity-y.csv";
    // String pathZ = "probes-velocity-z.csv";
    
    ///////////////////////////////////////////////////////////////////////////////

    public void execute() {

        Simulation simulation_0 = getActiveSimulation();

        SimpleAnnotation caseName = 
        ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("CASE_NAME"));
        

        MonitorPlot monitorPlot_0 = 
          ((MonitorPlot) simulation_0.getPlotManager().getPlot("probes-velocity-x"));
        // monitorPlot_0.export(resolvePath(pathX), ",");
        monitorPlot_0.export(resolvePath("../cases/" + caseName.getText()  + "/probes-velocity-x.csv"), ",");

        MonitorPlot monitorPlot_1 = 
          ((MonitorPlot) simulation_0.getPlotManager().getPlot("probes-velocity-y"));
        // monitorPlot_1.export(resolvePath(pathY), ",");
        monitorPlot_0.export(resolvePath("../cases/" + caseName.getText()  + "/probes-velocity-y.csv"), ",");

        MonitorPlot monitorPlot_2 = 
          ((MonitorPlot) simulation_0.getPlotManager().getPlot("probes-velocity-z"));
        // monitorPlot_2.export(resolvePath(pathZ), ",");
        monitorPlot_0.export(resolvePath("../cases/" + caseName.getText()  + "/probes-velocity-z.csv"), ",");
  }
}
 