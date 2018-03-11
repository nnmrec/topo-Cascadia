// STAR-CCM+ macro: scene_VirtualDisks_Reports.java
// tested on STAR-CCM+ v10 and v11
// 
// by Danny Clay Sale (dsale@uw.edu)
// 
// license: ?
// 

 
package macro;
import java.util.*;
import star.vdm.*;
import star.common.*;
import star.base.neo.*;
import star.base.report.*;
// import star.trimmer.*;
import star.dualmesher.*;
import star.prismmesher.*;
import star.meshing.*;
import star.vis.*;

// import star.common.*;
// import star.base.neo.*;
// import star.resurfacer.*;
import star.dualmesher.*;
import star.prismmesher.*;
import star.meshing.*;

import java.io.*;
import java.util.logging.*;



public class scene_VirtualDisks_Reports extends StarMacro {

	///////////////////////////////////////////////////////////////////////////////
	// USER INPUTS (all these user inputs should be read from a CSV file instead)
	// String path0    = "../inputs/turbines.csv";

	///////////////////////////////////////////////////////////////////////////////

	public void execute() {
		execute0();
	}

	private void execute0() {

    Simulation simulation_0 = 
      	getActiveSimulation();

    PhysicsContinuum physicsContinuum_0 = 
      	((PhysicsContinuum) simulation_0.getContinuumManager().getContinuum("Physics 1"));

    AutoMeshOperation autoMeshOperation_0 = 
      	((AutoMeshOperation) simulation_0.get(MeshOperationManager.class).getObject("Automated Mesh"));

  	Units units_none = 
	  	simulation_0.getUnitsManager().getPreferredUnits(new IntVector(new int[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));

	Region region_0 = 
		simulation_0.getRegionManager().getRegion("Region");

	VirtualDiskModel virtualDiskModel_0 = 
		physicsContinuum_0.getModelManager().getModel(VirtualDiskModel.class);




	SimpleAnnotation simpleAnnotation_00 = 
        ((SimpleAnnotation) simulation_0.getAnnotationManager().getObject("file_turbines"));
    // File f = new File("../inputs/" + simpleAnnotation_00.getText() + ".csv");    



	// figure out how many turbines exist (number of text lines)
	int 			nVirtualDisks 	= 0;
	List<String>	textline 		= new ArrayList<String>();

	// File f = new File("../inputs/" + simpleAnnotation_00.getText() + ".csv");
	File f = new File("rotors.csv");
	// File f = new File(path0);
	try {

	    FileReader	fr   = new FileReader(f);
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
	    Logger.getLogger(scene_VirtualDisks_Reports.class.getName()).log(Level.SEVERE, null, ex);
	}

// DEBUG
simulation_0.println("nVirtualDisks = " + nVirtualDisks);



      List<String>	names   = new ArrayList<String>();

      String[] table       	= new String[nVirtualDisks];
      double[] rotor_rpm	= new double[nVirtualDisks];
      double[] x 			= new double[nVirtualDisks];
      double[] y 			= new double[nVirtualDisks];
      double[] z 			= new double[nVirtualDisks];
      double[] nx 			= new double[nVirtualDisks];
      double[] ny 			= new double[nVirtualDisks];
      double[] nz 			= new double[nVirtualDisks];
      double[] rotor_radius	= new double[nVirtualDisks];
      double[] hub_radius	= new double[nVirtualDisks];
      double[] rotor_thick	= new double[nVirtualDisks];

      String[] name_VirtualDiskMarker 				= new String[nVirtualDisks];
      String[] name_VirtualDiskInflowPlaneMarker 	= new String[nVirtualDisks];

      for (int i = 0; i < nVirtualDisks; i++) {
      	
      	String name = textline.get(i).split(",")[0];
        names.add(name);
       
      	table[i]		= textline.get(i).split(",")[1];
      	rotor_rpm[i] 	= Double.parseDouble(textline.get(i).split(",")[2]);
      	x[i]			= Double.parseDouble(textline.get(i).split(",")[3]);
      	y[i]			= Double.parseDouble(textline.get(i).split(",")[4]);
      	z[i]			= Double.parseDouble(textline.get(i).split(",")[5]);
      	nx[i]			= Double.parseDouble(textline.get(i).split(",")[6]);
      	ny[i]			= Double.parseDouble(textline.get(i).split(",")[7]);
      	nz[i]           = Double.parseDouble(textline.get(i).split(",")[8]);
      	rotor_radius[i] = Double.parseDouble(textline.get(i).split(",")[9]);
      	hub_radius[i]   = Double.parseDouble(textline.get(i).split(",")[10]);
      	rotor_thick[i]  = Double.parseDouble(textline.get(i).split(",")[11]);

      	// I think these are not connected to the "name" variable ... they will always be named in order of creation by starccm
      	name_VirtualDiskMarker[i] = "VirtualDiskMarker" + (i+1);
		name_VirtualDiskInflowPlaneMarker[i] = "VirtualDiskInflowPlaneMarker" + (i+1);

      }





		for (int i = 0; i < nVirtualDisks; i++) {

		    VirtualDisk virtualDisk_0 = 
      			((VirtualDisk) virtualDiskModel_0.getVirtualDiskManager().getObject(names.get(i)));


			///////////////////////////////////////////////////////////////////////////////
			// create reports and monitors

			// Torque
			VirtualDiskMomentReport virtualDiskMomentReport_0 = 
	      	  simulation_0.getReportManager().createReport(VirtualDiskMomentReport.class);
	      	virtualDiskMomentReport_0.setVirtualDisk(virtualDisk_0);
			virtualDiskMomentReport_0.setPresentationName("Torque (" + names.get(i) + ")");
		    VirtualDiskMomentReport virtualDiskMomentReport_1 = 
		      ((VirtualDiskMomentReport) simulation_0.getReportManager().getReport("Torque (" + names.get(i) + ")"));
		    ReportMonitor reportMonitor_5 = 
		      virtualDiskMomentReport_1.createMonitor();


		    // Thrust
			VirtualDiskForceReport virtualDiskForceReport_0 = 
	          simulation_0.getReportManager().createReport(VirtualDiskForceReport.class);		  
			virtualDiskForceReport_0.setVirtualDisk(virtualDisk_0);
			virtualDiskForceReport_0.setPresentationName("Thrust (" + names.get(i) + ")");
		    VirtualDiskForceReport virtualDiskForceReport_1 = 
		      ((VirtualDiskForceReport) simulation_0.getReportManager().getReport("Thrust (" + names.get(i) + ")"));
		    ReportMonitor reportMonitor_6 = 
		      virtualDiskForceReport_1.createMonitor();


		    // Rotor Speed
		  	ExpressionReport expressionReport_rpm = 
			  simulation_0.getReportManager().createReport(ExpressionReport.class);
			expressionReport_rpm.setDefinition("" + rotor_rpm[i] + "");
			expressionReport_rpm.setPresentationName("Rotor Speed (" + names.get(i) + ")");
			ReportMonitor reportMonitor_rpm = 
			  expressionReport_rpm.createMonitor();





			    ///////////////////////////////////////////////////////////////////////////////
				// create threshold parts on the virtual disk markers and inflows
			    PrimitiveFieldFunction primitiveFieldFunction_0 = 
			      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction(name_VirtualDiskMarker[i]));
			    ThresholdPart thresholdPart_0 = 
			      simulation_0.getPartManager().createThresholdPart(new NeoObjectVector(new Object[] {region_0}), new DoubleVector(new double[] {1.0, 1.0}), units_none, primitiveFieldFunction_0, 0);
			    thresholdPart_0.setPresentationName(names.get(i));

			    PrimitiveFieldFunction primitiveFieldFunction_1 = 
			      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction(name_VirtualDiskInflowPlaneMarker[i]));
			    ThresholdPart thresholdPart_1 = 
			      simulation_0.getPartManager().createThresholdPart(new NeoObjectVector(new Object[] {region_0}), new DoubleVector(new double[] {1.0, 1.0}), units_none, primitiveFieldFunction_1, 0);
			    thresholdPart_1.setPresentationName("inflow (" + names.get(i) + ")");


			    ///////////////////////////////////////////////////////////////////////////////
				// create volume average reports and monitors on the threshold parts
			    FvRepresentation fvRepresentation_0 = 
      			  ((FvRepresentation) simulation_0.getRepresentationManager().getObject("Volume Mesh"));

			    VolumeAverageReport volumeAverageReport_vel = 
			      simulation_0.getReportManager().createReport(VolumeAverageReport.class);
    			volumeAverageReport_vel.setRepresentation(fvRepresentation_0);

    			VolumeAverageReport volumeAverageReport_tke = 
			      simulation_0.getReportManager().createReport(VolumeAverageReport.class);
    			volumeAverageReport_tke.setRepresentation(fvRepresentation_0);

    			VolumeAverageReport volumeAverageReport_omg = 
			      simulation_0.getReportManager().createReport(VolumeAverageReport.class);
    			volumeAverageReport_omg.setRepresentation(fvRepresentation_0);


			    PrimitiveFieldFunction primitiveFieldFunction_vel = 
			      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("Velocity"));
			    VectorMagnitudeFieldFunction vectorMagnitudeFieldFunction_vel = 
			      ((VectorMagnitudeFieldFunction) primitiveFieldFunction_vel.getMagnitudeFunction());
			    volumeAverageReport_vel.setScalar(vectorMagnitudeFieldFunction_vel);
			    volumeAverageReport_vel.getParts().setObjects(thresholdPart_1);
			    volumeAverageReport_vel.setPresentationName("volume avg. inflow (" + names.get(i) + ")");

