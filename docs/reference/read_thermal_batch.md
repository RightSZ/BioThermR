# Batch Read .raw Files

Scans a folder and imports all matching .raw files into a list.

## Usage

``` r
read_thermal_batch(folder_path, pattern = "\\.raw$", recursive = FALSE, ...)
```

## Arguments

- folder_path:

  String. Path to the folder.

- pattern:

  String. Regex pattern. Default is "\\raw\$".

- recursive:

  Logical. Default is FALSE.

- ...:

  Additional arguments passed to `read_thermal_raw`.

## Value

A named list of "BioThermR" objects.
