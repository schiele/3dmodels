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

$vpt = [-1,0,-18];

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

module lip(w, dv, dh) {
    vr = dv/2+w^2/8/dv;
    intersection() {
        union() {
            translate([0,0,latch])
                intersection() {
                    rotate([0,90,0])
                        linear_extrude(th+dep)
                            translate([-vr, 0])
                                difference() {
                                    circle(vr);
                                    circle(vr-snap);
                                }
                    if(dh == 0)
                        translate([0, -w/2, 0])
                            cube([th+dep, w, snap]);
                    else {
                        hr = dh/2+w^2/8/dh;
                        linear_extrude(snap+dh)
                            translate([hr, 0])
                                circle(hr);
                    }
                }
            linear_extrude(latch+snap-1+dv)
                polygon([
                    [dep,-w/2],
                    [-2*th,-w/2-2*th-dep],
                    [th+dep,-w/2-2*th-dep],
                    [th+dep,-w/2],
                    [th+dep,w/2],
                    [th+dep,w/2+2*th+dep],
                    [-2*th,w/2+2*th+dep],
                    [dep,w/2],
                ]);
            for(i=[-1,1])
                translate([dh,0,0]) rotate([90,0,90])
                    linear_extrude(th+dep-dh)
                        polygon([
                            [i*w/2,latch+snap-1+dv],
                            [i*w/2,latch+dv],
                            [i*(w/2+latch+dv),0],
                            [i*(w/2+latch+dv),latch+snap-1+dv],
                        ]);
        }
        translate([-2*th,0,0])
            rotate([90,0,90])
                linear_extrude(3*th+dep)
                    polygon([
                        [-w/2-2*th-dep,latch+snap-1+dv-2*th-dep],
                        [0,latch+snap-1+dv+w/2],
                        [w/2+2*th+dep,latch+snap-1+dv-2*th-dep],
                    ]);
    }
}

intersection() {
    translate([12,0,0])
        lip(llw, lldv, lldh);
    translate([-1,0,5])
        cube([34,20,10], center=true);
}
translate([-14,0,0])
    rotate([0,0,180])
        lip(lsw, lsdv, lsdh);
translate([-1,0,-1])
    cube([34,20,2], center=true);
translate([10,0,-15.5])
    cube([2,20,31], center=true);
translate([15,0,-11])
    cube([2,20,22], center=true);

for(i=[-11,-31])
    translate([0,0,i])
        rotate([90,0,180])
            wall(20, 18, anglestart=60, angleend=300);
