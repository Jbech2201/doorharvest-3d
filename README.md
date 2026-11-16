# Doorharvest print model

All dimensions are millimetres. `doorharvest.scad` is the editable authoritative model. Set `part` and export each part using OpenSCAD. `export_meshes.py` creates the included preview/print-layout `STL` and `OBJ` without needing OpenSCAD.

Parts: chassis: PETG preferred (PLA acceptable for indoor, low heat); print floor-down, no support. Lid: PLA or PETG; print outer face down with the rim up, no support. Use 0.20 mm layers, 4 perimeters and 25–35% infill. M3 lid screws enter 2.8-mm pilot holes in chassis posts; drill/tap, or use heat-set inserts. Board posts use 2-mm pilots.

Exported envelope per part: 158.6 x 142.6 mm, below a 180 x 180 mm bed. Assembly body: 158 x 142 x 39 mm. With 68-mm wheels, nominal outside width is 162 mm and wheel-bottom to chassis-floor clearance is 5 mm (wheel axle at approximately Z=34 mm; verify against the actual gearbox hub before printing).
