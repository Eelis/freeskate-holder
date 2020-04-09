include <constants.scad>
use <util.scad>

module clip() {
    module side() {
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
                             r = bolt_diameter / 2);
        }
    }

    translate([0,
               spring_axle_diameter / 2,
               -spring_arm_length])
        cube([clip_width,
              clip_thickness,
              spring_arm_length]);

    side();
    translate([spring_axle_length + cliphouse_wall_width, 0, 0])
        side();

    difference() {
        union() {
            translate([clip_width, 0, 0])
                rotate([-90, 0, 90])
                    arc(h = clip_width,
                        r = spring_arm_length + 4,
                        a = 140,
                        w = 4);
            translate([clip_width, 0, 0])
                rotate([-90, 0, 90])
                    arc(h = clip_wall_width,
                        r = spring_arm_length + 4,
                        a = 140,
                        w = 5);

            translate([clip_wall_width, 0, 0])
                rotate([-90, 0, 90])
                    arc(h = clip_wall_width,
                        r = spring_arm_length + 4,
                        a = 140,
                        w = 5);
        }

        translate([-epsilon,
                   spring_axle_diameter / 2 + clip_thickness,
                   -spring_arm_length * 2])
            cube([clip_width + 2 * epsilon,
                  spring_arm_length,
                  spring_arm_length * 2 + epsilon]);
    }

    rotate([90, 0, 90])
        arc(h = clip_width,
            r = spring_axle_diameter / 2 + clip_thickness,
            a = 130,
            w = wall_width);

    translate([clip_width + 3, 0, 0])
        rotate([-90, 0, 90])
            arc(h = clip_width + 2 * 3,
                r = spring_arm_length + 6,
                a = 150,
                w = 7,
                start = 134);
}

color("gold") clip();
