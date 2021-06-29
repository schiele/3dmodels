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

part = 1;
line1 = "Robert Schiele";
line2 = "+49-173-1234567";
handle_length = 35.00;
handle_width  = 18.00;
hole_distance =  3.00;
hole_dia      =  handle_width - hole_distance*2;
coin_dia      = 23.25;
obj_height    =  2.33;
$fn=90;

module base() {
    linear_extrude(height = obj_height)
        union() {
            translate([-(handle_length-(handle_width/2)), 0, 0])
                difference() {
                    union() {
                        circle(d = handle_width);
                        translate([0, -handle_width/2, 0])
                            square([handle_length-(handle_width/2),
                                    handle_width]);
                    }
                    translate([(-(handle_width-hole_dia)/2)+hole_distance, 0, 0])
                        circle(d = hole_dia);
                }
            circle(d=coin_dia);
        }
};

module engravetext(line) {
            linear_extrude(height = obj_height/2)
                text(line, font = "Liberation Sans:style=Bold",
                     size=2.5, halign="center", valign="center");
};

module engraving() {
    translate([-5, -4, obj_height/2]) rotate([180,0,0]) engravetext(line1);
    translate([-5,  4, obj_height/2]) rotate([180,0,0]) engravetext(line2);
    translate([-5,  4, obj_height/2]) rotate([0,0,0]) engravetext(line1);
    translate([-5, -4, obj_height/2]) rotate([0,0,0]) engravetext(line2);
}

if (part == 1) {
    difference() {
        base();
        engraving();
    };
} else if (part == 2) {
    engraving();
    engraving();
};
