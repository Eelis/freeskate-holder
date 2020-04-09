$fa = 1;
$fs = 0.4;

skate_width = 143; // measured
skate_length = 172; // measured
gap_around_skate = 2;
wall_width = 3;
wall_height = 30;
latch_length = 30;
latch_width = 20;
deck_thickness = 12; // measured
clip_thickness = 3;
clip_wall_width = 3;
spring_axle_length = 14; // measured
spring_axle_diameter = 7; // measured
spring_arm_length = 21; // measured from axle center
bolt_diameter = 3;
corner_radius = 40;
skate_overlap = 25;
spring_wire_width = 1.3;
cliphouse_wall_width = 3;
cliphouse_side_wall_width = 5;
clip_width = spring_axle_length + 2 * clip_wall_width;
epsilon = 0.01;
gap = 0.8; // tried 0.5 but it was slightly too low

module slice(h, r, a,start=0){
    difference(){
        cylinder(h=h, r=r);
        rotate([0, 0, a])
        translate([-r - epsilon, 0, -epsilon])
            cube([r * 2 + epsilon * 2, r + epsilon, h + epsilon * 2]);
        rotate([0, 0, start])
        translate([-r - epsilon, -r - epsilon, -epsilon * 2])
            cube([r * 2 + 2 * epsilon, r + epsilon, h + epsilon*4]);
    }
}

module arc(h, r, a, w, start=0){
    difference() {
        slice(h=h, r=r, a=a, start=start);
        translate([0,0,-epsilon]) cylinder(h=h+2*epsilon, r=r-w);
    }
}

module prism(l, w, h){
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]);
}

module ring(h, rinner, router) {
    difference() {
        union() {
            cylinder(h=h,r=router);
        }
        translate([0,0,-epsilon])
        cylinder(h=h+epsilon*2,r=rinner);
    }
}

module spring() {
    // axle
    translate([0,0,spring_arm_length])
    rotate([0,90,0])
    cylinder(h=spring_axle_length,r=spring_axle_diameter / 2);
    // arms
    translate([spring_wire_width/2,-spring_axle_diameter / 2 + spring_wire_width/2,0])
    cylinder(h=spring_arm_length,r=spring_wire_width/2);
    translate([spring_axle_length - spring_wire_width/2,spring_axle_diameter / 2 - spring_wire_width/2,0])
    cylinder(h=spring_arm_length,r=spring_wire_width/2);
    // hands
    translate([0,-spring_axle_diameter / 2 + spring_wire_width / 2, spring_wire_width/2])
    rotate([0,90,0])
    cylinder(h=spring_axle_length*0.75,r=spring_wire_width/2);
    translate([0.25 * spring_axle_length,spring_axle_diameter / 2 - spring_wire_width / 2, spring_wire_width/2])
    rotate([0,90,0])
    cylinder(h=spring_axle_length*0.75,r=spring_wire_width/2);
}

module corner() {
    arc(h=wall_height, w=wall_width, r=corner_radius, a=90);

    translate([corner_radius*0.7,corner_radius*0.7,15])
    rotate([0,90,315])
    arc(h=wall_width*2, w=wall_width, r=8, a=180);
}

module bridge() {
    bridge_radius = 15;
    bridge_size = 20;
    bridge_offset = skate_length - skate_overlap - wall_width;

    // side
    translate([
        skate_width / 2 + gap_around_skate - bridge_radius + wall_width,
        bridge_offset + bridge_size,
        wall_height])
        rotate([90, 0, 0])
            arc(h = bridge_size, w = wall_width, r = bridge_radius, a = 90);
    
    // roof
    translate([0, bridge_offset, wall_height + bridge_radius - wall_width])
        cube([skate_width / 2 + gap_around_skate - bridge_radius + wall_width, bridge_size, wall_width]);

    // back plate
    translate([0, bridge_offset, wall_height - wall_width])
        cube([skate_width / 2 + gap_around_skate + wall_width - bridge_radius + epsilon,
              wall_width,
              bridge_radius]);

    translate([-epsilon,bridge_offset,wall_height-wall_width])
        cube([skate_width / 2 + gap_around_skate + epsilon*2, wall_width, wall_width+epsilon]);

    translate([skate_width / 2 + gap_around_skate - bridge_radius + wall_width,
               bridge_offset + wall_width,
               wall_height])
        rotate([90, 0, 0])
            slice(h = wall_width, r = bridge_radius, a = 90);

}

