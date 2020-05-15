use <single.scad>

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

module moving_parts() {
    phase = floor($t * 8);
    flow = ($t * 8) - floor($t * 8);

    clip_flow
        = (phase == 1) ? flow
        : (phase == 2) ? 1
        : (phase == 3) ? (1 - flow)
        : (phase == 6) ? 1 - pow(1 - flow, 5)
        : 0;

    skate_flow
        = (phase == 2) ? flow / 2
        : (phase == 3) ? (flow / 2) + 0.5
        : (phase == 4) ? 1
        : (phase == 5) ? 1 - flow / 2
        : (phase == 6) ? 0.5 - flow / 2
        : 0;

    clip_in_single(clip_flow);
    skate_in_single(skate_flow);
}

color("gold") single();
moving_parts();
