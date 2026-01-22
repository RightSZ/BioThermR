# Save BioThermR Data Objects to Disk

Serializes and saves a single 'BioThermR' object or a list of objects to
a compressed .rds file. This ensures that all components—raw temperature
matrices, processed masks, metadata, and calculation stats—are preserved
accurately.

## Usage

``` r
save_biothermr(img_input, file_path)
```

## Arguments

- img_input:

  A single 'BioThermR' class object or a list of 'BioThermR' objects
  (e.g., the output from `read_thermal_batch`).

- file_path:

  String. The destination path (e.g., "results/obj.rds"). If the
  directory structure does not exist, it will be created automatically.

## Value

None (invisible `NULL`). Prints a success message to the console upon
completion.

## Examples

``` r
# \donttest{
# Load data
mat <- matrix(runif(160*120, 20, 40), nrow = 120, ncol = 160)
obj <- create_BioThermR(mat, name = "Simulation_01")
#> BioThermR object 'Simulation_01' created. Dimensions: 120x160

# Save a single object to a temporary directory
out_file <- file.path(tempdir(), "mouse_01.rds")
save_biothermr(obj, out_file)
#> Successfully saved BioThermR data to: /var/folders/_b/gx4lc14d5ssf7pl9qlkl32r80000gn/T//RtmpAEPdm9/mouse_01.rds
# }
```
