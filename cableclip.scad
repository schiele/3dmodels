use <surfacecylinder.scad>

// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

module clip(t, angle=320) difference() {
    union() {
        for(i=[0, angle]) rotate(i) translate([5/2+1/2, 0]) {
            for(j=[0, 10]) translate([0, 0, j]) sphere(d=1);
            cylinder(10, d=1);
        }
        rotate_extrude(angle=angle) translate([5/2+1/2, 0]) {
            for(j=[0, 10]) translate([0, j]) circle(d=1);
            translate([-1/2, 0]) square([1, 10]);
        }
    }
    surfacecylinder(d=7-0.5, ext=0.5)
        translate([PI*(7-0.5)*angle/360/2, 10/2])
            text(t, 8, halign="center", valign="center");
    translate([0, 0, -10-1/2/sqrt(2)]) cube(20, center=true);
}

translate([0, 0]) clip("H1");
translate([10, 0]) clip("H2");
translate([0, 10]) clip("L");
translate([10, 10]) clip("C");
