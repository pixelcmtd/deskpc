/// - 4× IM3
/// - 4× SM3×130
/// - 10× IM2
/// - 10× SM2×12
use <CMSL.scad>;
$fn = 50;

// TODO: this belongs in a library
module Deltron551Cutout() {
  circle(d=8.2);
  hull() {
    circle(d=2.4);
    translate([0, 4.5])
      circle(d=2.4);
  }
}

module sunkscrew(pos, length, invert=false) {
  union() {
    translate([pos.x, pos.y-2, pos.z+2])
      rotate([0, 90, 0])
      CMRoundCube([4, length+4, 10], r=2, 3d=false);
    translate([invert ? pos.x+10 : pos.x-100, pos.y-5, pos.z+5])
      rotate([0, 90, 0])
      CMRoundCube([10, length+10, 100], r=5, 3d=false);
  }
}

// SFF-8501
// SFF-8301
// https://downloads.caldigit.com/TS4/TS4-Chassis-Dimension.png
// https://www.store.level1techs.com/products/p/14-kvm-switch-dual-monitor-2computer-z5erd-n6mbj
difference() {
  union() {
    CMRoundCube([165, 160, 205], r=5, 3d=false);
    translate([-10, 50, 0])
      CMRoundCube([185, 50, 5], r=5, 3d=false);
  }

  translate([(165-146.55)/2, 0, 0])
    cube([146.55, 160, 50]);
  for(xi = [[7.5, false], [147.5, true]])
    for(z = [5+9.91, 5+21.84])
      sunkscrew([xi.x, 15, z], length=130, invert=xi.y);

  for(z = [50, 76.6]) {
    translate([(165-146.55)/2, 0, z])
      cube([102.10, 160, 26.6]);
    for(xi = [[7.5, false], [103.5, true]])
      sunkscrew([xi.x, 15, z+6.35], length=130, invert=xi.y);
  }

  // kvm
  translate([10, 0, 110])
    cube([145, 160, 58]);
  translate([2.5, 10, 110])
    cube([160, 103, 58]);

  // tb4 dock
  translate([10, 10, 174])
    cube([142, 115, 45]);
  translate([15, 0, 174])
    cube([132, 160, 45]);

  // usb
  translate([113, 0, 76.6+1.35])
    cube([46, 160, 25.25]);
  translate([113, 7, 76.6+1.35])
    cube([60, 146, 25.25]);
  for(y = [5, 5+21.5])
    for(x = [2, 22.75, 43.5])
      translate([113+x, y, 76.6+1.35])
        CMInsertM2();
  for(x = [0, 20])
    for(y = [80, 123])
      translate([125.75+x, y, 76.6+1.35])
        CMInsertM2();

  // 12v + ground
  for(x = [122.5, 135, 147.5])
    translate([x, 0, 57])
      rotate([-90, 0, 0])
      linear_extrude(160)
      Deltron551Cutout();
  translate([112.5, 3, 50])
    cube([45, 160, 18]);

  // attachments screws
  for(x = [5, 160])
    for(y = [5, 155]) {
      translate([x, y, 75])
        cylinder(130, d=4);
      translate([x, y, 76.6+1.4])
        CMInsertM3();
    }

  // wood screws
  for(x = [-5, 170])
    for(y = [60, 90])
      translate([x, y, 5])
        rotate([180, 0, 0])
        CMCountersunk(l=5, ds=4);

  //translate([-10, -10, 0]) cube([200, 200, 76.6+1.35]);
  //translate([-10, -10, 76.6+1.35]) cube([200, 200, 33.4001-1.35]);
  //translate([-10, -10, 110]) cube([200, 200, 68]);
  //translate([-10, -10, 174]) cube([200, 200, 100]);

  //translate([100, -10, 0]) cube([90, 200, 200]);
  //translate([-10, -10, 0]) cube([90, 200, 200]);
}
