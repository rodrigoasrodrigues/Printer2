// Go pro style mount
module go_pro_base(){
    include <MCAD/nuts_and_bolts.scad>;
    gp_mount_fin_width=3;
    gp_mount_fin_margin=0.1;
    gp_mount_fin_clearance=2;
    gp_mount_width=17;
    gp_mount_radius=9.8;
    gp_mount_spacer_height=4;
    $fn=50;
    translate([-gp_mount_width/2,-gp_mount_radius/2,0]){
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
                            d=gp_mount_radius);
            }
            //fins
            translate([gp_mount_width/2+
                        gp_mount_fin_width/2-gp_mount_fin_margin/2,
                        gp_mount_radius/2,
                        gp_mount_radius/2+ gp_mount_spacer_height])
                rotate([0,90,0])
                    cylinder(
                        h=gp_mount_fin_width+gp_mount_fin_margin,
                        d=gp_mount_radius+gp_mount_fin_clearance);
            
            translate([gp_mount_width/2-3/2*gp_mount_fin_width+
                        gp_mount_fin_margin/2,
                        gp_mount_radius/2,
                        gp_mount_radius/2+ gp_mount_spacer_height])
                rotate([0,90,0])
                    cylinder(h=gp_mount_fin_width+gp_mount_fin_margin,
                            d=gp_mount_radius+gp_mount_fin_clearance);
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