$fa = 1;
$fs = 0.4;

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

module slice(h, r, a,start=0){
    difference(){
        cylinder(h=h, r=r);
        rotate([0,0,a])
        translate([-r,0,-epsilon]) cube([r*2,r,h+epsilon*2]);
        rotate([0,0,start])
        translate([-r,-r,-epsilon*2]) cube([r*2,r,h+epsilon*4]);
    }
}

module arc(h, r, a, w, start=0){
    difference() {
        slice(h=h, r=r, a=a, start=start);
        translate([0,0,-epsilon]) cylinder(h=h+2*epsilon, r=r-w);
    }
}


skate_width = 143;
skate_length = 179;
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

module corner() {
    arc(h=wall_height, w=wall_width, r=corner_radius, a=90);
    
    translate([corner_radius*0.7,corner_radius*0.7,15])
    rotate([0,90,315])
    arc(h=wall_width*2, w=wall_width, r=8, a=180);
}

module side_wall() {

    translate([skate_width / 2,
               corner_radius-epsilon,
               0])
    cube([wall_width, skate_length*2-skate_overlap - corner_radius*2 + 2*epsilon+8, wall_height]);

    // bridge:
       
    bridge_radius=15;
    bridge_size=20;
    translate([
        skate_width/2 - bridge_radius + wall_width,
        bridge_offset + bridge_size,
        wall_height])
    rotate([90,0,0])
    arc(h=bridge_size,w=wall_width,r=bridge_radius,a=90);
    
    translate([0,bridge_offset,wall_height+bridge_radius-wall_width])
    cube([skate_width / 2 - bridge_radius + wall_width, bridge_size, wall_width]);

    translate([0,bridge_offset,wall_height-wall_width])
    cube([skate_width / 2 - bridge_radius + wall_width, wall_width, bridge_radius]);

    translate([-epsilon,bridge_offset,wall_height-wall_width])
    cube([skate_width / 2 + epsilon*2, wall_width, wall_width+epsilon]);


    
    bridge_offset = skate_length - skate_overlap - wall_width;
    
    translate([skate_width / 2 - bridge_radius + wall_width,
               bridge_offset + wall_width,
               wall_height])
    rotate([90,0,0])
    slice(h=wall_width,r=bridge_radius,a=90);
    
    // upper platform:
    translate([-epsilon, skate_length-15, wall_width + deck_thickness + 5.5])
    rotate([-7,0,0])
    cube([skate_width/2 + epsilon*2, 70, wall_width]);

    translate([clip_width/2+gap, skate_length-15, wall_width + deck_thickness + 5.5])
    rotate([-7,0,0])
    cube([20, 177, wall_width]);

    
    // lower platform:
    translate([-epsilon, 90, 0])
    cube([skate_width/2 + epsilon*2, 100, wall_width]);

    translate([clip_width/2+gap, 0, 0])
    cube([20, 100, wall_width]);

    
    // backstop:
    translate([-epsilon, 188])
    cube([skate_width/2 + epsilon*2, wall_width, 20]);

}


cliphouse_wall_width = 3;
clip_width = spring_axle_length + 2 * cliphouse_wall_width;

epsilon = 0.3;

module ring(h, rinner, router) {
    difference() {
        union() {
            cylinder(h=h,r=router);
        }
        translate([0,0,-epsilon])
        cylinder(h=h+epsilon*2,r=rinner);
    }
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
                    translate([0,0,-epsilon])
                        cylinder(h=clip_wall_width+2*epsilon,r=bolt_diameter/2);
        }
    }

    translate([0,spring_axle_diameter/2,-spring_arm_length])
        cube([clip_width, clip_thickness, spring_arm_length]);
    // side walls
    translate([0,0,0]) side();
    translate([spring_axle_length+cliphouse_wall_width,0,0]) side();

    difference(){
        translate([clip_width,0,0])
        rotate([-90,0,90])
        arc(h=clip_width,r=spring_arm_length+clip_thickness,a=140,w=clip_thickness);

        translate([0-epsilon,spring_axle_diameter/2+clip_thickness,-spring_arm_length*2])
            cube([clip_width+2*epsilon, spring_arm_length, spring_arm_length*2+epsilon]);
    }

    rotate([90,0,90])
    arc(h=clip_width,r=spring_axle_diameter / 2 + clip_thickness,a=130,w=wall_width);

    translate([clip_width+3,0,0])
        rotate([-90,0,90])
            arc(h=clip_width+2*3,
                r=spring_arm_length+5,
                a=147,
                w=7,
                start=134);
}

gap = 0.5;

module cliphouse() {
    // back wall
    translate([-cliphouse_wall_width,
               -cliphouse_wall_width - spring_axle_diameter / 2,
               -19])
        cube([clip_width + 2 * cliphouse_wall_width,
              cliphouse_wall_width,
              10-2*gap]);
    
