//head
include <MCAD/nuts_and_bolts.scad>;
include <../fan mount/go_pro_style_mount.scad>;
$fn=250;
mode=0; //0-full 1-base part 2-clamp
extruder=0;  // 0 - model 1-additivities
oversize=0.2;
hole_height=18;
bltouch_hole=3.5;
bltouch_w=11+6;
bltouch_dist=14.4+bltouch_hole;
bltouch_l=bltouch_dist+12;
gopro_mount=true;
gp_mount_fin_width=3;
gp_mount_fin_margin=0.1;
gp_mount_fin_clearance=2;
gp_mount_width=17;
gp_mount_radius=9.8;
gp_mount_spacer_height=4;
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
    plate=26;
    difference(){
        translate([0,25,6])cube([6,6+4,15]);
        translate([0,25+6+10,6+28]) rotate([180,0,0]) prism(10,7.5,28);
    }
    //translate([-3,0,plate])prism(6,6,6);
    //translate([6,25,6])prism(6,10,15);
    translate([0,25,6])rotate([0,0,-90])prism(6,20,15);
    translate([0,25,0])rotate([90,0,0])prism(6,-bltouch_w,20);
    translate([0,25+6,0])rotate([90,0,180])prism(6,bltouch_w,24);
    // CLAMP
    translate([-bltouch_w,25,0])difference(){
        cube([bltouch_w,6,6+bltouch_l]);
        //bltouch
        translate([bltouch_w/2,-0.1,bltouch_l])rotate([-90,0,0])cylinder(6.2,d=bltouch_hole);
        translate([bltouch_w/2,-0.1,12])rotate([-90,0,0])cylinder(6.2,d=bltouch_hole);
        
        //side cuts        
        translate([-0.1,-0.1,6+bltouch_l+0.1])rotate([0,90,0])prism(6.2,6,6);
        translate([bltouch_w+0.1,-0.1,6+bltouch_l+0.1])rotate([0,180,0])prism(6.2,6,6);
    }
}
module full (){
    h=28;
    w=50;
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
              translate([0,5,0])
            cube([w,plate-5,6]);
            translate([w+0.1,-0.1,-0.1])rotate([90,0,180])prism(6.2,20,30);
          }
          detector_clamp();
        }
    }
    translate([0,-9,hole_height])rotate([-90,0,0])head_hole(5);
    
    for (s=[-12,12]){
        translate([s,0,-6-0.1]){ cylinder(h+6,r=1.6); nutHole(3); }
        translate([s,0,h-3])cylinder(3.1,r=2.75);
    }
    //base holes
    translate([0,-base-2,0])
    {
        translate([15,0,-6-0.1])cylinder(6.2,r=1.6);
        translate([-15,0,-6-0.1])cylinder(6.2,r=1.6);
        translate([0,0,-6-0.1])cylinder(6.2,r=1.6);
        translate([0,-13,-6-0.1])cylinder(6.2,r=1.6);
    }
    
    }
    //go pro style mount for fan
    if(gopro_mount){
        translate([0,0,h]) go_pro_base();
    }

}

if (mode==0)
    full();
else
if (mode==1)
difference(){
    full();
    translate([-22,-10,hole_height])cube([60,20,hole_height+20]);
}
else
if (mode==2){ 
    translate([0,0,-hole_height])intersection(){
        full();
        translate([-22,-10,hole_height])cube([60,20,hole_height+30]);
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

