// auto-rewind spool holder for dry-box
// Copyright (C) 2023-2024  Robert Schiele <rschiele@gmail.com>
//
// This work is licensed under the Creative Commons Attribution 4.0
// International License. To view a copy of this license, visit 
// http://creativecommons.org/licenses/by/4.0/.
//
// This was inspired by the idea of
// https://www.printables.com/model/292276

// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;
eps=1/128;

spooldia = 200;
cyldia = 40;
cylspan = 205;
axledia = 7.35;
axlecut = 2.35;
separateaxle = false;
wall = 5;
tol = 0.1;
print = "single"; // ["no", "single", "left", "middle", "right"]
numspools = 5; // [1:10]

maxang = asin((cyldia/2-3/2*wall)/(cyldia/2+3/2*wall));

module axleprofile(d=axledia, o=0)
    intersection() {
        circle(d=d);
        translate([0,d/2-axlecut])
            square(d, center=true);
    }

module liftprof()
    polygon([
        [0,wall-eps-50],
        [0,2*wall-50],
        [wall/2,2*wall-50],
        [3/2*wall,wall-50],
        [3/2*wall,wall-eps-50],
    ]);
    
module prof() difference() {
    union() {
        translate([0, -cyldia+2*wall]) {
            circle(d=cyldia-3*wall);
            square(cyldia/2-3/2*wall);
        }
        translate([0, -cyldia-wall/2])
            rotate(90) square([30,
                (cyldia/2+3/2*wall)*sin(45)]);
    }
    circle(d=cyldia+3*wall);
}

module con(male)
        for(i=[0,1]) mirror([i, 0, 0])
            translate([cylspan/2-
                       (cyldia/2+3/2*wall)*sin(45)/2,
                       -cyldia-wall-1,
                       (male?1:-1)*(50-wall/2)])
            rotate([-90, 0, 0]) difference() {
                translate([0, 0, 3+2+(16-3)/2])
                    linear_extrude(4, center=true)                hull() {
                        translate([0, -17.5])
                            circle(d=14);
                        translate([0, male?0:-7])
                            square(14, center=true);
                    }
                translate([0, -17.5, 0])
                    cylinder(3+2+16+3, d=3);
            }

module concut()
    translate([cylspan/2-
               (cyldia/2+3/2*wall)*sin(45)/2,
               -cyldia-wall-1, 50-wall/2])
        rotate([-90, 0, 0]) {
            translate([0, 17.5, 0]) {
                for(j=[6,14.5])
                translate([0, 0, j])
                    linear_extrude(2.5)
                        for(i=[5, 9]) difference() {
                            circle(d=i+0.2);
                            circle(d=i);
                        }
                cylinder(3+2+16+3, d=3);
                cylinder(3+2, d=6);
                translate([0, 0, 3+2+16-3])
                    cylinder(2+1+4, d=6.24, $fn=6);
            }
            translate([0, 0, 3+2+(16-3)/2])
                cube([14+2*tol, 2*(14+8)+5, 4+2*tol],
                     center=true);
        }


