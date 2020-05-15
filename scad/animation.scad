use <frame.scad>
use <single_anim.scad>

//$vpr = [115, 0, 276.7];

mirror([0, 0, 1]) {
    color("gold") frame();
    for_both_skates()
        single_moving_parts();
}