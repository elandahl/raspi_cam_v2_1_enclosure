// Parameters for Raspberry Pi Camera V2.1
camera_width = 25;
camera_height = 24;
camera_thickness = 9;

// Enclosure Parameters
enclosure_wall_thickness = 7;
enclosure_top_thickness = 2;

// Camera mounting hole parameters
hole_diameter = 2.5;
hole_spacing_x = 21;
hole_spacing_y = 14;

// Parameters for #8-32 Hex Socket Head Bolt (simplified, without threads or hex socket)
bolt_diameter = 4.166; // 0.164 inch
head_diameter = 7.874; // 5/16 inch
head_height = 5.08; // Example height
shaft_length = 20; // Example length
thru = 1; // Extra diameter for thru hole clearance

module simplified_head_bolt() {
    // Create the bolt head
    cylinder(d = head_diameter+thru, h = head_height, $fn = 50);

    // Create the bolt shaft
    translate([0, 0, head_height]) {
        cylinder(d = bolt_diameter+thru, h = shaft_length, $fn = 50);
    }
}

//vertical translation shift for holes
vshift = -enclosure_top_thickness;

module raspberry_pi_camera_enclosure() {
    // Main enclosure
    difference() {
        cube([camera_width + 2 * enclosure_wall_thickness, camera_height + 2 * enclosure_wall_thickness, camera_thickness + enclosure_top_thickness]);
        translate([enclosure_wall_thickness, enclosure_wall_thickness, enclosure_top_thickness]) {
            cube([camera_width, camera_height, camera_thickness + 1]);
        }
    
    // Camera hole
    translate([enclosure_wall_thickness + (camera_width/2) - 3.5, enclosure_wall_thickness, enclosure_top_thickness - 0.5+vshift]) {
        cube([7, 9, 0.5-2*vshift ]);
    }
    }
}

module camera_mounting_holes() {
    for (x=[-1, 1], y=[-1, 1]) {
        translate([(camera_width + 2 * enclosure_wall_thickness) / 2 + x * hole_spacing_x / 2, (camera_height + 2 * enclosure_wall_thickness) / 2 + y * hole_spacing_y / 2, enclosure_top_thickness+2*vshift]) {
            cylinder(d = hole_diameter, h = 2 * enclosure_wall_thickness-vshift, $fn = 50);
        }
    }
}

module bolt_hole() {
    translate([enclosure_wall_thickness+.5,camera_width/2+      enclosure_wall_thickness,enclosure_top_thickness+(head_diameter+thru)/2]){
        rotate([0,270,0]){
            simplified_head_bolt();
        }
    }
}

 //Combine enclosure and mounting holes
difference() {
    raspberry_pi_camera_enclosure();
    camera_mounting_holes();
    bolt_hole();
}
