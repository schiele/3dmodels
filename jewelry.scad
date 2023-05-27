// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

tol=0.1;
part="stand"; // ["stand", "backplane", "clip"]
width = 210; // [180:10:210]
standheight = 100; // [100:10:170]
backplaneheight = 240; // [170:10:240]

module backplane() for(e=[2, 4]) linear_extrude(e) difference() {
    union() {
        hull() for(i=[10, width-10]) {
            translate([i, backplaneheight]) circle(r=10);
            translate([i, 20]) square(20, center=true);
        }
        if(e==2) translate([10, 0]) square([width-20,10]);
    }
    for(k=[30, backplaneheight/2+25]) hull()
        for(i=[20, width-20], j=[0, (backplaneheight-70)/2])
            translate([i, j+k]) circle(r=10);
    if(e==4) for(i=[25:10:width-25]) translate([i, 150])
        square([4, 300], center=true);
    for(i=[25:10:width-25], j=[10, 20, backplaneheight/2+5,
        backplaneheight/2+15, backplaneheight, backplaneheight+10])
        translate([i, j]) square(4, center=true);
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
    polygon([[0, 0], [108, 0], [108, 11], [6, standheight], [0, standheight]]);

module stand() difference() {
    union() {
        for(i=[2, width]) translate([i, 0, 0]) rotate([90, 0, -90])
            linear_extrude(2) difference() {
                sideprof();
                //offset(r=-11) sideprof();
            }
        mirror([0, 1, 0]) {
            cube([width, 108, 1]);
            translate([0, 106, 0]) cube([width, 2, 11]);
        }
        rotate([90, 0, 0]) linear_extrude(6, convexity=10)
            difference() {
                square([width, standheight]);
                for(i=[width/2-20*10:20:width/2+20*10],
                    j=[11:20:standheight-25])
                translate([i, j]) rotate(45) square(12.5);
                for(i=[width/2-20*10-10:20:width/2+20*10+10],
                    j=[21:20:standheight-25])
                translate([i, j]) rotate(45) square(12.5);
        }
    }
    translate([width/2, -3, standheight])
        cube([width-20+2*tol, 2+2*tol, 20], center=true);
}

if($preview) {
    color("white") 
    translate([0, -2, standheight-10])
    rotate([90, 0, 0]) backplane();
    color("darkgrey") {
    for(i=[25:10:width-25], j=[standheight:(backplaneheight-10)/2:
        standheight+backplaneheight-10])
        translate([i, -18, j]) rotate([90, 0, 90]) clip();
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
