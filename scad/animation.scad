include <constants.scad>
use <skate.scad>
use <frame.scad>
use <clip.scad>

phase = floor($t * 8);

/* animation phases:

0 paused while skates stored, clip locked.
1 move clip open
2 move skate out halfway
3 move clip closed + move skate out rest
4 pause
5 move skate back halfway
6 move clip open + move skate back rest
7 move clip closed

*/

tflow = ($t * 8) - phase;

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

module anim_clips() {
    aflow = (phase == 1 ? 1-tflow :
             phase == 2 ? 0 :
             phase == 3 ? tflow :
             phase == 6 ? pow((1 - tflow), 5):
             phase == 7 ? min(tflow * 10, 1) :
             1);

    translate([-clip_width / 2,
               -spring_axle_diameter / 2,
               spring_arm_length + deck_thickness + 2 * 3])
        rotate([23 * aflow,0,0])
            color("gold") clip();

    translate([0, 2 * skate_length - skate_overlap + 4, 0])
        mirror([0, 1, 0])
            translate([-clip_width / 2,
                       -spring_axle_diameter / 2,
                       spring_arm_length + deck_thickness + 2 * 3])
                rotate([23 * aflow, 0, 0])
            color("gold") clip();

    color("grey")
        translate([-clip_width / 2 - cliphouse_side_wall_width,
                   -spring_axle_diameter / 2,
                   37.5])
            rotate([0, 90, 0])
                bolt();
    color("grey")
        translate([-clip_width / 2 - cliphouse_side_wall_width,
                   spring_axle_diameter / 2 + 4 + 2 * skate_length - skate_overlap,
                   37.5])
            rotate([0, 90, 0])
                bolt();
}

module anim_skates() {
    move_out = 60;
    move_out_z_l = 15;
    move_out_z_r = 8;
    rbase_z = 3 + deck_thickness + 13;
    rskate_tilt = -7.75;

    if (phase == 2) {
        translate([skate_width / 2,
                   3 + skate_length + 2,
                   3])
            rotate([14 * tflow, 0, 180])
                skate("left");
        translate([
            -skate_width/2,
            skate_length - skate_overlap + tflow * 2,
            rbase_z])
            rotate([rskate_tilt + 14 * tflow, 0, 0])
                skate("right");
    } else if (phase == 3) {
        translate([skate_width / 2,
                   3 + skate_length + 2 - tflow * move_out,
                   3 + tflow * move_out_z_l])
            rotate([14 * 1, 0, 180])
                skate("left");
        translate([
            -skate_width / 2,
            skate_length - skate_overlap + 2 + tflow * move_out,
            rbase_z + tflow * move_out_z_r])
            rotate([rskate_tilt + 14 * 1, 0, 0])
                skate("right");
    } else if (phase == 4) {
        translate([skate_width / 2,
                   3 + skate_length + 2 - move_out,
                   3 + move_out_z_l])
            rotate([14 * 1, 0, 180])
                skate("left");
        translate([
            -skate_width / 2,
            skate_length - skate_overlap + 2 + move_out,
            rbase_z + move_out_z_r])
            rotate([rskate_tilt + 14 * 1, 0, 0])
                skate("right");
    } else if (phase == 5) {
        translate([skate_width / 2,
                   3 + skate_length + 2 - (1 - tflow) * move_out,
                   3 + (1 - tflow)*move_out_z_l])
            rotate([14 * 1, 0, 180])
                skate("left");
        translate([
            -skate_width / 2,
            skate_length - skate_overlap + 2 + (1 - tflow) * move_out,
            rbase_z + (1 - tflow) * move_out_z_r])
            rotate([rskate_tilt + 14 * 1, 0, 0])
                skate("right");
    } else if (phase == 6) {
        translate([skate_width / 2, 3 + skate_length + 2, 3])
            rotate([14 * (1 - tflow), 0, 180])
                skate("left");
        translate([
            -skate_width / 2,
            skate_length - skate_overlap + 2 * (1 - tflow),
            rbase_z])
            rotate([rskate_tilt  + 14 * (1 - tflow), 0, 0])
                skate("right");
    } else {
        translate([skate_width / 2, 3 + skate_length + 2, 3])
            rotate([0, 0, 180])
                skate("left");
        translate([
            -skate_width / 2,
            skate_length - skate_overlap,
            rbase_z])
            rotate([rskate_tilt , 0, 0])
                skate("right");
    }
}

$vpr = [115, 0, 276.7];

module scene() {
    color("gold") frame();
    anim_clips();
    anim_skates();
}

mirror([0, 0, 1]) scene();
