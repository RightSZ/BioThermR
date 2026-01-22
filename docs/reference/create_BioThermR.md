# Create BioThermR Object from Data

Manually creates a BioThermR object from a numeric matrix or data frame.
Useful for converting data loaded from other formats (Excel, CSV, txt)
or simulation data.

## Usage

``` r
create_BioThermR(data, name = "Sample")
```

## Arguments

- data:

  A numeric matrix or data frame representing the thermal image grid
  (rows x cols).

- name:

  String. An identifier for this sample (e.g., filename or sample ID).
  Default is "Sample".

## Value

A 'BioThermR' object.

## Examples

``` r
mat <- matrix(runif(160*120, 20, 40), nrow = 120, ncol = 160)
obj <- create_BioThermR(mat, name = "Simulation_01")
#> BioThermR object 'Simulation_01' created. Dimensions: 120x160
plot_thermal_heatmap(obj)
```
