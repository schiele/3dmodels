$fa=1;
$fs=0.2;

th = 1.2;
cutth = 2;
h = 21;
id = 25;
od = 40;
knife = 10;
knifesp = 0.4;

spikeang=acos((od/2+th)/(od/2+th+knife));

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

module smooth(h, d, inner=false, counter=false,
        angle=0, extra=0) {
    gap = ((counter!=inner)?-1:1) *
          asin((extra+th/2)/(d/2+(inner?-1:1)*th/2));
    rotate([0,0,angle+gap])
    translate([d/2+(inner?-1:1)*th/2,0,0])
    wall(h, th, start=false, end=false,
         anglestart=(inner ? (counter ? (270-gap) : 0) :
                             (counter ? (90-gap) : 180)),
         angleend=(inner ? (counter ? 360 : (90-gap)) :
                           (counter ? 180 : (270-gap))));
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
    polygon([
        [od/2+th,0],
        [od/2+th,-tan(spikeang)*(od/2+th)+th/2],
        [cos(spikeang)*(od/2),
            -sin(spikeang)*(od/2)]]);

    linear_extrude(h+2*th, center=true)
    hull() {
        translate([
            od/2+th-th/sin(spikeang)+tan(spikeang/2)*th/2,
            th/2-tan(spikeang)*(od/2+th)])
        circle(d=th);
        translate([od/2+th/2,
            -tan(spikeang)*(od/2+th)+th/2])
        circle(d=th);
        translate([od/2+th/2,
            -tan(spikeang)*(od/2+th)+th/cos(spikeang)
                -tan((90-spikeang)/2)*th/2])
        circle(d=th);
        translate([
            cos(spikeang)*(od/2+th)+sin(spikeang)*th/2,
            -sin(spikeang)*(od/2+th)+cos(spikeang)*th/2])
        circle(d=th);
        translate([
            cos(spikeang)*(od/2+th)-sin(spikeang)*th/2,
            -sin(spikeang)*(od/2+th)-cos(spikeang)*th/2])
        circle(d=th);
    }

    smooth(h+2*th, od+2*th, angle=-spikeang, extra=th, counter=true);
    smooth(h+2*th, od+2*th, angle=-spikeang, extra=th);
}

module box() {
    difference() {
        cleanbox();
        rotate([0,0,-spikeang])
        translate([(od/2+th)+knife/2,0,0])
        cube([knife,knifesp,h+knifesp], center=true);
    }
}

module cover() {
    wall(th, id, th=od/2-id/2, start=false, end=false);
    rings();
    for(i=[30:120:300]) {
        smooth(th, od, angle=i+60);
        smooth(th, od, angle=i, counter=true);
        smooth(th, id, angle=i+60, inner=true);
        smooth(th, id, angle=i, inner=true, counter=true);
    }
}

translate([0,0,h/2+th])
    box();
translate([od+3*th,0,th/2])
    cover();
