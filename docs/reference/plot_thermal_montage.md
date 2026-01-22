# Create a Gap-Free Thermal Image Montage

Combines a list of 'BioThermR' objects into a single, high-resolution
grid plot (montage). Unlike standard faceting, this function uses a
custom integer-coordinate system to center each subject within a uniform
grid cell, ensuring pixel-perfect alignment without the visual artifacts
(white gaps) often seen in R raster plots.

## Usage

``` r
plot_thermal_montage(
  img_list,
  ncol = NULL,
  padding = 10,
  palette = "inferno",
  text_color = "black",
  text_size = 4
)
```

## Arguments

- img_list:

  A list of 'BioThermR' objects (e.g., output from `read_thermal_batch`
  or `roi_filter_interactive`).

- ncol:

  Integer. The number of columns in the grid. If `NULL` (default), it is
  automatically calculated based on the square root of the number of
  images to create a roughly square layout.

- padding:

  Integer. The size of the whitespace gap (in pixels) between grid
  cells. Default is 10.

- palette:

  String. The color palette to use (from 'viridis' package). Default is
  "inferno".

- text_color:

  String. Color of the filename labels. Default is "black".

- text_size:

  Integer. Font size for the filename labels. Default is 4.

## Value

A `ggplot` object representing the combined montage.

## Details

The function executes a two-pass algorithm:

1.  **Scan Pass:** Iterates through all objects to calculate the
    bounding box dimensions of the largest subject. This defines the
    uniform cell size for the grid.

2.  **Layout Pass:** Calculates the integer offsets required to center
    each smaller subject within the master cell. It merges all pixel
    data into a single master data frame.

The result is rendered using `geom_tile(width=1, height=1)` to guarantee
continuous, gap-free visualization.

## Examples

``` r
# \donttest{
# Load a batch of images
img_obj_list <- system.file("extdata",package = "BioThermR")
batch <- read_thermal_batch(img_obj_list)
#> Reading 30 files...
#> Batch read completed. Imported 30 files.

# Create a montage with 4 columns
p <- plot_thermal_montage(batch, ncol = 4, padding = 20)
#> Scanning objects for bounding box dimensions...
#> Montage Layout: 8 x 4 | Cell Size: 180 x 140
# }
```
