// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

function points(s, n) =
    let(v=[rands(s.x.x, s.y.x, n), rands(s.x.y, s.y.y, n)])
        [for(i=[0:n-1]) [v.x[i], v.y[i]]];

module voronoi(s, pts, dst, r)
    let(m=max(s.y-s.x))
    for(p=pts) offset(r=r) offset(r=-dst/2-r) difference() {
        children();
        translate(p) for(q=pts)
            let(v=q-p, d=norm(v), a=atan2(v.x, v.y))
                if(d) rotate(-a) translate([-m, d/2]) square(2*m);
    }

bounds=[[-100, -100], [100, 100]];

linear_extrude(10)
difference() {
    circle(r=100);
    voronoi(bounds, points(bounds, 200), 1, 2) circle(r=90);
}
