# Assess replicate consistency and repeatability

Evaluates the statistical consistency and reliability of repeated
thermal measurements. The function calculates the Intraclass Correlation
Coefficient (ICC) and performs variance decomposition using Linear Mixed
Models (LMM) to assess the proportion of variance attributable to
between-subject differences versus measurement error.

## Usage

``` r
assess_replicates(
  data,
  id_col,
  metrics,
  replicate_col = NULL,
  sort_cols = NULL,
  methods = "icc",
  return_models = FALSE,
  quiet = FALSE
)
```

## Arguments

- data:

  A data.frame containing the thermal metrics and identifier columns.

- id_col:

  A single character string specifying the column name for subject IDs.

- metrics:

  A character vector specifying the column names of the thermal metrics
  to be assessed.

- replicate_col:

  A single character string specifying the column name for the replicate
  index. Default is `NULL`. If `NULL`, replicate indices are inferred
  from row order.

- sort_cols:

  A character vector specifying the columns to sort the data by before
  inferring replicate indices. Default is `NULL`.

- methods:

  A character vector specifying the statistical methods to apply. Valid
  options include `"icc"`, `"variance"`, and `"lmm"`. Default is
  `"icc"`.

- return_models:

  Logical. If `TRUE` and `"lmm"` is in `methods`, the fitted linear
  mixed models are returned. Default is `FALSE`.

- quiet:

  Logical. If `TRUE`, console messages are suppressed. Default is
  `FALSE`.

## Value

An object of class `BioThermR_replicate_assessment`, which is a list
containing:

- settings:

  A list of the input parameters used for the assessment.

- icc:

  A data.frame containing ICC results (if `"icc"` is selected).

- variance:

  A data.frame containing variance decomposition results (if
  `"variance"` is selected).

- lmm:

  A data.frame containing fixed effects and variance components from LMM
  (if `"lmm"` is selected).

- models:

  A list of fitted `lmer` model objects (if `return_models = TRUE`).

## Details

This function requires the `psych` package for ICC calculations and the
`lme4` package for variance decomposition and LMM fitting. Ensure these
packages are installed before selecting the respective methods.

## Examples

``` r
if (FALSE) { # \dontrun{
# Assuming df is a data.frame with columns: Sample, Rep, Mean
res <- assess_replicates(
  data = df,
  id_col = "Sample",
  metrics = "Mean",
  replicate_col = "Rep",
  methods = c("icc", "variance")
)
print(res$icc)
} # }
```