    module side_wall() {
        difference() {
            union() {
                
                translate([0,0,-19])
                cube([cliphouse_wall_width - gap,
                      spring_axle_diameter + 2 * cliphouse_wall_width,
                      19]);

                translate([0,cliphouse_wall_width+spring_axle_diameter/2,0])
                rotate([0,90,0])
                cylinder(h=cliphouse_wall_width-gap,r=spring_axle_diameter/2+cliphouse_wall_width);
                
                translate([0,0,-19])
                mirror([0,0,1])
                prism(cliphouse_wall_width-gap,
                      spring_axle_diameter + wall_width,
                        wall_width + deck_thickness+wall_width+spring_arm_length-19);
            }
            translate([-epsilon,cliphouse_wall_width+spring_axle_diameter/2,0])
            rotate([0,90,0])
            cylinder(h=cliphouse_wall_width+2*epsilon,r=bolt_diameter / 2);
        }
    }
    
    translate([-cliphouse_wall_width,-cliphouse_wall_width-spring_axle_diameter/2,0]) side_wall();
    translate([clip_width + gap,-cliphouse_wall_width-spring_axle_diameter/2,0]) side_wall();
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

module skate() {
    color("red") deck();
    translate([skate_width/2,skate_length/2,30])
    rotate([0,0,15])
    truck();
}

module truck() {
    translate([0,0,10])
    color("grey") cube([111,55,55],center=true);
    
    translate([52,0,30])
    rotate([90,0,0])
    color("black") cylinder(r=35,h=45,center=true);

    translate([-52,0,30])
    rotate([90,0,0])
    color("black") cylinder(r=35,h=45,center=true);
    
}

spring_wire_width = 1.3;



//translate([clip_wall_width,0,2*3+deck_thickness]) color("grey") spring();
//$t = 1;

flow = sin($t * 360)/2+0.5;

module fullcorner() {
    translate([corner_radius-skate_width / 2 - wall_width,corner_radius,0])
    rotate([0,0,180])
    corner();
    translate([-skate_width / 2 + corner_radius - wall_width, 0, 0])
    cube([skate_width / 2 - corner_radius - clip_width / 2 + wall_width - gap, wall_width, wall_height]);
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
               -spring_axle_diameter/2,
               spring_arm_length+deck_thickness+2*3])
            rotate([23*aflow,0,0])
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

    if (phase == 2) {
        translate([skate_width/2,3 + skate_length+2,3])
        rotate([14*tflow,0,180])
        skate();
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap,
            3 + deck_thickness + 12])
        rotate([-7 + 14 * tflow,0,0]) skate();
    } else if (phase == 3) {
        translate([skate_width/2, 3 + skate_length+2 - tflow * 40, 3 + tflow*10])
        rotate([14*1,0,180])
        skate();
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap + tflow * 40,
            3 + deck_thickness + 12 + tflow * 5])
        rotate([-7 + 14 * 1,0,0]) skate();
    } else if (phase == 4) {
        translate([skate_width/2, 3 + skate_length+2 - 40, 3 + 10])
        rotate([14*1,0,180])
        skate();
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap + 1 * 40,
            3 + deck_thickness + 12 + 1 * 5])
        rotate([-7 + 14 * 1,0,0]) skate();
    } else if (phase == 5) {
        translate([skate_width/2, 3 + skate_length+2 - (1 - tflow) * 40, 3 + (1 - tflow)*10])
        rotate([14*1,0,180])
        skate();
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap + (1 - tflow) * 40,
            3 + deck_thickness + 12 + (1 - tflow) * 5])
        rotate([-7 + 14 * 1,0,0]) skate();
    } else if (phase == 6) {
        translate([skate_width/2,3 + skate_length+2,3])
        rotate([14*(1 - tflow),0,180])
        skate();
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap,
            3 + deck_thickness + 12])
        rotate([-7 + 14 * (1 - tflow),0,0]) skate();
    } else {
        translate([skate_width/2,3 + skate_length+2,3])
        rotate([0,0,180])
        skate();
        translate([
            -skate_width/2,
            3 + skate_length - skate_overlap,
            3 + deck_thickness + 12])
        rotate([-7,0,0]) skate();
    }
}

module device() {
    side_wall();
    mirror([1,0,0]) side_wall();

    one_end();
    translate([0,2*skate_length-skate_overlap+8,0])
    mirror([0,1,0]) one_end();
}

module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
}
   


object = "all";

if (object == "frame" || object == "all") {
  device();
}

if (object == "skates" || object == "all") {
  skates();
}

if (object == "clip") {
  clip();
}