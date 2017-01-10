// STAR-CCM+ macro: export_VirtualDisks.java
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

public class export_VirtualDisks extends StarMacro {

    // this should give Fx, Fy, Fz and Mx, My, Mz about the body nodes which is 
    // actually offset from the center of mass of bodies; i.e., turbines and buoyancy pods) and writes into a CSV file



    ///////////////////////////////////////////////////////////////////////////////
    // USER INPUTS
    //
    // String path0 = "../outputs/rotors-velocity.csv";
    // String path1 = "../outputs/rotors-thrust.csv";
    // String path2 = "../outputs/rotors-torque.csv";
    // String path0 = "rotors-velocity.csv";
    // String path1 = "rotors-thrust.csv";
    String path2 = "rotors-torque.csv";
    ///////////////////////////////////////////////////////////////////////////////
    
    public void execute() {

        Simulation simulation_0 = getActiveSimulation();

        SimpleAnnotation caseName = 
        ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("CASE_NAME"));

        MonitorPlot monitorPlot_0 = 
          ((MonitorPlot) simulation_0.getPlotManager().getPlot("rotors-inflow"));
        // monitorPlot_0.export(resolvePath(path0), ",");
        monitorPlot_0.export(resolvePath("../cases/" + caseName.getText()  + "/rotors-velocity.csv"), ",");
        


        MonitorPlot monitorPlot_1 = 
          ((MonitorPlot) simulation_0.getPlotManager().getPlot("rotors-thrust"));
        // monitorPlot_1.export(resolvePath(path1), ",");
        monitorPlot_0.export(resolvePath("../cases/" + caseName.getText()  + "/rotors-thrust.csv"), ",");


        MonitorPlot monitorPlot_2 = 
          ((MonitorPlot) simulation_0.getPlotManager().getPlot("rotors-torque"));
        // monitorPlot_2.export(resolvePath(path2), ",");
          monitorPlot_0.export(resolvePath("../cases/" + caseName.getText()  + "/rotors-torque.csv"), ",");


    } 
}
