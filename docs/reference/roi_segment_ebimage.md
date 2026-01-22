# Automated ROI Segmentation via EBImage

Performs automated background removal using a hybrid pipeline of global
thresholding (Otsu's method), morphological operations, and connected
component analysis.

## Usage

``` r
roi_segment_ebimage(
  img_obj,
  method = "otsu",
  keep_largest = TRUE,
  morphology = TRUE
)
```

## Arguments

- img_obj:

  A 'BioThermR' object.

- method:

  String. The thresholding algorithm. Currently, only `"otsu"` is
  supported.

- keep_largest:

  Logical. If `TRUE` (default), keeps only the largest connected object
  and converts all other clusters to background (`NA`). This is a
  powerful denoising step for animal experiments.

- morphology:

  Logical. If `TRUE` (default), applies morphological opening and
  closing operations to smooth edges and reduce noise.

## Value

A 'BioThermR' object where the `processed` matrix has been masked
(background pixels are set to `NA`).

## Details

The segmentation pipeline consists of four steps:

1.  **Normalization:** The temperature matrix is scaled to \[0, 1\] to
    be compatible with 'EBImage'.

2.  **Thresholding:** Otsu's method is used to calculate an optimal
    global threshold that separates the foreground (subject) from the
    background based on histogram bimodality.

3.  **Morphology:** A disc-shaped brush (size=5) is used for 'Opening'
    (to remove salt noise) and 'Closing' (to fill small holes inside the
    subject).

4.  **Component Filter:** If `keep_largest` is `TRUE`, the function
    labels all connected regions and retains only the largest one
    (assuming the animal is the largest heat source), effectively
    removing smaller artifacts like bedding noise or reflections.

## Examples

``` r
# Load raw data
img_obj <- system.file("extdata", "C05.raw", package = "BioThermR")
img <- read_thermal_raw(img_obj)

# Apply automated segmentation
img <- roi_segment_ebimage(img, keep_largest = TRUE)
#> Auto-Segmentation: Kept largest object ( 401 pixels )
```
