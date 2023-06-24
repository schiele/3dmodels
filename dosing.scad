// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;
eps=1/128;

fact=2;
height=85;
rad=sqrt(fact*1000/PI);
noz=0.8;

module outline(dents) polygon(concat(
    [[rad+noz, height],
     [0, height],
     [0, -1],
     [rad+noz-1, -1],
     [rad+noz, 0]],
    [for(d=is_list(dents)?dents:[dents:dents:height*fact],
         p=[-1, 0, 1]) if(d/fact<height-1)
             [rad+noz-(p?0:1), d/fact+p]]));

module segment(start, length, dents)
    rotate(start) rotate_extrude(angle=length+eps) outline(dents);

for(a=[0:120:300]) rotate(a) {
    segment( 0, 10, 50);
    segment(10, 10, 10);
    segment(20, 10, 5);
    segment(30, 30, [60, 95, 150]);
    segment(60, 60, 1000);
}
