# LightingToolbox
The Lighting Toolbox contains numerous Matlab/Octave functions for lighting research calculations, plotting and colorimetry. It is available under BSD3.0 licence.

**Categories:**
- Calculation functions
- Colorimetric functions
- Daylight functions
- Plot functions
- Image functions
- Lighting control functions
- Measurement functions

The Lighting Toolbox contains various reference spectra provided by the Commission International d’Éclairage (CIE – International Commission on Illumination). The reference data is sourced from the CIE and permission to use the data in the Lighting Toolbox was granted. Any errors in the data set or in results generated with the Lighting Toolbox are not in the liability of the CIE nor me, see licence.

## LightingToolbox setup:
**MATLAB:**
Tested with version 2022a
1. Download the Lighting Toolbox and move it to a location of your choice.
2. Start Matlab
3. Add the Lighting Toolbox to Matlab's search path:
  	- Type: ```addpath(‘PATH_TO_LIGHTING_TOOLBOX\functions’)``` in the command window
    - Or click “Set Path” button under Matlab HOME tab -> “Add Folder…” -> select folder -> confirm -> “Save”
4. Test the Lighting Toolbox functionality:
    - Type: ```plotciexy``` in the command window
    - A plot of the CIE x and y chromaticity should appear
5. The Lighting Toolbox is ready to use.

**GNU Octave:**
Tested with version 7.1.0
1. Download the Lighting Toolbox and move it to a location of your choice.
2. Start GNU Octave
3. Add the Lighting Toolbox to Octave's search path:
    - type: ```addpath(‘PATH_TO_LIGHTING_TOOLBOX\functions’)``` in the command window
4. Optional: install image package:
    - Type: ```pkg install -forge image``` in the command window
    - Recommended: load image package at startup:
      * Type: ```edit octaverc``` in command window
      * Add line: ```pkg load image``` to octaverc file
      * Save -> close Octave -> restart Octave
      * Or load the image package each time manually with the command: ```pkg load image```
5. Test the Lighting Toolbox functionality:
    - Type: ```plotciexy``` in the command window
    - A plot of the CIE x and y chromaticity should appear
6. The Lighting Toolbox is ready to use.

## Documentation:
The Lighting Toolbox is documented with numerous function examples on: https://frudawski.de/lighting-toolbox/

## Cite:
Frederic Rudawski, *Lighting Toolbox for Matlab and Octave*, 2022, version 1.18, URL: https://github.com/Frudawski/LightingToolbox
