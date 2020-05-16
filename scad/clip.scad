include <constants.scad>
include <util.scad>

module half_clip() {
    // front wall
    translate([-epsilon,
               spring_axle_diameter / 2,
               -spring_arm_length])
        cube([clip_width / 2 + epsilon,
              clip_thickness,
              spring_arm_length]);

    // side:
    translate([spring_axle_length / 2, 0, 0]) {
        outer = spring_axle_diameter / 2 + clip_thickness;
        difference() {
            union() {
                rotate([0, 90, 0])
                    cylinder(h = clip_wall_width,
                             r = outer);
                translate([0,
                           -spring_axle_diameter / 2,
                           -spring_arm_length])
                    cube([clip_thickness,
                          spring_axle_diameter + clip_thickness,
                          spring_arm_length]);
            }
            rotate([0, 90, 0])
                translate([0, 0, -epsilon])
                    cylinder(h = clip_wall_width + 2 * epsilon,
                             r = bolt_diameter / 2 + 0.2);
        }
    }

    // handle:
    translate([0, -20, -16]) {
        translate([clip_width / 2, 0, 0])
            sphere(5);
        translate([-epsilon, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = clip_width / 2 + epsilon, r = 5);
    }

    difference() {
        union() {
            rotate([-130 + 90, 0, 0])
                translate([-epsilon, -9, -25])
                    prism(clip_width / 2 + epsilon, 9, 9);

            translate([-epsilon, 0, 0])
                mirror([1, 0, 0])
                    rotate([0, 0, 90])
                        rotate([-90, 0, 0])
                            arc(h = clip_width / 2 + epsilon,
                                r = spring_arm_length + 4,
                                a = 130,
                                w = 9);
        }

        translate([-2 * epsilon, 0, 0])
            mirror([1, 0, 0])
                rotate([-90, 0, 90])
                    cylinder(
                        h = clip_width / 2 - clip_wall_width + 2 * epsilon,
                        r = spring_arm_length);

        translate([-2 * epsilon,
                   spring_axle_diameter / 2 + clip_thickness,
                   -spring_arm_length * 2])
            cube([clip_width + 4 * epsilon,
                  spring_arm_length,
                  spring_arm_length * 2 + epsilon]);
    }

    // roof
    translate([-epsilon, 0, 0])
        rotate([90, 0, 90])
            arc(h = clip_width / 2 + epsilon,
                r = spring_axle_diameter / 2 + clip_thickness,
                a = 130,
                w = wall_width);
}

module clip()
    mirror_copy([1, 0, 0])
        half_clip();

color("gold") clip();
