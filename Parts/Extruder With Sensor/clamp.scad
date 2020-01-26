//head
include <MCAD/nuts_and_bolts.scad>;
$fn=50;
mode=0;
oversize=0.1;
//subs
module prism(l, w, h) {
	translate([0, l, 0]) rotate( a= [90, 0, 0]) 
	linear_extrude(height = l) polygon(points = [
		[0, 0],
		[w, 0],
		[0, h]
	], paths=[[0,1,2,0]]);
}
module trapeze(w1,w2,d,h){
    down=min(w1,w2);
    low=abs(w1-w2)/2;
    translate([down/-2,d/-2,0]){
        cube([down,d,h]);
        prism(d,-low,h);
    }
    translate([down/2,d/-2,0])prism(d,low,h);
}

//hotend
module head_hole(cap=5){
    translate([0,0,3+6+3.7-0.1])cylinder(5,r=cap+oversize);
    translate([0,0,3+6])cylinder(3.7,r=8+oversize);
    translate([0,0,3-0.1])cylinder(6.0+0.2,r=6+oversize);
    translate([0,0,-0.1])cylinder(3.0+0.1,r=8+oversize);
}
module detector_clamp(){
    plate=22;
    translate([0,0,6])cube([6,6,15]);
    //translate([-3,0,plate])prism(6,6,6);
    translate([6,0,6])prism(6,15,15);
    translate([6,6,6])rotate([0,0,90,0])prism(6,20,15);
    translate([0,6,0])rotate([90,0,180])prism(6,plate,40-6);
    translate([-plate,0,0])difference(){
        cube([plate,6,6+plate]);
        translate([plate/2,-0.1,plate/2+6])rotate([-90,0,0])cylinder(6.2,r=6.2);
        translate([-0.1,-0.1,plate+6+0.1])rotate([0,90,0])prism(6.2,6,6);
        translate([plate+0.1,-0.1,plate+6+0.1])rotate([0,180,0])prism(6.2,6,6);
    }
}
module full (){
difference(){
    h=26;
    w=50;
    base=15;
    plate=62;
    union(){
        trapeze(w,w-2*h*tan(15),12,h);
        translate([0,12/-2,h/2])rotate([90,0,0])trapeze(22+3*2,22,h,3);
        translate([0,6,0])
            intersection(){
                rotate([0,0,90])translate([0,-w/2,0])prism(w,9,9);
                translate([0,9/2,0])trapeze(w,w-2*h*tan(15),9,h);
            }
        //plate
        translate([-w/2,-plate+9+6,-6])
         {
          difference(){
            cube([w,plate,6]);
            translate([w+0.1,-0.1,-0.1])rotate([90,0,180])prism(6.2,20,30);
          }
          detector_clamp();
        }
    }
    translate([0,-9,15])rotate([-90,0,0])head_hole(5);
    
    for (s=[-12,12]){
        translate([s,0,-6-0.1]){ cylinder(h+6,r=1.6); nutHole(3); }
        translate([s,0,h-3])cylinder(3.1,r=2.75);
    }
    //base holes
    translate([0,-base,0])
    {
        translate([15,0,-6-0.1])cylinder(6.2,r=1.6);
        translate([-15,0,-6-0.1])cylinder(6.2,r=1.6);
        translate([0,-25,-6-0.1])cylinder(6.2,r=1.6);
    }
    
}
}
if (mode==0)
    full();
else
if (mode==1)
difference(){
    full();
    translate([-30,-10,15])cube([60,20,15]);
}
else translate([0,0,-15])intersection(){
    full();
    translate([-30,-10,15])cube([60,20,15]);
}