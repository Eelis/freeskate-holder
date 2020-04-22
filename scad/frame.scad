include <constants.scad>
use <util.scad>

module corner() {
    arc(h = wall_height,
        w = wall_width,
        r = corner_radius,
        a = 90);

    translate([corner_radius * 0.7, corner_radius * 0.7, 15])
        rotate([0, 90, 315])
            arc(h = wall_width * 2,
                w = wall_width,
                r = 8,
                a = 180);
}

module bridge() {
    bridge_height = 13;
    bridge_size = 25;
    bridge_offset = skate_length - skate_overlap - wall_width;
    lower_slope_length = 20;

    // side
    difference(){
        union() {
            translate([skate_width / 2 + gap_around_skate
                        + wall_width - corner_radius,
                       bridge_offset + corner_radius,
                       wall_height - 6])
                arc(h = bridge_height + 6,
                    w = wall_width,
                    r = corner_radius,
                    start = 270,
                    a = 0);

            translate([skate_width / 2 + gap_around_skate,
                       bridge_offset + corner_radius + 90,
                       wall_height])
                mirror([0, 1, 0])
                    cube([wall_width,
                          2 * skate_length - skate_overlap - corner_radius + 2 * wall_width - bridge_offset + lower_slope_length,
                          bridge_height]);
        }


        translate([-epsilon,
                   skate_length * 2 - skate_overlap - corner_radius + 2 * wall_width - 30 + epsilon,
                   wall_height + bridge_height + epsilon])
            mirror([0, 0, 1])
                prism(100,
                      30,
                      bridge_height + epsilon * 2);

        translate([-epsilon,
                   bridge_offset - epsilon,
                   wall_height + bridge_height + epsilon])
            mirror([0, 1, 0])
            mirror([0, 0, 1])
                prism(100,
                      lower_slope_length,
                      bridge_height + epsilon * 2);
    }
    // roof
    translate([0,
               bridge_offset + wall_width - epsilon,
               wall_height + bridge_height - wall_width])
        cube([skate_width / 2 + gap_around_skate + wall_width,
              bridge_size - wall_width - 10,
              wall_width]);


    difference() {
        translate([skate_width / 2 + gap_around_skate + wall_width - corner_radius,
                   bridge_offset + corner_radius,
                   wall_height - wall_width + bridge_height])
            slice(h = wall_width,
                  r = corner_radius,
                  start = 270,
                  a = 0);

        translate([0,
                   bridge_offset + bridge_size - epsilon - 10,
                   wall_height + bridge_height - wall_width - 10])
            cube([100, 50, 30]);
    }

    // back plate
    translate([-epsilon,
               bridge_offset,
               wall_height - 6])
        cube([skate_width / 2 + gap_around_skate + wall_width + epsilon,
              wall_width,
              bridge_height + 6]);
}

module side_wall() {
    translate([skate_width / 2 + gap_around_skate,
               corner_radius - epsilon,
               0])
        cube([wall_width,
              skate_length * 2 - skate_overlap
               - (corner_radius - wall_width) * 2 + 2 * epsilon - 2,
              wall_height]);

    bridge();

    // upper platform:
    translate([clip_width / 2 + gap + 20,
               epsilon + wall_width + skate_length * 2 - skate_overlap - 2,
               0])
        rotate([7.4, 0, 180])
            cube([20, skate_length + 2 * wall_width - 1, wall_width]);

    // lower platform:
    translate([-epsilon, 80, 0])
        cube([skate_width / 2 + gap_around_skate + epsilon * 2,
              10,
              wall_width]);
    translate([clip_width / 2 + gap, 0, 0])
        cube([20, skate_length + 1 + 2 * wall_width, wall_width]);

