// STAR-CCM+ macro: parts_Create_LineProbes.java
// tested on STAR-CCM+ v10 and v11
// 
// by Danny Clay Sale (dsale@uw.edu)
// 
// license: ?
// 

package macro;
import java.io.*;
import java.util.*;
import java.util.logging.*;
import star.common.*;
import star.base.neo.*;
import star.base.report.*;
import star.vis.*;

public class parts_Create_LineProbes extends StarMacro {

  // NOTE: it would be better to define these as field functions so do not have to duplicate User Inputs over multiple files
  // static final double xo          = 0;       // origin x coordinate [m]
  // static final double yo          = 0;       // origin y coordinate [m]
  // static final double zo          = 0;       // origin z coordinate [m]
  // // static final double length      = 12.3;     // length in x-dimention (steamwise) [m]
  // // static final double width       = 1.0;     // length in y-dimention (crossflow) [m]
  // // static final double depth       = 0.8;      // length in z-dimention (vertical) [m]
  // static final double length      = 1000;     // length in x-dimention (steamwise) [m]
  // static final double width       = 400;     // length in y-dimention (crossflow) [m]
  // static final double depth       = 60;      // length in z-dimention (vertical) [m]

  ///////////////////////////////////////////////////////////////////////////////
    // USER INPUTS
    //
    // path to CSV file with names and coordinates of point probes (this gets updated from the "mooring model" code) This file should NOT have any empty lines at bottom 
    // String path1     = "../outputs/probes_points.csv";
    // String path1     = "../inputs/probes_lines.csv";
    // String path1     = "inputs/update-probes.csv";
    // String path2     = "../outputs/probes-velocity.csv";

    ///////////////////////////////////////////////////////////////////////////////


  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    Units units_2 = 
      simulation_0.getUnitsManager().getPreferredUnits(new IntVector(new int[] {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");


    LabCoordinateSystem labCoordinateSystem_0 = 
      simulation_0.getCoordinateSystemManager().getLabCoordinateSystem();

      
      SimpleAnnotation simpleAnnotation_00 = 
        ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("file_probes_lines"));
    

        // File f = new File("../inputs/" + simpleAnnotation_00.getText() + ".csv"); 
        File f = new File("../../inputs/" + simpleAnnotation_00.getText() + ".csv"); 
        // File f = new File(path1);
        try {

            FileReader  fr      = new FileReader(f);
            Scanner     sc      = new Scanner(fr);
            String      line    = "";

        Integer nLines = new Integer(0);
        while (sc.hasNextLine()) {
            if(nLines == 0) {
               nLines = nLines + 1;
               sc.nextLine();
               continue;
            }
            line        = sc.nextLine();
            String name = line.split(",")[0];
            double x0   = Double.parseDouble(line.split(",")[1]);
            double x1   = Double.parseDouble(line.split(",")[2]);
            double y0   = Double.parseDouble(line.split(",")[3]);
            double y1   = Double.parseDouble(line.split(",")[4]);
            double z0   = Double.parseDouble(line.split(",")[5]);
            double z1   = Double.parseDouble(line.split(",")[6]);
            double n    = Double.parseDouble(line.split(",")[7]);

            // PointPart pointPart_0 = 
            //   ((PointPart) simulation_0.getPartManager().getObject(name));

            // Coordinate coordinate_0 = 
            //   pointPart_0.getPointCoordinate();

            // coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {x, y, z}));










            LinePart linePart_0 = 
              simulation_0.getPartManager().createLinePart(new NeoObjectVector(new Object[] {}), new DoubleVector(new double[] {0.0, 0.0, 0.0}), new DoubleVector(new double[] {1.0, 0.0, 0.0}), 200);

            Coordinate coordinate_0 = 
              linePart_0.getPoint1Coordinate();


              coordinate_0.setCoordinateSystem(labCoordinateSystem_0);

              coordinate_0.setValue(new DoubleVector(new double[] {x0, y0, z0}));

              coordinate_0.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {x0, y0, z0}));


            Coordinate coordinate_1 = 
              linePart_0.getPoint2Coordinate();

                coordinate_1.setCoordinateSystem(labCoordinateSystem_0);

                coordinate_1.setValue(new DoubleVector(new double[] {x1, y1, z1}));

                coordinate_1.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {x1, y1, z1}));

            


