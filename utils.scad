// utility library
// Copyright (C) 2022  Robert Schiele <rschiele@gmail.com>
//
// This work is licensed under the Creative Commons Attribution 4.0
// International License. To view a copy of this license, visit 
// http://creativecommons.org/licenses/by/4.0/.

fmod = function(a, b) (a%b + b)%b;
eps = 0.01;

module hexcut(gh, gt, hex, ch) {
    r=hex.x/3-gt/2*sqrt(3);
    chr=r+ch*sqrt(3)+eps;
    translate([0, 0, -eps])
        cylinder(ch+eps, chr, r, $fn=6);
    translate([0, 0, -eps])
        cylinder(gh+2*eps, r=r, $fn=6);
    translate([0, 0, gh-ch])
        cylinder(ch+eps, r, chr, $fn=6);
}

module singlehex(gh, gt, hex, ch) {
        hexcut(gh, gt, hex,ch);
        translate([hex.x/2, hex.y/2, 0])
            hexcut(gh, gt, hex,ch);
}

module hexgrid(size=1, center=false, hexsize=15,
            width=1.4, offset=[0,0], chamfer=0) {
    s = is_list(size) ? size : [size,size,1];
    assert(width < hexsize, "width should be smaller than hexsize");
    assert(chamfer*2 <= width, "chamfer should not exceed half of width");
    assert(chamfer*2 <= s.z, "chamfer should not exceed half of size.z");
    hex = [hexsize*sqrt(3), hexsize];
    r = center ? s/2 : s;
    ro = [fmod(offset.x, hex.x), fmod(offset.y, hex.y)];
    difference() {
        cube(s, center);
        translate([0, 0, center ? -s.z/2 : 0])
        for(x=[0:hex.x:r.x+hex.x+ro.x])
        for(y=[0:hex.y:r.y+hex.y+ro.y]) {
            translate([x-ro.x, y-ro.y, 0])
                singlehex(s.z, width, hex, chamfer);
            if(center) {
                translate([-hex.x-x-ro.x,        y-ro.y, 0])
                    singlehex(s.z, width, hex, chamfer);
                translate([       x-ro.x, -hex.y-y-ro.y, 0])
                    singlehex(s.z, width, hex, chamfer);
                translate([-hex.x-x-ro.x, -hex.y-y-ro.y, 0])
                    singlehex(s.z, width, hex, chamfer);
            }
        }
    }
}

module cubecut(gh, gt, cube, ch) {
    r=cube/2-gt/2*sqrt(2);
    chr=r+ch*sqrt(2)+eps;
    translate([0, 0, -eps])
        cylinder(ch+eps, chr, r, $fn=4);
    translate([0, 0, -eps])
        cylinder(gh+2*eps, r=r, $fn=4);
    translate([0, 0, gh-ch])
        cylinder(ch+eps, r, chr, $fn=4);
}

module singlecube(gh, gt, cube, ch) {
        cubecut(gh, gt, cube,ch);
        translate([cube/2, cube/2, 0])
            cubecut(gh, gt, cube, ch);
}

module cubicgrid(size=1, center=false, cubesize=15,
            width=1.4, offset=[0,0], chamfer=0) {
    s = is_list(size) ? size : [size,size,1];
    assert(width < cubesize, "width should be smaller than cubesize");
    assert(chamfer*2 <= width, "chamfer should not exceed half of width");
    assert(chamfer*2 <= s.z, "chamfer should not exceed half of size.z");
    cube = cubesize*sqrt(2);
    r = center ? s/2 : s;
    ro = [fmod(offset.x, cube), fmod(offset.y, cube)];
    difference() {
        cube(s, center);
        translate([0, 0, center ? -s.z/2 : 0])
        for(x=[0:cube:r.x+cube+ro.x])
        for(y=[0:cube:r.y+cube+ro.y]) {
            translate([x-ro.x, y-ro.y, 0])
                singlecube(s.z, width, cube, chamfer);
            if(center) {
                translate([-cube-x-ro.x,        y-ro.y, 0])
                    singlecube(s.z, width, cube, chamfer);
                translate([       x-ro.x, -cube.y-y-ro.y, 0])
                    singlecube(s.z, width, cube, chamfer);
                translate([-cube.x-x-ro.x, -cube.y-y-ro.y, 0])
                    singlecube(s.z, width, cube, chamfer);
            }
        }
    }
}

module chamferedcube(size=1, center=false, chamfer=0) {
    s = is_list(size) ? size : [size,size,size];
    c = center ? s/2 : [0, 0, 0];
    ch = chamfer;
    translate(-c)
    polyhedron([
        [     0,     ch,     ch],
        [    ch,      0,     ch],
        [    ch,     ch,      0],
        [s.x   ,     ch,     ch],
        [s.x-ch,      0,     ch],
        [s.x-ch,     ch,      0],
        [     0, s.y-ch,     ch],
        [    ch, s.y   ,     ch],
        [    ch, s.y-ch,      0],
        [s.x   , s.y-ch,     ch],
        [s.x-ch, s.y   ,     ch],
        [s.x-ch, s.y-ch,      0],
        [     0,     ch, s.z-ch],
        [    ch,      0, s.z-ch],
        [    ch,     ch, s.z   ],
        [s.x   ,     ch, s.z-ch],
        [s.x-ch,      0, s.z-ch],
        [s.x-ch,     ch, s.z   ],
        [     0, s.y-ch, s.z-ch],
        [    ch, s.y   , s.z-ch],
        [    ch, s.y-ch, s.z   ],
        [s.x   , s.y-ch, s.z-ch],
        [s.x-ch, s.y   , s.z-ch],
        [s.x-ch, s.y-ch, s.z   ],
    ], [
        [ 0, 1, 2],
        [ 3, 5, 4],
        [ 6, 8, 7],
        [ 9,10,11],
        [12,14,13],
        [15,16,17],
        [18,19,20],
        [21,23,22],
    
        [ 1, 4, 5, 2],
        [ 0, 2, 8, 6],
        [ 9,11, 5, 3],
        [10, 7, 8,11],
        [ 0,12,13, 1],
        [ 3, 4,16,15],
        [ 6, 7,19,18],
        [ 9,21,22,10],
        [13,14,17,16],
        [12,18,20,14],
        [21,15,17,23],
        [22,23,20,19],

        [ 2, 5,11, 8],
        [ 1,13,16, 4],
        [ 0, 6,18,12],
        [ 3,15,21, 9],
        [ 7,10,22,19],
        [14,20,23,17],
    ]);
};

module chamferedcylinder(h, r, chamfer=0) {
    ch = (chamfer < 0) ? -chamfer : chamfer;
        cylinder(ch, r-chamfer, r);
    translate([0, 0, ((chamfer<0)?0:ch)])
        cylinder(h-((chamfer<0)?0:(2*ch)), r=r);
    translate([0, 0, h-ch])
        cylinder(ch, r, r-chamfer);
}
