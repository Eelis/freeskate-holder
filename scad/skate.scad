include <constants.scad>
use <util.scad>

module deck() {
    r = 40;
    bracket_width = 14;

    color("#b0b0b0")
        translate([bracket_width, bracket_width, 1])
            rounded_cube(skate_width - bracket_width * 2 + epsilon,
                         skate_length - bracket_width * 2 + epsilon,
                         deck_thickness - 2,
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

wheel_width = 43;
wheel_radius = 35;
truck_height = 55;

module wheels() {
    translate([52, 0, 30])
        rotate([90, 0, 0])
            color("#303030")
                cylinder(r = wheel_radius, h = wheel_width, center = true);

    translate([-52, 0, 30])
        rotate([90, 0, 0])
            color("#303030")
                cylinder(r = wheel_radius, h = wheel_width, center = true);
}

module truck() {
    translate([0, 0, 10])
        color("#b0b0b0")
            cube([121, 55, truck_height], center = true);

    wheels();
}

module skate(side) {
    deck();

    translate([skate_width / 2,
               skate_length / 2,
               truck_height / 2])
        rotate([0, 0, side == "left" ? 15 : -15])
            truck();
}

skate("left");