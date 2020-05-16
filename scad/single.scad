include <constants.scad>
use <util.scad>
use <skate.scad>
use <clip.scad>

module wall_profile(lower_height=lower_wall_height) {
    square([wall_width, lower_height]);
    translate([0, lower_height])
        rotate([0, 0, -30]) {
            translate([wall_width / 2, upper_wall_height])
                circle(wall_width / 2);
        square([wall_width, upper_wall_height]);
    }
}

module inner_wall_profile(lower_height=lower_wall_height) {
    square([wall_width, lower_height]);
    translate([0, lower_height])
        rotate([0, 0, -30]) {
            translate([wall_width / 2, upper_wall_height])
                circle(wall_width / 2);
        square([wall_width, upper_wall_height]);
    }
}

module corner() {
    translate([0, 0, 0])
        rotate_extrude(angle=90, convexity=10)
            translate([corner_radius - wall_width, 0])
                wall_profile();
}

module interior() {
    lower_height = lower_wall_height;
    translate([corner_radius - wall_width - 30, wall_width])
        square([30, lower_height + upper_wall_height - wall_width]);
    translate([corner_radius - wall_width, lower_height])
        rotate([0, 0, -30])
            translate([-30, 0])
                square([30, upper_wall_height]);
}

module exterior() {
    lower_height = lower_wall_height;
    translate([corner_radius - wall_width, lower_height])
        rotate([0, 0, -30])
            translate([wall_width, 0])
                square([20, upper_wall_height]);
}

module outer_space() {
    mirror_copy([1, 0, 0]) {

        translate([skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
           skate_length + 2 * y_gap_around_skate - corner_radius + 2 * wall_width,
           0])
            rotate_extrude(angle=90)
                exterior();

        translate([
                skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
                corner_radius - epsilon,
                0])
            mirror([0, 1, 0])
                rotate([90, 0, 0])
                    linear_extrude(
                            height = skate_length + 2 * y_gap_around_skate + 2 * wall_width
                                     - 2 * corner_radius + 2 * epsilon)
                        exterior();

        translate([skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
                   corner_radius,
                   0])
            rotate([0, 0, -90])
                rotate_extrude(angle = 90)
                    exterior();
    }
}

module corner_inner_space() {
    translate([skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
               skate_length + 2 * y_gap_around_skate - corner_radius + 2 * wall_width,
               0])
        rotate_extrude(angle=90)
            interior();
}

module inner_space() mirror_copy([1, 0, 0]) half_inner_space();

module half_inner_space() {
    translate([skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
               skate_length + 2 * y_gap_around_skate - corner_radius + 2 * wall_width,
               0])
        rotate_extrude(angle=90)
            interior();

    translate([
            skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
            corner_radius - epsilon,
            0])
        mirror([0, 1, 0])
            rotate([90, 0, 0])
                linear_extrude(
                        height = skate_length + 2 * y_gap_around_skate + 2 * wall_width
                                 - 2 * corner_radius + 2 * epsilon)
                    interior();

    translate([skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
               corner_radius,
               0])
        rotate([0, 0, -90])
            rotate_extrude(angle = 90)
                interior();

    translate([
            -skate_width/2-x_gap_around_skate,
            wall_width,
            wall_width])
        rounded_cube(
            w = skate_width + 2 * x_gap_around_skate,
            l = skate_length + 2 * y_gap_around_skate,
            h = 40,
            r = corner_radius - wall_width);
}

module half_single() {
    // front corner
    fullcorner();

    // side wall
    translate([skate_width / 2 + x_gap_around_skate,
            2 * wall_width + skate_length + 2 * y_gap_around_skate - corner_radius,
            0])
            rotate([90, 0, 0])
                linear_extrude(height =
                        (skate_length + 2 * y_gap_around_skate + 2 * wall_width) -
                        corner_radius * 2 + 2 * epsilon,
                        convexity = 10)
                    translate([0, -30])
                        wall_profile(lower_height = lower_wall_height + 30);

    //  back corner
    translate([
            skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
            skate_length + 2 * y_gap_around_skate + 2 * wall_width - corner_radius,
            0])
        corner();

