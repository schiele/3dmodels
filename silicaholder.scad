use <utils.scad>

box=88;
sil=140;
height=35;
th=8;
ch=th/(2+sqrt(2));
$fa=1;
$fs=0.2;

difference() {
for(i=[-1,1]) {
    translate([i*(box/2-th/2), 0, 0]) chamferedcube([th, 2*th + sil, th], center=true, chamfer=ch);
    translate([0, i*(box/2-th/2), 0]) chamferedcube([box, th, th], center=true, chamfer=ch);
    for(j=[-1,1])
        translate([i*(box/2-th/2), j*(sil/2+th/2), 0]) {
        translate([0, 0, (height+th)/2])
    chamferedcube([th, th, 2*th+height], center=true, chamfer=ch);
    translate([0, 0, height+th])
    rotate([90,0,90]) linear_extrude(th,center=true)
    polygon([
            [-th/2,th/2-ch],
            [ch-th/2,th/2],
            [th/2-ch,th/2],
            [th/2,th/2-ch],
            [th/2,ch-th/2],
            [th/2-ch,-th/2],
            [ch-th/2,-th/2],
            [-th/2,ch-th/2],
            ]);
        }
}
for(i=[-1,1])
    translate([0, i*(sil/2+th/2), height+th])
    rotate([0,90,0]) cylinder(box+th, d=3, center=true);
}
