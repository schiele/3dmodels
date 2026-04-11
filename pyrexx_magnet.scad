// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

module plateprofile() {
    offset(r=0.1) {
        square([62, 52], center=true);
        difference() {
            offset(2.5) square([73, 3], center=true);
            for(i=[-1, 1]) translate([35, 0]*i) circle(d=4.9);
        }
    }
    for(i=[0, 1], j=[0, 1]) mirror([i, 0]) mirror([0, j]) translate([62, 52]/2) circle($fn=4);
}

//#plateprofile();

module dummy() difference() {
    cylinder(5, d1=105, d2=115);
    linear_extrude(30, center=true) square([60, 50], center=true);
    translate([0, 0, 3.5]) linear_extrude(10, convexity=3) plateprofile();
}

latches = [0, 107, 220];

difference() {
    // base
    rotate_extrude() polygon([
        [0, 0],
        [53.5+0.25, 0],
        [57+0.25, 3.5],
        [57.25+0.25, 14.5],
        [55.75+0.25, 14.5],
        [54.5+0.5, 9],
        [54.5+0.5, 5],
        [0, 5],
    ]);
    // magnet cutout
    linear_extrude(30, center=true) square([60, 50], center=true);
    // plate cutout
    translate([0, 0, 3.5]) linear_extrude(10, convexity=3) plateprofile();
    // latch cutouts
    for(a=latches) rotate(a)
    rotate_extrude(angle=23) polygon([
        [56+0.25, 5],
        [56+0.25, 15],
        [54, 15],
        [54, 5],
    ]);
    // snap cutout
    rotate(270) {
        for(i=[0, 1]) mirror([0, i, 0])
            translate([32, 2.5, -1]) cube([30, 0.5, 7]);
        translate([32, -3, 5]) cube([30, 6, 1.5]);
        rotate([90, 0, 0]) linear_extrude(6, center=true) polygon([
            [32, 3.5],
            [32, -1],
            [33, -1],
            [33, 1],
            [36.9, 3.2],
            [36.9, 3.5],
            [37.3, 3.5],
            [37.3, 3.2],
            [39.15, 1],
            [39.15, -1],
            [40.15, -1],
            [40.15, 1],
            [42, 3.2],
            [42, 3.5],
            [42.4, 3.5],
            [42.4, 3.2],
            [46.3, 1],
            [46.3, -1],
            [47.3, -1],
            [47.3, 3.5],
        ]);
        translate([57, 0, 14.5]) cube([1, 1, 10], center=true);
    }
}
for(a=latches) rotate(a) {
    // latch side limit
    rotate_extrude(angle=-1.5) polygon([
        [57, 9],
        [57.25, 14.5],
        [54.75, 14.5],
        [54.75, 9],
    ]);
    // latch top limit
    rotate_extrude(angle=10) polygon([
        [57, 13],
        [57.25, 14.5],
        [54.75, 14.5],
        [54.75, 13],
    ]);
    // support back
    rotate(0.5) rotate_extrude(angle=9.1) polygon([
        [55.25, 5],
        [55.25, 14.5],
        [54.75, 14.5],
        [54.75, 5],
    ]);
    // support sides
    for(r=[0.5, 9.5]) rotate(r) rotate_extrude(angle=0.5) polygon([
        [55.25, 4],
        [55.25, 13],
        [53.75, 13],
        [50.75, 4],
    ]);
}
rotate(295) {
    // switch base
    rotate_extrude(angle=15) polygon([
        [57+0.25, 3.5],
        [57.25+0.25, 14.5],
        [53.75+0.25, 14.5],
        [53.75+0.25, 16.5],
        [49.75+0.25, 16.5],
        [49.75+0.25, 3.5],
    ]);
    // switch sides
    for(a=[0, 12]) rotate(a)
    rotate_extrude(angle=3) polygon([
        [53.75+0.25, 14],
        [53.75+0.25, 21.5],
        [52.75+0.25, 21.5],
        [52.75+0.25, 20.5],
        [50.95+0.25, 20.5],
        [50.95+0.25, 21.5],
        [49.75+0.25, 21.5],
        [49.75+0.25, 14],
    ]);
}
    // snap
    rotate(270) {
        rotate([90, 0, 0]) linear_extrude(5, center=true) polygon([
            [47.3+0.25, 4],
            [47.3+0.25, 6.5],
            [48.5+0.25, 6.5],
            [48.5+0.25, 4],
        ]);
        for(i=[0, 1]) mirror([0, i, 0])
        translate([0, 2.5, 0]) rotate([90, 0, 0]) linear_extrude(1) polygon([
            [47.3+0.25, 4],
            [47.3+0.25, 6.5],
            [49.5+0.25, 6.5],
            [51+0.25, 5],
        ]);
    }