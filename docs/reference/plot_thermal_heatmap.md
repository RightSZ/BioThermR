# Visualize Thermal Matrix as 2D Heatmap

Generates a high-quality raster plot of the thermal data using the
'ggplot2' framework. This function allows for quick visualization of raw
or processed matrices with customizable perceptually uniform color
scales (viridis).

## Usage

``` r
plot_thermal_heatmap(img_obj, use_processed = TRUE, palette = "inferno")
```

## Arguments

- img_obj:

  A 'BioThermR' object.

- use_processed:

  Logical. If `TRUE` (default), plots the 'processed' matrix (showing
  masking effects). If `FALSE`, plots the original 'raw' data.

- palette:

  String. The color map option from the 'viridis' package. Options
  include: `"magma"`, `"inferno"`, `"plasma"`, `"viridis"`, `"cividis"`.
  Default is `"inferno"`.

## Value

A `ggplot` object.

## Details

The function performs the following steps:

- Converts the thermal matrix into a long-format data frame suitable for
  ggplot.

- Renders the image using `geom_raster`.

- Maps temperature to color using the specified 'viridis' palette.

- Ensures the aspect ratio is preserved (`coord_fixed`) so the image
  does not appear distorted.

- Sets `NA` values (masked background) to transparent.

Since the output is a standard ggplot object, layers can be added
subsequently (e.g., new titles or annotations).

## Examples

``` r
if (FALSE) { # \dontrun{
# Standard plot
p <- plot_thermal_heatmap(my_obj)
print(p)

# Customize plot (e.g., change title)
p + ggplot2::ggtitle("Subject A - Cold Exposure")
} # }
```
