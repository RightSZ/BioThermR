# Read a Single .raw Thermal Image File

Reads a binary .raw file (typically 32-bit floating point), converts it
into a matrix, and constructs a 'BioThermR' object containing raw data
and metadata.

## Usage

``` r
read_thermal_raw(file_path, width = 160, height = 120, rotate = TRUE)
```

## Arguments

- file_path:

  String. The full path to the .raw file.

- width:

  Integer. The width of the thermal sensor (number of columns). Default
  is 160.

- height:

  Integer. The height of the thermal sensor (number of rows). Default is
  120.

- rotate:

  Logical. Whether to rotate the image 90 degrees counter-clockwise.
  Default is TRUE (corrects orientation for many standard sensor
  exports).

## Value

A list object of class "BioThermR" containing:

- raw:

  The original temperature matrix (numeric).

- processed:

  A copy of the raw matrix, intended for subsequent ROI filtering or
  masking.

- meta:

  A list containing metadata: `filename`, `fullpath`, and `dims`.

## Examples

``` r
if (FALSE) { # \dontrun{
img <- read_thermal_raw("data/sample.raw")
} # }
```
