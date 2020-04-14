// Measured parameters
kx3_width = 190;
kx3_height = 88;
kx3_corner_rounding_radius = 1.95;

// Constrained but not maximized parameters
horizontal_inward_clearance_bottom = 2;  // max 3 for VFO knob base
horizontal_inward_clearance_top = 4;
vertical_side_jack_clearance = 8;  // max 9 or so depending on accessory plug diameter
panel_control_clearance_height = 21;

// Chosen parameters
vertical_wall_thickness = 0.8;
horizontal_wall_thickness = 0.6;  // three layers to ensure good fusion of the logo
epsilon = 0.02;


printable();


module printable() {
    rotate([180, 0, 0]) main();
}

module preview() {
    difference() {
        main();
        translate([0, 0, -500])
        cube([1000, 1000, 1000]);
    }
}

module main() {
    difference() {
        exterior_volume();
        interior_volume();
        
        label_cut();
    }
}

module label_cut() {
    // Times appears to be the font used for the Elecraft and KX3 branding (in small-caps)
    translate([2 /* fudge */, 0, panel_control_clearance_height - epsilon])
    linear_extrude(horizontal_wall_thickness * 2)
    text("KX3", spacing=1.1, size=kx3_width * 0.31, font="Times", halign="center", valign="center");
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
        corner_round(rim_outer_radius)
        rim_2d();
        
        // create 45° overhang support
        // Precise form of this would be matching the slope of the horizontal clearance but that would be a line intersection problem, so fudge it.
        overhang_inset = horizontal_inward_clearance_bottom * 1.6;
        translate([0, 0, -overhang_inset])
        linear_extrude(epsilon)
        offset(delta=-overhang_inset)
        rim_2d();
    }
    
    // Volume for panel controls
    minkowski() {
        // Shape for top bevel and side walls — a pyramid
        hull() {
            linear_extrude(epsilon)
            square([1, 1] * vertical_wall_thickness * 2, center=true);

            // 45° chamfered top
            chamfer = horizontal_wall_thickness;
            linear_extrude(chamfer)
            offset(delta=-chamfer)
            square([1, 1] * vertical_wall_thickness * 2, center=true);
        }
        panel_clearance_volume();
    }
    
    module panel_2d() {
        square([
            kx3_width - horizontal_inward_clearance_bottom * 2 + vertical_wall_thickness * 2, 
            kx3_height - horizontal_inward_clearance_bottom * 2 + vertical_wall_thickness * 2
        ], center=true);
    }
    
    module rim_2d() {
        square([kx3_width + vertical_wall_thickness * 2, kx3_height + vertical_wall_thickness * 2], center=true);
    }
}

module panel_clearance_volume() {
    hull() {
        // bottom
        linear_extrude(epsilon)
        corner_round(1)
        square([
            kx3_width - horizontal_inward_clearance_bottom * 2,
            kx3_height - horizontal_inward_clearance_bottom * 2,
        ], center=true);

        // top (bottom as printed)
        translate([0, 0, panel_control_clearance_height])
        mirror([0, 0, 1])
        linear_extrude(epsilon)
        corner_round(1)
        square([
            kx3_width - horizontal_inward_clearance_top * 2,
            kx3_height - horizontal_inward_clearance_top * 2,
        ], center=true);
    }
}

module corner_round(r) {
    offset(r=r, $fn=30)
    offset(delta=-r)
    children();
}