            linePart_0.setCoordinateSystem(labCoordinateSystem_0);

            linePart_0.getInputParts().setObjects(region_0);

            linePart_0.setResolution((int) n);

            linePart_0.setPresentationName(name);






            // simulation_0.println("Probe line '" + name + "' updated coordinates (" + x + "," + y + "," + z + ")");
        } // end while


        } catch (FileNotFoundException ex) {
            Logger.getLogger(parts_Create_LineProbes.class.getName()).log(Level.SEVERE, null, ex);
        } 







      // get the user inputs field functions
      UserFieldFunction userFieldFunction_0 = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__xo"));
      UserFieldFunction userFieldFunction_1 = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__yo"));
      UserFieldFunction userFieldFunction_2 = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__zo"));
      UserFieldFunction userFieldFunction_3 = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__length"));
      UserFieldFunction userFieldFunction_4 = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__width"));
      UserFieldFunction userFieldFunction_5 = 
        ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("__depth"));




      // double xx   = Double.parseDouble(userFieldFunction_0.getDefinition())+(Double.parseDouble(userFieldFunction_3.getDefinition())-Double.parseDouble(userFieldFunction_0.getDefinition()))/2;
      // Double.parseDouble(userFieldFunction_0.getDefinition())
      double yy1   = (Double.parseDouble(userFieldFunction_4.getDefinition())-Double.parseDouble(userFieldFunction_1.getDefinition()))/2;
      double yy2   = Double.parseDouble(userFieldFunction_1.getDefinition()) + (Double.parseDouble(userFieldFunction_4.getDefinition())-Double.parseDouble(userFieldFunction_1.getDefinition()))/2;
      double zz1   = (Double.parseDouble(userFieldFunction_5.getDefinition())-Double.parseDouble(userFieldFunction_2.getDefinition()))/2;
      double zz2   = Double.parseDouble(userFieldFunction_2.getDefinition()) + (Double.parseDouble(userFieldFunction_5.getDefinition())-Double.parseDouble(userFieldFunction_2.getDefinition()))/2;











    LinePart linePart_00 = 
      simulation_0.getPartManager().createLinePart(new NeoObjectVector(new Object[] {}), new DoubleVector(new double[] {0.0, 0.0, 0.0}), new DoubleVector(new double[] {1.0, 0.0, 0.0}), 200);

    Coordinate coordinate_0 = 
      linePart_00.getPoint1Coordinate();

    // LabCoordinateSystem labCoordinateSystem_0 = 
    //   simulation_0.getCoordinateSystemManager().getLabCoordinateSystem();

    coordinate_0.setCoordinateSystem(labCoordinateSystem_0);

    // coordinate_0.setValue(new DoubleVector(new double[] {xo, (width-yo)/2, (depth-zo)/2}));
    coordinate_0.setValue(new DoubleVector(new double[] {Double.parseDouble(userFieldFunction_0.getDefinition()), yy1, zz1}));

    // coordinate_0.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {xo, yo + (width-yo)/2, zo + (depth-zo)/2}));
    coordinate_0.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {Double.parseDouble(userFieldFunction_0.getDefinition()), yy2, zz2}));


    Coordinate coordinate_1 = 
      linePart_00.getPoint2Coordinate();

    coordinate_1.setCoordinateSystem(labCoordinateSystem_0);

    // coordinate_1.setValue(new DoubleVector(new double[] {length, (width-yo)/2, (depth-zo)/2}));
    coordinate_1.setValue(new DoubleVector(new double[] {Double.parseDouble(userFieldFunction_3.getDefinition()), yy1, zz1}));

    // coordinate_1.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {length, yo + (width-yo)/2, zo + (depth-zo)/2}));
    coordinate_1.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {Double.parseDouble(userFieldFunction_3.getDefinition()), yy2, zz2}));

    linePart_00.setCoordinateSystem(labCoordinateSystem_0);

    linePart_00.getInputParts().setObjects(region_0);

    linePart_00.setResolution(200);

    linePart_00.setPresentationName("line_probe_centerline");





    LinePart linePart_1 = 
      simulation_0.getPartManager().createLinePart(new NeoObjectVector(new Object[] {}), new DoubleVector(new double[] {0.0, 0.0, 0.0}), new DoubleVector(new double[] {1.0, 0.0, 0.0}), 20);

    Coordinate coordinate_2 = 
      linePart_1.getPoint1Coordinate();

    // LabCoordinateSystem labCoordinateSystem_0 = 
    //   simulation_0.getCoordinateSystemManager().getLabCoordinateSystem();

    coordinate_2.setCoordinateSystem(labCoordinateSystem_0);

    // coordinate_2.setValue(new DoubleVector(new double[] {xo, yo+(width-yo)/2, 0.0}));
    coordinate_2.setValue(new DoubleVector(new double[] {Double.parseDouble(userFieldFunction_0.getDefinition()), yy2, Double.parseDouble(userFieldFunction_2.getDefinition())}));

    // coordinate_2.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {xo, yo+(width-yo)/2, 0.0}));
    coordinate_2.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {Double.parseDouble(userFieldFunction_0.getDefinition()), yy2, Double.parseDouble(userFieldFunction_2.getDefinition())}));

    Coordinate coordinate_3 = 
      linePart_1.getPoint2Coordinate();

    coordinate_3.setCoordinateSystem(labCoordinateSystem_0);

    // coordinate_3.setValue(new DoubleVector(new double[] {xo, yo+(width-yo)/2, depth}));
    coordinate_3.setValue(new DoubleVector(new double[] {Double.parseDouble(userFieldFunction_0.getDefinition()), yy2, Double.parseDouble(userFieldFunction_5.getDefinition())}));

    // coordinate_3.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {xo, yo+(width-yo)/2, depth}));
    coordinate_3.setCoordinate(units_2, units_2, units_2, new DoubleVector(new double[] {Double.parseDouble(userFieldFunction_0.getDefinition()), yy2, Double.parseDouble(userFieldFunction_5.getDefinition())}));

    linePart_1.setCoordinateSystem(labCoordinateSystem_0);

    linePart_1.getInputParts().setObjects(region_0);

    linePart_1.setResolution(200);

    // scene_0.setTransparencyOverrideMode(0);

    linePart_1.setPresentationName("line_probe_inflow");







    // // setup XYZ internal table for line probes
    // XyzInternalTable xyzInternalTable_1 = 
    //   simulation_0.getTableManager().createTable(XyzInternalTable.class);

    // xyzInternalTable_1.setPresentationName("line_probe_TI_local");

    // UserFieldFunction userFieldFunction_1 = 
    //   ((UserFieldFunction) simulation_0.getFieldFunctionManager().getFunction("local_TI"));

    // xyzInternalTable_1.setFieldFunctions(new NeoObjectVector(new Object[] {userFieldFunction_1}));

    // xyzInternalTable_1.getParts().setObjects(linePart_0);




    // XyzInternalTable xyzInternalTable_2 = 
    //   simulation_0.getTableManager().createTable(XyzInternalTable.class);

    // xyzInternalTable_2.setPresentationName("line_probe_Ux");

    // PrimitiveFieldFunction primitiveFieldFunction_0 = 
    //   ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("Velocity"));
    // VectorComponentFieldFunction vectorComponentFieldFunction_0 = 
    //   ((VectorComponentFieldFunction) primitiveFieldFunction_0.getComponentFunction(0));

    // xyzInternalTable_2.setFieldFunctions(new NeoObjectVector(new Object[] {vectorComponentFieldFunction_0}));

    // xyzInternalTable_2.getParts().setObjects(linePart_0);





  }
}