module side_wall() {
    translate([skate_width / 2 + gap_around_skate,
               corner_radius-epsilon,
               0])
    cube([wall_width,
          skate_length * 2 - skate_overlap - (corner_radius-wall_width) * 2 + 2 * epsilon + 2,
          wall_height]);

    bridge();

    // upper platform:
    translate([-clip_width / 2 - gap,
               epsilon + wall_width + skate_length * 2 - skate_overlap + 2,
               0])
    rotate([7, 0, 180])
    cube([20, 176, wall_width]);

    translate([epsilon, epsilon + wall_width + skate_length * 2 - skate_overlap + 2, 0])
    rotate([7, 0, 180])
    translate([0, 126, 0])
    cube([skate_width / 2 + gap_around_skate + epsilon*2, 50, wall_width]);

    translate([epsilon,
               epsilon + wall_width + skate_length * 2 - skate_overlap + 2,
               0])
    rotate([0, 0, 180])
    rotate([7, 0, 0])
    translate([0, 58, 0])
    cube([skate_width / 2 + gap_around_skate + epsilon * 2,
          10,
          wall_width]);

    // support for upper platform:
    translate([-epsilon, 261, 0])
    cube([skate_width / 2 + gap_around_skate + epsilon * 2,
          wall_width,
          10]);

    // lower platform:
    translate([-epsilon, 55, 0])
        cube([skate_width / 2 + gap_around_skate + epsilon * 2,
              10,
              wall_width]);
    translate([-epsilon, 120, 0])
        cube([skate_width / 2 + gap_around_skate + epsilon * 2,
              skate_length + gap_around_skate * 2 - 120 + wall_width + epsilon,
              wall_width]);
    translate([clip_width/2 + gap, 0, 0])
        cube([20, 130, wall_width]);

    // backstop:
    translate([-epsilon, skate_length + gap_around_skate * 2 + wall_width])
        cube([skate_width / 4,
              wall_width, 20]);
}

module clip() {
    module side() {
        outer=spring_axle_diameter / 2 + clip_thickness;
        difference(){
            union(){
                rotate([0,90,0])
                    cylinder(h=clip_wall_width,r=outer);
                translate([0,
                           -spring_axle_diameter / 2,
                           -spring_arm_length])
                    cube([clip_thickness,
                          spring_axle_diameter + clip_thickness,
                          spring_arm_length]);

            }
            rotate([0,90,0])
                translate([0, 0, -epsilon])
                    cylinder(h = clip_wall_width + 2 * epsilon,
                             r = bolt_diameter / 2);
        }
    }

    translate([0, spring_axle_diameter / 2, -spring_arm_length])
        cube([clip_width, clip_thickness, spring_arm_length]);

    // side walls
    translate([0,0,0]) side();
    translate([spring_axle_length+cliphouse_wall_width,0,0]) side();

    difference(){
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
                  spring_arm_length, spring_arm_length * 2 + epsilon]);
    }

    rotate([90, 0, 90])
    arc(h = clip_width,
        r = spring_axle_diameter / 2 + clip_thickness,
        a = 130,
        w = wall_width);

    translate([clip_width + 3, 0, 0])
        rotate([-90, 0, 90])
            arc(h = clip_width+2*3,
                r = spring_arm_length+6,
                a = 150,
                w = 7,
                start=134);
}

module cliphouse() {
    // back wall
    translate([-cliphouse_wall_width,
               -cliphouse_wall_width - spring_axle_diameter / 2,
               -18])
        cube([clip_width + 2 * cliphouse_wall_width,
              cliphouse_wall_width,
              13 - 2 * gap]);

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

                translate([0,0,-25])
                mirror([0,0,1])
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
        cylinder(h = 2 + epsilon, r=5.5/2 + 0.5);
    }

    difference() {
        translate([clip_width + gap,
                   -cliphouse_wall_width - spring_axle_diameter / 2, 0])
        side_wall();

        translate([clip_width + cliphouse_side_wall_width - 4, 0, 0])
        rotate([0, 90, 0])
        cylinder(h = 4 + epsilon, r=5.5/2 * (2/sqrt(3)) + 0.5, $fn=6);
    }
}

module deck() {
    r=40;
    hull() {
        translate([r,r,0])
        cylinder(h=deck_thickness, r=r);
        translate([skate_width - r,r,0])
        cylinder(h=deck_thickness, r=r);
        translate([r, skate_length - r,0])
        cylinder(h=deck_thickness, r=r);
        translate([skate_width - r, skate_length - r,0])
        cylinder(h=deck_thickness, r=r);
    }
}

module skate(side) {
    color("red") deck();
    translate([skate_width/2,skate_length/2,30])
        rotate([0, 0, side == "left" ? 15 : -15])
            truck();
}

