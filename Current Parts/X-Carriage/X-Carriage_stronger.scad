
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
include <MCAD/nuts_and_bolts.scad>;
aprox_carriage_w=50 ;
h=30;
$fn=50;
difference(){
    import("../X-Carriage/X-Carriage_stronger.stl", convexity=3);

    //base holes
    translate([-aprox_carriage_w/2,6,0])
    {
        translate([15,0,-6-0.1])cylinder(h,r=1.6);
        translate([-15,0,-6-0.1])cylinder(h,r=1.6);
        translate([0,0,-6-0.1])cylinder(h,r=1.6);
        translate([0,-13,-6-0.1])cylinder(h,r=1.6);
    }
}