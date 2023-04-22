/* [Settings] */
// string diameter - diameter of the string (hair-band) attached
sd = 3; // [1:0.1:6]
// extra thickness below the carve-out for the string
base = 1; // [0.2:0.1:3]
// inner diameter of the carve-out for the string
diff = 20; // [1:1:45]
/* [Technical Specs] */
// card dimensions (width, height, thickness, radius)
card = [85.60, 53.98, 0.76, 3.18];
/* [Rendering Precision] */
// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;
eps=1/128;

platesz = base+sd/2*(1+sqrt(2)/2);

module plate() {
    intersection() {
        minkowski() {
            cube([card.x-2*card[3],card.y-2*card[3],
                  2*platesz-2*card[3]], center=true);
            sphere(card[3]);
        }
        translate([0, 0, platesz])
            cube([card.x, card.y, 2*platesz], center=true);
    }
}

module cut() {
    for(i=[-1,1])
        translate([i*(diff+sd)/2,-card.y/2+base,0])
        rotate([90,0,-90])
            rotate_extrude(angle=90)
                translate([sd/2+base,0])
                    circle(d=sd);
    translate([0,-card.y/2+base,sd/2+base])
        rotate_extrude()
            translate([(diff+sd)/2,0])
                circle(d=sd);
}

module wallet() {
    difference() {
        plate();
        cut();
        mirror([0,1,0]) cut();
        drawercut();
        mirror([1,0,0]) drawercut();
    }
}

module rectcut(a) {
    for(i=[0,a], j=[0,a])
        translate([i,j,0])
            cylinder(base+eps, base, 0);
    polyhedron([
        [ -base,0     ,0       ],
        [0     , -base,0       ],
        [a     , -base,0       ],
        [a+base,0     ,0       ],
        [a+base,a     ,0       ],
        [a     ,a+base,0       ],
        [0     ,a+base,0       ],
        [ -base,a     ,0       ],
        [0     ,0     ,base+eps],
        [a     ,0     ,base+eps],
        [a     ,a     ,base+eps],
        [0     ,a     ,base+eps],
    ], [
        [ 0, 1, 2, 3, 4, 5, 6, 7],
        [ 1, 0, 8],
        [ 3, 2, 9],
        [ 5, 4,10],
        [ 7, 6,11],
        [ 2, 1, 8, 9],
        [ 4, 3, 9,10],
        [ 6, 5,10,11],
        [ 0, 7,11, 8],
        [11,10, 9, 8],
    ]);
}

module partcut(xpos, x, y) {
    difference() {
        translate([xpos, -y/2, base])
            cube([x+1, y, platesz-2*base+eps]);
        translate([xpos,0,platesz-2*base])
            rotate([90,0,0])
                cylinder(100,r=base,center=true);
        translate([xpos,0,platesz-3*base])
            cube([2,100,2], center=true);
    }
}

module drawercut() {
    drawerbase();
    partcut( 1, 22, 22);
    partcut(14, 25, 46);
}

module drawerbase(gap=0) {
    translate([0,0,platesz-base])
    difference() {
        union() {
            translate([ 2+gap, -22/2+gap, 0])
                rectcut(22-2*gap);
            translate([15+gap, -46/2+gap, 0])
                rectcut(46-2*gap);
        }
        translate([40-gap,-5-gap,0])
            rotate([0,30,0])
                cube([5, 10+2*gap, 5]);
    }
}

module drawer() {
    translate([50,0,base-platesz])
        intersection() {
            plate();
            drawerbase(gap=0.1);
        }
}

wallet();
drawer();
mirror([1,0,0]) drawer();
