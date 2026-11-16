"""Dependency-free approximate STL/OBJ exporter for the Doorharvest print parts.
The authoritative, exact CSG (including circular cut-outs) is doorharvest.scad.
Meshes use mm and have the intended bed orientation."""
from pathlib import Path
import math

OUT=Path(__file__).parent
class Mesh:
 def __init__(s): s.v=[];s.f=[]
 def box(s,x,y,z,dx,dy,dz):
  n=len(s.v); s.v += [(x+a*dx,y+b*dy,z+c*dz) for c in (0,1) for b in (0,1) for a in (0,1)]
  s.f += [(n+a,n+b,n+c) for a,b,c in [(0,1,3),(0,3,2),(4,6,7),(4,7,5),(0,4,5),(0,5,1),(2,3,7),(2,7,6),(0,2,6),(0,6,4),(1,5,7),(1,7,3)]]
 def tube(s,x,y,z,ro,ri,h,n=32):
  n0=len(s.v)
  for zz in (z,z+h):
   for r in (ro,ri):
    for i in range(n):
     a=2*math.pi*i/n;s.v.append((x+r*math.cos(a),y+r*math.sin(a),zz))
  # indices: bottom outer 0, bottom inner n, top outer 2n, top inner 3n
  for i in range(n):
   j=(i+1)%n
   s.f += [(n0+i,n0+j,n0+2*n+j),(n0+i,n0+2*n+j,n0+2*n+i),
           (n0+n+i,n0+3*n+j,n0+n+j),(n0+n+i,n0+3*n+i,n0+3*n+j),
           (n0+2*n+i,n0+2*n+j,n0+3*n+j),(n0+2*n+i,n0+3*n+j,n0+3*n+i),
           (n0+i,n0+n+j,n0+j),(n0+i,n0+n+i,n0+n+j)]
 def save(s,name):
  with open(OUT/(name+'.stl'),'w') as g:
   g.write('solid '+name+'\n')
   for a,b,c in s.f:
    p,q,r=(s.v[i] for i in (a,b,c)); ux,uy,uz=q[0]-p[0],q[1]-p[1],q[2]-p[2];vx,vy,vz=r[0]-p[0],r[1]-p[1],r[2]-p[2]; nx=uy*vz-uz*vy;ny=uz*vx-ux*vz;nz=ux*vy-uy*vx
    g.write(f' facet normal {nx} {ny} {nz}\n  outer loop\n   vertex {p[0]} {p[1]} {p[2]}\n   vertex {q[0]} {q[1]} {q[2]}\n   vertex {r[0]} {r[1]} {r[2]}\n  endloop\n endfacet\n')
   g.write('endsolid '+name+'\n')
  with open(OUT/(name+'.obj'),'w') as g:
   g.write('# Doorharvest; millimetres\n')
   for p in s.v:g.write('v %.3f %.3f %.3f\n'%p)
   for a,b,c in s.f:g.write(f'f {a+1} {b+1} {c+1}\n')

def chassis():
 m=Mesh(); L,W,H=158,142,39; w=3
 m.box(0,0,0,L,W,3)
 # side walls: a 12 x 11 mm axle/gearbox aperture from x=29..41 at the top
 for y in (0,W-3):
  m.box(0,y,3,L,3,25); m.box(0,y,28,29,3,11); m.box(41,y,28,L-41,3,11)
 # front wall, plus rear wall divided around USB-C opening y=65.5..76.5, z=23..28.2
 m.box(0,0,3,3,W,36)
 m.box(L-3,0,3,3,65.5,36);m.box(L-3,76.5,3,3,W-76.5,36);m.box(L-3,65.5,3,3,11,20);m.box(L-3,65.5,28.2,3,11,10.8)
 for x,y in [(10,10),(10,132),(148,10),(148,132)]:m.tube(x,y,3,4,1.4,31)
 for x,y in [(91,103),(121,103),(91,128),(121,128),(94,12),(119,12),(94,35),(119,35)]:m.tube(x,y,3,2.75,1,6,20)
 m.box(78,39,3,76,2,5);m.box(78,101,3,76,2,5)
 for y in (3,136):m.box(7,y,10,67,3,8);m.box(7,y,28,67,3,8)
 return m
def lid():
 m=Mesh();L,W=158,142; fit=.3
 # 2-mm tiled top plate, omitting real trimmer / BMP openings and M3 holes
 # The tiled construction avoids boolean-engine dependencies in this exporter.
 step=2
 for x in range(0,160,step):
  for y in range(0,144,step):
   cx=x+1;cy=y+1
   cut=((cx-(106+fit))**2+(cy-(23+fit))**2<4.5**2 or
        any((cx-(px+fit))**2+(cy-(py+fit))**2<2.0**2 for px,py in [(10,10),(10,132),(148,10),(148,132)]) or
        any((cx-(px+fit))**2+(cy-(120+fit))**2<1.0**2 for px in (106,110,114,118)))
   if not cut:m.box(x,y,0,step,step,3)
 for a,b,c,d in [(fit,fit,L-2*fit,3),(fit,W-3-fit,L-2*fit,3),(fit,fit,3,W-2*fit),(L-3-fit,fit,3,W-2*fit)]:m.box(a,b,-10,c,d,10)
 for x,y in [(10,10),(10,132),(148,10),(148,132)]:m.tube(x+fit,y+fit,-10,4.0,1.7,13)
 return m
for name,make in [('doorharvest_chassis',chassis),('doorharvest_lid',lid)]: make().save(name)
