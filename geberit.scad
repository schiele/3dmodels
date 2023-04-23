// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

eps=1/128;

cut=true;
slot=true;

module board() {
difference() {
    union() {
        linear_extrude(2, convexity=10) difference() {
            polygon([
                [-285/2, 0],
                [-10-35/2+22/2, 0],
                [-10-35/2+22/2, 2],
                [-35/2+22/2, 2],
                [-35/2+22/2, -2],
                [35/2+22/2, -2],
                [35/2+22/2, 2],
                [10+35/2+22/2, 2],
                [10+35/2+22/2, 0],
                [285/2, 0],
                [275/2, 135],
                [144/2, 135],
                [144/2, 136],
                [144/2-2.1, 136],
                [144/2-2.1, 135],
                [-144/2+2.1, 135],
                [-144/2+2.1, 136],
                [-144/2, 136],
                [-144/2, 135],
                [-275/2, 135]
            ]);
            for(j=[0, 1]) mirror([j, 0]) {
                translate([269/2+12/2, 10.5-12/2]) {
                    for(i=[0, 180]) rotate(i) square(12/2);
                    circle(d=12);
                }
                translate([260/2+12/2, 135-(10.5-12/2)]) {
                    for(i=[90, 270]) rotate(i) square(12/2);
                    circle(d=12);
                }
                translate([251/2+18/2, 59.5+18/2]) {
                    translate([0, -18/2]) square(18);
                    circle(d=18);
                }
                translate([251/2+18/2-18/2-7/2-10, 59.5+18/2])
                    circle(d=7.3);
                for(i=[144/2+2.8/2, 176/2-2.8/2])
                    translate([i, 135+2.8/2-16]) {
                        translate([-2.8/2, 0]) square([2.8, 20]);
                        circle(d=2.8);
                    }
                translate([160/2, 135+15/2-1.75-10/2])
                    square(15, center=true);
            }
            difference() {
                translate([0, 101+35.7/2]) circle(d=35.7);
                translate([-20, 135-3]) square(40);
            }
            for(i=[-20/2-32/2-24/2, 20/2+32/2-24/2])
                translate([i, 20/2+25.4]) circle(d=20);
        }
        linear_extrude(7, convexity=10) {
            for(j=[0, 1]) mirror([j, 0]) {
                translate([273.5/2-28/2, 28/2+3]) intersection() {
                    difference() { circle(d=28); circle(d=24); }
                    rotate(-90) square(28/2);
                }
                translate([273.5/2-2, 28/2+3]) square([2, 32-28/2]);
            }
            translate([-5-35/2+22/2-37, 0]) {
                for(j=[0, 1]) mirror([j, 0])
                    translate([12/2+8/2, 8/2+3]) intersection() {
                        difference() { circle(d=8); circle(d=4); }
                        rotate(180) square(8/2);
                    }
                translate([0, 1+3+2]) square([12+4, 2], center=true);
            }
            translate([-273.5/2+28/2, 3]) square([64.25, 2]);
            translate([-273.5/2+28/2+64.25+12+8, 3])
                square([161.25, 2]);
        }
        linear_extrude(5, convexity=10) {
            difference() {
                for(j=[0, 1]) mirror([j, 0]) hull() {
                    translate([245/2, 8.5]) circle(d=2);
                    translate([-245/2, 135-7]) circle(d=2);
                }
                translate([-95.5/2-26/2, 0]) square([95.5, 135-60.5]);
            }
            if(cut) translate([-110, 22-15/2-10])
                square([20,15+114.5-22+10]);
        }
        for(j=[0, 1]) mirror([j, 0])
            translate([160/2, 0, 0]) rotate([0, -90, 0]) {
                linear_extrude(16-2.8*2, center=true) {
                    translate([10/2,135-10/2-1.75]) intersection() {
                        difference() {
                            union() {
                                circle(d=10);
                                rotate(90+45) square(10/2);
                            }
                            circle(d=6);
                        }
                        rotate(90) square(10/2);
                    }
                    translate([10/2,135-10/2-1.75]) polygon([
                        [0,3],
                        [0,5],
                        [2.2,5],
                        [2.2,5+1.75],
                        [2.25,5+1.75],
                        [6,3],
                    ]);
                }
                linear_extrude(2, center=true) {
                    translate([10/2,135-10/2-1.75]) polygon([
                        [-3,1],
                        [-3,3],
                        [6,3],
                        [8,1],
                    ]);
                }
            }
    }
    for(i=[-20/2-32/2-24/2, 20/2+32/2-24/2])
        translate([i, 20/2+25.4, 1]) cylinder(2, d=34);
    if(slot) translate([95, 45, 0]) rotate([45, 0, 0])
        cube([42, 42, 80], center=true);
}

if(slot) translate([95, 45, 0]) intersection() {
    rotate([45, 0, 0]) translate([0, 0, -22])
        linear_extrude(90, convexity=2) difference() {
            square(44, center=true);
            square(40, center=true);
        }
    translate([0, 0, 100]) cube(200, center=true);
}
}

module cutter(tol=0) difference() {
    translate([-100, -72, -1]) cube([250, 210, 210]);
            for(i=[22:(114.5-22)/3:114.5])
                translate([-100, i, 5/2]) rotate([0, 90, 0]) cylinder(16-tol*2, d=5*sqrt(2), center=true);

}

//%cutter();

if(cut) {
    intersection() {
        board();
        cutter();
    }
    translate([40, 88, 0]) rotate(90) difference() {
        board();
        cutter(0.2);
    }
} else board();