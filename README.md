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
1. Download the Lighting Toolbox and move it to a location of your choice.
2. Start Matlab
3. Add the Lighting Toolbox to Matlab's search path:
  	* Type: “addpath(‘path_to_lighting_toolbox’)” in the command window
    * Or click “Set Path” button under Matlab HOME tab -> “Add Folder…” -> select folder -> confirm -> “Save”
4. Test the Lighting Toolbox functionality:
    * Type: “plotciexy” in the command window
    * A plot of the CIE x and y chromaticity should appear

**GNU Octave**
1. Download the Lighting Toolbox and move it to a location of your choice.
2. Start GNU Octave
3. Add the Lighting Toolbox to Octave's search path:
    * type: “addpath(‘path_to_lighting_toolbox’)” in the command window
4. Optional: install image package:
    - Type: “install package -forge image” in the command window
5. Recommended: load image package at startup:
- Type: “edit octaverc” in command window
- Add line: “pkg load image” to octaverc file
- Save -> close Octave -> start Octave
6. Test the Lighting Toolbox functionality:
- Type: “plotciexy” in the command window
- A plot of the CIE x and y chromaticity should appear

# Documentation
The LigthingToolbox is documenteted with numerous function examples on: www.frudawski.de/LightingToolbox
