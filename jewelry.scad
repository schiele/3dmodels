// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

tol=0.1;
part="stand"; // ["stand", "backplane", "clip"]

module backplane() for(e=[2, 4]) linear_extrude(e) difference() {
    union() {
        hull() for(i=[10, 200]) {
            translate([i, 240]) circle(r=10);
            translate([i, 20]) square(20, center=true);
        }
        if(e==2) translate([10, 0]) square([190,10]);
    }
    for(k=[30, 145]) hull() for(i=[20, 190], j=[0, 85])
        translate([i, j+k]) circle(r=10);
    if(e==4) for(i=[25:10:185]) translate([i, 150])
        square([4, 300], center=true);
    for(i=[25:10:185], j=[10, 20, 125, 135, 240, 250]) translate([i, j])
        square(4, center=true);
}

module clip() linear_extrude(4-2*tol, center=true) polygon([
    [0, 0],
    [15-tol, 0],
    [15-tol, 2-tol],
    [14-tol, 2-tol],
    [14-tol, 8+tol],
    [16+tol, 8+tol],
    [16+tol, 2-tol],
    [15+tol, 2-tol],
    [15+tol, 0],
    [18, 0],
    [18, 10],
    [12, 10],
    [12, 2],
    [2, 2],
    [2, 10],
    [0, 10],
]);

module sideprof()
    polygon([[0, 0], [108, 0], [108, 11], [6, 100], [0, 100]]);

module stand() difference() {
    union() {
        for(i=[2, 210]) translate([i, 0, 0]) rotate([90, 0, -90])
            linear_extrude(2) difference() {
                sideprof();
                offset(r=-11) sideprof();
            }
        mirror([0, 1, 0]) {
            cube([210, 108, 1]);
            //cube([210, 6, 100]);
            translate([0, 106, 0]) cube([210, 2, 11]);
        }
        rotate([90, 0, 0]) linear_extrude(6, convexity=10)
            difference() {
                square([210, 100]);
                for(i=[5:20:205], j=[11:20:75])
                translate([i, j]) rotate(45) square(12.5);
                for(i=[-5:20:215], j=[21:20:75])
                translate([i, j]) rotate(45) square(12.5);
        }
    }
    translate([210/2, -3, 100]) cube([190+2*tol, 2+2*tol, 20], center=true);
}

if($preview) {
    color("white") 
    translate([0, -2, 90])
    rotate([90, 0, 0]) backplane();
    color("darkgrey") {
    for(i=[25:10:185], j=[100:115:330])
    translate([i, -18, j])
    rotate([90, 0, 90]) clip();
    stand();
}
} else
    if(part == "stand")
        stand();
    else if(part == "clip")
        //for(i=[10:19:190], j=[1:13:30])
        //translate([i, j, 2-tol])
        clip();
    else
        mirror([1, 0, 0]) rotate(90) backplane();
