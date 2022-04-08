include <utils.scad>

$fn = 100;

sz = 65;
lh = 33;
uh = 10.4;
screwcase = 8;
thick = 1.6;
boardx = 60.2;
boardz = 1.6;
eps = 0.01;
inf = 100;
connx = 30.81;
conny = 12.55;
ch = 1;
fndep = 0.8;
numsize = 6;
fontsize = 4;
uselogos = 0;

module screwcut(l1, l2=0) {
    translate([0,0,-eps]) {
        cylinder(2.5+eps, r=3);
        cylinder(2.5+l1+2*eps, r=1.5);
    }
    if(l2)
        translate([0,0,2.5+l1-l2])
        cylinder(l2+eps, r=5.5/2*2/sqrt(3), $fn=6);
}

module connectorcut() {
    translate([0,0,7-0.9])
    cube([connx,conny,0.9+3]);
    translate([connx/2-24.99/2,conny/2,0])
    screwcut(10);
    translate([connx/2+24.99/2,conny/2,0])
    screwcut(10);
    translate([0,0,-eps])
    linear_extrude(7+eps)
    hull() {
        translate([connx/2-18/2+2.5,conny/2+10.2/2-2.5])
        circle(2.5);
        translate([connx/2+18/2-2.5,conny/2+10.2/2-2.5])
        circle(2.5);
        translate([connx/2-18/2+2.5+tan(10)*(10.2-2.5*2),conny/2-10.2/2+2.5])
        circle(2.5);
        translate([connx/2+18/2-2.5-tan(10)*(10.2-2.5*2),conny/2-10.2/2+2.5])
        circle(2.5);
    }
}


module side() {
    intersection() {
        cube([sz/2,sz,lh+uh]);
        difference() {
            union() {
                translate([sz/2,sz/2,thick/2])
                hexgrid([sz-2*ch,sz-2*ch,thick],center=true, hexsize=5, width=1, chamfer=ch/4);
                translate([sz/2,sz/2,lh+uh-thick/2])
                hexgrid([sz-2*ch,sz-2*ch,thick],center=true, hexsize=5, width=1, chamfer=ch/4);
                translate([thick/2,sz/2,lh/2+uh/2])
                rotate([90,0,90])
                hexgrid([sz-2*ch,lh+uh-2*ch,thick],center=true, hexsize=5, width=1, chamfer=ch/4);
                translate([sz/2,thick/2,lh/2+uh/2])
                rotate([90,0,0])
                hexgrid([sz-2*ch,lh+uh-2*ch,thick],center=true, hexsize=5, width=1, chamfer=ch/4);
                translate([sz/2,sz-thick/2,lh/2+uh/2])
                rotate([90,0,0])
                hexgrid([sz-2*ch,lh+uh-2*ch,thick],center=true, hexsize=5, width=1, chamfer=ch/4);
                chamferedcube([screwcase,screwcase,lh+uh],chamfer=ch);
                translate([0,sz-screwcase,0])
                chamferedcube([screwcase,screwcase,lh+uh],chamfer=ch);
                translate([0,screwcase+boardz,0])
                chamferedcube([screwcase,screwcase,lh+uh],chamfer=ch);
                translate([sz/2-10/2-3*ch,sz-screwcase,0])
                chamferedcube([10+6*ch,screwcase,lh+uh],chamfer=ch);
                translate([0,ch,ch])
                cube([sz/2-boardx/2,boardz+screwcase,lh+uh-2*ch]);
                chamferedcube([sz,3*ch,3*ch],chamfer=ch);
                translate([0,sz-24,0])
                chamferedcube([sz,24,7],chamfer=ch);
                translate([0,2*screwcase+boardz-3*ch,0])
                chamferedcube([sz,3*ch,3*ch],chamfer=ch);
                translate([ch,ch,0])
                cube([sz-2*ch,boardz+2*screwcase-2*ch,thick]);
                translate([0,0,lh+uh-3*ch])
                chamferedcube([sz,3*ch,3*ch],chamfer=ch);
                translate([0,sz-screwcase,lh+uh-3*ch])
                chamferedcube([sz,screwcase,3*ch],chamfer=ch);
                translate([0,2*screwcase+boardz-3*ch,lh+uh-3*ch])
                chamferedcube([sz,3*ch,3*ch],chamfer=ch);
                translate([ch,ch,lh+uh-thick])
                cube([sz-2*ch,boardz+2*screwcase-2*ch,thick]);
                translate([0,0,lh-3*ch/2])
                chamferedcube([sz,thick+ch,3*ch],chamfer=ch);
                translate([0,sz-thick-ch,lh-3*ch/2])
                chamferedcube([sz,thick+ch,3*ch],chamfer=ch);
                chamferedcube([3*ch,sz,7],chamfer=ch);
                translate([0,0,lh+uh-3*ch])
                chamferedcube([3*ch,sz,3*ch],chamfer=ch);
                translate([0,0,lh-3*ch/2])
                chamferedcube([thick+ch,sz,3*ch],chamfer=ch);
            }
            translate([sz/2,sz+eps,lh])
            rotate([90,0,0])
            chamferedcylinder(screwcase+2*eps, r=5, chamfer=-ch+eps);
            translate([(sz-2*connx)/3,sz-30/2+7/2-screwcase/2-conny/2,0])
            connectorcut();
            translate([screwcase/2,screwcase/2,0])
                screwcut(lh+uh-2.5, 5.4);
            translate([screwcase/2,sz-screwcase/2,0])
                screwcut(lh+uh-2.5, 5.4);
            translate([sz/2-boardx/2,screwcase,thick])
                cube([boardx,boardz,uh+lh-2*thick]);
        }
    }
}

