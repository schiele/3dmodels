// badge holder for multiple cards
// Copyright (C) 2021  Robert Schiele <rschiele@gmail.com>
//
// This work is licensed under the Creative Commons Attribution 4.0
// International License. To view a copy of this license, visit 
// http://creativecommons.org/licenses/by/4.0/.
//
// Code was written from scratch but some ideas got inspired from
// https://www.prusaprinters.org/prints/42136

/* [customize] */
// name to be printed on the upper line
name = "Robert Schiele";
// font for name
name_font = "Liberation Sans:style=Bold";
// font size for name
name_fontsize = 6; // [3:0.1:10]
// stretch height of name
name_stretch = 1; // [0.5:0.1:2]
// phone to be printed on the lower line
phone = "+49-176-1234567";
// font for phone
phone_font = "Liberation Sans:style=Bold";
// font size for phone
phone_fontsize = 6; // [3:0.1:10]
// stretch height of phone
phone_stretch = 1; // [0.5:0.1:2]
// number of cards
cards = 3; // [3,4,5]
// width of connector band
connectorsize = 15; // [3:0.5:20]
// create hole for keyring instead of connector band
hole = false;
// color of the base
basecolor = "yellow";
// color of the font
fontcolor = "black";
/* [technical] */
part = 0;
card_length = 85.60;
card_width = 53.98;
card_thickness = 0.76;
card_radius = 3.18;
space = 0.2;
thickness = 1; // [0.2:0.1:3]
chamfer = 0.5;
clipoffset = 6.57;
clipsize = 10;
eps = 1/128;
// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

clamp = [
    [0, 0],
    [card_radius + space + thickness - chamfer, 0],
    [card_radius + space + thickness, chamfer],
    [card_radius + space + thickness,
     2*space + 2*thickness + cards*card_thickness - chamfer],
    [card_radius + space + thickness - chamfer,
     2*space + 2*thickness + cards*card_thickness],
    [card_radius - thickness, 2*space + 2*thickness + cards*card_thickness],
    [card_radius - thickness,
     2*space + (1 + 1/tan(55))*thickness + cards*card_thickness],
    [card_radius + space,
     (2 - 1/tan(55))*space + thickness + cards*card_thickness],
    [card_radius + space, thickness],
    [0, thickness]
];
front = [
    [0 ,0],
    [card_radius + space + thickness - chamfer, 0],
    [card_radius + space + thickness, chamfer],
    [card_radius + space + thickness, 2*thickness - chamfer],
    [card_radius + space - (cards-1)*card_thickness + 2*thickness - chamfer,
     thickness + (cards-1)*card_thickness],
    [0, thickness + (cards-1)*card_thickness]
];
clip = [
    [0, 0],
    [0, 2*space + 2*thickness + cards*card_thickness],
    [5*thickness - chamfer - 2*space - cards*card_thickness,
     2*space + 2*thickness + cards*card_thickness],
    [2*thickness, 5*thickness - chamfer],
    [2*thickness, 0],
];
loadcut = [
    [-eps, eps+2*space + 2*thickness + cards*card_thickness],
    [-eps, thickness + (cards-1)*card_thickness],
    [card_width/2 + space, thickness + (cards-1)*card_thickness],
    [card_width/2 + space,
     (2 - 1/tan(55))*space + thickness + cards*card_thickness],
    [card_width/2 - thickness,
     2*space + (1 + 1/tan(55))*thickness + cards*card_thickness],
    [card_width/2 - thickness, eps+2*space + 2*thickness + cards*card_thickness],
];
connectorcut = [
    [0, -eps],
    [0, thickness],
    [-1, thickness],
    [-1, thickness + (cards-1)*card_thickness+eps],
    [5*thickness, thickness + (cards-1)*card_thickness+eps],
    [5*thickness, 2*thickness],
    [3*thickness + chamfer, 2*thickness],
    [3*thickness, 2*thickness - chamfer],
    [3*thickness, chamfer],
    [3*thickness + chamfer+eps, -eps]
];

module mirrory() {
    children();
    mirror([1, 0, 0]) children();
}

