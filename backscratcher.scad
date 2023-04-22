// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;
eps=1/128;

module profile()
    circle(d=10);
    
intersection() {
    union() {
        rotate_extrude() translate([20, 0]) profile();
        for(i=[0,60]) rotate(i+9) translate([40, 0, 0])
            rotate(i+120) rotate_extrude(angle=60)
                translate([20, 0]) profile();
        rotate([90, 0, 129])
            linear_extrude(275) profile();
        rotate(39) translate([275, 0, 0]) sphere(d=10);
        cylinder(10, r=20, center=true);
    }
    cube([500, 500, 10/sqrt(2)], center=true);
}
for(j=[0:5:20],i=[1:300/j:360]) rotate(i+j)
    translate([j, 0, 5/sqrt(2)-eps])
        cylinder(10/sqrt(2), d1=10/sqrt(2), d2=0);
