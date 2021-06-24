// badge holder for multiple cards
// Copyright (C) 2021  Robert Schiele <rschiele@gmail.com>
//
// This work is licensed under the Creative Commons Namensnennung 4.0 International
// License. To view a copy of this license, visit 
// http://creativecommons.org/licenses/by/4.0/.

card_length = 85.60;
card_width = 53.98;
card_thickness = 0.76;
card_radius = 3.18;
cards = 3;
space = 0.2;
thickness = 1;
chamfer = 0.5;
clipoffset = 6.57;
clipsize = 10;
connectorsize = 15;
$fn = 90;

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
    [card_radius + space, (2 - 1/tan(55))*space + thickness + cards*card_thickness],
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
    [0, 2*space + 2*thickness + cards*card_thickness],
    [0, thickness + (cards-1)*card_thickness],
    [card_width/2 + space, thickness + (cards-1)*card_thickness],
    [card_width/2 + space, (2 - 1/tan(55))*space + thickness + cards*card_thickness],
    [card_width/2 - thickness,
     2*space + (1 + 1/tan(55))*thickness + cards*card_thickness],
    [card_width/2 - thickness, 2*space + 2*thickness + cards*card_thickness],
];
connectorcut = [
    [0, 0],
    [0, thickness],
    [-1, thickness],
    [-1, thickness + (cards-1)*card_thickness],
    [5*thickness - chamfer, thickness + (cards-1)*card_thickness],
    [5*thickness - chamfer, 2*thickness],
    [3*thickness + chamfer, 2*thickness],
    [3*thickness, 2*thickness - chamfer],
    [3*thickness, chamfer],
    [3*thickness + chamfer, 0]
];

module oneside() {
    union() {
        difference() {
            union() {
                translate([0, -4*thickness, 0])
                    cube([card_width/2 - card_radius,
                          card_length - 2*card_radius + 4*thickness, thickness]);
                translate([card_width/2 - card_radius, card_length - 2*card_radius, 0])
                    rotate([90,0,0])
                        linear_extrude(height = card_length - 2*card_radius)
                            polygon(clamp);
                translate([0, card_length - 2*card_radius, 0])
                    rotate([90,0,90])
                        linear_extrude(height = card_width/2 - card_radius)
                            polygon(clamp);
                translate([card_width/2 - card_radius, 0, 0])
                    rotate([90,0,270])
                        linear_extrude(height = card_width/2 - card_radius)
                            polygon(clamp);
                translate([card_width/2 - card_radius, card_length - 2*card_radius, 0])
                    rotate([0,0,0])
                        rotate_extrude(angle = 90)
                            polygon(clamp);
                translate([card_width/2 - card_radius, 0, 0])
                    rotate([0,0,270])
                        rotate_extrude(angle = 90)
                            polygon(clamp);
                translate([card_width/2 - card_radius, 0, 0])
                    difference() {
                        rotate([90,0,0])
                            linear_extrude(height = 4*thickness)
                                polygon(front);
                        cylinder(h=thickness + (cards-1)*card_thickness,
                                 r=card_radius+space);
                    };
                translate([card_width/2 - card_radius, -4*thickness, 0])
                    rotate([0,0,270])
                        rotate_extrude(angle = 90)
                            polygon(front);
                translate([card_width/2 - card_radius, -4*thickness, 0])
                    rotate([90,0,270])
                        linear_extrude(height = card_width/2 - card_radius)
                            polygon(front);
            };
            rotate([90,0,0])
                linear_extrude(height = card_radius + space + thickness)
                    polygon(loadcut);
            translate([
                0,
                -(1 +
                  sin(acos((card_radius + space)/(card_radius + space + thickness)))) *
                  (card_radius + space + thickness),
                thickness + (cards-1)*card_thickness])
                cube([thickness + space + card_width/2,
                      card_radius + space + thickness,
                      2*space + thickness + card_thickness]);
            translate([card_width/2 - card_radius - clipoffset - clipsize/2 - thickness,
                       0 - card_radius - space - 3*thickness, 0]) {
                cube([thickness, 3*thickness + clipsize,
                      thickness + (cards-1)*card_thickness]);
                cube([2*thickness + clipsize,
                      thickness, thickness + (cards-1)*card_thickness]);
                translate([11*thickness, 0, 0])
                    cube([thickness, 3*thickness + clipsize,
                          thickness + (cards-1)*card_thickness]);
            };
            translate([connectorsize/2, 0 - card_radius - space, 0])
                rotate([90,0,270])
                    linear_extrude(height = connectorsize/2)
                        polygon(connectorcut);
            translate([0, card_length - 2*card_radius - card_width/2 + card_radius, 0]) {
                translate([0, -22, 0]) cylinder(h=thickness, r=10);
                translate([-10, -22, 0]) cube([20, 22, thickness]);
                translate([0, 0, 0]) cylinder(h=thickness, r=10);
            };
        };
        translate([card_width/2 - card_radius - clipoffset + clipsize/2,
                   0 - card_radius - space, 0])
            rotate([90,0,270])
                linear_extrude(height = clipsize)
                    polygon(clip);
    };
};

oneside();
mirror([1, 0, 0])
    oneside();
