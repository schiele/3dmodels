use <voronoi.scad>
use <surfacecylinder.scad>

// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

d=74.3;

bounds=[[-75/2, -75/2], [75/2, 75/2]];

linear_extrude(2) difference() {
    circle(d=d+2);
    voronoi(bounds, points(bounds, 25), 2, 2) circle(d=d);
}
difference() {
    linear_extrude(80, convexity=2) difference() {
        circle(d=d+2);
        circle(d=d);
    }
    surfacecylinder(d=d-0.5, ext=2)
        translate([0, 40])
            text("Sha Schiele", 26, "Stencil", valign="center");
}
