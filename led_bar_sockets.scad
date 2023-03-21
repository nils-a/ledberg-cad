// Male and female sockets for Ikea LEDBERG LED strips.  These are designed to
// be filled with 22 gauge solid core wire (or similar).  Multi-filament wire
// also works if you twist it. It'll work even better if you tin it. All units
// are in mm.

// Original design by Steve Pomeroy (https://www.thingiverse.com/xxv/)
//  under CC-BY-SA (https://creativecommons.org/licenses/by-sa/3.0/) in 2013.
//  See https://www.thingiverse.com/thing:121247
//
// This design is an adaption for newer Ledberg (bought in Mar. 2023)
// Nils Andresen, Mar. 2023, CC-BY-SA
//

// Size of male connector. This is the base connector size.
male_x=6.8;
male_y=11;
male_z=4.7;

// male connector has two tounges on top
female_groove_y=6;
female_groove_z=1;
female_groove_x=0.4;

// female connector has a tounge on the left side
male_groove_x=0.4;
male_groove_z=1;
male_groove_z_pos=1;


// thickness of the outer wall.
wall_thickness=1.5;

// size of female housing.
female_y=10+male_y;

// extra height above connector for electronics
female_z_extra=2;
male_z_extra=1;

// The amount of minor offset to make differences work correctly.
diff_offset=.01;

// contact channel width
contact_channel_x=1.5;
contact_channel_y=40;
contact_channel_z=1.5;

// how much of a lip to give the contact channel at the end of the socket
contact_channel_recess_male=1;
// No lip on the female, as it could potentially make the bar get stuck.
contact_channel_recess_female=0;

// The distance between the centers of the two contacts.
contact_channel_separation=3;

// How much extra to add to account for extrusion inaccuracies. This makes the male smaller and the female larger. 0.1 works well on a Lulzbot 0.5mm nozzle, 3mm filament.
extrusion_offset=0.1;

male_contact_z=male_z-contact_channel_z-wall_thickness+diff_offset-extrusion_offset*2;

// only create "parts"
print_male=true;
print_female=true;

module contact_channel(x, y, z, recess, end_lock_z, end_lock_z_offset, end_lock_y_offset){
  // one contact left
  translate([(wall_thickness + x/2)-contact_channel_separation/2-contact_channel_x/2, recess, z+wall_thickness]) {
    cube([contact_channel_x, contact_channel_y, contact_channel_z]);
	  translate([0, end_lock_y_offset, end_lock_z_offset-wall_thickness]) {
		  cube([contact_channel_x, contact_channel_x, end_lock_z]);
	  }
  }
  // right contact
  translate([(wall_thickness + x/2)+contact_channel_separation/2-contact_channel_x/2, recess, z+wall_thickness]) {
    cube([contact_channel_x, contact_channel_y, contact_channel_z]);
	  translate([0, end_lock_y_offset, end_lock_z_offset-wall_thickness]) {
		  cube([contact_channel_x, contact_channel_x, end_lock_z]);
	  }
  }
}

module female_grooves(xpos, ypos, zpos, extra_witdh) {
  module tounge() {
    cube([female_groove_x+extra_witdh, female_groove_y, female_groove_z]);
  }

  // left tounge
  translate([xpos-extra_witdh, ypos, zpos]) {
    tounge();
  }

  // right tounge
  translate([xpos+male_x-female_groove_x-(2*extrusion_offset), ypos, zpos]) {
    tounge();
  }
}

module male_groove(xpos, ypos, zpos) {
  translate([xpos, ypos, zpos]) {
    cube([male_groove_x, male_y, male_groove_z]);
  }
}

module female() {
  difference() {
    // Outer casing
    cube([male_x+wall_thickness*2+extrusion_offset*2, female_y,
      male_z+wall_thickness*2 + female_z_extra+extrusion_offset*2]);

    // Socket hole
    translate([wall_thickness, -diff_offset, wall_thickness]){
      cube([male_x + extrusion_offset*2, male_y+diff_offset, male_z + extrusion_offset*2]);
    }
    contact_channel(male_x +extrusion_offset*2, male_y, male_z+ extrusion_offset*2, contact_channel_recess_female, male_z + wall_thickness*2+female_z_extra+extrusion_offset*2, 0, wall_thickness);
    // groove
    female_grooves(wall_thickness+extrusion_offset*2, 0, male_z + extrusion_offset*2 + wall_thickness, extrusion_offset);
  }
}

module male(){
  difference(){
    union(){
      translate([wall_thickness, 0, 0]){
        cube([male_x - extrusion_offset*2, male_y, male_z - extrusion_offset*2]);
      }
      translate([-extrusion_offset*2, male_y, -extrusion_offset*2]){
        cube([male_x+wall_thickness*2 + extrusion_offset*2, male_y, male_z+wall_thickness+male_z_extra+extrusion_offset*2]);
      }
    }
    contact_channel(male_x-extrusion_offset*2, male_y, male_contact_z, contact_channel_recess_male, male_z, -male_contact_z, 0);
    // groove
    male_groove(wall_thickness, 0, male_groove_z_pos + extrusion_offset);
  }
}

rotation=-90;

// Rotating them -90 degrees made the prints come out the best.
if(print_female) {
translate([0,0, female_y]) {
    rotate([rotation, 0, 0]){
      female();
    }
}
}

if(print_male) {
translate([15, 0, female_y+contact_channel_recess_male]){
  rotate([rotation, 0, 0]){
	male();
  }
}
}