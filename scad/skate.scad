include <constants.scad>
use <util.scad>
use <truck.scad>

bracket_thickness = 1.5;
wheel_width = 43;
wheel_radius = 36;

module deck() {
    r = 40;
    bracket_width = 14;

    color("#b0b0b0")
        translate([bracket_width,
                   bracket_width,
                   bracket_thickness])
            rounded_cube(skate_width - bracket_width * 2 + epsilon,
                         skate_length - bracket_width * 2 + epsilon,
                         deck_thickness - bracket_thickness * 2,
                         r - bracket_width + epsilon);

    // rubber bracket:
    color("#303030")
        difference() {
            rounded_cube(skate_width,
                         skate_length, deck_thickness, r);

            translate([bracket_width, bracket_width, -epsilon])
            rounded_cube(skate_width - bracket_width * 2,
                         skate_length - bracket_width * 2,
                         deck_thickness + 2 * epsilon, r - bracket_width);
        }
}

module tyre() {
    tyre_diameter = 22;
    intersection() {
        scale([1, 1, 2])
            rotate_extrude(angle = 360) 
                translate([wheel_radius - tyre_diameter / 2, 0])
                    circle(d = tyre_diameter);
        cylinder(h=40, r=90, center=true);
    }
}

module wheel() {
    color("#303030") tyre();

    // axle
    color("grey")
    translate([0, 0, -truck_full_width / 2 + epsilon])
    cylinder(h = truck_full_width - 2 * epsilon, r = 6);

    // bearing
    color("grey")
    translate([0, 0, -10])
    cylinder(h = 20, r = 20);
}

module wheels() {
    translate([52, 0, 30])
        rotate([90, 0, 0])
            wheel();

    translate([-52, 0, 30])
        rotate([90, 0, 0])
            wheel();
}

module assembled_truck() {
    mirror([0, 0, 1]) truck();
    translate([0, 0, 19]) wheels();
}

module skate(side) {
    deck();

    translate([skate_width / 2,
               skate_length / 2,
               deck_thickness - bracket_thickness])
        rotate([0, 0, side == "left" ? 15 : -15])
            assembled_truck();
}

skate("left");
