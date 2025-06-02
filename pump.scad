use <CMSL.scad>;
$fn = 50;

mbholes = [       // names according to the ATX & mATX specs
  [141, 78.7],    // H
  [298.5, 78.7],  // J
  [141, 233.7],   // C
  [298.5, 210.8], // F
];

pumpholes = [
  [159.75, 78.7],
  [279.75, 78.7],
  [159.75, 198.7],
  [279.75, 198.7],
];

difference() {
  CMFrame(concat(mbholes, pumpholes, [[159.75, 233.7], [141, 198.7], [298.5, 198.7]]), r=5, h=3, w=10, 3d=false);
  for(h = mbholes)
    translate([h.x, h.y, 0])
      cylinder(3, d=3.5);
  // should probably be done with CMFanHoles120
  for(h = pumpholes)
    translate([h.x, h.y, 0])
      cylinder(3, d=5);
}
