// enclosure for joystick adapter
// Copyright (C) 2022  Robert Schiele <rschiele@gmail.com>
//
// This program is free software: you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation, either version 3
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

include <NopSCADlib/lib.scad>
include <utils.scad>

$fa=1;
$fs=0.2;

sz = 65;
lh = 33;
pcbsp = 0.2;
screwcase = 8;
thick = 1.6;
ch = 1;
fndep = 0.8;
numsize = 6;
fontsize = 4;
uselogos = 0;

uh = pcb_width(PERF60x40) + pcbsp + 2*thick - lh;

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
    type = DCONN9;
    l = 10;

    translate([0,0,d_front_height(type)-d_flange_thickness(type)])
    linear_extrude(l + d_flange_thickness(type)
                   - d_front_height(type))
        rounded_square([d_flange_length(type),
                        d_flange_width(type)], 2);

    translate([0,0,-eps])
        linear_extrude(d_front_height(type)+eps)
            d_plug_D(d_lengths(type)[0],
                     d_widths(type)[0], 2.5);

    d_connector_holes(type)
    screwcut(l-2.5);
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
                translate([0,screwcase
                        +pcb_thickness(PERF60x40)
                        +pcbsp,0])
                chamferedcube([screwcase,screwcase,lh+uh],chamfer=ch);
                translate([sz/2-10/2-3*ch,sz-screwcase,0])
                chamferedcube([10+6*ch,screwcase,lh+uh],chamfer=ch);
                translate([0,ch,ch])
                cube([sz/2-pcb_length(PERF60x40)/2
                          -pcbsp/2,
                      pcb_thickness(PERF60x40)+pcbsp
                          +screwcase,lh+uh-2*ch]);
                chamferedcube([sz,3*ch,3*ch],chamfer=ch);
                translate([0,sz-24,0])
                chamferedcube([sz,24,7],chamfer=ch);
                translate([0,2*screwcase
                    +pcb_thickness(PERF60x40)+pcbsp
                    -3*ch,0])
                chamferedcube([sz,3*ch,3*ch],chamfer=ch);
                translate([ch,ch,0])
                cube([sz-2*ch,
                    pcb_thickness(PERF60x40)+pcbsp
                        +2*screwcase-2*ch,thick]);
                translate([0,0,lh+uh-3*ch])
                chamferedcube([sz,3*ch,3*ch],chamfer=ch);
                translate([0,sz-screwcase,lh+uh-3*ch])
                chamferedcube([sz,screwcase,3*ch],chamfer=ch);
                translate([0,2*screwcase
                    +pcb_thickness(PERF60x40)+pcbsp
                    -3*ch,lh+uh-3*ch])
                chamferedcube([sz,3*ch,3*ch],chamfer=ch);
                translate([ch,ch,lh+uh-thick])
                cube([sz-2*ch,
                    pcb_thickness(PERF60x40)+pcbsp
                        +2*screwcase-2*ch,thick]);
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
            translate([sz/3-d_flange_length(DCONN9)/6,
                       sz-30/2+7/2-screwcase/2,0])
            connectorcut();
            translate([screwcase/2,screwcase/2,0])
                screwcut(lh+uh-2.5, 5.4);
            translate([screwcase/2,sz-screwcase/2,0])
                screwcut(lh+uh-2.5, 5.4);
            translate([sz/2-pcb_length(PERF60x40)/2
                           -pcbsp/2,screwcase,thick])
                cube([pcb_length(PERF60x40) + pcbsp,
                      pcb_thickness(PERF60x40) + pcbsp,
                      uh+lh-2*thick]);
        }
    }
    if($preview) {
        translate([sz/3-d_flange_length(DCONN9)/6,
                   sz-30/2+7/2-screwcase/2,
                   d_front_height(DCONN9)])
        mirror([0,0,1])
        d_plug(DCONN9, idc=true);
            translate([sz/2,screwcase+pcbsp/2,pcb_width(PERF60x40)/2+pcbsp/2+thick])
        rotate([-90,0,0])
                pcb(PERF60x40);
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
        translate([sz/2,screwcase
            +pcb_thickness(PERF60x40)/2+pcbsp/2,0])
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
        translate([sz/2,screwcase
            +pcb_thickness(PERF60x40)+pcbsp,lh+uh]) {
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
