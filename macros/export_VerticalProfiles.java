// STAR-CCM+ macro: export_VerticalProfiles.java
// Written by STAR-CCM+ 12.02.010
package macro;

import java.util.*;

import star.common.*;
import star.base.neo.*;
import star.vis.*;

public class export_VerticalProfiles extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    Simulation simulation_0 = 
      getActiveSimulation();

    Units units_0 = 
      simulation_0.getUnitsManager().hasPreferredUnits(new IntVector(new int[] {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));

    LinePart linePart_0 = 
      simulation_0.getPartManager().createLinePart(new NeoObjectVector(new Object[] {}), new DoubleVector(new double[] {0.0, 0.0, 0.0}), new DoubleVector(new double[] {1.0, 0.0, 0.0}), 20);

    Coordinate coordinate_0 = 
      linePart_0.getPoint1Coordinate();

    LabCoordinateSystem labCoordinateSystem_0 = 
      simulation_0.getCoordinateSystemManager().getLabCoordinateSystem();

    coordinate_0.setCoordinateSystem(labCoordinateSystem_0);

    coordinate_0.setValue(new DoubleVector(new double[] {-1591.198488571242, 49.55293642944144, -171.2969403154193}));

    coordinate_0.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-1591.198488571242, 49.55293642944144, -171.2969403154193}));

    Coordinate coordinate_1 = 
      linePart_0.getPoint2Coordinate();

    coordinate_1.setCoordinateSystem(labCoordinateSystem_0);

    coordinate_1.setValue(new DoubleVector(new double[] {-1589.749211398087, 49.081536283562855, -1240.866294925605}));

    coordinate_1.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-1589.749211398087, 49.081536283562855, -1240.866294925605}));

    linePart_0.setCoordinateSystem(labCoordinateSystem_0);

    linePart_0.getInputParts().setQuery(null);

    Region region_0 = 
      simulation_0.getRegionManager().getRegion("Region");

    linePart_0.getInputParts().setObjects(region_0);

    linePart_0.setResolution(20);

    LinePart linePart_1 = 
      simulation_0.getPartManager().createLinePart(new NeoObjectVector(new Object[] {}), new DoubleVector(new double[] {0.0, 0.0, 0.0}), new DoubleVector(new double[] {1.0, 0.0, 0.0}), 20);

    Coordinate coordinate_2 = 
      linePart_1.getPoint1Coordinate();

    coordinate_2.setCoordinateSystem(labCoordinateSystem_0);

    coordinate_2.setValue(new DoubleVector(new double[] {-1512.0, -42.0, 0.0}));

    coordinate_2.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-1512.0, -42.0, 0.0}));

    Coordinate coordinate_3 = 
      linePart_1.getPoint2Coordinate();

    coordinate_3.setCoordinateSystem(labCoordinateSystem_0);

    coordinate_3.setValue(new DoubleVector(new double[] {-1512.0, -42.0, -200.0}));

    coordinate_3.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-1512.0, -42.0, -200.0}));

    linePart_1.setCoordinateSystem(labCoordinateSystem_0);

    linePart_1.getInputParts().setQuery(null);

    linePart_1.getInputParts().setObjects(region_0);

    linePart_1.setResolution(2000);

    linePart_1.setPresentationName("Line1_flood");

    LinePart linePart_2 = 
      simulation_0.getPartManager().createLinePart(new NeoObjectVector(new Object[] {}), new DoubleVector(new double[] {0.0, 0.0, 0.0}), new DoubleVector(new double[] {1.0, 0.0, 0.0}), 20);

    linePart_2.setPresentationName("Copy of Line1_flood");

    linePart_2.copyProperties(linePart_1);

    LinePart linePart_3 = 
      simulation_0.getPartManager().createLinePart(new NeoObjectVector(new Object[] {}), new DoubleVector(new double[] {0.0, 0.0, 0.0}), new DoubleVector(new double[] {1.0, 0.0, 0.0}), 20);

    linePart_3.setPresentationName("Copy of Line1_flood");

    linePart_3.copyProperties(linePart_1);

    LinePart linePart_4 = 
      simulation_0.getPartManager().createLinePart(new NeoObjectVector(new Object[] {}), new DoubleVector(new double[] {0.0, 0.0, 0.0}), new DoubleVector(new double[] {1.0, 0.0, 0.0}), 20);

    linePart_4.setPresentationName("Copy of Line1_flood");

    linePart_4.copyProperties(linePart_1);

    linePart_2.setPresentationName("Line1_ebb");

    Coordinate coordinate_4 = 
      linePart_2.getPoint1Coordinate();

    coordinate_4.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-857.0, -657.0, 0.0}));

    Coordinate coordinate_5 = 
      linePart_2.getPoint2Coordinate();

    coordinate_5.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-857.0, -657.0, -200.0}));

    linePart_3.setPresentationName("Line2_flood");

    Coordinate coordinate_6 = 
      linePart_3.getPoint1Coordinate();

    coordinate_6.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-684.0, 1540.0, 0.0}));

    Coordinate coordinate_7 = 
      linePart_3.getPoint2Coordinate();

    coordinate_7.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-684.0, 1540.0, -200.0}));

    linePart_4.setPresentationName("Line2_ebb");

    Coordinate coordinate_8 = 
      linePart_4.getPoint1Coordinate();

    coordinate_8.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-140.0, 1045.0, 0.0}));

    Coordinate coordinate_9 = 
      linePart_4.getPoint2Coordinate();

    coordinate_9.setCoordinate(units_0, units_0, units_0, new DoubleVector(new double[] {-140.0, 1045.0, -200.0}));

    XyzInternalTable xyzInternalTable_0 = 
      simulation_0.getTableManager().createTable(XyzInternalTable.class);

    xyzInternalTable_0.getParts().setQuery(null);

    xyzInternalTable_0.getParts().setObjects(linePart_2, linePart_1, linePart_4, linePart_3);

    PrimitiveFieldFunction primitiveFieldFunction_0 = 
      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("Velocity"));

    VectorMagnitudeFieldFunction vectorMagnitudeFieldFunction_0 = 
      ((VectorMagnitudeFieldFunction) primitiveFieldFunction_0.getMagnitudeFunction());

    PrimitiveFieldFunction primitiveFieldFunction_1 = 
      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("TurbulentKineticEnergy"));

    PrimitiveFieldFunction primitiveFieldFunction_2 = 
      ((PrimitiveFieldFunction) simulation_0.getFieldFunctionManager().getFunction("SpecificDissipationRate"));

    xyzInternalTable_0.setFieldFunctions(new NeoObjectVector(new Object[] {vectorMagnitudeFieldFunction_0, primitiveFieldFunction_1, primitiveFieldFunction_2}));

    xyzInternalTable_0.setPresentationName("VerticalProfiles");

    TableUpdate tableUpdate_0 = 
      xyzInternalTable_0.getTableUpdate();

    tableUpdate_0.setAutoExtract(true);

    xyzInternalTable_0.extract();

    xyzInternalTable_0.export("vertical_profiles.csv", ",");

    XyzInternalTable xyzInternalTable_1 = 
      simulation_0.getTableManager().createTable(XyzInternalTable.class);

    xyzInternalTable_1.setPresentationName("Line1_flood");

    xyzInternalTable_1.getParts().setQuery(null);

    xyzInternalTable_1.getParts().setObjects(linePart_1);

    xyzInternalTable_1.setFieldFunctions(new NeoObjectVector(new Object[] {vectorMagnitudeFieldFunction_0, primitiveFieldFunction_1, primitiveFieldFunction_2}));

    xyzInternalTable_1.extract();

    xyzInternalTable_1.export("vertical_profiles_Line1-flood.csv", ",");

    XyzInternalTable xyzInternalTable_2 = 
      simulation_0.getTableManager().createTable(XyzInternalTable.class);

    xyzInternalTable_2.setPresentationName("Copy of Line1_flood");

    xyzInternalTable_2.copyProperties(xyzInternalTable_1);

    xyzInternalTable_2.setPresentationName("Line1_ebb");

    xyzInternalTable_2.getParts().setQuery(null);

    xyzInternalTable_2.getParts().setObjects(linePart_2);

    xyzInternalTable_2.extract();

    xyzInternalTable_2.export("vertical_profiles_Line1-ebb.csv", ",");

    XyzInternalTable xyzInternalTable_3 = 
      simulation_0.getTableManager().createTable(XyzInternalTable.class);

    xyzInternalTable_3.setPresentationName("Copy of Line1_flood");

    xyzInternalTable_3.copyProperties(xyzInternalTable_1);

    xyzInternalTable_3.setPresentationName("Line2_flood");

    xyzInternalTable_3.getParts().setQuery(null);

    xyzInternalTable_3.getParts().setObjects(linePart_3);

    xyzInternalTable_3.extract();

    xyzInternalTable_3.export("vertical_profiles_Line2-flood.csv", ",");

    XyzInternalTable xyzInternalTable_4 = 
      simulation_0.getTableManager().createTable(XyzInternalTable.class);

    xyzInternalTable_4.setPresentationName("Copy of Line1_flood");

    xyzInternalTable_4.copyProperties(xyzInternalTable_1);

    xyzInternalTable_4.setPresentationName("Line2_ebb");

    xyzInternalTable_4.getParts().setQuery(null);

    xyzInternalTable_4.getParts().setObjects(linePart_4);

    xyzInternalTable_4.extract();

    xyzInternalTable_4.export("vertical_profiles_Line2-ebb.csv", ",");
  }
}
