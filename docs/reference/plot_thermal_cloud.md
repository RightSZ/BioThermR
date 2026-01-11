# Generate a "Thermal Cloud" Visualization (Phyllotaxis Layout)

Arranges a collection of segmented thermal objects into an organic,
spiral "cloud" formation. Unlike a rigid grid, this layout uses a
golden-angle spiral (phyllotaxis) algorithm to cluster subjects
efficiently. This is particularly effective for visualizing the
diversity of thermal phenotypes in large datasets or creating artistic
figures for presentations and covers.

## Usage

``` r
plot_thermal_cloud(
  img_list,
  spread_factor = 1.1,
  jitter_factor = 0.5,
  palette = "inferno",
  text_color = "black",
  text_size = 3,
  show_labels = TRUE
)
```

## Arguments

- img_list:

  A list of 'BioThermR' objects. For best results, these should be
  pre-processed (e.g., background removed via
  [`roi_filter_threshold`](https://rightsz.github.io/BioThermR/reference/roi_filter_threshold.md)).

- spread_factor:

  Numeric. Multiplier for the distance between objects. Values \> 1.0
  increase spacing (airier cloud), values \< 1.0 pack objects tighter.
  Default is 1.1.

- jitter_factor:

  Numeric. Introduces random noise to the placement coordinates to break
  perfect symmetry and create a more natural look. Default is 0.5.

- palette:

  String. The color palette from the 'viridis' package. Default is
  "inferno".

- text_color:

  String. Color of the filename labels. Default is "black".

- text_size:

  Integer. Font size for the labels. Default is 3.

- show_labels:

  Logical. If `TRUE`, displays the filename below each object. Default
  is `TRUE`.

## Value

A `ggplot` object with a white background and void theme.

## Details

The function performs object-centric rendering:

1.  **Extraction:** For each image, it extracts only the valid
    foreground pixels (non-NA), ignoring the original frame dimensions.

2.  **Re-centering:** Each object is mathematically centered at (0,0)
    relative to its own coordinate system.

3.  **Placement:** Objects are placed along a spiral path defined by the
    Golden Angle (~137.5 degrees).

The spacing and randomness of the spiral can be tuned using
`spread_factor` and `jitter_factor`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Load data
batch <- read_thermal_batch("data/mice")

# Create an artistic thermal cloud
p_cloud <- plot_thermal_cloud(batch, spread_factor = 1.5, jitter_factor = 2.0)

# Save for cover art
ggsave("thermal_cloud_cover.png", p_cloud, width = 15, height = 15, dpi = 300)
} # }
```
