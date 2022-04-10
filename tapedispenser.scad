$fa=1;
$fs=0.2;

eps = 0.01;
th = 2;
cutth = 2;
h = 21;
id = 25;
od = 40;

module wall(h, d, th=th, inner=false,
        anglestart=0, angleend=360,
        start=true, end=true, gapstart=0, gapend=0) {
    r = d/2 + (inner ? -1 : 1) * th/2;
    gapunit = asin(th/2/r);
    realgapstart = (gapstart + (start ? 1 : 0));
    realgapend = (gapend + (start ? 1 : 0));
    realanglestart = anglestart + realgapstart*gapunit;
    realangleend = angleend - realgapend * gapunit;

    if(start)
        rotate([0,0,realanglestart])
        translate([r,0,0])
        cylinder(h, d=th, center=true);

    rotate([0,0,realanglestart])
    rotate_extrude(angle=realangleend-realanglestart)
    translate([r,0,0])
    square([th,h], center=true);

    if(end)
        rotate([0,0,realangleend])
        translate([r,0,0])
        cylinder(h, d=th, center=true);
}

module rings() {
    for(i=[30:120:300]) {
        wall(th, id, inner=true,
            anglestart=i+60, angleend=i+120);
        wall(th, od, anglestart=i,
            angleend=i+60);
    }
}

module cleanbox() {
    translate([0,0,-h/2-th/2])
    wall(th, id-2*th, th=od/2-id/2+2*th, start=false, end=false);

    wall(h, od, gapstart=2, gapend=-1);
    wall(h, id, inner=true,
        start=false, end=false);

    translate([0,0,h/2+th/2])
    rotate([0,0,3/2*asin(th/2/(od/2+th/2))])
    rings();
    
    translate([0,0,-h/2-th/2])
    linear_extrude(th, center=true)
    polygon([[od/2+th,0],[od/2+th,-od/2-th],
        [od/4+th/2,-od/4-th/2]]);

    linear_extrude(h+2*th, center=true)
    polygon([
        [(od/2+th/2)/sqrt(2),-(od/2+th/2)/sqrt(2)],
        [(od/2+th*3/2)/sqrt(2),-(od/2-th/2)/sqrt(2)],
        [od/2+th-(3/2-3/4*sqrt(2))*th,
         -od/2+(7/4*sqrt(2)-1-3/2/(1+sqrt(2)))*th],
        [od/2+th,
         -od/2+(-1+sqrt(2)-3/2/(1+sqrt(2)))*th],
        [od/2+th,-od/2-th]]);

    rotate([0,0,-45-asin(th/2/(od/2+3/2*th))])
    translate([od/2+3/2*th,0,0])
    wall(h+2*th, th, start=false, end=false,
        anglestart=90, angleend=180);

    rotate([0,0,-45+asin(3/2*th/(od/2+3/2*th))])
    translate([od/2+3/2*th,0,0])
    wall(h+2*th, th, start=false, end=false,
        anglestart=180,
        angleend=270-asin(3/2*th/(od/2+3/2*th)));

    translate([od/2-1/2*th,
        -od/2-th+(sqrt(2)-3/2/(1+sqrt(2)))*th,0])
    wall(h+2*th, th*2, th=th/2,
        start=false, end=false,
        anglestart=0, angleend=45);
}

module box() {
    difference() {
        cleanbox();
        for(i=[-(h/2+th+cutth):cutth:h/2+th+cutth])
            translate([od/2-cutth/4+th+eps,-od/2-th,i])
            rotate([0,90,0])
            cylinder(cutth/2, d=cutth, center=true, $fn=4);
    }
}

module cover() {
    wall(th, id, th=od/2-id/2, start=false, end=false);
    rings();
    for(i=[30:120:300]) {
        rotate([0,0,i+60+asin(th/2/(od/2+th/2))])
        translate([od/2+th/2,0,0])
        wall(th, th, start=false, end=false,
            anglestart=180, angleend=270);

        rotate([0,0,i-asin(th/2/(od/2+th/2))])
        translate([od/2+th/2,0,0])
        wall(th, th, start=false, end=false,
            anglestart=90, angleend=180);

        rotate([0,0,i+60-asin(th/2/(id/2-th/2))])
        translate([id/2-th/2,0,0])
        wall(th, th, start=false, end=false,
            anglestart=0, angleend=90);

        rotate([0,0,i+asin(th/2/(id/2-th/2))])
        translate([id/2-th/2,0,0])
        wall(th, th, start=false, end=false,
            anglestart=270, angleend=360);
    }
}

translate([0,0,h/2+th])
    box();
translate([od+3*th,0,th/2])
    cover();
