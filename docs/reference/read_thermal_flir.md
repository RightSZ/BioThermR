# Read FLIR Radiometric JPG File

Reads a FLIR radiometric JPG file, parses the embedded metadata
(emissivity, distance, Planck constants, atmospheric parameters),
converts the raw sensor data to temperature (Celsius), and constructs a
'BioThermR' object.

## Usage

``` r
read_thermal_flir(file_path, exiftoolpath = "installed")
```

## Arguments

- file_path:

  String. The full path to the FLIR radiometric .jpg file.

- exiftoolpath:

  String. Path to the ExifTool executable. Default is "installed"
  (assumes it is available in the system PATH).

## Value

A list object of class "BioThermR" containing:

- raw:

  The calculated temperature matrix in degrees Celsius.

- processed:

  A copy of the raw matrix, intended for subsequent ROI filtering or
  masking.

- meta:

  A list containing metadata: `filename`, `fullpath`, and `dims`.

## Details

This function relies on the 'Thermimage' package and the external tool
'ExifTool'. It automatically extracts calibration constants (Planck R1,
B, F, O, R2) and environmental parameters to ensure accurate physical
temperature conversion. Please ensure 'ExifTool' is installed and added
to your system PATH.

## Examples

``` r
if (FALSE) { # \dontrun{
img <- read_thermal_flir("data/mouse_flir.jpg")
} # }
```