module textcut(txt, sz) {
    translate([0,0,-fndep])
    linear_extrude(fndep+eps)
    text(txt, font="Liberation Sans:style=Bold",
         size=sz, halign="center", valign="center");
}

module logocut(file) {
   translate([0,0,-fndep])
   scale([0.1, 0.1, (fndep+eps)/100])
   mirror([0,0,1])  
   surface(file=file, center=true, invert=true);
}

module box() {
    difference() {
        union() {
            side();
            translate([sz,0,0]) mirror([1,0,0]) side();
        }
        if(uselogos)
        translate([sz/2,screwcase+boardz/2,0])
        rotate([0,180,0]) {
            translate([-10,0,0])
            logocut("Atari_logo_alt.png");
            translate([10,0,0])
            logocut("Commodore_C\=_logo.png");
        }
        translate([sz/2,sz-6,0])
        rotate([0,180,0]) {
            translate([-sz/4,0,0])
            textcut("1", 6);
            translate([sz/4,0,0])
            textcut("2", 6);
        }
        translate([sz/2,screwcase+boardz,lh+uh]) {
            translate([0,3,0])
            textcut("NOSE INSIDE OFFS. 1", 4);
            translate([0,-3,0])
            textcut("RED = PIN 4", 4);
        }
        translate([sz/2,sz-screwcase/2,lh+uh])
        textcut("ROBERT SCHIELE", 4);
    }
    
}

difference() {
intersection() {
    box();
    cube([sz,sz,lh]);
}
translate([sz/2,3/2*ch,lh])
rotate([0,90,0])
cylinder(sz-2*screwcase,r=0.8, center=true);
translate([screwcase+0.2,sz-3/2*ch,lh])
rotate([0,90,0])
cylinder(sz/2-screwcase-10/2-2*ch-0.2,r=0.8);
translate([sz-screwcase,sz-3/2*ch,lh])
rotate([0,-90,0])
cylinder(sz/2-screwcase-10/2-2*ch,r=0.8);
translate([3/2*ch,sz/2,lh])
rotate([90,0,0])
cylinder(sz-2*screwcase,r=0.8, center=true);
translate([sz-3/2*ch,sz/2,lh])
rotate([90,0,0])
cylinder(sz-2*screwcase,r=0.8, center=true);
}

translate([2*sz+10,0,lh+uh])
rotate([0,180,0]) {
intersection() {
    box();
    translate([0,0,lh])
    cube([sz,sz,uh]);
}
translate([sz/2,3/2*ch,lh])
rotate([0,90,0])
cylinder(sz-2*screwcase-0.4,r=0.6, center=true);
translate([screwcase+0.2,sz-3/2*ch,lh])
rotate([0,90,0])
cylinder(sz/2-screwcase-10/2-2*ch-0.2,r=0.6);
translate([sz-screwcase-0.2,sz-3/2*ch,lh])
rotate([0,-90,0])
cylinder(sz/2-screwcase-10/2-2*ch-0.2,r=0.6);
translate([3/2*ch,sz/2,lh])
rotate([90,0,0])
cylinder(sz-2*screwcase-0.4,r=0.6, center=true);
translate([sz-3/2*ch,sz/2,lh])
rotate([90,0,0])
cylinder(sz-2*screwcase-0.4,r=0.6, center=true);
}
