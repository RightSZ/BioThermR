# Convert BioThermR Object to EBImage Object

Extracts the thermal matrix (raw or processed) from a 'BioThermR' object
and converts it into an 'EBImage' class object. This conversion is
essential for applying advanced morphological operations (e.g.,
thresholding, watershed, labeling) provided by the 'EBImage' package.

## Usage

``` r
as_EBImage(img_obj, use_processed = TRUE, replace_na = 0, normalize = FALSE)
```

## Arguments

- img_obj:

  A 'BioThermR' object.

- use_processed:

  Logical. If `TRUE` (default), uses the 'processed' matrix (which might
  already have masks applied). If `FALSE`, uses the 'raw' temperature
  matrix.

- replace_na:

  Numeric. The value to replace `NA`s with, as 'EBImage' does not
  support missing values. Default is 0 (typically treated as
  background).

- normalize:

  Logical. If `TRUE`, scales the matrix values linearly to the range
  \[0, 1\]. This is highly recommended for visualization or standard
  thresholding algorithms (like Otsu) in 'EBImage'. Default is `FALSE`
  (preserves actual temperature values).

## Value

An `Image` object (defined in the 'EBImage' package).

## Examples

``` r
# \donttest{
# Load data
mat <- matrix(runif(160*120, 20, 40), nrow = 120, ncol = 160)
obj <- create_BioThermR(mat, name = "Simulation_01")
#> BioThermR object 'Simulation_01' created. Dimensions: 120x160

# Convert to EBImage format with normalization (for thresholding)
eb_norm <- as_EBImage(obj, normalize = TRUE)

# Convert preserving temperature values (for calculation)
eb_temp <- as_EBImage(obj, normalize = FALSE)
# }
```
