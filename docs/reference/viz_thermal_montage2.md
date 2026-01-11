# Create a Thermal Image Montage

Combines multiple BioThermR objects into a single plot (a
montage/collage). Images are laid out in a grid, and filenames are
labeled above each image. Uses the 'processed' matrix (NA values are
transparent).

## Usage

``` r
viz_thermal_montage2(
  img_list,
  ncol = NULL,
  padding = 10,
  palette = "inferno",
  text_color = "white",
  text_size = 4
)
```

## Arguments

- img_list:

  A list of 'BioThermR' objects.

- ncol:

  Integer. Number of columns in the grid. If NULL, tries to create a
  roughly square grid.

- padding:

  Integer. Pixel gap between images. Default is 10.

- palette:

  String. Color palette for temperature. Default is "inferno".

- text_color:

  String. Color of the filename labels. Default is "white" (good
  contrast on dark backgrounds).

- text_size:

  Integer. Font size of the labels. Default is 4.

## Value

A ggplot object.
