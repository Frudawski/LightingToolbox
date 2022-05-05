# LightingToolbox
The LightingToolbox contains numerous Matlab/Octave functions for lighting reseach calculations, plotting and colorimetry.

**Categories**
- Calculation functions
- Colorimetric functions
- Daylight functions
- Plot functions
- Image functions
- Measurement functions

# LigthingToolbox setup
**MATLAB**
* Download the Lighting Toolbox and move it to a location of your choice.
* Start Matlab
* Add the Lighting Toolbox to Matlab's search path:
  - Type: “addpath(‘path_to_lighting_toolbox’)” in the command window
  - Or click “Set Path” button under Matlab HOME tab -> “Add Folder…” -> select folder -> confirm -> “Save”
* Test the Lighting Toolbox functionality:
  - Type: “plotciexy” in the command window
  - A plot of the CIE x and y chromaticity should appear

**GNU Octave**
* Download the Lighting Toolbox and move it to a location of your choice.
* Start GNU Octave
* Add the Lighting Toolbox to Octave's search path:
  - type: “addpath(‘path_to_lighting_toolbox’)” in the command window
* Optional: install image package:
  - Type: “install package -forge image” in the command window
* Recommended: load image package at startup:
  - Type: “edit octaverc” in command window
  - Add line: “pkg load image” to octaverc file
  - Save -> close Octave -> start Octave
* Test the Lighting Toolbox functionality:
  - Type: “plotciexy” in the command window
  - A plot of the CIE x and y chromaticity should appear

# Documentation
The LigthingToolbox is documenteted with numerous function examples on: www.frudawski.de/LightingToolbox