			    PrimitiveFieldFunction primitiveFieldFunction_tke = 
      			  ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("TurbulentKineticEnergy"));
			    volumeAverageReport_tke.setScalar(primitiveFieldFunction_tke);
			    volumeAverageReport_tke.getParts().setObjects(thresholdPart_1);
			    volumeAverageReport_tke.setPresentationName("TKE inflow (" + names.get(i) + ")");

			    PrimitiveFieldFunction primitiveFieldFunction_omg = 
      			  ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("SpecificDissipationRate"));
			    volumeAverageReport_omg.setScalar(primitiveFieldFunction_omg);
			    volumeAverageReport_omg.getParts().setObjects(thresholdPart_1);
			    volumeAverageReport_omg.setPresentationName("Omega inflow (" + names.get(i) + ")");


			    VolumeAverageReport volumeAverageReport_inflowvel = 
			      ((VolumeAverageReport) simulation_0.getReportManager().getReport("volume avg. inflow (" + names.get(i) + ")"));
			    ReportMonitor reportMonitor_vel = 
				  volumeAverageReport_inflowvel.createMonitor();

				VolumeAverageReport volumeAverageReport_inflowtke = 
			      ((VolumeAverageReport) simulation_0.getReportManager().getReport("TKE inflow (" + names.get(i) + ")"));
			    ReportMonitor reportMonitor_tke = 
				  volumeAverageReport_inflowtke.createMonitor();

				VolumeAverageReport volumeAverageReport_inflowomg = 
			      ((VolumeAverageReport) simulation_0.getReportManager().getReport("Omega inflow (" + names.get(i) + ")"));
			    ReportMonitor reportMonitor_omg = 
				  volumeAverageReport_inflowomg.createMonitor();



			    // FIELD FUNCTIONS
				// tip-speed ratio
				UserFieldFunction userFieldFunction_tsr = 
			      simulation_0.getFieldFunctionManager().createFieldFunction();
			    userFieldFunction_tsr.getTypeOption().setSelected(FieldFunctionTypeOption.Type.SCALAR);
			    userFieldFunction_tsr.setPresentationName("Tip-Speed-Ratio (" + names.get(i) + ")");
			    userFieldFunction_tsr.setFunctionName("Tip-Speed-Ratio (" + names.get(i) + ")");
			    userFieldFunction_tsr.setDefinition(rotor_radius[i] + " * ${RotorSpeed(" + names.get(i) + ")Report} * (3.14159/30) / ${volumeavg.inflow(" + names.get(i) + ")Report}");

			    // power
			    UserFieldFunction userFieldFunction_power = 
			      simulation_0.getFieldFunctionManager().createFieldFunction();
			    userFieldFunction_power.getTypeOption().setSelected(FieldFunctionTypeOption.Type.SCALAR);
			    userFieldFunction_power.setPresentationName("Power (" + names.get(i) + ")");
			    userFieldFunction_power.setFunctionName("Power (" + names.get(i) + ")");
			    userFieldFunction_power.setDefinition("${Torque(" + names.get(i) + ")Report} *${RotorSpeed(" + names.get(i) + ")Report} * (3.14159/30)");


			    // REPORTS
				ExpressionReport expressionReport_power = 
      				simulation_0.getReportManager().createReport(ExpressionReport.class);
			    expressionReport_power.setDefinition("${Power (" + names.get(i) + ")}");
			    expressionReport_power.setPresentationName("Power (" + names.get(i) + ")");
				    ReportMonitor reportMonitor_power = 
				      expressionReport_power.createMonitor();


			    ExpressionReport expressionReport_tsr = 
      				simulation_0.getReportManager().createReport(ExpressionReport.class);
			    expressionReport_tsr.setDefinition("${Tip-Speed-Ratio (" + names.get(i) + ")}");
			    expressionReport_tsr.setPresentationName("Tip-Speed-Ratio (" + names.get(i) + ")");
					ReportMonitor reportMonitor_tsr = 
					      expressionReport_tsr.createMonitor();



				// reports on rotor speeds
				ExpressionReport expressionReport_rotorspeed = 
				  ((ExpressionReport) simulation_0.getReportManager().getReport("Rotor Speed (" + names.get(i) + ")"));


		} // end FOR loop


		




		ReportMonitor reportMonitor_vel = 
		  ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("volume avg. inflow (" + names.get(0) + ") Monitor"));
	    MonitorPlot monitorPlot_0 = 
	      simulation_0.getPlotManager().createMonitorPlot(new NeoObjectVector(new Object[] {reportMonitor_vel}), "volume avg. inflow");
	    monitorPlot_0.setPresentationName("rotors-inflow");

	    ReportMonitor reportMonitor_1 = 
		  ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Thrust (" + names.get(0) + ") Monitor"));
	    MonitorPlot monitorPlot_1 = 
	      simulation_0.getPlotManager().createMonitorPlot(new NeoObjectVector(new Object[] {reportMonitor_1}), "thrust");
	    monitorPlot_1.setPresentationName("rotors-thrust");

	    ReportMonitor reportMonitor_2 = 
		  ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Torque (" + names.get(0) + ") Monitor"));
	    MonitorPlot monitorPlot_2 = 
	      simulation_0.getPlotManager().createMonitorPlot(new NeoObjectVector(new Object[] {reportMonitor_2}), "torque");
	    monitorPlot_2.setPresentationName("rotors-torque");



	    ReportMonitor reportMonitor_3 = 
		  ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Rotor Speed (" + names.get(0) + ") Monitor"));
	    MonitorPlot monitorPlot_3 = 
	      simulation_0.getPlotManager().createMonitorPlot(new NeoObjectVector(new Object[] {reportMonitor_3}), "rotor speed");
	    monitorPlot_3.setPresentationName("rotor speed");

	    ReportMonitor reportMonitor_4 = 
		  ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Tip-Speed-Ratio (" + names.get(0) + ") Monitor"));
	    MonitorPlot monitorPlot_4 = 
	      simulation_0.getPlotManager().createMonitorPlot(new NeoObjectVector(new Object[] {reportMonitor_4}), "Tip-Speed-Ratio");
	    monitorPlot_4.setPresentationName("Tip-Speed-Ratio");

	   ReportMonitor reportMonitor_5 = 
		  ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Power (" + names.get(0) + ") Monitor"));
	    MonitorPlot monitorPlot_5 = 
	      simulation_0.getPlotManager().createMonitorPlot(new NeoObjectVector(new Object[] {reportMonitor_5}), "Power");
	    monitorPlot_5.setPresentationName("Power");


	    ReportMonitor reportMonitor_tke = 
		  ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("TKE inflow (" + names.get(0) + ") Monitor"));
	    MonitorPlot monitorPlot_tke = 
	      simulation_0.getPlotManager().createMonitorPlot(new NeoObjectVector(new Object[] {reportMonitor_tke}), "TKE inflow");
	    monitorPlot_tke.setPresentationName("rotors-inflow-tke");

	    ReportMonitor reportMonitor_omg = 
		  ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Omega inflow (" + names.get(0) + ") Monitor"));
	    MonitorPlot monitorPlot_omg = 
	      simulation_0.getPlotManager().createMonitorPlot(new NeoObjectVector(new Object[] {reportMonitor_tke}), "Omega inflow");
	    monitorPlot_omg.setPresentationName("rotors-inflow-omg");


	    // Total Power
        StringBuilder sb = new StringBuilder();
        sb.append("${Power (" + names.get(0) + ")}");
        for(int i=1; i<nVirtualDisks; ++i){
            // sb.append("2");
            sb.append("+ ${Power (" + names.get(i) + ")}");
        }
        String finalFF = sb.toString();

        // total farm power
			UserFieldFunction userFieldFunction_2 = 
				simulation_0.getFieldFunctionManager().createFieldFunction();
			userFieldFunction_2.getTypeOption().setSelected(FieldFunctionTypeOption.Type.SCALAR);
			userFieldFunction_2.setPresentationName("Total Power");
			userFieldFunction_2.setFunctionName("Total Power");
			userFieldFunction_2.setDefinition(finalFF);
 		


 		ExpressionReport expressionReport_P = 
      				simulation_0.getReportManager().createReport(ExpressionReport.class);
			    expressionReport_P.setDefinition("${Total Power}");
			    expressionReport_P.setPresentationName("Total Power");
				    ReportMonitor reportMonitor_P = 
				      expressionReport_P.createMonitor();


 		ReportMonitor reportMonitor_6 = 
		  ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Total Power Monitor"));
	    MonitorPlot monitorPlot_6 = 
	      simulation_0.getPlotManager().createMonitorPlot(new NeoObjectVector(new Object[] {reportMonitor_6}), "Total Power");
	    monitorPlot_6.setPresentationName("Total Power");




	    for (int i = 1; i < nVirtualDisks; i++) {
            ReportMonitor reportMonitor_veln = 
              ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("volume avg. inflow (" + names.get(i) + ") Monitor"));
            monitorPlot_0.getDataSetManager().addDataProviders(new NeoObjectVector(new Object[] {reportMonitor_veln}));

            ReportMonitor reportMonitor_1n = 
              ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Thrust (" + names.get(i) + ") Monitor"));
            monitorPlot_1.getDataSetManager().addDataProviders(new NeoObjectVector(new Object[] {reportMonitor_1n}));

            ReportMonitor reportMonitor_2n = 
              ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Torque (" + names.get(i) + ") Monitor"));
            monitorPlot_2.getDataSetManager().addDataProviders(new NeoObjectVector(new Object[] {reportMonitor_2n}));



            ReportMonitor reportMonitor_3n = 
              ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Rotor Speed (" + names.get(i) + ") Monitor"));
            monitorPlot_3.getDataSetManager().addDataProviders(new NeoObjectVector(new Object[] {reportMonitor_3n}));


            ReportMonitor reportMonitor_4n = 
              ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Tip-Speed-Ratio (" + names.get(i) + ") Monitor"));
            monitorPlot_4.getDataSetManager().addDataProviders(new NeoObjectVector(new Object[] {reportMonitor_4n}));

            ReportMonitor reportMonitor_5n = 
              ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Power (" + names.get(i) + ") Monitor"));
            monitorPlot_5.getDataSetManager().addDataProviders(new NeoObjectVector(new Object[] {reportMonitor_5n}));


            ReportMonitor reportMonitor_tken = 
              ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("TKE inflow (" + names.get(i) + ") Monitor"));
            monitorPlot_tke.getDataSetManager().addDataProviders(new NeoObjectVector(new Object[] {reportMonitor_tken}));

            ReportMonitor reportMonitor_omgn = 
              ((ReportMonitor) simulation_0.getMonitorManager().getMonitor("Omega inflow (" + names.get(i) + ") Monitor"));
            monitorPlot_omg.getDataSetManager().addDataProviders(new NeoObjectVector(new Object[] {reportMonitor_omgn}));


        }

	        

		
  } // end execute0()
} // end public class
