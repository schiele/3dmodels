// badge holder for multiple cards
// Copyright (C) 2023  Robert Schiele <rschiele@gmail.com>
//
// This work is licensed under the Creative Commons Attribution 4.0
// International License. To view a copy of this license, visit 
// http://creativecommons.org/licenses/by/4.0/.

/* [customize] */
// number of cards
cards = 3; // [3,4,5]
/* [technical] */
card_length = 85.60;
card_width = 53.98;
card_thickness = 0.76;
card_radius = 3.18;
space = 0.2;
thickness = 1; // [0.2:0.1:3]
chamfer = 0.5;
eps = 1/128;
// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

full_height = 2*space + 2*thickness + cards*card_thickness;

function bodyframe() = [
    [0, 0],
    [0, full_height],
    [card_radius+space+thickness-chamfer, full_height],
    [card_radius+space+thickness, full_height-chamfer],
    [card_radius+space+thickness, chamfer],
    [card_radius+space+thickness-chamfer, 0],
];

function cut(closed=true) = [
    [0, closed ? thickness : -eps],
    [0, full_height+eps],
    [card_radius-thickness, full_height+eps],
    [card_radius-thickness,
     full_height+(1/tan(55)-1)*thickness],
    [card_radius+space,
     full_height-1/tan(55)*space-thickness],
    [card_radius+space, closed ? thickness : -eps],
];

module cardloop(poly) {
    for (i=[0, 1], j=[0, 1])
        mirror([i, 0, 0]) mirror([0, j, 0]) {
        translate([-eps, -eps, poly[0].y])
            cube([card_width/2 - card_radius + 2*eps,
                  card_length/2 - card_radius + 2*eps,
                  poly[1].y - poly[0].y]);
        translate([card_width/2 - card_radius,
                   card_length/2 - card_radius +eps, 0])
            rotate([90,0,0])
                linear_extrude(height=card_length/2 +eps
                               - card_radius, convexity=10)
                    polygon(poly);
        translate([0, card_length/2 - card_radius, 0])
            rotate([90,0,90])
                linear_extrude(height = card_width/2 +eps
                               - card_radius, convexity=10)
                    polygon(poly);
        translate([card_width/2 - card_radius,
                   card_length/2 - card_radius, 0])
            rotate_extrude(angle = 90, convexity=10)
                polygon(poly);
    }
}

difference() {
    for(i=[0, full_height + 3])
        difference() {
            translate([0, i, 0]) cardloop(bodyframe());
            if(i)
                cube([13, card_length
                          + 2*space + 2*thickness + 2*3
                          + full_height, 50],
                     center=true);
        }
    cardloop(cut());
    intersection_for(i=[0,2/3*card_length])
        translate([0, i, 0]) cardloop(cut(false));
    linear_extrude(50, center=true) hull()
        for(i=[-(card_width/2-card_radius-10),
                 card_width/2-card_radius-10],
            j=[-(card_length/2-card_radius-10),
               -(card_length/2-card_radius-10)
               +card_width-2*card_radius-20])
            translate([i, j]) circle(card_radius);
}
translate([0, card_length/2 + thickness + space + 3
              + full_height/2, full_height/2])
rotate([0, 90, 0])
cylinder(15, d=full_height, center=true);
