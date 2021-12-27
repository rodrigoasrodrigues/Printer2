// i believe this is remixed from https://www.thingiverse.com/thing:959381/files
//head
include <MCAD/nuts_and_bolts.scad>;
$fn=200;
mode=0; //0-full 1-base part 2-clamp
extruder=1;  // 0 - model 1-additivities
oversize=0.2;
hole_height=23;
detector_diameter=9;
detector_washer=21;
detector_edge=15;
plate_width=50;
fs=100; //round surfaces precision
gopro_mount=true;
gp_mount_fin_width=3;
gp_mount_fin_margin=0.1;
gp_mount_fin_clearance=2;
gp_mount_width=17;
gp_mount_radius=9.8;
gp_mount_spacer_height=4;
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
    translate([6,6,6])rotate([0,0,90])prism(6,20,detector_edge);
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
    //go pro style mount for fan
    if(gopro_mount){
        translate([-gp_mount_width/2,-gp_mount_radius/2,h]){
            difference(){
                group(){
                //base
                cube([gp_mount_width,
                        gp_mount_radius,
                        gp_mount_radius/2+gp_mount_spacer_height]);
                //rouded part
                translate([0,
                            gp_mount_radius/2,
                            gp_mount_radius/2+ gp_mount_spacer_height])
                    rotate([0,90,0])
                        cylinder(h=gp_mount_width,
                                d=gp_mount_radius,
                                $fs=fs);
                }
                //fins
                translate([gp_mount_width/2+
                            gp_mount_fin_width/2-gp_mount_fin_margin/2,
                            gp_mount_radius/2,
                            gp_mount_radius/2+ gp_mount_spacer_height])
                    rotate([0,90,0])
                        cylinder(
                            h=gp_mount_fin_width+gp_mount_fin_margin,
                            d=gp_mount_radius+gp_mount_fin_clearance,
                            $fs=fs);
                
                translate([gp_mount_width/2-3/2*gp_mount_fin_width+
                            gp_mount_fin_margin/2,
                            gp_mount_radius/2,
                            gp_mount_radius/2+ gp_mount_spacer_height])
                    rotate([0,90,0])
                        cylinder(h=gp_mount_fin_width+gp_mount_fin_margin,
                                d=gp_mount_radius+gp_mount_fin_clearance,
                                $fs=fs);
                translate([gp_mount_width-2,
                            gp_mount_radius/2,
                            gp_mount_radius/2+ gp_mount_spacer_height])
                    rotate([0,90,0])
                        nutHole(3);
                translate([2.5,
                            gp_mount_radius/2,
                            gp_mount_radius/2+ gp_mount_spacer_height])
                    rotate([0,90,0])
                        boltHole(3,length=30);
            }
        }
    }
}

if (mode==0)
    full();
else
if (mode==1)
difference(){
    full();
    translate([-30,-10,hole_height])cube([60,20,hole_height*2]);
}
else
if (mode==2){ rotate([0,0,0])translate([0,0,-hole_height])intersection(){
    full();
    translate([-30,-10,hole_height])cube([60,20,50]);
}
}