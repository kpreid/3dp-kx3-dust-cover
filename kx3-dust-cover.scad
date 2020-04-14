// Measured parameters
kx3_width = 190;
kx3_height = 87.2;
kx3_corner_rounding_radius = 1.95;

// Constrained but not maximized parameters
horizontal_inward_clearance = 2;  // max 3 for VFO knob base
vertical_side_jack_clearance = 5;  // max 9 or so depending on accessory plug diameter
panel_control_clearance = 21;
topmost_control_clearance = 4;

// Chosen parameters
vertical_wall_thickness = 0.8;
horizontal_wall_thickness = 0.4;
epsilon = 0.02;


difference() {
    main();
    translate([0, 0, -500])
    cube([1000, 1000, 1000]);
}


module main() {
    difference() {
        exterior_volume();
        interior_volume();
    }
}

module interior_volume() {
    // Rim
    mirror([0, 0, 1])
    translate([0, 0, -epsilon])
    linear_extrude(vertical_side_jack_clearance + epsilon * 2)
    offset(r=kx3_corner_rounding_radius, $fn=30)
    offset(delta=-kx3_corner_rounding_radius)
    square([kx3_width, kx3_height], center=true);
    
    // Volume for panel controls
    panel_clearance_volume();
}

module exterior_volume() {
    // Rim
    mirror([0, 0, 1])
    translate([0, 0, -horizontal_wall_thickness])
    hull() {
        rim_outer_radius = kx3_corner_rounding_radius + vertical_wall_thickness;
        linear_extrude(vertical_side_jack_clearance + horizontal_wall_thickness)
        offset(r=rim_outer_radius, $fn=30)
        offset(delta=-rim_outer_radius)
        rim_2d();
        
        // create 45° overhang support
        translate([0, 0, -horizontal_inward_clearance])
        linear_extrude(epsilon)
        panel_2d();
    }
    
    // Volume for panel controls
    minkowski() {
        cube([vertical_wall_thickness, vertical_wall_thickness, horizontal_wall_thickness] * 2, center=true);
        panel_clearance_volume();
    }
    
    module panel_2d() {
        square([
            kx3_width - horizontal_inward_clearance * 2 + vertical_wall_thickness * 2, 
            kx3_height - horizontal_inward_clearance * 2 + vertical_wall_thickness * 2
        ], center=true);
    }
    
    module rim_2d() {
        square([kx3_width + vertical_wall_thickness * 2, kx3_height + vertical_wall_thickness * 2], center=true);
    }
}

module panel_clearance_volume() {
    linear_extrude(panel_control_clearance)
    square([
        kx3_width - horizontal_inward_clearance * 2,
        kx3_height - horizontal_inward_clearance * 2
    ], center=true);
}