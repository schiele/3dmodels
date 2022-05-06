// keychain cart coin
// Copyright (C) 2021  Robert Schiele <rschiele@gmail.com>
//
// This work is licensed under the Creative Commons
// Attribution-NonCommercial-ShareAlike 4.0 International License.
// To view a copy of this license, visit
// http://creativecommons.org/licenses/by-nc-sa/4.0/.
//
// Code based on the model from
// https://www.prusaprinters.org/prints/19338

// part to render
part = 0; // [0:2]
// first name
line1 = "Robert";
// family name
line2 = "Schiele";
// country and area code
line3 = "+49 173";
// phone number
line4 = "1234567";
// length of handle
handle_length = 35.00; // [20:0.5:50]
// width of handle
handle_width  = 18.00; // [5:0.5:25]
// distance of hole to outside
hole_distance =  3.00; // [1:0.2:12]
hole_dia      = handle_width - hole_distance*2;
hole_center   = -handle_length+handle_width/2;
// diameter of coin
coin_dia      = 23.25;
// height of coin
obj_height    =  2.33;
eps = 1/128;
// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

module base() {
    linear_extrude(height=obj_height,
                   center=true) {
        difference() {
            hull() {
                circle(d=handle_width);
                translate([hole_center, 0])
                    circle(d=handle_width);
            }
            translate([hole_center, 0])
                circle(d=hole_dia);
        }
        circle(d=coin_dia);
    }
};

module engravetext(line) {
    linear_extrude(height = obj_height/2)
        text(line,
             font = "Liberation Sans:style=Bold",
             size=5,
             halign="center", valign="center");
};

module engraving(eps=0) {
    translate([-5,  4, eps]) engravetext(line1);
    translate([-5, -4, eps]) engravetext(line2);
    rotate([180,0,0]) {
        translate([-5,  4, eps]) engravetext(line3);
        translate([-5, -4, eps]) engravetext(line4);
    }
}

if (part == 0 || part == 1)
    color("black") difference() {
        base();
        engraving(eps);
    };
if (part == 0 || part == 2)
    color("yellow") engraving();
