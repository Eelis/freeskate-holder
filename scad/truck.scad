include <constants.scad>

module truck_frame_profile() {
    polygon(points =
              [[-truck_frame_top_length / 2, 0],
               [-truck_middle_length / 2, truck_middle_height],
               [-truck_bottom_length / 2, truck_frame_height],
               [truck_bottom_length / 2, truck_frame_height],
               [truck_middle_length / 2, truck_middle_height],
               [truck_frame_top_length / 2, 0]
               ] );
}

module truck_frame_side() {
    translate([0,
               truck_full_width / 2 - truck_sheet_thickness,
               0])
        rotate([270, 0, 0])
            difference() {
                linear_extrude(height = truck_sheet_thickness)
                    truck_frame_profile();
                translate([0, 7, -epsilon])
                linear_extrude(height = truck_sheet_thickness + epsilon * 2)
                    scale(0.7)
                        truck_frame_profile();
            }
}

module truck_frame_connection() {
    color("grey")
        cube([truck_frame_top_length,
              truck_full_width + 4,
              truck_frame_connection_width], center=true);
}

module truck_frame() {
    truck_frame_side();
    mirror([0, 1, 0]) truck_frame_side();

    translate([0, 0, -truck_sheet_thickness / 2])
        cube([truck_frame_top_length - 10,
              truck_full_width - 2 * truck_sheet_thickness + epsilon * 2,
              truck_sheet_thickness], center=true);

    translate([0, 0, -truck_frame_height + truck_sheet_thickness / 2])
        cube([26,
              truck_full_width - 2 * truck_sheet_thickness + epsilon * 2,
              truck_sheet_thickness], center=true);
}

module truck() {
    color("#b0b0b0")
        translate([0, 0, -truck_frame_connection_width])
        truck_frame();
    translate([0, 0, -truck_frame_connection_width / 2])
        truck_frame_connection();
}

truck();
