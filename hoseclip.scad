th = 2;
tube = 18;
width = 20;
clipheight = 21.5;
clipdep = 32;
snap = (clipheight-th)/2;

// minimum angle for a fragment
$fa=1;
// minimum size of a fragment
$fs=0.2;

linear_extrude(width, center=true) {
    polygon([
        [tube/2             , clipheight/2+th  ],
        [tube/2             ,-clipheight/2-th  ],
        [tube/2+clipdep+2*th,-clipheight/2-th  ],
        [tube/2+clipdep+2*th,-clipheight/2+snap],
        [tube/2+clipdep+  th,-clipheight/2+snap],
        [tube/2+clipdep+  th,-clipheight/2     ],
        [tube/2+          th,-clipheight/2     ],
        [tube/2+          th, clipheight/2     ],
        [tube/2+clipdep+  th, clipheight/2     ],
        [tube/2+clipdep+  th, clipheight/2-snap],
        [tube/2+clipdep+2*th, clipheight/2-snap],
        [tube/2+clipdep+2*th, clipheight/2+th  ],
    ]);
    for(i=[-120,120])
        rotate([0,0,i])
            translate([tube/2 + th/2,0])
                circle(d=th);
    difference() {
        circle(d=tube+2*th);
        circle(d=tube);
        translate([-tube/2-2*th,0])
            circle(d=tube+4*th, $fn=6);
    }
}

%cylinder(2*width, d=tube, center=true);
