# Component fit-check models

Open `components.scad` in OpenSCAD, set `item` near the top to the desired name, press F6, then export STL or OBJ. Available names: `battery_18650`, `tp4056`, `mt3608`, `esp32_mini`, `ina226`, `bmp280`, `motor_gearbox`, `wheel_65`, `wheel_68`, `wheel_70`, and `all`.

The models are deliberately simple envelope dummies sized from the supplied nominal dimensions. `motor_gearbox` is a 70 × 22 × 18 mm box with illustrative tabs and shaft. Wheels have nominal diameter 65/68/70 mm, 8 mm width, and an 8 mm axle bore. Confirm the real motor shaft, wheel hub, board connector height, and mounting hole locations before making production mounts. The sensor board blocks are approximate outlines; they help reveal collisions and clearances, not fit component terminals exactly.

The `all` setting lays out the objects as a separated reference set for a single export; export each by selecting its individual `item` value when testing enclosure placement.
