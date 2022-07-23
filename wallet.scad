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
        rotate_extrude(angle=360)
            translate([(diff+sd)/2,0])
                rotate(90)
                    circle(d=sd);
}

difference() {
    plate();
    cut();
    mirror([0,1,0]) cut();
}
