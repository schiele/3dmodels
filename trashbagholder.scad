// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

th=5;
wi=150;
wh=91;
wt=16.5;
bd=16.5;
bw=40.5;
bh=51.5;

module quart(r) intersection() {
    circle(r=r);
    square(r);
}

module half(r) intersection() {
    circle(r=r);
    translate([-r, 0]) square(2*r);
}

module base() difference() {
    union() {
        translate([-wt, 0]) hull() {
            translate([0, wh]) rotate(90) quart(th);
            translate([-th/2, th/2]) circle(d=th);
        }
        translate([0, wh]) hull() {
            translate([-wt, 0]) rotate(90) quart(th);
            quart(th);
        }
        hull() {
            translate([0, wh]) quart(th);
            translate([th/2, th/2]) circle(d=th);
        }
        hull() {
            translate([bw-bd*3/2, wh-bd/2-bh]) circle(d=bd);
            translate([th/2, th/2]) circle(d=th);
            translate([0, wh-bd/2-bh]) square(bd/2+th);
        }
        translate([0, wh]) hull() {
            translate([th/2, -bd/2-bh+th/2]) circle(d=th);
            translate([60, -bd/2-bh+th/2]) circle(d=th);
            translate([wi-th, -th]) circle(d=th);
            translate([th/2, -th]) circle(d=th);
        }
        translate([0, wh]) hull() {
            translate([bw+bd/2, -bd/2-bh]) circle(d=bd);
            translate([wi-bd/2-th, -th/2])
                rotate(-90) quart(bd/2+th);
        }
        hull() for(i=[th*5/2, wi-th*5/2])
            translate([i, wh+th/2]) circle(d=th);
        hull() for(i=[-th/2, th/2])
            translate([wi-th/2, wh+i]) circle(d=th);
        translate([th+bd/2, wh+th-bd]) square([wi-2*th-bd, bd]);
    }
    for(i=[bd/2+th,wi-bd/2-th]) translate([i, wh-th/2])
        hull() {
            rotate(180) half(bd/2);
            for(j=[-1, 1]) translate([j*(bd/2-th/2), 0])
                circle(d=th);
        }
    translate([bw-bd/2, wh-bd/2-bh]) circle(d=bd);
}

linear_extrude(15) difference() {
    base();
    offset(r=th/2) offset(r=-3/2*th) base();
}
