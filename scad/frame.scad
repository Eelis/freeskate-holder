include <constants.scad>
use <util.scad>
use <skate.scad>
use <clip.scad>
use <single.scad>

module relative_skate_orientation() {
    translate([0, 2 * (skate_length + 2 * y_gap_around_skate) - skate_overlap, 0])
        mirror([0, 1, 0])
            rotate([8, 0, 0])
                children();
}

module for_both_skates() {
    children();
    relative_skate_orientation() children();
}

bridge_offset = skate_length - skate_overlap - wall_width - 3;

module bridge() {
    bridge_height = 13;

    difference() {
        translate([0,
                   bridge_offset + wall_width - epsilon,
                   wall_height + bridge_height - wall_width])
            cube([skate_width / 2 + 10,
                  15,
                  wall_width]);
        relative_skate_orientation()
            outer_space();
    }
}

module side_wall() {
    translate([skate_width / 2 + x_gap_around_skate,
               120,
               0])
        cube([wall_width, 100, lower_wall_height]);

    difference() {
        translate([skate_width / 2 + x_gap_around_skate,
               120,
               0])
            cube([wall_width, 80, 28]);

        for_both_skates() inner_space();
    }
}

module skirt_profile() {
    translate([corner_radius - wall_width, 0])
        rotate(55) {
            translate([0, -skirt_height])
                square([wall_width, skirt_height]);
            translate([wall_width / 2, -skirt_height])
                circle(wall_width / 2);
        }
}

module extrude_skirt() {
    // skirt side
    translate([0, corner_radius, 0])
        mirror([0, 1, 0])
            rotate([90, 0, 0])
                linear_extrude(
                        height=(2 * y_gap_around_skate + skate_length) * 2
                        - skate_overlap - corner_radius * 2)
                    translate([skate_width / 2 + x_gap_around_skate - corner_radius + wall_width, 0])
                        children(); 

    // skirt at one cliphouse
    translate([0, corner_radius, 0])
        mirror([1, 0, 0])
            rotate([0, 0, -90])
                rotate([90, 0, 0])
                    linear_extrude(
                            height = skate_width / 2 + x_gap_around_skate + wall_width
                                     - corner_radius)
                        children();

    // skirt at the other cliphouse
    translate([0, 2 * (skate_length + 2 * y_gap_around_skate) - skate_overlap - corner_radius, 0])
        rotate([0, 0, 90])
            rotate([90, 0, 0])
                linear_extrude(
                        height = skate_width / 2 + x_gap_around_skate + wall_width
                                 - corner_radius)
                    children();

    // skirt corners
    translate([
            skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
            2 * (2 * y_gap_around_skate + skate_length) - skate_overlap - corner_radius,
            0])
        rotate([0, 0, -epsilon])
            rotate_extrude(angle = 90 + 2 * epsilon)
                children();
    translate([
            skate_width / 2 + x_gap_around_skate - corner_radius + wall_width,
            corner_radius,
            0])
    rotate([0, 0, 270])
        rotate([0, 0, -epsilon])
            rotate_extrude(angle = 90 + 2 * epsilon)
                children();
}

module skirt_side_hooks() {
    hook_radius = 3;

    mirror_copy([1, 0, 0])
        translate([
                skate_width / 2 + x_gap_around_skate - 8,
                (2 * (skate_length + 2 * y_gap_around_skate) - skate_overlap) / 2 + 4,
                3])
            rotate([90, 0, 0])
                rotate([0, 0, -50])
                rotate_extrude(angle = 119)
                    translate([20, 0])
                        circle(hook_radius);
}

module skirt_inner_space() {
    mirror_copy([1, 0, 0])
        extrude_skirt()
            translate([corner_radius - wall_width, 0])
                rotate(55)
                    translate([-30, -40])
                        square([30, 40]);

    translate([-skate_width / 2 + -x_gap_around_skate, wall_width, -40])
        rounded_cube(
            r = corner_radius - wall_width,
            w = skate_width + 2*x_gap_around_skate,
            h = 40,
            l = 2*(skate_length+2*y_gap_around_skate)-skate_overlap - 2 * wall_width);

}

module skirt()
    mirror_copy([1, 0, 0])
        extrude_skirt()
            skirt_profile();

module skates(phase = 0)
    for_both_skates()
        skate_in_single(phase);

module clips(openness = 0)
    for_both_skates()
        clip_in_single(openness);

module frame() {
    skirt();

    mirror_copy([1, 0, 0])
        bridge();

    difference() {
        union() {
            difference() {
                union() {
                    mirror_copy([1, 0, 0])
                        side_wall();
                    single();
                }

                relative_skate_orientation()
                    inner_space();
            }

            difference(){
                relative_skate_orientation()
                    single();
                translate([-200, 120, 43])
                    cube([400,120,20]);
            }

            skirt_side_hooks();
        }

        skirt_inner_space();
    }
}

color("gold") frame();
//clips();
//skates();