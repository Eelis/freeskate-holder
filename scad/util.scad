include <constants.scad>

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