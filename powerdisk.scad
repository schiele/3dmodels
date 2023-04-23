// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

eps=1/128;

function solve(f, s, l=eps^2) =
    f(s) < l ? s : solve(f, s-f(s)*eps/(f(s+eps)-f(s)),l);

// tickness of cover base
base = 0.4; // [0.1:0.1:2]
// extrusion height of font
fontext = 0.4; // [0:0.1:2]
// tickness of lid
lid = 1;
// width of rim
rim = 4.7;
// thickness of walls
th = 1;
// size of clip
clip = 2;
// diameter of disk
d = 153;
d1 = 24;
r1 = 20;
d2 = 16;
r2 = -52;
d4 = 128.5;
// tolerance
tol = 0.1; // [0:0.05:0.5]
c1 = [(d-d1)/2*cos(r1)+(d2+d1)/2*cos(r2),
      (d-d1)/2*sin(r1)+(d2+d1)/2*sin(r2)];
function c2(d3) = [(d4+d3)/2, 0];
function c3(d3) = c2(d3)-c1;
function r3(d3) = let(c3=c3(d3)) atan(c3.y/c3.x);
delta = function(d3)
    c2(d3).x-cos(r3(d3))*(d3/2) - (c1.x-cos(r3(d3))*(d2/2));
d3 = solve(delta, 50);

module profile(r, x=0, c=true)
    mirror([r>=0?0:1, 0]) translate([r, 0]) polygon([
        [th+tol, -base],
        [r>0?-r:-x, -base],
        [r>0?-r:-x, 0],
        [-th-rim-tol, 0],
        [-th-rim-tol, c?(lid+clip):0],
        [-rim-tol, c?(lid+clip):0],
        [-rim-tol, 0],
        [tol, 0],
        [tol, lid],
        [max(-clip/2, -r*sign(r))+tol, lid+clip/2],
        [tol, lid+clip],
        [th+tol, lid+clip],
    ]);

module linprofile(l, r=0, x=0, c=true)
    rotate([90, 0, 180]) linear_extrude(l+2*eps)
        profile(r, x, c);

module rotprofile(s, e, r, x=0, c=true)
    let(a=e-s, fix=a>0?eps:-eps) rotate(s-fix)
        rotate_extrude(angle=a+2*fix) profile(r, x, c);

if(1) rotate(-90) {
    difference() {
        rotprofile(r1+50.5, 180-r1, d/2);
        translate([-28.8, 64.5, eps])
            cube([th+2*tol, 2, lid+clip]);
    }
    rotprofile(r1, r1+50.5, d/2, c=false);
    rotprofile(-180+r1, -r1-19.2, d/2);
    rotprofile(-r1-19.2, -r1, d/2, c=false);
    for(i=[-1,1]) rotate(i*r1) translate([(d-d1)/2, 0])
        rotprofile(0, i*(r2-r1), d1/2, c=false);
    for(i=[-1,1]) rotate(180+i*r1) translate([(d-d1)/2, 0])
        rotprofile(0, i*(r2-r1), d1/2);
    for(i=[-1,1]) rotate(i*r1) translate([(d-d1)/2, 0])
        rotate(i*(r2-r1)) translate([(d1+d2)/2, 0])
            rotprofile(i*180, i*(180+r3(d3)-r2), -d2/2, d4/2,
                       c=false);
    for(i=[-1,1]) rotate(180+i*r1) translate([(d-d1)/2, 0])
        rotate(i*(r2-r1)) translate([(d1+d2)/2, 0])
            rotprofile(i*180, i*(180+r3(d3)-r2), -d2/2, d4/2);
    translate(c2(d3))
        rotprofile(180-r3(d3), 180+r3(d3), -d3/2, d4/2, c=false);
    rotate(180) translate(c2(d3))
        rotprofile(180-r3(d3), 180+r3(d3), -d3/2, d4/2);
    translate([d4/2, -37/2, 0]) linprofile(37, 24, c=false);
    for(i=[-1,1]) translate([d4/2-24, i*37/2, 0])
        rotprofile(180, 180-i*30, 0, c=false);
    for(i=[0,1]) mirror([0, i, 0]) translate([d4/2, 37/2, 0])
        translate([-24, 0, 0]) rotate([0, 0, -30])
            translate([2, 0, 0]) linprofile(24.9+i*6, 2, c=false);
    rotate(180+52.7) translate([12.7-d/2, -19, -eps])
        cube([th, 36.5, lid+clip+eps]);
    translate([22.95, 61.49, -eps]) cube([th, 6.1, lid+clip+eps]);
    translate([0, 0, -eps]) linear_extrude(lid+clip+eps)
        difference() {
            circle(d=23.7+2*th+2*tol);
            circle(d=23.7+2*tol);
        }
    color("black") linear_extrude(fontext, center=true)
        mirror([0, 1, 0]) rotate(90) {
            translate([-32, 38]) text("Power", 18);
            translate([-32, 18]) text("Disk", 18);
            translate([4, -34])
                text("ReCover", 18, halign="center");
        }
    }
else
    profile(10);
