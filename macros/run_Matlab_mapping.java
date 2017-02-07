// STAR-CCM+ macro: run_Matlab_mapping.java
// tested on STAR-CCM+ v10 and v11
// 
// by Danny Clay Sale (dsale@uw.edu)
// 
// license: ?
// 



///////////////////////////////////////////////////////////////////////////////
// import all the classes we need
//
package macro;
import java.util.*;
import star.common.*;
import java.util.*;
import star.vis.*;
import java.io.*;


public class run_Matlab_mapping extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {   

    Simulation simulation_0 = getActiveSimulation();

    // now use this bash script to archive the images, and give numbering to filenames
    String cmd = "../../macros/matlab_mesh_mapping.sh";
    // String cmd = "../../utilities/archive_images.sh";
    try {
        Process p = Runtime.getRuntime().exec(new String[]{"bash", "-c", cmd});
        simulation_0.println("success");
    } catch (IOException ex) {
        simulation_0.println("Error: failed to execute batch command.");
    }
    


  } // end execute0()
} // end public class
