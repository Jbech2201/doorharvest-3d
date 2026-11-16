/* Doorharvest component fit-check models. Units: mm.
   Set item to one of: battery_18650, tp4056, mt3608, esp32_mini,
   ina226, bmp280, motor_gearbox, wheel_65, wheel_68, wheel_70, all.
   These are envelope dummies for placement checks, not detailed electronics. */
$fn=48;
item="all";
module board(x,y,z=1.6,corner=1.5){
  linear_extrude(height=z) offset(r=corner) offset(delta=-corner)
    square([x-2*corner,y-2*corner]);
}
module battery(){ color("#3d434a") cylinder(d=18.5,h=65); }
module tp4056(){ color("#236caa") board(26,17,1.6); color("#555") translate([22,5,1.6]) cube([4,7,3]); }
module mt3608(){ color("#27804c") board(36,17,1.6); color("#c99a24") translate([25,7,1.6]) cylinder(d=7,h=5); }
module esp32(){ color("#246b9b") board(35,20,1.6); color("#aaa") translate([3,4,1.6]) cube([8,12,2]); }
module ina226(){ color("#2c8b58") board(25,18,1.6); color("#555") translate([8,6,1.6]) cube([8,6,2]); }
module bmp280(){ color("#2c8b58") board(18,12,1.6); color("#333") translate([6,3,1.6]) cube([6,6,2]); }
// Generic gearbox envelope 70 x 22 x 18. Shaft and mounting tabs are illustrative.
module motor(){
 color("#777") translate([0,0,0]) cube([70,22,18]);
 color("#aaa") translate([70,11,7]) rotate([0,90,0]) cylinder(d=6,h=8);
 color("#555") translate([12,-3,3]) cube([8,28,2]);
 color("#555") translate([50,-3,3]) cube([8,28,2]);
}
// Wheel axle along X; wheel plane normal X, diameter selected by parameter.
module wheel(d=68,width=8){
 color("#252525") rotate([0,90,0]) difference(){
   cylinder(d=d,h=width,center=true);
   cylinder(d=8,h=width+1,center=true);
 }
 color("#999") rotate([0,90,0]) cylinder(d=22,h=width+0.5,center=true);
}
module placed(){
 if(item=="battery_18650") battery();
 else if(item=="tp4056") tp4056();
 else if(item=="mt3608") mt3608();
 else if(item=="esp32_mini") esp32();
 else if(item=="ina226") ina226();
 else if(item=="bmp280") bmp280();
 else if(item=="motor_gearbox") motor();
 else if(item=="wheel_65") wheel(65);
 else if(item=="wheel_68") wheel(68);
 else if(item=="wheel_70") wheel(70);
 else {
   // Side by side reference tray: objects separated for individual inspection.
   translate([0,0,0]) battery();
   translate([78,0,0]) tp4056();
   translate([112,0,0]) mt3608();
   translate([155,0,0]) esp32();
   translate([198,0,0]) ina226();
   translate([231,0,0]) bmp280();
   translate([0,45,0]) motor();
   translate([90,58,34]) wheel(65);
   translate([135,58,34]) wheel(68);
   translate([180,58,34]) wheel(70);
 }
}
placed();
