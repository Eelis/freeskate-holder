include <constants.scad>

module slice(h, r, a, start=0) {

    rotate([0, 0, start])
    rotate_extrude(angle=360-start) {
        square([r,h]);
    }
}

module arc(h, r, a, w, start=0) {
    rotate([0, 0, start])
        rotate_extrude(angle=a-start)
            translate([r - w, 0, 0]) square([w, h]);
}

module prism(l, w, h) {
    rotate([0, 90, 0])
        linear_extrude(height=l)
           polygon([[0, 0], [-h,w], [0, w]]);
}

module spring() {
    // axle
    translate([0, 0, spring_arm_length])
        rotate([0, 90, 0])
            cylinder(h = spring_axle_length,
                     r = spring_axle_diameter / 2);
    // arms
    translate([spring_wire_width / 2,
               -spring_axle_diameter / 2 + spring_wire_width / 2,
               0])
        cylinder(h = spring_arm_length,
                 r = spring_wire_width / 2);
    translate([spring_axle_length - spring_wire_width / 2,
               spring_axle_diameter / 2 - spring_wire_width / 2,
               0])
        cylinder(h = spring_arm_length,
                 r = spring_wire_width / 2);
    // hands
    translate([0,
               -spring_axle_diameter / 2 + spring_wire_width / 2,
               spring_wire_width / 2])
        rotate([0, 90, 0])
            cylinder(h = spring_axle_length * 0.75,
                     r = spring_wire_width / 2);
    translate([0.25 * spring_axle_length,
               spring_axle_diameter / 2 - spring_wire_width / 2,
               spring_wire_width / 2])
        rotate([0,90,0])
            cylinder(h = spring_axle_length * 0.75,
                     r = spring_wire_width / 2);
}

module rounded_square(w, l, r) {
    translate([r, 0]) square([w - r * 2, l]);
    translate([0, r]) square([w, l - r * 2]);
    translate([r, r])         circle(r);
    translate([w - r, r])     circle(r);
    translate([r, l - r])     circle(r);
    translate([w - r, l - r]) circle(r);
}

module rounded_cube(w, l, h, r) {
    linear_extrude(height=h) rounded_square(w, l, r);
}