module base() {
    union() {
        difference() {
            union() {
                translate([-card_width/2 + card_radius, -4*thickness, 0])
                    cube([card_width - 2*card_radius,
                          card_length - 2*card_radius + 4*thickness,
                          thickness]);
                mirrory() translate([card_width/2 - card_radius,
                           card_length - 2*card_radius, 0])
                    rotate([90,0,0])
                        linear_extrude(height = card_length - 2*card_radius, convexity=10)
                            polygon(clamp);
                translate([-card_width/2 + card_radius, card_length - 2*card_radius, 0])
                    rotate([90,0,90])
                        linear_extrude(height = card_width - 2*card_radius, convexity=10)
                            polygon(clamp);
                translate([card_width/2 - card_radius, 0, 0])
                    rotate([90,0,270])
                        linear_extrude(height = card_width - 2*card_radius, convexity=10)
                            polygon(clamp);
                mirrory() translate([card_width/2 - card_radius,
                           card_length - 2*card_radius, 0])
                    rotate([0,0,0])
                        rotate_extrude(angle = 90, convexity=10)
                            polygon(clamp);
                mirrory() translate([card_width/2 - card_radius, 0, 0])
                    rotate([0,0,270])
                        rotate_extrude(angle = 90, convexity=10)
                            polygon(clamp);
                mirrory() translate([card_width/2 - card_radius, 0, 0])
                    difference() {
                        rotate([90,0,0])
                            linear_extrude(height = 4*thickness, convexity=10)
                                polygon(front);
                        translate([0,0,-eps])
                        cylinder(h=thickness + (cards-1)*card_thickness + 2*eps,
                                 r=card_radius+space);
                    };
                mirrory() translate([card_width/2 - card_radius, -4*thickness, 0])
                    rotate([0,0,270])
                        rotate_extrude(angle = 90, convexity=10)
                            polygon(front);
                translate([card_width/2 - card_radius, -4*thickness, 0])
                    rotate([90,0,270])
                        linear_extrude(height = card_width - 2*card_radius, convexity=10)
                            polygon(front);
            };
            mirrory() rotate([90,0,0])
                linear_extrude(height = eps+card_radius + space + thickness, convexity=10)
                    polygon(loadcut);
            translate([
                -thickness - space - card_width/2,
                -(1 +
                  sin(acos((card_radius + space)/(card_radius + space +
                           thickness)))) *
                  (card_radius + space + thickness),
                thickness + (cards-1)*card_thickness])
                cube([2*thickness + 2*space + card_width,
                      card_radius + space + thickness,
                      eps+2*space + thickness + card_thickness]);
            mirrory() translate([card_width/2 - card_radius - clipoffset - clipsize/2 -
                           thickness,
                       0 - card_radius - space - 3*thickness, -eps]) {
                cube([thickness, 3*thickness + clipsize,
                      2*eps+thickness + (cards-1)*card_thickness]);
                cube([2*thickness + clipsize,
                      thickness, 2*eps+thickness + (cards-1)*card_thickness]);
                translate([11*thickness, 0, 0])
                    cube([thickness, 3*thickness + clipsize,
                          2*eps+thickness + (cards-1)*card_thickness]);
            };
            if (!hole)
                translate([connectorsize/2, 0 - card_radius - space, 0])
                    rotate([90,0,270])
                        linear_extrude(height = connectorsize, convexity=10)
                            polygon(connectorcut);
            translate([0, card_length - card_radius - card_width/2, -eps]) {
                linear_extrude(thickness+2*eps, convexity=10)
                hull() {
                    translate([0, -22])
                        circle(10);
                    circle(10);
                }
            };
        };
        mirrory() translate([card_width/2 - card_radius - clipoffset + clipsize/2,
                   0 - card_radius - space, 0])
            rotate([90,0,270])
                linear_extrude(height = clipsize, convexity=10)
                    polygon(clip);
    };
};

module engravetext(loc, line, sz, st, ft, eps=0) {
    translate([loc, card_length - card_radius - card_width/2 - 11,
               thickness/2])
    scale([st,1,1])
        rotate([180,0,90])
            linear_extrude(height = thickness/2+eps, convexity=10)
                text(line, font = ft,
                     size=sz, halign="center", valign="center");
};

module engraving(eps=0) {
    engravetext(18, name, name_fontsize, name_stretch, name_font, eps=eps);
    engravetext(-18, phone, phone_fontsize, phone_stretch, phone_font, eps=eps);
}

if (part == 0 || part == 1)
    color(basecolor) difference() {
        base();
        engraving(eps=eps);
        if (hole) {
            translate([0,-5,-1])
                cylinder(10,1.5,1.5);
            translate([0,-3.5,6])
                cube([3,3,10], center = true);
        }
    };
if (part == 0 || part == 2)
    color(fontcolor) engraving();
