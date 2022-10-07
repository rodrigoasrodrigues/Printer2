ext_length=15;
ext_thichness=9.8;
include <go_pro_style_mount.scad>;

module prism(l, w, h) {
	translate([0, l, 0]) rotate( a= [90, 0, 0]) 
	linear_extrude(height = l) polygon(points = [
		[0, 0],
		[w, 0],
		[0, h]
	], paths=[[0,1,2,0]]);
}

rotate([90,0,0]){
translate([-ext_thichness/2,-ext_thichness/2,0])
    cube([ext_thichness,ext_thichness,ext_length]);
translate([0,0,ext_length])
go_pro_mount();
    
}
rotate([-90,0,0]){
    go_pro_fan_mount();
}

//reinforcements

//larger
translate([ext_thichness/2,0,-ext_thichness/2])
rotate([90,0,0])
translate([0,0,0])
prism(ext_thichness,15/2-ext_thichness/2,5);


translate([-ext_thichness/2,0,-ext_thichness/2])
rotate([90,0,0])
translate([0,0,0])
prism(ext_thichness,-15/2+ext_thichness/2,5);

//thinner
translate([-ext_thichness/2+15/2-ext_thichness/2,-ext_length,-ext_thichness/2])
rotate([90,0,0])
translate([0,0,0])
prism(ext_thichness,-15/2+ext_thichness/2,5);

translate([ext_thichness/2-15/2+ext_thichness/2,-ext_length,-ext_thichness/2])
rotate([90,0,0])
translate([0,0,0])
prism(ext_thichness,15/2-ext_thichness/2,5);