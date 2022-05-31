/* [Settings] */
// currency
currency = "EUR"; // [EUR:Euro, AED:United Arab Emirates dirham]
// thickness of rim
th = 0.4; // [0:0.05:2]
// width of rim
rim = 1; // [0:0.1:5]
/* [Technical Specs] */
// card dimensions (width, height, thickness, radius)
card = [85.60, 53.98, 0.76, 3.18];
// Euro coins (x, y, thickness, diameter, extra, corners)
EUR = [
    [14.22, 14.58, 2.20, 25.75, 0.25, 0],
    [39.86, 12.71, 2.33, 23.25, 0.25, 0],
    [13.21, 40.77, 2.38, 24.25, 0.25, 0],
    [73.06, 12.22, 2.14, 22.25, 0.25, 0],
    [35.69, 35.03, 1.93, 19.75, 0.25, 0],
    [73.89, 35.38, 1.67, 21.25, 0.25, 0],
    [54.31, 43.52, 1.67, 18.75, 0.25, 0],
    [56.85, 24.98, 1.67, 16.25, 0.25, 0],
];
// United Arab Emirates dirham coins (x, y, thickness, diameter, extra, corners)
AED = [
    [16.49, 15.35, 2.00, 24.00, 0.15, 0],
    [45.12, 15.35, 2.00, 24.00, 0.15, 0],
    [67.62, 38.19, 1.70, 21.00, 0.15, 7],
    [71.06, 13.90, 1.70, 21.00, 0.15, 7],
    [42.51, 40.63, 1.50, 20.00, 0.15, 0],
    [19.09, 40.63, 1.50, 20.00, 0.15, 0],
];
/* [Rendering Precision] */
// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

module cornered(d, n)
    if(n==0)
        circle(d=d);
    else
        intersection_for(i=[0:n-1])
            rotate([0,0,i*360/n])
                translate([d/2/sin(180/n*floor(n/2)),0])
                    circle(r=d);

module element(h, rim, coins)
    linear_extrude(h, convexity=10)
        difference() {
            hull()
                for(x=[card[3], card.x-card[3]],
                    y=[card[3], card.y-card[3]])
                    translate([x, y])
                        circle(card[3]);
            for(c=coins)
                translate([c.x, c.y])
                    cornered(c[3]+c[4]-2*rim, c[5]);
        }

module plate(coins) {
    maxsz = max([for(c=coins) c.z])*2;
    difference() {
        union() {
            element(maxsz + th, 0, coins);
            element(th, rim, coins);
        }
        for(i=[0,1])
        translate([card.x/2,card.y*i,(maxsz+th)/2])
            rotate([90,0,180*i])
                linear_extrude(th, center=true)
                    text(currency, size=maxsz-th,
                         font="Liberation Sans:style=Bold",
                         halign="center", valign="center");
    }
}

if(currency == "EUR")
    plate(EUR);
else if(currency == "AED")
    plate(AED);
