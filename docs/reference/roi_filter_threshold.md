# Filter Thermal Image by Temperature Thresholds

Masks the thermal image by retaining only pixels that fall within a
specified temperature window. Pixels outside this range are set to `NA`
(background).

## Usage

``` r
roi_filter_threshold(img_obj, threshold, use_processed = FALSE)
```

## Arguments

- img_obj:

  A 'BioThermR' object.

- threshold:

  Numeric vector of length 2, e.g., `c(22, 38)`. Defines the inclusive
  temperature range `[min, max]` to keep. Use `Inf` for open upper
  bounds (e.g., `c(25, Inf)` keeps everything above 25°C).

- use_processed:

  Logical.

  - If `FALSE` (default): The filter is applied to the **raw** matrix,
    discarding any previous masks.

  - If `TRUE`: The filter is applied to the **processed** matrix,
    allowing for cumulative masking (e.g., refining an Otsu
    segmentation).

## Value

A 'BioThermR' object with the `processed` matrix updated.

## Details

This is the most fundamental segmentation method for thermal images.
Since animals are typically warmer than their environment, a simple
low-pass filter (e.g., keep \> 22°C) is often sufficient to separate the
subject from the cage. Open boundaries can be defined using `Inf` or
`-Inf`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Simple background removal: Keep everything above 24 degrees
obj <- roi_filter_threshold(obj, threshold = c(24, Inf))

# Specific physiological window: Keep between 30 and 39 degrees
obj <- roi_filter_threshold(obj, threshold = c(30, 39))
} # }
```
