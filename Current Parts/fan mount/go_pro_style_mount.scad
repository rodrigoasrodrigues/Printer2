// Go pro style mount
include <MCAD/nuts_and_bolts.scad>;
gp_mount_fin_width=3;
gp_mount_fin_margin=0.1;
gp_mount_fin_clearance=2;
gp_mount_width=17;
gp_mount_radius=9.8;
gp_mount_spacer_height=4;
module go_pro_base(){
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

module go_pro_mount(){
    $fn=50;
    go_fin_hole=gp_mount_fin_width+gp_mount_fin_margin;
    go_fin_space= gp_mount_fin_width-gp_mount_fin_margin;
    go_attach_width=go_fin_hole*2+go_fin_space;
    translate([-go_attach_width/2,-gp_mount_radius/2,0]){
        difference()
        {
            group(){
            //base
            cube([go_attach_width,
                    gp_mount_radius,
                    gp_mount_radius/2+gp_mount_spacer_height]);
            //rouded part
            translate([0,
                        gp_mount_radius/2,
                        gp_mount_radius/2+ gp_mount_spacer_height])
                rotate([0,90,0])
                    cylinder(h=go_attach_width,
                            d=gp_mount_radius);
            }
            //cut / space
            translate(
                [go_fin_hole,
                 gp_mount_radius/2,
                 gp_mount_radius/2+gp_mount_spacer_height
                ])
                rotate([0,90,0])
                    cylinder(h=go_fin_space,
                             d=gp_mount_radius+gp_mount_fin_clearance);
            // bolt
            translate([-5,
                        gp_mount_radius/2,
                        gp_mount_radius/2+ gp_mount_spacer_height])
                rotate([0,90,0])
                    boltHole(3,length=30);
        }
                        
    }
}

module go_pro_fan_mount(){
    $fn=50;
    fan_fin=3.4;
    fan_space=3.4;
    fan_base=15;
    translate([-fan_base/2,-gp_mount_radius/2,0]){
        difference()
        {
            group(){
            //base
            cube([fan_base,
                    gp_mount_radius,
                    gp_mount_radius/2+gp_mount_spacer_height]);
            //rouded part
            translate([0,
                        gp_mount_radius/2,
                        gp_mount_radius/2+ gp_mount_spacer_height])
                rotate([0,90,0])
                    cylinder(h=fan_base,
                            d=gp_mount_radius);
            }
            //fins
            translate([fan_base/2+
                        fan_space/2,
                        gp_mount_radius/2,
                        gp_mount_radius/2+ gp_mount_spacer_height])
                rotate([0,90,0])
                    cylinder(
                        h=fan_fin+gp_mount_fin_margin,
                        d=gp_mount_radius+gp_mount_fin_clearance);
            
            translate([fan_base/2-fan_fin-fan_space/2,
                        gp_mount_radius/2,
                        gp_mount_radius/2+ gp_mount_spacer_height])
                rotate([0,90,0])
                    cylinder(h=fan_fin+gp_mount_fin_margin,
                            d=gp_mount_radius+gp_mount_fin_clearance);

            translate([-5,
                        gp_mount_radius/2,
                        gp_mount_radius/2+ gp_mount_spacer_height])
                rotate([0,90,0])
                    boltHole(3,length=30);
        }
    }
}

