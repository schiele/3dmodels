// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

d=55;
id=49;
g=1;
gd=id-2*g;
w=11.8;
iw=w-1.5;
gw=w-5;

l=[[d, w], [id, w], [id, iw], [gd, gw]]/2;

rotate_extrude() intersection() {
    circle(d=d);
    polygon(concat(l,
        [for (i = [len(l)-1:-1:0]) [l[i].x, -l[i].y]]));
}
