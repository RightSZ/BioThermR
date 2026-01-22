# Calculate Comprehensive Thermal Statistics

Computes a detailed set of summary statistics from the thermal matrix.
Metrics include central tendency (Mean, Median, Peak Density),
dispersion (SD, IQR, CV), and range (Min, Max, Quantiles). NA values
(background) are automatically excluded.

## Usage

``` r
analyze_thermal_stats(img_obj, use_processed = TRUE)
```

## Arguments

- img_obj:

  A 'BioThermR' object.

- use_processed:

  Logical. If `TRUE` (default), calculates statistics on the 'processed'
  matrix (where background is likely masked as NA). If `FALSE`, uses the
  'raw' matrix.

## Value

A 'BioThermR' object with the `stats` slot updated containing a data
frame of results.

## Details

The function calculates the following metrics:

- **Min/Max:** Extremities of the temperature distribution.

- **Mean/Median:** Measures of central tendency.

- **SD (Standard Deviation):** Absolute measure of spread.

- **IQR (Interquartile Range):** Robust measure of spread (Q75 - Q25).

- **CV (Coefficient of Variation):** Relative measure of spread (SD /
  Mean), useful for assessing thermal heterogeneity.

- **Peak_Density:** The temperature value corresponding to the peak of
  the kernel density estimate (Mode).

## Examples

``` r
img_obj <- system.file("extdata", "C05.raw", package = "BioThermR")
img <- read_thermal_raw(img_obj)
img <- analyze_thermal_stats(img)
```
