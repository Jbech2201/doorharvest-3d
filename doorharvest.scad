/* Doorharvest enclosure, units: mm.  X=front/forward, Y=left-right, Z=up.
   Export separately: set part = "chassis" or "lid" then F6/export STL.
   Clearance values are deliberately editable. */
$fn=48;
part="chassis";
L=158; W=142; H=39; wall=3; floor=3; fit=0.30;
module rr(x,y,z, r=4) { // rounded plan box
  hull() for (a=[r,x-r]) for(b=[r,y-r]) translate([a,b,0]) cylinder(r=r,h=z);
}
module m3post(x,y,h=31) difference(){ translate([x,y,floor]) cylinder(d=8,h=h); translate([x,y,floor-0.1]) cylinder(d=2.8,h=h+0.2); }
module chassis(){
 difference(){
  union(){
   rr(L,W,floor); // base
   // Perimeter with broad wheel reliefs. Wheels sit outside side walls, axle at Z=34.
   translate([0,0,floor]) cube([L,wall,H-floor]);
   translate([L-wall,0,floor]) cube([wall,W,H-floor]);
   for (y=[0,W-wall]) { translate([0,y,floor]) cube([23,wall,H-floor]); translate([47,y,floor]) cube([L-47,wall,H-floor]); }
   // M3 lid posts
   m3post(10,10); m3post(10,W-10); m3post(L-10,10); m3post(L-10,W-10);
   // electronics posts: ESP32, MT3608, INA226 (M2 clearance/pilot)
   for(p=[[91,103],[121,103],[91,128],[121,128],[94,12],[119,12],[94,35],[119,35]])
     translate([p[0],p[1],floor]) difference(){cylinder(d=5.5,h=6);translate([0,0,-.1])cylinder(d=2,h=6.2);}
   // battery pack locating rails: 72 x 62 envelope, x=80..152, y=40..102
   translate([78,39,floor]) cube([76,2,5]); translate([78,101,floor]) cube([76,2,5]);
   // Motor pockets: gearboxes lie along X, shaft points outward along +/-Y.
   // Two cross straps per motor give a 22 x 18 gearbox an adjustable zip-tie clamp.
   for(y=[8,W-11]) for(x=[12,55]) translate([x,y,7]) cube([4,3,25]);
   // Low inner wheel guards around the external 65-70 mm wheels
   for(y=[wall,W-wall-2]) translate([23,y,4]) cube([34,2,32]);
  }
  // USB-C opening: rear (X=max) wall, 11 x 5.2 mm
  translate([L-wall-.1,W/2-5.5,23]) cube([wall+.2,11,5.2]);
  // Wheel clearance slots, centered on shaft: 38 mm long x 14 mm high.
  for(y=[-.1,W-wall+.1]) translate([22,y,27]) cube([36,wall+.2,14]);
 }
}
module lid(){
 // inverted print orientation: top surface is at z=3, rim projects downward
 difference(){
  union(){
   rr(L+2*fit,W+2*fit,3); // cap overhang
   translate([fit,fit,-10]) difference(){ rr(L-2*wall-2*fit,W-2*wall-2*fit,10); translate([wall,wall,-.1]) rr(L-4*wall-2*fit,W-4*wall-2*fit,10.2); }
   // underside board keepers (adhesive/zip-tie or M2 screws)
   for(p=[[91,103],[121,103],[91,128],[121,128],[94,12],[119,12],[94,35],[119,35]]) translate([p[0],p[1],-5]) cylinder(d=5.5,h=5);
  }
  // M3 clearance holes align chassis posts
  for(p=[[10,10],[10,W-10],[L-10,10],[L-10,W-10]]) translate([p[0]+fit,p[1]+fit,-10.1]) cylinder(d=3.4,h=13.2);
  // MT3608 trimmer access; board position documented in layout notes
  translate([106+fit,23+fit,-.1]) cylinder(d=9,h=3.2);
  // BMP280 breathing vents, above sensor region x=105..117,y=115..125
  for(x=[106,110,114,118]) translate([x+fit,120+fit,-.1]) cylinder(d=2,h=3.2);
 }
}
if(part=="chassis") chassis(); else lid();
