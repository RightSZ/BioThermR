# Import EBImage Object into BioThermR

Converts an 'EBImage' class object back into the 'BioThermR' framework.
This function is designed to integrate results from external
morphological operations (e.g., watershed segmentation, filtering) back
into the standard BioThermR analytical workflow.

## Usage

``` r
from_EBImage(
  eb_img,
  template_obj = NULL,
  name = "Imported_EBImage",
  mask_zero = FALSE
)
```

## Arguments

- eb_img:

  An `Image` object (from the 'EBImage' package).

- template_obj:

  Optional. An existing 'BioThermR' object to update. Providing this
  ensures that original metadata (like filenames and original raw data)
  is retained. Default is `NULL`.

- name:

  String. The name assigned to the new object (used only if
  `template_obj` is `NULL`). Default is "Imported_EBImage".

- mask_zero:

  Logical. If `TRUE`, converts values of 0 in the imported matrix to
  `NA`. This is particularly useful when importing binary masks where 0
  represents the background, as BioThermR uses `NA` to exclude
  background pixels from statistical calculations. Default is `FALSE`.

## Value

A 'BioThermR' object with the imported matrix stored in the `processed`
slot.

## Details

This function supports two modes:

- **Update Mode:** If `template_obj` is provided, the input image
  replaces the `processed` matrix of the template. Metadata (filename,
  path) is preserved. Statistics are reset to `NULL` as the data has
  changed.

- **Create Mode:** If `template_obj` is `NULL`, a new 'BioThermR' object
  is created from scratch using the input matrix.

If the input `eb_img` has more than 2 dimensions (e.g., color/RGB), only
the first channel is utilized, and a warning is issued.

## Examples

``` r
# \donttest{
# Load data
mat <- matrix(runif(160*120, 20, 40), nrow = 120, ncol = 160)
obj <- create_BioThermR(mat, name = "Simulation_01")
#> BioThermR object 'Simulation_01' created. Dimensions: 120x160

# Convert to EBImage format with normalization
eb_obj <- as_EBImage(obj, normalize = TRUE)

# Convert to BioThermR from EBImage
new_obj <- from_EBImage(eb_obj)
# }
```
