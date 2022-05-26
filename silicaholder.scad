use <utils.scad>

box=88;
sil=140;
height=35;
th=8;
ch=th/(2+sqrt(2));
hyg=true;
support=true;
eps=1/128;
$fa=1;
$fs=0.2;

difference() {
    for(i=[-1,1]) {
        translate([i*(box/2-th/2),
                   -(hyg?hygoff-hygdep+th:0)/2, 0])
            chamferedcube([
                th,
                2*th + sil + (hyg?hygoff-hygdep+th:0),
                th], center=true, chamfer=ch);
        translate([0, i*(box/2-th/2), 0])
            chamferedcube([box, th, th], center=true,
                          chamfer=ch);
        for(j=[-1,1])
            translate([i*(box/2-th/2),
                       j*(sil/2+th/2), 0]) {
                translate([0, 0, (height+th)/2])
                    chamferedcube([th, th, 2*th+height],
                                  center=true,
                                  chamfer=ch);
                translate([0, 0, height+th])
                    rotate([90,0,90])
                        linear_extrude(th,center=true)
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
            rotate([0,90,0])
                cylinder(box+th, d=3, center=true);
}

hygoff = 14;
hygwdt = 46.5;
hyghgt = 26.5;
hygdep = 15;
hygind = 0.8;
hygindwdt = 10;
hygindhgt = 10;
hygindoff = 0.5;
hygth = 4;

if(hyg)
    translate([0,
               -hygoff+hygdep/2-th-sil/2,
               -th/2+hyghgt/2+hygth]) {
        difference() {
            union() {
                chamferedcube([hygwdt+2*hygth,
                               hygdep,
                               hyghgt+2*hygth],
                              center=true, chamfer=ch);
                translate([0,
                           hygoff-hygdep/2+th+sil/2
                               -(sil/2+th/2)
                               -(hygoff-hygdep+th),
                           th/2-hyghgt/2-hygth])
                    chamferedcube([box, th, th],
                                  center=true,
                                  chamfer=ch);
            }
            cube([hygwdt, hygdep+2*eps, hyghgt],
                 center=true);
            translate([0,hygindoff,0])
                chamferedcube([hygwdt+2*hygind,
                               hygindwdt,
                               hygindhgt],
                              center=true, chamfer=0.5);
        }

        if(support) color("black", 0.1){
        for(i=[-15:10:15])
        translate([i,0,0])
        rotate([90,0,90])
            linear_extrude(0.5, center = true)
                polygon([
                    [-hygdep/2-1, hyghgt/2],
                    [-15, -hyghgt/2-hygth],
                    [-10, -hyghgt/2-hygth],
                    [0, hyghgt/2-1],
                    [10, -hyghgt/2-hygth],
                    [15, -hyghgt/2-hygth],
                    [hygdep/2+1, hyghgt/2],
                ]);
        for(i=[-10,10])
        translate([i,0,0])
        rotate([90,0,90])
            linear_extrude(10.5, center = true) {
                polygon([
                    [-hygdep/2-0.5, hyghgt/2],
                    [-hygdep/2-1, hyghgt/2],
                    [-15, -hyghgt/2-hygth],
                    [-14.5, -hyghgt/2-hygth],
                ]);
                polygon([
                    [14.5, -hyghgt/2-hygth],
                    [15, -hyghgt/2-hygth],
                    [hygdep/2+1, hyghgt/2],
                    [hygdep/2+0.5, hyghgt/2],
                ]);
            }
        rotate([90,0,90])
            linear_extrude(10.5, center = true)
                polygon([
                    [-0.5, hyghgt/2-0.8],
                    [-10.5, -hyghgt/2-hygth],
                    [-10, -hyghgt/2-hygth],
                    [0, hyghgt/2-1],
                    [10, -hyghgt/2-hygth],
                    [10.5, -hyghgt/2-hygth],
                    [0.5, hyghgt/2-0.8],
                ]);
        for(i=[-1,1]){
        translate([0,i*12.5,0.1-hyghgt/2-hygth])
        cube([hygwdt,5,0.2], center=true);
        }
        }
    }