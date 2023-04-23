// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

for(i=[0,1]) mirror([0,i,0]) {
    rotate(30) rotate_extrude(angle=150)
        translate([49,0]) square([2,20]);
    rotate(22) translate([50,0])
        rotate(-90) rotate_extrude(angle=300)
            translate([6,0]) square([2,40]);
    rotate(22) translate([50,0]) for(j=[0,300]) rotate(j-90) translate([7,0]) cylinder(40, d=2);
}
