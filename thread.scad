function segs(r) =
    $fn > 0 ?
        ($fn >= 3 ? $fn : 3) :
        ceil(max(min(360/$fa, r*2*PI/$fs), 5));

module thread(fun, h=1, r=1, d=undef, center=undef, 
              convexity=undef, slices=undef, left=false,
              starts=1)
    let(rr=(d==undef)?r:d/2)
        linear_extrude(h, center=center,
                       convexity=convexity,
                       twist=(left?1:-1)*h*360/fun.y.x/
                             starts,
                       slices=slices)
            polygon([for(i=[0:360/segs(rr):360])
                     [sin(i), cos(i)]*
                     (rr+fun.x((i*starts/360)%1)*fun.y.y)]);

module threadcut(fun, h=1, r=1, d=undef, center=undef, 
                 slices=undef, starts=1)
    let(rr=(d==undef)?r:d/2)
        translate([0,center?-h/2:0]) polygon([
            for(i=[0:h/((slices==undef)?segs(h):slices):h])
                [(rr+fun.x((i/fun.y.x)%1)*fun.y.y), i],
            
            for(i=[h:-h/((slices==undef)?segs(h):slices):0])
                [-(rr+fun.x((i/fun.y.x+(starts%2)/2)%1)*fun.y.y), i]
        ]);

function triangle(s=[2, 1]) =
    [function(i) (i<0.5?2*i-1:1-2*i)+0.5, s];
function sine(s=[PI, 1]) = [function(i) sin(i*360)/2, s];
function square(s=[2, 1]) = [function(i) (i<0.5?-1:1)/2, s];
function sawtooth(s=[1, 1]) = [function(i) i-0.5, s];
function ctriangle(w=1, a=45, a1=undef, a2=undef, r=0.5, r1=undef, r2=undef, s=[1, 1]) =
    let(aa1=(a1==undef)?a:a1, aa2=(a2==undef)?a:a2,
        rr1=(r1==undef)?r:r1, rr2=(r2==undef)?r:r2, 
        p1=[sin(aa1)*rr1,(1-cos(aa1))*rr1],
        p2=[sin(aa1)*rr2,(1-cos(aa1))*rr2],
        p3=[sin(aa2)*rr2,(1-cos(aa2))*rr2],
        p4=[sin(aa2)*rr1,(1-cos(aa2))*rr1],
        mx=aa1==90 ? rr1+rr2 :
           aa2==90 ? w-rr1-rr2 :
           (p3.y + p4.y - p1.y - p2.y +
            (p1.x + p2.x) * tan(aa1) +
            (w - p3.x - p4.x) * tan(aa2)) /
            (tan(aa1) + tan(aa2)),
        m=[mx, aa1<90 ?
            (mx-p1.x-p2.x)*tan(aa1)+p1.y+p2.y-rr2 :
            (w-mx-p3.x-p4.x)*tan(aa2)+p3.y+p4.y-rr2])
    [function(i) (
        i<=p1.x ?
            (rr1==0 ? 0 : rr1*(1-cos(asin(i/rr1)))) :
        i>=1-p4.x ?
            (rr1==0 ? 0 : rr1*(1-cos(asin((i-1)/rr1)))) :
        i<m.x-p2.x ?
            (i-p1.x)*tan(aa1)+p1.y:
        i>m.x+p3.x ?
            (1-i-p4.x)*tan(aa2)+p4.y :
            m.y+(rr2==0 ? 0 : rr2*cos(asin((i-m.x)/rr2)))),
     s, [p1,p2,p3,p4,m]];
    
module curve(fun)
    polygon([for(i=[0:1/segs(fun.y.x):1])
             [i*fun.y.x, (0+fun.x(i)*fun.y.y)]]);


let(r=0.0, tol=0.0) {
style=ctriangle(a1=45, a2=90, r1=0, r2=0);
//style=triangle();
//style=square();
echo(style.z);
if(0){
translate([20, 0, 0]) difference() {
    thread(style, 20, r=5, starts=1, convexity=2);
    rotate_extrude() polygon([
        [0, -4], [4, 0], [5, 1], [5, 3], [7, 5], [7, 0]]);
}
difference() {
    translate([0, 0, 10]) cube(20, center=true);
    rotate_extrude() polygon([
        [8+tol, -1], [6+tol, 1], [6+tol, 3],
        [0, 9], [0, -1]]);
    translate([0, 0, 1])
        thread(style, 20, r=5+tol, starts=1, convexity=2);
}
}
threadcut(style, 2, r=0, starts=1);
if(0)
difference() {
    //translate([0, 10]) square([20, 10], center=true);
    translate([0, 0, 10]) cube([20, 20, 10], center=true);
    thread(ctriangle(r1=r, r2=r+tol), 20, r=5.5+tol*sqrt(2));
    //threadcut(ctriangle(r1=r, r2=r+tol), 20, r=5.5+tol*sqrt(2));
}
//curve(ctriangle(r=r));
}
$fa=1;
$fs=0.01;
