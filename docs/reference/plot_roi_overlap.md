# Visualize ROI Overlap and Dice Coefficient

Visually compares two segmentation masks (ROIs) by overlaying them on
the original thermal image. This function is primarily used for
validation purposes: to compare an automated segmentation (filled layer)
against a manual ground truth (contour line). It automatically
calculates and displays the **Dice Similarity Coefficient (DSC)** in the
title.

## Usage

``` r
plot_roi_overlap(
  img_obj1,
  img_obj2,
  title = NULL,
  color = "green",
  alpha = 0.5,
  line_color = "white",
  palette = "inferno"
)
```

## Arguments

- img_obj1:

  A 'BioThermR' object. Typically the **Automated/Predicted**
  segmentation. This object must contain the raw thermal matrix. Its
  mask will be plotted as a filled area.

- img_obj2:

  A 'BioThermR' object. Typically the **Manual/Ground Truth**
  segmentation. Its mask will be plotted as a contour outline.
  Dimensions must match `img_obj1`.

- title:

  String. Custom title for the plot. If `NULL` (default), the title
  shows "ROI overlap (DICE: X.XXX)".

- color:

  String. Fill color for the `img_obj1` mask. Default is "green".

- alpha:

  Numeric. Transparency level for the `img_obj1` mask (0 to 1). Default
  is 0.5.

- line_color:

  String. Line color for the `img_obj2` contour. Default is "white".

- palette:

  String. Color palette for the background thermal image (passed to
  `scale_fill_viridis_c`). Default is "inferno".

## Value

A `ggplot` object showing the overlay.

## Details

The visualization consists of three layers:

1.  **Background:** The raw thermal image from `img_obj1`.

2.  **Prediction (img_obj1):** The processed mask from the first object,
    rendered as a semi-transparent filled raster (default green).

3.  **Ground Truth (img_obj2):** The processed mask from the second
    object, rendered as a contour outline (default white).

The function calculates the Dice Similarity Coefficient (DSC) using the
formula: \$\$DSC = \frac{2 \times \|X \cap Y\|}{\|X\| + \|Y\|}\$\$ where
X and Y are the set of pixels in the two masks. A DSC of 1 indicates
perfect overlap.

## Examples

``` r
if (FALSE) { # \dontrun{
# 1. Automated Segmentation
auto_obj <- roi_segment_ebimage(my_image)

# 2. Manual Segmentation
manual_obj <- roi_filter_interactive(my_image)

# 3. Compare them
plot_roi_overlap(img_obj1 = auto_obj,
                 img_obj2 = manual_obj,
                 color = "blue",
                 line_color = "red")
} # }
```
