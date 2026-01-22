# Load BioThermR Data from Disk

Restores a previously saved 'BioThermR' object or a list of objects from
a .rds file. This function is the counterpart to
[`save_biothermr`](https://rightsz.github.io/BioThermR/reference/save_biothermr.md)
and allows you to resume analysis from a saved checkpoint.

## Usage

``` r
load_biothermr(file_path)
```

## Arguments

- file_path:

  String. The full path to the .rds file (e.g.,
  "results/experiment_data.rds").

## Value

A single 'BioThermR' object or a list of 'BioThermR' objects, depending
on the structure of the saved data.

## Details

Upon loading, the function performs an automatic validation check to
ensure the file contains a valid 'BioThermR' class instance (or a list
of them). It provides feedback to the console regarding the type and
quantity of objects loaded.

## See also

[`save_biothermr`](https://rightsz.github.io/BioThermR/reference/save_biothermr.md)
