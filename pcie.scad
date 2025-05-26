use <CMSL.scad>;
$fn = 50;

n_p = 2;

difference() {
  CMRoundCube([20+n_p*20.32, 10, 5], r=5, 3d=false);

  for(i = [0:n_p-1])
    translate([5+18.4+20.32*i, 5, 5])
      CMInsertM3S();

  for(x = [5, 15+n_p*20.32])
    translate([x, 5, 5])
      rotate([180, 0, 0])
      CMCountersunk(l=5, ds=4);
}