module truck() {
    translate([0,0,10])
    color("grey") cube([111,55,55],center=true);
    
    translate([52,0,30])
    rotate([90,0,0])
    color("#303030") cylinder(r=35,h=45,center=true);

    translate([-52,0,30])
    rotate([90,0,0])
    color("#303030") cylinder(r=35,h=45,center=true);
}

//translate([clip_wall_width,0,2*3+deck_thickness]) color("grey") spring();
//$t = 1;

module fullcorner() {
    translate([corner_radius - skate_width / 2 - gap_around_skate - wall_width,corner_radius,0])
    rotate([0,0,180])
    corner();
    translate([-skate_width / 2 - gap_around_skate + corner_radius - wall_width, 0, 0])
    cube([skate_width / 2 + gap_around_skate - corner_radius - clip_width / 2 + wall_width - gap,
          wall_width, wall_height]);
}

module one_end() {
    fullcorner();
    mirror([1,0,0]) fullcorner();

    phase = anim_phase();
    tflow = ($t * 8) - phase;

    aflow = (phase == 1 ? 1-tflow :
             phase == 2 ? 0 :
             phase == 3 ? tflow :
             phase == 6 ? 1-tflow :
             phase == 7 ? tflow :
             1);

    if (object == "all")
        translate([-clip_width / 2,
                   -spring_axle_diameter / 2,
                   spring_arm_length + deck_thickness + 2 * 3])
            rotate([23 * aflow,0,0])
                clip();

    translate([-clip_width / 2,
           -spring_axle_diameter/2,
           wall_width + deck_thickness + wall_width + spring_arm_length])
        cliphouse();
}

/* animation:

0 paused while skates stored, clip locked.
1 move clip open
2 move skate out halfway
3 move clip closed + move skate out rest
4 pause
5 move skate back halfway
6 move clip open + move skate back rest
7 move clip closed

*/

function anim_phase() = floor($t * 8);

module skates() {
    phase = anim_phase();
    tflow = ($t * 8) - phase;

    move_out = 60;
    move_out_z_l = 15;
    move_out_z_r = 8;

    if (phase == 2) {
        translate([skate_width/2,3 + skate_length+2,3])
        rotate([14*tflow,0,180])
        skate("left");
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap,
            3 + deck_thickness + 12])
        rotate([-7 + 14 * tflow,0,0]) skate("right");
    } else if (phase == 3) {
        translate([skate_width/2, 3 + skate_length+2 - tflow * move_out, 3 + tflow*move_out_z_l])
        rotate([14*1,0,180])
        skate("left");
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap + tflow * move_out,
            3 + deck_thickness + 12 + tflow * move_out_z_r])
        rotate([-7 + 14 * 1,0,0]) skate("right");
    } else if (phase == 4) {
        translate([skate_width/2, 3 + skate_length+2 - move_out, 3 + move_out_z_l])
        rotate([14*1,0,180])
        skate("left");
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap + move_out,
            3 + deck_thickness + 12 + move_out_z_r])
        rotate([-7 + 14 * 1,0,0]) skate("right");
    } else if (phase == 5) {
        translate([skate_width / 2,
                   3 + skate_length + 2 - (1 - tflow) * move_out,
                   3 + (1 - tflow)*move_out_z_l])
        rotate([14*1, 0, 180])
        skate("left");
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap + (1 - tflow) * move_out,
            3 + deck_thickness + 12 + (1 - tflow) * move_out_z_r])
        rotate([-7 + 14 * 1,0,0]) skate("right");
    } else if (phase == 6) {
        translate([skate_width / 2, 3 + skate_length+2,3])
        rotate([14*(1 - tflow), 0, 180])
        skate("left");
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap,
            3 + deck_thickness + 12])
            rotate([-7 + 14 * (1 - tflow),0,0]) skate("right");
    } else {
        translate([skate_width/2,3 + skate_length+2,3])
        rotate([0,0,180])
        skate("left");
        translate([
            -skate_width / 2,
            3 + skate_length - skate_overlap,
            3 + deck_thickness + 12])
            rotate([-7,0,0]) skate("right");
    }
}

module device() {
    side_wall();
    mirror([1, 0, 0]) side_wall();

    one_end();
    translate([0, 2 * skate_length - skate_overlap + 8,0])
        mirror([0, 1, 0])
            one_end();
}

object = "all";

if (object == "frame" || object == "all") {
  color("gold") device();
}

if (object == "skates" || object == "all") {
  skates();
}

if (object == "clip") {
  clip();
}
