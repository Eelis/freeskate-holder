include <constants.scad>

module deck() {
    r = 40;
    hull() {
        translate([r, r, 0])
            cylinder(h = deck_thickness, r = r);
        translate([skate_width - r, r, 0])
            cylinder(h = deck_thickness, r = r);
        translate([r, skate_length - r, 0])
            cylinder(h = deck_thickness, r = r);
        translate([skate_width - r, skate_length - r, 0])
            cylinder(h = deck_thickness, r = r);
    }
}

module truck() {
    translate([0, 0, 10])
        color("grey")
            cube([111, 55, 55], center = true);

    translate([52, 0, 30])
        rotate([90, 0, 0])
            color("#303030")
                cylinder(r = 35, h = 45, center = true);

    translate([-52, 0, 30])
        rotate([90, 0, 0])
            color("#303030")
                cylinder(r = 35, h = 45, center = true);
}

module skate(side) {
    color("red") deck();

    translate([skate_width / 2, skate_length / 2, 30])
        rotate([0, 0, side == "left" ? 15 : -15])
            truck();
}