    // wall next to cliphouse
    translate([clip_width / 2 + gap, wall_width, 0])
        rotate([0, 0, 90])
            mirror([1, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(
                        height = skate_width / 2 + x_gap_around_skate + 2 * epsilon -
                            corner_radius + wall_width - clip_width / 2 - gap,
                        convexity = 10)
                        wall_profile(); 

    // back wall
    translate([
        0,
        wall_width + skate_length + 2 * y_gap_around_skate, 0])
            rotate([0, 0, 90])
            rotate([90, 0, 0])
                linear_extrude(
                    height = skate_width / 2 + x_gap_around_skate + 2 * epsilon - corner_radius + wall_width,
                    convexity = 10)
                    wall_profile(); 

    // lower platform:

    translate([-epsilon, 55, 0])
        cube([skate_width / 2 + x_gap_around_skate + epsilon * 2,
              10,
              wall_width]);
    translate([-epsilon, 58, -30])
        cube([skate_width / 2 + x_gap_around_skate + epsilon * 2,
              4,
              30 + wall_width]);
    translate([-epsilon, 110, 0])
        cube([skate_width / 2 + x_gap_around_skate + epsilon * 2,
              10,
              wall_width]);
    translate([-epsilon, 113, -30])
        cube([skate_width / 2 + x_gap_around_skate + epsilon * 2,
              4,
              30 + wall_width]);
    translate([clip_width / 2 + gap, 0, 0])
        cube([10,
            wall_width + skate_length + y_gap_around_skate * 2 + wall_width,
            wall_width]);
    translate([clip_width / 2 + gap + 3, 0, -30])
        cube([4,
            wall_width + skate_length + y_gap_around_skate * 2 + wall_width - 42,
            30 + wall_width]);
}

module cliphouse() {
    // back wall
    difference() {
        translate([-cliphouse_wall_width,
                   -cliphouse_wall_width - spring_axle_diameter / 2 - cliphouse_overhang,
                   -14])
            cube([clip_width + 2 * cliphouse_wall_width,
                  cliphouse_wall_width,
                  8 ]);

        translate([-50, 0, 0])
            rotate([0, 90, 0])
                cylinder(r = spring_axle_diameter / 2 + clip_thickness + gap, h = 100);
    }

    module side_wall() {
        difference() {
            union() {
                translate([0, 0, -70])
                    cube([cliphouse_side_wall_width - gap,
                          spring_axle_diameter + 2 * cliphouse_wall_width,
                          70]);

                translate([0, cliphouse_wall_width+spring_axle_diameter/2, 0])
                    rotate([0, 90, 0])
                        cylinder(h = cliphouse_side_wall_width - gap,
                                 r = spring_axle_diameter / 2 + cliphouse_wall_width);
            }

            translate([-epsilon,
                       cliphouse_wall_width + spring_axle_diameter / 2,
                       0])
                rotate([0, 90, 0])
                    cylinder(h = cliphouse_side_wall_width + 2 * epsilon,
                             r = bolt_diameter / 2);
        }
    }

    difference() {
        translate([-cliphouse_side_wall_width,
                   -cliphouse_wall_width - spring_axle_diameter / 2 - cliphouse_overhang, 0])
            side_wall();

        // opening for bolt head
        translate([-cliphouse_side_wall_width - epsilon, -cliphouse_overhang, 0])
            rotate([0, 90, 0])
                cylinder(h = epsilon + 2,
                         r = 5.5 / 2 + 0.5);
    }

    difference() {
        translate([clip_width + gap,
                   -cliphouse_wall_width - spring_axle_diameter / 2 - cliphouse_overhang, 0])
            side_wall();

        // opening for nut
        translate([clip_width + cliphouse_side_wall_width - 2, -cliphouse_overhang, 0])
            rotate([0, 90, 0])
                cylinder(h = 4,
                         r = 5.5 / 2 * (2 / sqrt(3)) + 0.25,
                         $fn = 6); 
    }
}

module fullcorner() {
    translate([skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
               corner_radius,
               0])
        rotate([0, 0, 270])

    translate([0, 0, 0])
        rotate_extrude(angle=90, convexity=10)
            translate([corner_radius - wall_width, -30])
                wall_profile(lower_height = lower_wall_height + 30);

    // hook
    difference() {

        hook_radius = 3;
        translate([
                skate_width / 2 + x_gap_around_skate - corner_radius + (1 / sqrt(2)) * corner_radius + hook_radius / 2 - 13,
                corner_radius - (1 / sqrt(2)) * corner_radius + hook_radius / 2 + 13,
                10])
            rotate([0, 0, 45])
                rotate([0, 90, 0])
                    rotate([0, 0, 231])
                        rotate_extrude(angle = 75)
                            translate([30, 0])
                                circle(hook_radius);
        translate([skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
                   corner_radius,
                   0])
            rotate([0, 0, -90])
                rotate_extrude(angle=90, convexity=10)
                    interior();
    }
}

module single() {
    mirror_copy([1, 0, 0]) half_single();

    translate([-clip_width / 2,
               -spring_axle_diameter / 2,
               wall_width + deck_thickness + wall_width + spring_arm_length])
        cliphouse();
}

module clip_in_single(openness = 1) {
    open_angle = 25;
    translate([
            0,
            -spring_axle_diameter / 2 - cliphouse_overhang,
            wall_width + deck_thickness + wall_width + spring_arm_length])
        color("gold")
            rotate([(1 - openness) * open_angle, 0, 0])
                clip();

    translate([
            -cliphouse_width / 2,
            -spring_axle_diameter / 2 - cliphouse_overhang,
            wall_width + deck_thickness + wall_width + spring_arm_length])
        rotate([0, 90, 0])
            color("grey") bolt();
}

module skate_in_single(phase = $t) {
    nphase = (phase <= 0.5 ? phase * 2 : (phase - 0.5) * 2);

    mid_rotation = 14;
    max_y_offset = 60;
    max_z_offset = 10;
    more_rotation = 12;
    rotation = (phase <= 0.5 ? nphase * mid_rotation : mid_rotation + nphase * more_rotation);
    y_translation = (phase <= 0.5 ? nphase * -2 : -2 - nphase * max_y_offset);
    z_translation = (phase <= 0.5 ? 0 : nphase * max_z_offset);

    translate([
            -skate_width / 2,
            skate_length + wall_width + y_gap_around_skate + y_translation,
            wall_width + 0.5 + z_translation])
        rotate([-rotation, 0, 0])
            mirror([0, 1, 0])
            skate();
}

module bolt_head() {
    difference() {
        cylinder(r = 3, 2);
        rotate([0, 0, 45]) cube([10, 1, 2], center = true);
    }
}

module bolt() {
    translate([0, 0, 1])
        cylinder(r = 1.5, h = clip_width + 2 * cliphouse_side_wall_width);
    bolt_head();
    translate([0, 0, clip_width + 2 * cliphouse_side_wall_width - 2])
        cylinder(r = 3, h = 2, $fn = 6);
}

color("gold") single();
clip_in_single();
skate_in_single();
