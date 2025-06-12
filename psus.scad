use <CMSL.scad>;
$fn = 50;

height = 4;
holes = [[-69, 16], [-69, 80], [45, 6], [69, 80]];
w = 7;

module atxpsu() {
  union() {
    difference() {
      for(p = holes)
        translate([p.x-w/2, 0, 0])
          cube([w, p.y+w/2, height]);
      for(p = holes)
        translate([p.x, p.y, 0])
          cylinder(height, d=4);

      translate([45+w/2, w/2, 0])
        cube([50, 80-w, height]);
      translate([-70-w/2, 16+w/2, 0])
        cube([50, 64-w, height]);
    }

    for(x = [69+w/2, -69-6])
      translate([x, 0, 0])
        cube([6-w/2, 86+w, height]);
  }
}

union() {
  translate([0, 0, 150/2])
    union() {
      //CMFrame([[150, 20], [290, 20], [150, 14], [290, 14]], r=5, h=5, w=10, 3d=false)

      rotate([90, 90, 180])
        atxpsu();
      rotate([270, -90, 0])
        atxpsu();

      translate([-w/2, 4, 69+w/2])
        rotate([90, 90, 0])
        cube([69*2+w, w, height]);

      translate([86-w/2, 4, 69+6])
        rotate([90, 90, 0])
        cube([69*2+6*2, 10+1+w/2+height*3/4, height]);
      translate([-86-10-1, 4, 69+6])
        rotate([90, 90, 0])
        cube([69*2+6*2, 10+1+w/2, height]);

      translate([-86-w/2, 0, -150/2])
        cube([86*2+w, height, 6-w/2]);
    }
  difference() {
    union() {
      for(x = [86+1, -86-10-1])
        translate([x, height-150, 0])
          cube([10, 150, height]);
      translate([86+1, height-150, 0])
        cube([90+3*height/2, 150, height/2]);
    }

    for(x = [86+1+5, -86-1-5])
      for(y = [25:50:150])
        translate([x, -y, height])
          rotate([180, 0, 0])
          CMCountersunk(l=height, ds=4);
  }
  translate([86+1+10, height-150, 0])
    cube([height*3/4, 150, 70]);
  translate([86+1+10+80+height*3/4, height-150, 0])
    cube([height*3/4, 150, 70]);
}
