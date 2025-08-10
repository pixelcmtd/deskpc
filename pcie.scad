use <CMSL.scad>;
$fn = 50;

difference() {
  union() {
    CMRoundCube([40, 10, 5], r=5, 3d=false);
    translate([20, 5, 0]) {
      cylinder(10, d=10);
      cylinder(100, d=8);
    }
  }
  translate([20, 5, 100])
    CMInsertM3(l=10);

  for(x = [5, 35])
    translate([x, 5, 5])
      rotate([180, 0, 0])
      CMCountersunk(l=5, ds=4);
}
