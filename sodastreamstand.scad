// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

rows=1; // [1:10]
cols=2; // [1:10]
th=2; // [0.1:0.1:10]
tol=1; // [0.0:0.1:3]
gap=th+tol;
preview=$preview;

module bottlecut()
for (i=[0,1]) mirror([i,0])
difference() {
    intersection() {
        translate([95/2-250, 90+th]) circle(r=250);
        square(90);
    }
    translate([0,11+th-40]) circle(r=39);
    square([80,th]);
}

module card(n, cuttop=false)
linear_extrude(th, center=true)
difference() {
    hull() for (i=[-1,1], j=[7,80])
        translate([i*((95*n+2*th*(n+1))/2-7),j]) circle(r=7);
    for (i=[1-n:2:n-1]) translate([i*(95/2+th),0]) {
        bottlecut();
        translate([0, cuttop?(11+th/2):0])
            square([gap, 11+th/2], center=true);
        for(j=[0,1], pos=[30, 80])
            translate([0, pos-(th+tol/2)]) mirror([j, 0])
                translate([95/2+th+(pos<50?-20-7:
                    (i>1-n && j==1 || i<n-1 && j==0 ) ? th/2:0), 0])
                    square((i>1-n && j==1 || i<n-1 && j==0) ?
                        [20, 90] : [20, gap]);
    }
}

module ring(m, n, pos) {
    linear_extrude(th, center=true) difference() {
        hull() for (i=[1-n:2:n-1], j=[1-m:2:m-1])
            translate([i, j]*(95/2+th)) circle(95/2+2*th);
        for (i=[1-n:2:n-1], j=[1-m:2:m-1]) translate([i,j]*(95/2+th)) {
            hull() projection() rotate_extrude()
                intersection() {
                    projection(cut=true) translate([0, 0, -pos])
                        rotate([90, 0, 0]) linear_extrude(th)
                            bottlecut();
                    translate([0, -40]) square(80);
                }
            for(k=[90:90:360]) rotate(k)
                if (i>1-n && k==90 || j>1-m && k==180)
                    translate([0, 95/2+th])
                        square([gap, pos<50?14+tol:gap], center=true);
                else if(i<n-1 && k==270 || j<m-1 && k==360);
                else
                    translate([0, 95/2+th+(pos<50?10-7:-10)])
                        square([gap, 20], center=true);
        }
    }
}

if(preview) {
    for(i=[1-rows:2:rows-1]) translate([0, i*(95/2+th), 0])
        rotate([90, 0, 0]) card(cols);
    for(i=[1-cols:2:cols-1]) translate([i*(95/2+th), 0, 0])
        rotate([90, 0, 90]) card(rows, true);
    for(i=[30, 80]) translate([0, 0, i-th/2]) ring(rows, cols, i);
} else {
    for(i=[1-rows:2:rows-1]) translate([i*((95/2+th)*cols+th+1),0, 0])
        card(cols);
    for(i=[1-cols:2:cols-1]) translate([i*((95/2+th)*rows+th+1),90, 0])
        card(rows, true);
    for(i=[0,1])
        translate([(i*2-1)*((95/2+th)*rows+th+1),
                   -((95/2+th)*cols+th+1), 0])
            rotate(90) ring(rows, cols, i ? 80 : 30);
}