    difference() {
        union() {
            // lower backstop
            translate([-epsilon,
                       skate_length + gap_around_skate + wall_width,
                       0])
                cube([skate_width / 2 + gap_around_skate + wall_width - corner_radius
                       + epsilon * 2,
                      wall_width,
                      wall_height]);

            // lower backstop corner
            translate([skate_width / 2 + gap_around_skate + wall_width - corner_radius,
                       skate_length + gap_around_skate + 2 * wall_width - corner_radius,
                       0])
                arc(h = wall_height,
                    w = wall_width,
                    r = corner_radius,
                    start = 0,
                    a = 90);

            // support for upper platform
            translate([-epsilon, 247, 0])
                cube([skate_width / 2 + gap_around_skate + epsilon * 2,
                      wall_width,
                      wall_height]);

            translate([19, skate_length + gap_around_skate + wall_width, 0])
                cube([wall_width,
                      skate_length - skate_overlap,
                      wall_height]);
        }

        // space above upper platform
        mirror([1, 0, 0])
            translate([epsilon * 2,
                   epsilon + wall_width + skate_length * 2 - skate_overlap - 2,
                   wall_width])
                rotate([7.4, 0, 180])
                    cube([skate_width / 2 + gap_around_skate + epsilon * 2,
                          200,
                          50]);
    }
}

module cliphouse() {
    // back wall
    difference() {
        translate([-cliphouse_wall_width,
                   -cliphouse_wall_width - spring_axle_diameter / 2,
                   -15])
            cube([clip_width + 2 * cliphouse_wall_width,
                  cliphouse_wall_width,
                  10 ]);

        translate([-50, 0, 0])
            rotate([0, 90, 0])
                cylinder(r = spring_axle_diameter / 2 + clip_thickness + gap, h = 100);
    }

    module side_wall() {
        difference() {
            union() {
                translate([0, 0, -25])
                    cube([cliphouse_side_wall_width - gap,
                          spring_axle_diameter + 2 * cliphouse_wall_width,
                          25]);

                translate([0, cliphouse_wall_width+spring_axle_diameter/2, 0])
                    rotate([0, 90, 0])
                        cylinder(h = cliphouse_side_wall_width - gap,
                                 r = spring_axle_diameter / 2 + cliphouse_wall_width);

                translate([0, 0, -25])
                    mirror([0, 0, 1])
                        prism(cliphouse_side_wall_width - gap,
                              spring_axle_diameter + wall_width,
                              wall_width + deck_thickness + wall_width +
                               spring_arm_length - 25);
            }

            translate([-epsilon,
                       cliphouse_wall_width + spring_axle_diameter / 2,
                       0])
                rotate([0,90,0])
                    cylinder(h = cliphouse_side_wall_width + 2 * epsilon,
                             r = bolt_diameter / 2);
        }
    }

    difference() {
        translate([-cliphouse_side_wall_width,
                   -cliphouse_wall_width - spring_axle_diameter / 2, 0])
            side_wall();

        translate([-cliphouse_side_wall_width - epsilon, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = epsilon + 2,
                         r = 5.5 / 2 + 0.5);
    }

    difference() {
        translate([clip_width + gap,
                   -cliphouse_wall_width - spring_axle_diameter / 2, 0])
            side_wall();

        translate([clip_width + cliphouse_side_wall_width - 2, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = 4,
                         r = 5.5 / 2 * (2 / sqrt(3)) + 0.25,
                         $fn = 6);
    }
}

module fullcorner() {
    translate([corner_radius - skate_width / 2 - gap_around_skate - wall_width,
               corner_radius,
               0])
        rotate([0, 0, 180]) // todo: consider mirror instead
            corner();

    translate([-skate_width / 2 - gap_around_skate + corner_radius - wall_width, 0, 0])
        cube([skate_width / 2 + gap_around_skate - corner_radius - clip_width / 2 + wall_width - gap,
              wall_width,
              wall_height]);
}

module one_end() {
    fullcorner();
    mirror([1, 0, 0]) fullcorner();

    translate([-clip_width / 2,
               -spring_axle_diameter / 2,
               wall_width + deck_thickness + wall_width + spring_arm_length])
        cliphouse();
}

module frame() {
    side_wall();
    mirror([1, 0, 0]) side_wall();

    one_end();
    translate([0, 2 * skate_length - skate_overlap + 4, 0])
        mirror([0, 1, 0])
            one_end();
}

color("gold") frame();
