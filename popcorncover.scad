include <utils.scad>

$fn = 100;
ch = 0.25;

translate([0,-55,0])
    chamferedcylinder(1, r=10, chamfer=ch);
translate([0,-50-ch,0.5])
    chamferedcube([20,10+ch,1], center=true, chamfer=ch);

intersection() {
    translate([0, 0, 0.5])
    hexgrid([85,85,1], center=true, width=1, chamfer=ch, hexsize=6);
    union() {
        linear_extrude(1)
            circle(d=85);
        translate([-85/2,0,0])
            linear_extrude(1)
                square([85, 85/2]);
    }
}

difference() {
    union() {
        chamferedcylinder(1, r=95/2, chamfer=ch);
        translate([-95/2, -ch, 0])
            chamferedcube([95, 95/2+ch, 1], chamfer=ch);
        chamferedcylinder(5, r=85/2, chamfer=ch);
        translate([-85/2, -ch, 0])
            chamferedcube([85, 85/2+ch, 5], chamfer=ch);
        translate([-85/2, 85/2-1, 4])
            chamferedcube([85, 6, 1], chamfer=ch);
    };
    union() {
        translate([0,0,-eps])
            chamferedcylinder(5+2*eps, r=83/2, chamfer=-ch-eps);
        translate([-83/2,0,-eps])
            cube([83, 83/2, 5+2*eps]);
        translate([-83/2-ch,-ch,5-ch])
            chamferedcube([83+2*ch, 83/2+2*ch, 2*ch], chamfer=ch);
        translate([-83/2-ch,-ch,-ch])
            chamferedcube([83+2*ch, 83/2+2*ch, 2*ch], chamfer=ch);
    };
};

translate([-95/2, 85/2+5, 0])
rotate([90,0,90])
linear_extrude(95)
polygon([[1,0],[1,1],[0,4],[-ch,4],[-ch,4.2],[1,4.2],[1,4],[2,1],[2,0]]);
