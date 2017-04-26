// STAR-CCM+ macro: physics_VirtualDisks_ChangeHeading.java
// Written by STAR-CCM+ 12.02.010
package macro;

import java.util.*;

import star.vdm.*;
import star.common.*;
import star.base.neo.*;
import star.vis.*;
import java.io.*;
import java.util.logging.*;

public class physics_VirtualDisks_ChangeHeading extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    PhysicsContinuum physicsContinuum_0 = 
      ((PhysicsContinuum) simulation_0.getContinuumManager().getContinuum("Physics 1"));

    VirtualDiskModel virtualDiskModel_0 = 
      physicsContinuum_0.getModelManager().getModel(VirtualDiskModel.class);


    SimpleAnnotation simpleAnnotation_00 = 
      ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("file_turbines"));
    // File f = new File("../inputs/" + simpleAnnotation_00.getText() + ".csv");    



      int       nVirtualDisks   = 0;
      List<String>  textline    = new ArrayList<String>();

      // File f = new File("../inputs/" + simpleAnnotation_00.getText() + ".csv");    
      File f = new File("rotors.csv");    
      // File f = new File(path0);
        try {

            FileReader  fr   = new FileReader(f);
            Scanner     sc   = new Scanner(fr);
            String      line = "";
            
            Integer nLines = new Integer(0);
            while (sc.hasNextLine()) {
          // this skips the header line
          if(nLines == 0) {
             nLines = nLines + 1;
             sc.nextLine();
             continue;
          }
                nLines = nLines + 1;
                line = sc.nextLine();
                textline.add(line);
            }
            nVirtualDisks = nLines - 1;          

        } catch (FileNotFoundException ex) {
            Logger.getLogger(physics_VirtualDisks_ChangeHeading.class.getName()).log(Level.SEVERE, null, ex);
        } // end try


        List<String>  names   = new ArrayList<String>();

        // String[] table        = new String[nVirtualDisks];
        // double[] rotor_rpm  = new double[nVirtualDisks];
        // double[] x      = new double[nVirtualDisks];
        // double[] y      = new double[nVirtualDisks];
        // double[] z      = new double[nVirtualDisks];
        double[] nx       = new double[nVirtualDisks];
        double[] ny       = new double[nVirtualDisks];
        double[] nz       = new double[nVirtualDisks];
        // double[] rotor_radius = new double[nVirtualDisks];
        // double[] hub_radius = new double[nVirtualDisks];
        // double[] rotor_thick  = new double[nVirtualDisks];

        // String[] name_VirtualDiskMarker         = new String[nVirtualDisks];
        // String[] name_VirtualDiskInflowPlaneMarker  = new String[nVirtualDisks];

        for (int i = 0; i < nVirtualDisks; i++) {
          
          String name = textline.get(i).split(",")[0];
          names.add(name);
         
          // table[i]    = textline.get(i).split(",")[1];
          // rotor_rpm[i]  = Double.parseDouble(textline.get(i).split(",")[2]);
          // x[i]      = Double.parseDouble(textline.get(i).split(",")[3]);
          // y[i]      = Double.parseDouble(textline.get(i).split(",")[4]);
          // z[i]      = Double.parseDouble(textline.get(i).split(",")[5]);
          nx[i]     = Double.parseDouble(textline.get(i).split(",")[6]);
          ny[i]     = Double.parseDouble(textline.get(i).split(",")[7]);
          nz[i]           = Double.parseDouble(textline.get(i).split(",")[8]);
          // rotor_radius[i] = Double.parseDouble(textline.get(i).split(",")[9]);
          // hub_radius[i]   = Double.parseDouble(textline.get(i).split(",")[10]);
          // rotor_thick[i]  = Double.parseDouble(textline.get(i).split(",")[11]);

          // I think these are not connected to the "name" variable ... they will always be named in order of creation by starccm
          // name_VirtualDiskMarker[i] = "VirtualDiskMarker" + (i+1);
          // name_VirtualDiskInflowPlaneMarker[i] = "VirtualDiskInflowPlaneMarker" + (i+1);

        }






        for (int i = 0; i < nVirtualDisks; i++) {

            VirtualDisk virtualDisk_0 = 
            ((VirtualDisk) virtualDiskModel_0.getVirtualDiskManager().getObject(names.get(i)));

            SimpleDiskGeometry simpleDiskGeometry_0 = 
              virtualDisk_0.getComponentsManager().get(SimpleDiskGeometry.class);

            ((NormalAndCoordinateSystem) simpleDiskGeometry_0.getOrientationSpecification()).getDiskNormal().setComponents(-1*nx[i], -1*ny[i], -1*nz[i]);

        }



    // VirtualDisk virtualDisk_0 = 
    //   ((VirtualDisk) virtualDiskModel_0.getVirtualDiskManager().getObject("ccw_turbine-1"));

    // SimpleDiskGeometry simpleDiskGeometry_0 = 
    //   virtualDisk_0.getComponentsManager().get(SimpleDiskGeometry.class);

    // ((NormalAndCoordinateSystem) simpleDiskGeometry_0.getOrientationSpecification()).getDiskNormal().setComponents(-0.707107, 0.707107, 0.0);

    
    // VirtualDisk virtualDisk_1 = 
    //   ((VirtualDisk) virtualDiskModel_0.getVirtualDiskManager().getObject("ccw_turbine-2"));

    // SimpleDiskGeometry simpleDiskGeometry_1 = 
    //   virtualDisk_1.getComponentsManager().get(SimpleDiskGeometry.class);

    // ((NormalAndCoordinateSystem) simpleDiskGeometry_1.getOrientationSpecification()).getDiskNormal().setComponents(-0.707107, 0.707107, 0.0);


  }
}
