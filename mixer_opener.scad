// minimum angle for a fragment
$fa=5;
// minimum size of a fragment
$fs=1;
eps=1/128;

module smooth() {
    sphere(d=10);
    mirror([0, 0, 1]) translate([0, 0, 5/sqrt(2)])
        cylinder(5-5/sqrt(2),
                 d1=10/sqrt(2), d2=10*sqrt(2)-10);
}

module base()
    difference() {
        hull() {
            circle(d=130);
            translate([160, 120]) circle(d=10);
        }
        hull() {
            translate(0.833*[160, 120]) circle(d=10);
            translate(0.46*[160, 120]) circle(d=55);
        }
    }

module cut()
    linear_extrude(100, center=true, convexity=10) {
        intersection() {
            circle(d=100);
            square([20, 100], center=true);
        }
        circle(d=96.5);
    }

if(1)
difference() {
    minkowski() {
        linear_extrude(eps, convexity=10) base();
        smooth();
    }
    cut();
}
else
base();
