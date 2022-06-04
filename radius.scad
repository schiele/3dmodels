/* [Rendering Precision] */
// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

module txt(i, a, t)
    rotate([0,0,a])
        translate([i+5,0,2])
            rotate([0,0,-90])
                linear_extrude(0.8, center=true)
                    text(str(t), size=8,
                         valign="center",
                         halign="center");

module rads(st)
for(i=[st:20:205])
    difference() {
        rotate_extrude(angle=45)
            translate([i,0])
                square([10,2]);
        if(i%10)
            txt(i, 45/2, i/10+0.5);
        else {
            txt(i, 35, i/10);
            txt(i, 10, i/10+1);
        }
    }

module radpat(st) {
    translate([2,0,0]) rads(st);
    rotate([0,0,45]) rads(st+10);
}

module case() {
    rotate_extrude(angle=45)
        square([10,2]);
    for(i=[55,105,155])
    rotate_extrude(angle=45)
        translate([i,0])
            square([10,2]);
    rotate_extrude(angle=45)
        translate([205,0])
            square([15,2]);
    rotate([0,0,45]) cube([220,2,8.2]);
    translate([0,-2,0]) cube([220,2,8.2]);
    translate([8,0,0]) cube([210,10,2]);
    rotate([0,0,45])
        translate([8,-10,0]) cube([210,10,2]);
    rotate([90,0,90])
        linear_extrude(220)
            polygon([[0,6.2], [2,8.2], [0,8.2]]);
    rotate([90,0,135])
        linear_extrude(220)
            polygon([[0,6.2], [-2,8.2], [0,8.2]]);
    rotate_extrude(angle=-315)
        square([2,8.2]);
    difference() {
        translate([0,0,2])
            rotate_extrude(angle=45)
                translate([210.2,0])
                    square([9.8,2]);
        for(i=[1,3])
            translate([0,0,8])
                rotate([45,0,i*45/4])
                    translate([217.5,0,0])
                        cube(30, center=true);
    }
    intersection() {
        translate([0,0,4])
            rotate_extrude(angle=45)
                translate([215.2,0])
                    square([4.8,4.2]);
        rotate([45,0,45/2])
            translate([217.5,0,0])
                cube(30, center=true);
    }
    if(0) %union() {
        translate([0,0,2]) {
            rads(0);
            rads(10);
        }
        translate([0,0,4]) {
            rads(5);
            rads(15);
        }
    }
}

//radpat(0);
//radpat(5);
case();