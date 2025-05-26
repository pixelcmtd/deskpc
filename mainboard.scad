use <CMSL.scad>;
$fn = 50;

posts = [         // names according to the ATX & mATX specs
  [16.5, 6.4],    // K
  [141, 6.4],     // L
  [298.5, 6.4],   // M
  [16.5, 78.7],   // G
  //[74.9, 78.7],   // R
  //[95.3, 78.7],   // S
  [141, 78.7],    // H
  [298.5, 78.7],  // J
  [16.5, 233.7],  // A
  //[95.3, 233.7],  // B
  [141, 233.7],   // C
  [298.5, 210.8], // F
];

union() {
  difference() {
    CMFrame(concat(posts, [[298.5, 233.7]]), r=5, h=5, w=10, 3d=false);

  // TODO: find a proper algorithm for this and put it in CMSL
  for(p1 = posts)
    for(p2 = posts)
      if(p1.x == p2.x && p1.y < p2.y && p2.y - p1.y < 200)
        translate([p1.x, p1.y + (p2.y - p1.y)/2, 5])
        rotate([180, 0, 0])
          CMCountersunk(l=5, ds=4);
      else if(p1.y == p2.y && p1.x < p2.x && p2.x - p1.x < 200)
        translate([p1.x + (p2.x - p1.x)/2, p1.y, 5])
        rotate([180, 0, 0])
          CMCountersunk(l=5, ds=4);
  }

  for(pos = posts)
    difference() {
      translate([pos.x, pos.y, 5])
        cylinder(15, d=10);
      translate([pos.x, pos.y, 20])
        CMInsertM3(15);
    }
}
