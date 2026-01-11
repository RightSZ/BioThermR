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
if (FALSE) { # \dontrun{
# Save a single processed object
save_biothermr(mouse_obj, "data/processed/mouse_01.rds")
} # }
```