module element(back, male, conmale, print=true) {
    for(i=[0,1]) mirror([i, 0, 0]) difference() {
    translate([cylspan/2, 0, 0]) {
    translate([0, 0, -95/2])
        linear_extrude(wall/(back?1:2), center=back,
                       convexity=2) difference() {
            hull() for(x=[0,-1], y=[0, 2*wall-cyldia])
                translate([x*cylspan/2, y])
                    circle(d=cyldia);
            hull() for(x=[0,-1], y=[0, 2*wall-cyldia])
                translate([x*
                    (cylspan/2)-cyldia-2*wall, y])
                    circle(d=cyldia-2*wall);
        }
        if(male)
            %cylinder(85, d=cyldia, center=true);
        translate([0, 0, -95/2])
            cylinder(wall, d1=11+2*wall, d2=11);
        rotate(180-maxang)
            rotate_extrude(angle=45+maxang)
                translate([cyldia/2+3/2*wall, 0])
                    liftprof();
        rotate(180-maxang)
            translate([cyldia/2+3/2*wall, 0])
                rotate_extrude() liftprof();
        rotate(maxang-90)
            translate([cyldia/2+3/2*wall, 0])
                rotate_extrude() liftprof();
        rotate(-maxang)
            rotate_extrude(angle=90+2*maxang)
                translate([-cyldia/2-3/2*wall, 0])
                    liftprof();
        translate([0, -cyldia+2*wall])
            rotate(-90) rotate_extrude(angle=90)
                translate([cyldia/2-3/2*wall, 0])
                    liftprof();
        translate([cyldia/2-3/2*wall,
                   -cyldia+5/2*wall+
                   (cyldia/2+3/2*wall)*
                   (1-cos(maxang))])
            rotate([90,0,0])
                linear_extrude((cyldia/2+3/2*wall)*
                    (1-cos(maxang))+wall/2)
                    liftprof();
        rotate([90,0,180+45])
            translate([cyldia/2+3/2*wall, 0])
            rotate([0, -45, 0])
            translate([0, 0,
                      -(cyldia/2+3/2*wall)*(1-cos(45))
                      -cyldia/2+wall]) 
            linear_extrude((cyldia/2+3/2*wall)*
                           (1-cos(45))+cyldia/2-wall)
                liftprof();
        translate([0, -cyldia-wall/2])
            rotate([90,0,-90])
                linear_extrude((cyldia/2+3/2*wall)*
                               sin(45))
                    liftprof();
        translate([-(cyldia/2+3/2*wall)*
                   sin(45), -cyldia-1/2*wall])
            rotate_extrude() liftprof();
        if(male) {
            difference() {
                linear_extrude(90, center=true,
                               convexity=2)
                offset(r=wall/2) prof();
                if(i==0) translate([0, -30-1/4*wall, 0])
                    rotate([0, 90, 0])
                        rotate_extrude()
                            difference() {
                                translate([0, -25])
                                    square([20, 50]);
                                translate([cyldia/2+9/4*wall,0])
                                    circle(d=cyldia+4*wall);
                            }
            }
        }
        if(male && !(separateaxle && print)) {
            linear_extrude(93, center=true)
                axleprofile();
        }
    }
    if(male && !conmale) concut();
    translate([cylspan/2, 0, 0]) {
        if(!male)
            linear_extrude(90, center=true,
                           convexity=2)
                offset(r=wall/2+tol) prof();
        if(separateaxle && print || !male)
            linear_extrude(93, center=true)
                offset(r=tol) axleprofile();
    }
    if(!back) {
        mirror([0, 0, 1]) concut();
        translate([cylspan/2, 0, wall/2-50])
            rotate(180-maxang)
                translate([cyldia/2+3/2*wall, 0])
                    cylinder(10, d=wall, center=true);
    }
    }
    if(!back && print) translate([0, 0, -95/2])
        cylinder(9, d=wall);
    if(male && separateaxle && print) for(i=[-15, -30])
        translate([0, i, axlecut-(back?100/2:95/2)])
            rotate([90, 0, 90])
                linear_extrude(93, center=true)
                    axleprofile();
    if(conmale) con(male);
}

if(print != "no") {
    if(print == "left") translate([0, 0, 100/2])
        element(true, true, true);
    if(print == "middle") translate([0, 0, 95/2])
        element(false, true, true);
    if(print == "right" || print == "single")
        translate([0, 0, 100/2]) mirror([1, 0, 0])
            element(true, true, false);
    if(print != "single") translate([0, 71, 95/2])
        element(false, false);
    if(print == "single") translate([0, 71, 100/2])
        element(true, false, true);
} else rotate([90, 0, 0]) {
    if(numspools > 1) {
        for(i=[0:1:numspools-1])
            translate([0,0,i*95]) {
                element(i == 0, i < numspools-1,
                        i < numspools-1, print=false);
                mirror([0, 0, 1])
                    element(i == numspools-1,
                            i == numspools-1, false,
                            print=false);
        }
    } else {
        element(true, true, false, print=false);
        translate([0,0,0]) mirror([0, 0, 1])
            element(true, false, true, print=false);
    }
}