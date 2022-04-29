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
ntubes = 2;
tube = 18;
tubegap = 120;
width = 20;
holder = 20;
holdergap = 3;

$vpt = [-12,0,-18];

eps = 1/128;
// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

module lip(w, dv, dh) {
    intersection() {
        union() {
            translate([0,0,latch])
                intersection() {
                    vr = dv/2+w^2/8/dv;
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
        rotate([0,90,0])
        cylinder(3*th+dep, r=latch+snap-1+dv+w/2, $fn=4);
    }
}

intersection() {
    union() {
        translate([1,0,0])
            lip(llw, lldv, lldh);
        translate([-25,0,0]) rotate([0,0,180])
            lip(lsw, lsdv, lsdh);
    }
    translate([-12,0,5])
        cube([34,width,10], center=true);
}

rotate([90,0,0])
linear_extrude(width, center=true) {
    polygon([
        [holdergap+th-34,0],
        [holdergap+th-34,-th],
        [-th,-th],
        [-th,-(ntubes-1/2)*(tube+th)-th/2],
        [0,-(ntubes-1/2)*(tube+th)-th/2],
        [0,-th],
        [holdergap,-th],
        [holdergap,-th-holder],
        [holdergap+th,-th-holder],
        [holdergap+th,0],
    ]);
    for(i=[1:ntubes])
        translate([-tube/2-th,(1/2-i)*(tube+th)-th/2]) {
            for(i=[-120,120])
                rotate([0,0,i])
                translate([tube/2 + th/2,0])
                circle(d=th);
            difference() {
                circle(d=tube+2*th);
                circle(d=tube);
                translate([-tube/2-2*th,0])
                    circle(d=tube+4*th, $fn=6);
            }
        }
}

%for(i=[1:ntubes])
    translate([-tube/2-th,0,(1/2-i)*(tube+th)-th/2])
    rotate([90,0,0])
    cylinder(2*width, d=tube, center=true);
