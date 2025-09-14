use <CMSL.scad>;
$fn = 50;

union() {
  difference() {
    CMRoundCube([50, 15, 5], r=5, 3d=false);

    for(x = [5, 45])
      translate([x, 5, 5])
        rotate([180, 0, 0])
        CMCountersunk(l=5, ds=4);
  }

  translate([10, 10, 0])
    cube([30, 5, 15]);

  translate([25, 15, 0])
    rotate([90, 0, 0])
    difference() {
      union() {
        CMRoundCube([8, 140, 5], r=4, 3d=false);
        translate([-6, 80, 0])
          CMRoundCube([14, 60, 5], r=4, 3d=false);
      }
      translate([-9, 83, 2])
        CMRoundCube([12, 54, 3], r=3, 3d=false);
      translate([-4, 84, 0])
        CMRoundCube([3, 52, 2], r=1.5, 3d=false);
    }
}
