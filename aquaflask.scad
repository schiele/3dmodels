use <voronoi.scad>
use <surfacecylinder.scad>

// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

bounds=[[-75/2, -75/2], [75/2, 75/2]];

linear_extrude(2)
difference() {
    circle(d=76);
    voronoi(bounds, points(bounds, 25), 2, 2) circle(d=74);
}
difference() {
linear_extrude(80, convexity=2)
difference() {
    circle(d=76);
    circle(d=74);
}
    surfacecylinder(d=74-0.5, ext=2)
        translate([0, 40])
            text("Sha Schiele", 26, "Stencil", valign="center");
}
