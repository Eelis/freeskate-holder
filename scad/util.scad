include <constants.scad>

module arc(h = 10, r = 10, a = 90, w = 1, start = 0)
    rotate([0, 0, start])
        rotate_extrude(angle = a - start)
            translate([r - w, 0, 0])
                square([w, h]);

module prism(l, w, h)
    rotate([0, 90, 0])
        linear_extrude(height = l)
           polygon([[0, 0], [-h, w], [0, w]]);

module rounded_square(w, l, r) {
    translate([r, 0]) square([w - r * 2, l]);
    translate([0, r]) square([w, l - r * 2]);
    translate([r, r])         circle(r);
    translate([w - r, r])     circle(r);
    translate([r, l - r])     circle(r);
    translate([w - r, l - r]) circle(r);
}

module rounded_cube(w = 10, l = 10, h = 10, r = 2)
    linear_extrude(height = h)
        rounded_square(w, l, r);

module mirror_copy(x) {
    children();
    mirror(x) children();
}
