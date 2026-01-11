# Interactive 3D Thermal Surface Plot

Generates a rotatable, interactive 3D surface plot using the 'plotly'
engine. This visualization maps temperature to the Z-axis, allowing
users to intuitively explore the thermal topology, gradients, and
intensity of hotspots.

## Usage

``` r
plot_thermal_3d(img_obj, use_processed = TRUE)
```

## Arguments

- img_obj:

  A 'BioThermR' object.

- use_processed:

  Logical. If `TRUE` (default), uses the 'processed' matrix (where
  background is likely `NA`). If `FALSE`, uses the 'raw' sensor data.

## Value

A `plotly` object (HTML widget).

## Details

3D visualization is particularly powerful for:

- **Quality Control:** Quickly identifying noise spikes or "cold"
  artifacts that flat heatmaps might hide.

- **Gradient Analysis:** Visualizing how heat dissipates from a central
  source (e.g., a tumor or inflammation site).

- **Presentation:** Creating engaging, interactive figures for HTML
  reports or Shiny dashboards.

The output is an HTML widget that allows zooming, panning, and hovering
to see specific pixel values.

## Examples

``` r
if (FALSE) { # \dontrun{
# Create an interactive 3D plot
p_3d <- plot_thermal_3d(my_obj)

# Display it (opens in Viewer or Browser)
p_3d
} # }
```
