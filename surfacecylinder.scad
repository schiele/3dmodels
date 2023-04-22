// surfacecylinder - map 2D objects to a cylinder
// Copyright (C) 2023  Robert Schiele <rschiele@gmail.com>
//
// This work is licensed under the Creative Commons Attribution 4.0
// International License. To view a copy of this license, visit
// http://creativecommons.org/licenses/by/4.0/.

module surfacecylinder(r=undef, d=undef, ext=undef)
    let(eps=1/128,
        inf=1000,
        rr = (r==undef) ? d/2 : r,
        n = $fn>0 ?
            ($fn>=3?$fn:3) :
            ceil(max(min(360/$fa,rr*2*PI/$fs),5)),
        angle = 360/n,
        c = 2*rr*sin(angle/2),
        hc = sqrt(4*rr^2-c^2)/2)
    for(i=[0.5:n]) rotate([90, 0, 90+angle*i])
        translate([0, 0, ext>=0 ? hc : hc+ext])
            scale(ext>=0 ? 1 : [(ext+hc)/hc, 1])
                linear_extrude(abs(ext), scale=
                        [ext>=0 ? (ext+hc)/hc : hc/(ext+hc), 1]) 
                    translate([-i*c, 0]) intersection() {
                        translate([i*c, 0])
                            square([c+eps, inf], center=true);
                        children();
                    }

color("green") surfacecylinder(d=10, ext=1, $fa=1, $fs=0.2) text("Test");
color("red") surfacecylinder(d=10, ext=-1, $fa=1, $fs=0.2) text("Test");
