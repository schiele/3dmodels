llw = 15;
lldv = 0.8;
lldh = 0.5;
lsw = 10;
lsdv = 0.2;
lsdh = 0;
dep = 2;
snap = 1.8;
latch = 3;
th = 2;

eps = 1/128;
// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

module wall(h, d, th=th, inner=false,
        anglestart=0, angleend=360,
        start=true, end=true, gapstart=0, gapend=0) {
    r = d/2 + (inner ? -1 : 1) * th/2;
    gapunit = asin(th/2/r);
    realgapstart = (gapstart + (start ? 1 : 0));
    realgapend = (gapend + (start ? 1 : 0));
    realanglestart = anglestart + realgapstart*gapunit;
    realangleend = angleend - realgapend * gapunit;

    if(start)
        rotate([0,0,realanglestart])
        translate([r,0,0])
        cylinder(h, d=th, center=true);

    rotate([0,0,realanglestart])
    rotate_extrude(angle=realangleend-realanglestart)
    translate([r,0,0])
    square([th,h], center=true);

    if(end)
        rotate([0,0,realangleend])
        translate([r,0,0])
        cylinder(h, d=th, center=true);
}

module lip(s, dv, dh) {
    vr = dv/2+s.y^2/8/dv;
    intersection() {
        union() {
            translate([0,0,latch])
                intersection() {
                    rotate([0,90,0])
                        linear_extrude(s.x)
                            translate([-vr, 0])
                                difference() {
                                    circle(vr);
                                    circle(vr-snap);
                                }
                    if(dh == 0)
                        translate([0, -s.y/2, 0])
                            cube([s.x, s.y, snap]);
                    else {
                        hr = dh/2+s.y^2/8/dh;
                        linear_extrude(snap+dh)
                            translate([hr, 0])
                                circle(hr);
                    }
                }
            linear_extrude(s.z)
                polygon([
                    [s.x-th,-s.y/2],
                    [-2*th,-s.y/2-s.x-th],
                    [s.x,-s.y/2-s.x-th],
                    [s.x,-s.y/2],
                    [s.x,s.y/2],
                    [s.x,s.y/2+s.x+th],
                    [-2*th,s.y/2+s.x+th],
                    [s.x-th,s.y/2],
                ]);
            translate([dh,0,0])
                rotate([90,0,90])
                    linear_extrude(s.x-dh)
                        polygon([
                            [-s.y/2,s.z],
                            [-s.y/2,latch+dv],
                            [-s.y/2-latch-dv,0],
                            [-s.y/2-latch-dv,s.z],
                        ]);
            translate([dh,0,0])
                rotate([90,0,90])
                    linear_extrude(s.x-dh)
                        polygon([
                            [s.y/2,s.z],
                            [s.y/2,latch+dv],
                            [s.y/2+latch+dv,0],
                            [s.y/2+latch+dv,s.z],
                        ]);
        }
        translate([-2*th,0,0])
            rotate([90,0,90])
                linear_extrude(s.x+2*th)
                    polygon([
                        [-s.y/2-s.x-th,s.z-s.x-th],
                        [0,s.z+s.y/2],
                        [s.y/2+s.x+th,s.z-s.x-th],
                    ]);
    }
}

intersection() {
    translate([12,0,0])
        lip([4,llw,latch+snap-1+lldv], lldv, lldh);
    translate([-1,0,5])
        cube([34,20,10], center=true);
}
translate([-14,0,0])
    rotate([0,0,180])
        lip([4,lsw,latch+snap-1+lsdv], lsdv, lsdh);
translate([-1,0,-1])
    cube([34,20,2], center=true);
translate([10,0,-15.5])
    cube([2,20,31], center=true);
translate([15,0,-11])
    cube([2,20,22], center=true);

translate([0,0,-11])
    rotate([90,0,180])
        wall(20, 18, anglestart=60, angleend=300);
translate([0,0,-31])
    rotate([90,0,180])
        wall(20, 18, anglestart=60, angleend=300);
