use <thread.scad>

// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;
eps=1/128;
tol=0.1;
part=2;

module flatprofile() intersection() {
    circle(r=10);
    square([20, 10*sqrt(2)], center=true);
}

module bowl() rotate_extrude() intersection() {
    circle(r=10);
    translate([0, -10/sqrt(2)]) square([10, 10+10/sqrt(2)]);
}

module inner()
    for(a=[0:120:240]) rotate(a)
        translate([-tan(60)*25, -25.0]) rotate_extrude(angle=60)
            translate([tan(60)*25, 0]) flatprofile();

module outer()
    for(a=[0:120:240]) rotate(a)
        rotate([90, 0, 0]) linear_extrude(35) flatprofile();

module part1() {
    inner();
    outer();
    for(a=[0:120:240]) rotate(a) {
        intersection() {
            translate([-tan(60)*25, -25.0])
                rotate_extrude(angle=60)
                    translate([tan(60)*25-10, 0])
                        square([20, 25]);
            cylinder(25, d1=50, d2=45);
        }
        rotate(30) translate([35, 0]) bowl();
    }
    translate([0, 0, 25-eps])
        if(0 && $preview)
            cylinder(36, r=7.5-tol);
        else
            for(i=[0:2:34]) translate([0, 0, i])
                thread(triangle(), 2+eps, r=7-tol, starts=1,
                       convexity=2, $fa=5, $fs=1);
}

module part2() difference() {
    union() {
        inner();
        outer();
        for(a=[0:120:240]) rotate(a) {
            rotate(30) translate([35, 0])
            rotate_extrude() intersection() {
                circle(r=10);
                translate([0, -5*sqrt(2)])
                    square([10, 10*sqrt(2)]);
            }
        }
    }
    cylinder(100, d=15, center=true);
}

module part3() difference() {
    intersection() {
        inner();
        cylinder(20, d=50, center=true);
    }
    translate([0, 0, -10])
        if(0 && $preview)
            cylinder(20, r=7.5);
        else
            for(i=[0:2:18]) translate([0, 0, i])
            thread(triangle(), 2+eps, r=7, starts=1, convexity=2, $fa=5, $fs=1);
}


part1();
translate([0, 70]) part2();
translate([0, 120]) part3();
