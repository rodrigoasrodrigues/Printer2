//head
include <MCAD/nuts_and_bolts.scad>;
$fn=50;
mode=1; //0-full 1-base part 2-clamp
extruder=0;  // 0 - model 1-additivities
oversize=0.2;
hole_height=18+5;
detector_diameter=18;
detector_washer=1+31;
detector_edge=15;
plate_width=50;
echo ("Y_PROBE_OFFSET_FROM_EXTRUDER =",(hole_height-detector_washer/2));
echo ("X_PROBE_OFFSET_FROM_EXTRUDER =",-(plate_width/2+detector_washer/2));
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
module head_hole(cap=6){
  inner=5.6; //v5
  //inner=6;   //v6
  top=3.7;
  bottom=3;
    translate([0,0,bottom+inner+top-0.1])cylinder(5,r=cap+oversize);
    translate([0,0,bottom+inner])cylinder(top,r=8+oversize);
    translate([0,0,bottom-0.1])cylinder(inner+0.2,r=6+oversize);
    translate([0,0,-0.1])cylinder(bottom+0.1,r=8+oversize);
}
module detector_clamp(){
    translate([0,0,6])cube([6,6,detector_edge]);
    translate([6,0,6])prism(6,10,detector_edge);
    translate([6,6,6])rotate([0,0,90,0])prism(6,20,detector_edge);
    translate([0,6,0])rotate([90,0,180])prism(6,detector_washer,40-6);
    translate([-detector_washer,0,0])difference(){
        cube([detector_washer,6,6+detector_washer]);
        translate([detector_washer/2,-0.1,detector_washer/2+6])rotate([-90,0,0])cylinder(6.2,d=detector_diameter);
        translate([-0.1,-0.1,detector_washer+6+0.1])rotate([0,90,0])prism(6.2,6,6);
        translate([detector_washer+0.1,-0.1,detector_washer+6+0.1])rotate([0,180,0])prism(6.2,6,6);
    }
}
module full (){
    h=28+7;
    w=plate_width;
    base=11;
    plate=55;
difference(){
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
    translate([0,-9,hole_height])rotate([-90,0,0])head_hole(6);
    
    for (s=[-12,12]){
        translate([s,0,-6-0.1]){ cylinder(h+6,r=1.6); nutHole(3); }
        translate([s,0,h-3])cylinder(3.1,r=3);
    }
    //base holes
    translate([0,-base,0])
    {
        translate([15,0,-6-0.1])cylinder(6.2,r=1.6);
        translate([-15,0,-6-0.1])cylinder(6.2,r=1.6);
        translate([0,-25,-6-0.1])cylinder(6.2,r=1.6);
    }
    //translate([0,-21,-6-0.1])cylinder(6.2,r=9);    
}
}

if (mode==0)
    full();
else
if (mode==1)
difference(){
    full();
    translate([-30,-10,hole_height])cube([60,20,hole_height]);
}
else
if (mode==2){ rotate([0,180,0])translate([0,0,-hole_height])intersection(){
    full();
    translate([-30,-10,hole_height])cube([60,20,hole_height]);
}
}
if (extruder==1)
	translate([0,0,hole_height]){
	translate([-0,-60,0])
	rotate([0,-90,0])
	translate([-8.7,0,-15.85])import("E3D V6 1.75 Uni model.STL", convexity=3);

	translate([0,-25,0])
	rotate([90,-90,0])
	translate([15.9,-2.5,-25])scale(0.85)import("E3D_Duct_wo_Plate.stl", convexity=3);

	translate([5,-29.5,13])rotate([90,-90,0])
	mirror()rotate([0,32.5,0])
	translate([2,3,-35-15])import("E3D_Fan_Nozzle_v2.stl", convexity=3);
}

