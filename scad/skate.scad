include <constants.scad>
use <util.scad>
use <truck.scad>

bracket_thickness = 1.5;
wheel_width = 43;
wheel_radius = 36;
bracket_width = 14;
bracket_r = 50;

module bracket() {
    color("#303030")
        linear_extrude(height=deck_thickness)
            difference() {
                rounded_square(skate_width, skate_length, bracket_r);

                translate([bracket_width, bracket_width])
                    rounded_square(
                        skate_width - bracket_width * 2,
                        skate_length - bracket_width * 2,
                        bracket_r - bracket_width);
            }
}

module deck() {
    color("#b0b0b0")
        translate([bracket_width,
                   bracket_width,
                   bracket_thickness])
            rounded_cube(skate_width - bracket_width * 2 + epsilon,
                         skate_length - bracket_width * 2 + epsilon,
                         deck_thickness - bracket_thickness * 2,
                         bracket_r - bracket_width + epsilon);

    bracket();
}

module tyre() {
    tyre_diameter = 22;
    color("#303030")
        intersection() {
            scale([1, 1, 2])
                rotate_extrude(angle = 360)
                    translate([wheel_radius - tyre_diameter / 2, 0])
                        circle(d = tyre_diameter);
            cylinder(h = 40, r = 90, center = true);
        } // todo: do as extrusion
}

module axle()
    color("grey")
        translate([0, 0, -truck_full_width / 2 + epsilon])
            cylinder(h = truck_full_width - 2 * epsilon, r = 6);

module bearing()
    color("grey")
        translate([0, 0, -10])
            cylinder(h = 20, r = 20);

module wheel() {
    tyre();
    axle();
    bearing();
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
